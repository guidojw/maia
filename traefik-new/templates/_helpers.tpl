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

{{/*
Generate HTTP router rule with a Host matcher for every inputted URL
*/}}
{{- define "traefik.httpRouterRule" -}}
{{- $matchers := list }}
{{- range . }}
{{- $matchers = append $matchers (printf "Host(`%s`)" .) }}
{{- end }}
{{- $matchers | join " || " }}
{{- end }}
