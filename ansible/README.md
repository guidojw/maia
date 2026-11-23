# Ansible

Ansible playbook for machines setup.

# Install collections

Change directory:

```sh
cd ansible
```

Install collections with:

```sh
ansible-galaxy install -r collections/requirements.txt
```

# Run playbook

The machines have their own playbooks, `site.yml` sets up the `maia` VM (network, K3s, the optional NVIDIA GPU and the cluster settings). The Proxmox host `pleiades` has its own, see [Proxmox GPU passthrough](#proxmox-gpu-passthrough-optional) and [HBA temperature](#hba-temperature).

Run the playbook with:

```sh
ansible-playbook -K site.yml
```

# Proxmox GPU passthrough (optional)

The `proxmox_gpu_passthrough` role of `pleiades.yml` prepares the Proxmox host to pass an NVIDIA GPU through to a VM, which the [NVIDIA GPU](#nvidia-gpu-optional) step below needs. It is not part of `site.yml`, as it needs a reboot of the host, which stops the cluster VM, and `site.yml` should not need access to the host. Add the host to `inventory/my_cluster/hosts.ini`:

```ini
[pleiades]
<proxmox host>
```

1. **BIOS:** enable VT-d (Intel) or AMD-Vi, this is not automated.
2. **GPU:** on the Proxmox host get the IDs of all functions of the GPU (the GPU and its audio device):

   ```sh
   lspci -nn | grep -i nvidia
   ```

3. **Variables:** set the IDs in `inventory/my_cluster/group_vars/pleiades/main.yml`:

   ```yaml
   proxmox_gpu_pci_ids:
     - "10de:xxxx"
     - "10de:yyyy"
   ```

4. **Run:** `ansible-playbook -K pleiades.yml`. The role enables the IOMMU on the kernel command line (`intel_iommu=on` on Intel and `iommu=pt`, GRUB or systemd-boot), loads the VFIO modules, binds the GPU to `vfio-pci` and blacklists the GPU drivers on the host (`proxmox_gpu_blacklist`, by default the NVIDIA ones).
5. **Reboot:** reboot the Proxmox host yourself, the role does not do it as it stops all VMs, including the cluster. Then check that `lspci -nnk` lists `Kernel driver in use: vfio-pci` for the GPU.
6. **VM:** adding the GPU to the VM is not automated. Give the VM the `q35` machine type, turn memory ballooning off, and add the GPU under `Hardware > Add > PCI Device` with `All Functions` and `PCI-Express` ticked. A VM that is already running only gets the GPU after a full stop and start. The tested VM uses SeaBIOS (the default, OVMF is not needed) and an emulated display (`vga: std`). With `vga: serial0`, which cloud-init images often use, the VM did not boot with the GPU attached (the cause has not been established), so keep the emulated display.

For an NVIDIA GPU, set `nvidia_gpu: true` after this and run `site.yml` again.

The host can no longer use the GPU, nor any other GPU the blacklisted drivers support, which are all NVIDIA GPUs by default (`proxmox_gpu_blacklist`). If the GPU is also the primary graphics of the host, set `proxmox_gpu_disable_framebuffer: true`, which adds `video=vesafb:off,efifb:off` to the kernel command line, as the boot framebuffer of the host otherwise keeps hold of the device, and the host then loses the console of that GPU. The GRUB edit expects `GRUB_CMDLINE_LINUX_DEFAULT` in double quotes, as Proxmox ships it. A VM with a passed through GPU cannot be live migrated or snapshotted with its memory.

## Shared IOMMU group (optional)

Proxmox binds every device in the IOMMU group of a passed through device to `vfio-pci` when the VM starts, so a device that shares the group with the GPU, for example a NIC the host needs, is taken from the host. Check the groups with `find /sys/kernel/iommu_groups -type l`. Moving the card to a slot on another PCIe root port is the safest fix. If that is not possible, set `proxmox_gpu_acs_override: true` in `inventory/my_cluster/group_vars/pleiades/main.yml` and run `pleiades.yml` and reboot, which adds `pcie_acs_override=downstream,multifunction` to the kernel command line and splits the groups in software. The IOMMU then no longer guarantees that the devices that were grouped are isolated from each other, so a VM with the GPU could reach the memory of those devices. On the tested host (Proxmox kernel `7.0.2-6-pve`) the option worked, the GPU ended up alone in its IOMMU group.

## Blocked GPU DMA (optional)

If the driver in the VM fails to initialise the GPU (`NVRM: ... RmInitAdapter failed`) and the host log shows `DMAR: [DMA Read NO_PASID] Request device [<GPU>] ... non-zero reserved fields in PTE` (`dmesg | grep DMAR`), the IOMMU of the host blocks the DMA of the GPU. On the tested host (Proxmox kernel `7.0.2-6-pve`, Intel VT-d) the GPU initialised after turning off the transparent huge pages, whether this fully resolves the faults still has to be verified. Set `proxmox_gpu_disable_thp: true` in `inventory/my_cluster/group_vars/pleiades/main.yml`, run `pleiades.yml` and reboot, which adds `transparent_hugepage=never` to the kernel command line. Until the reboot, `echo never > /sys/kernel/mm/transparent_hugepage/enabled` on the host sets it at runtime, followed by a full stop and start of the VM. The cause has not been established and the setting was only tried on one host. It applies to all processes on the host, which then use 4 KiB pages only, with somewhat more TLB misses and so a small performance cost, and the memory used stays the same.

# NVIDIA GPU (optional)

Set `nvidia_gpu: true` in `inventory/my_cluster/group_vars/all/main.yml` to install the NVIDIA driver and the NVIDIA Container Toolkit for the hardware transcoding of the [media](../media/README.md#hardware-transcoding-nvidia-optional) chart. The `nvidia` role runs after K3s is installed and restarts K3s when the toolkit is installed, as K3s only adds the `nvidia` runtime when it starts. The Kubernetes API is unavailable for a moment during the restart.

Pass the GPU through to the node first, for a Proxmox VM see [Proxmox GPU passthrough](#proxmox-gpu-passthrough-optional), the kernel module loads when the GPU shows up. Then check on the node that `nvidia-smi` lists the GPU.

The driver is the one of Debian (`nvidia-kernel-dkms`, built for the running kernel with the matching headers), so it has to support the GPU. It built and loaded on the Debian cloud kernel (`6.1.0-56-cloud`, Debian 12, driver `535.309.01`) of the tested node. If it doesn't build or load on yours, use the standard kernel instead (`linux-image-amd64`), which the playbooks don't install.

# HBA temperature

The `lm_sensors` role of `pleiades.yml` installs `lm-sensors` on the Proxmox host. From Linux 7.3 the `mpt3sas` driver of an LSI/Broadcom SAS HBA exposes the chip temperature as an hwmon sensor, so `sensors` lists it without a Broadcom tool:

```sh
sensors mpt3sas-pci-*
```

The host kernel has to be 7.3 or newer, the default Proxmox kernel is older and does not have it, so `sensors` shows no HBA until the kernel is upgraded. Set `proxmox_newer_kernel: true` in `inventory/my_cluster/group_vars/pleiades/main.yml` and run `ansible-playbook -K pleiades.yml` to install `proxmox-kernel-7.3` (`proxmox_kernel_package`) from the Proxmox repository. It is in `pve-no-subscription`, which has to be enabled, and is not the default kernel of Proxmox VE 9.2. It is installed next to the current kernel, which stays. The newest installed kernel is the default boot entry, so the host uses it at its next reboot. The role does not reboot, as that stops the VMs.

To try it once, run `proxmox-boot-tool kernel list`, then `proxmox-boot-tool kernel pin <version> --next-boot` with the new version and reboot, so a kernel that does not boot is replaced by the old one at the next power cycle (the option is from memory, check `proxmox-boot-tool help`). A kernel that does not boot or bring up the network needs a monitor and keyboard at the host to pick the old one. Check the running kernel with `uname -r`, `zpool status`, the GPU passthrough and the sensor with `grep -l mpt3sas /sys/class/hwmon/*/name`. To keep the new kernel, `proxmox-boot-tool kernel pin <version>`, to go back `proxmox-boot-tool kernel unpin` after pinning the old version. The driver only registers the sensor when the card reports a temperature. The LSI HBA of this setup does, `sensors` lists its `IOC` (chip) temperature and no board temperature.
