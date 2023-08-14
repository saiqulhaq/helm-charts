{{/*
Expand the name of the chart.
*/}}
{{- define "s3-nginx-proxy-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "s3-nginx-proxy-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "s3-nginx-proxy-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "s3-nginx-proxy-chart.labels" -}}
helm.sh/chart: {{ include "s3-nginx-proxy-chart.chart" . }}
{{ include "s3-nginx-proxy-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "s3-nginx-proxy-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "s3-nginx-proxy-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "s3-nginx-proxy-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "s3-nginx-proxy-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use for config validation in Helm hook
*/}}
{{- define "s3-nginx-proxy-chart.serviceAccountNameConfigValidation" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "s3-nginx-proxy-chart.fullname" .) .Values.serviceAccount.name }}-config-validation
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Pod annotations, combining metrics config and .Values.podAnnotations
*/}}
{{- define "s3-nginx-proxy-chart.podAnnotations" -}}
{{- if .Values.metrics.enabled -}}
prometheus.io/scrape: {{ .Values.metrics.enabled | quote }}
prometheus.io/path: {{ .Values.metrics.location | quote }}
prometheus.io/port: {{ .Values.metrics.port | quote }}
{{- with .Values.podAnnotations }}
{{ toYaml . }}
{{- end }}
{{- else }}
{{- toYaml .Values.podAnnotations }}
{{- end }}
{{- end }}
