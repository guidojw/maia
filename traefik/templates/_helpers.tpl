{{/*
Generate TCP router rule with a HostSNI matcher for every inputted URL
*/}}
{{- define "traefik.tcpRouterRule" -}}
{{- $matchers := list }}
{{- range . }}
{{- $matchers = append $matchers (printf "HostSNI(`%s`)" .) }}
{{- end }}
{{- $matchers | join " || " }}
{{- end }}
