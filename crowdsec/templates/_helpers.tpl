{{/*
Name of the bouncer Deployment and Service
*/}}
{{- define "bouncer.name" -}}
{{ .Release.Name }}-routeros-bouncer
{{- end }}

{{/*
Labels the bouncer Deployment, Service and network policies select on
*/}}
{{- define "bouncer.selectorLabels" -}}
app.kubernetes.io/name: cs-routeros-bouncer
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
URL of the LAPI service, whose name the crowdsec chart derives from the release name
*/}}
{{- define "bouncer.lapiUrl" -}}
http://{{ .Release.Name }}-service.{{ .Release.Namespace }}.svc:8080/
{{- end }}
