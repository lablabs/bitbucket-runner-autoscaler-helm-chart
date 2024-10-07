{{/*
Expand the name of the chart.
*/}}
{{- define "bitbucketRunnerAutoscaler.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bitbucketRunnerAutoscaler.fullname" -}}
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
{{- define "bitbucketRunnerAutoscaler.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bitbucketRunnerAutoscaler.labels" -}}
helm.sh/chart: {{ include "bitbucketRunnerAutoscaler.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Controller selector labels
*/}}
{{- define "bitbucketRunnerAutoscalerController.selectorLabels" -}}
{{- include "bitbucketRunnerAutoscaler.labels" . }}
app.kubernetes.io/name: {{ include "bitbucketRunnerAutoscaler.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: controller
{{- end }}

{{/*
Cleaner selector labels
*/}}
{{- define "bitbucketRunnerAutoscalerCleaner.selectorLabels" -}}
{{- include "bitbucketRunnerAutoscaler.labels" . }}
app.kubernetes.io/name: {{ include "bitbucketRunnerAutoscaler.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: cleaner
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bitbucketRunnerAutoscaler.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bitbucketRunnerAutoscaler.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the bitbucket secret to use
*/}}
{{- define "bitbucketRunnerAutoscaler.secretName" -}}
{{- if .Values.credentialSecret.create }}
{{- default (include "bitbucketRunnerAutoscaler.fullname" .) .Values.credentialSecret.name }}
{{- else }}
{{- default "default" .Values.credentialSecret.name }}
{{- end }}
{{- end }}

{{/*
Define tolerations to be used for cleaner service
*/}}
{{- define "bitbucketRunnerAutoscaler.cleanerTolerations" -}}
{{- if .Values.controller.cleaner.tolerations }}
{{ .Values.controller.cleaner.tolerations | toYaml }}
{{- else if .Values.controller.tolerations }}
{{ .Values.controller.tolerations | toYaml }}
{{- else if .Values.global.tolerations }}
{{ .Values.global.tolerations | toYaml }}
{{- else }}
[]
{{- end }}
{{- end }}

{{/*
Define node selector for cleanup service
*/}}
{{- define "bitbucketRunnerAutoscaler.cleanerNodeSelector" -}}
{{- if .Values.controller.cleaner.nodeSelector }}
{{ .Values.controller.cleaner.nodeSelector | toYaml }}
{{- else if .Values.controller.nodeSelector }}
{{ .Values.controller.nodeSelector | toYaml }}
{{- else if .Values.global.nodeSelector }}
{{ .Values.global.nodeSelector | toYaml }}
{{- else }}
{}
{{- end }}
{{- end }}

{{/*
Define tolerations to be used for controller service
*/}}
{{- define "bitbucketRunnerAutoscaler.controllerTolerations" -}}
{{- if .Values.controller.tolerations }}
{{ .Values.controller.tolerations | toYaml }}
{{- else if .Values.global.tolerations }}
{{ .Values.global.tolerations | toYaml }}
{{- else }}
[]
{{- end }}
{{- end }}

{{/*
Define node selector for controller service
*/}}
{{- define "bitbucketRunnerAutoscaler.controllerNodeSelector" -}}
{{- if .Values.controller.nodeSelector }}
{{ .Values.controller.nodeSelector | toYaml }}
{{- else if .Values.global.nodeSelector }}
{{ .Values.global.nodeSelector | toYaml }}
{{- else }}
{}
{{- end }}
{{- end }}

{{/*
Define runner tolerations
*/}}
{{- define "bitbucketRunnerAutoscaler.runnerTolerations" -}}
{{- if .Values.runner.tolerations }}
{{ .Values.runner.tolerations | toYaml }}
{{- else if .Values.global.tolerations }}
{{ .Values.global.tolerations | toYaml }}
{{- else }}
[]
{{- end }}
{{- end }}

{{/*
Define runner node selector
*/}}
{{- define "bitbucketRunnerAutoscaler.runnerNodeSelector" -}}
{{- if .Values.runner.nodeSelector }}
{{ .Values.controller.runner.nodeSelector | toYaml }}
{{- else if .Values.global.nodeSelector }}
{{ .Values.global.nodeSelector | toYaml }}
{{- else }}
{}
{{- end }}
{{- end }}
