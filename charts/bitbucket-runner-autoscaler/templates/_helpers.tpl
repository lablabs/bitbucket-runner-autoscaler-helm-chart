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

{{- define "bitbucketRunnerAutoscaler.labels" -}}
{{- $name := include "bitbucketRunnerAutoscaler.name" . -}}
{{- $labels := dict -}}
{{- $labels = merge $labels (dict "app.kubernetes.io/name" $name) -}}
{{- $labels = merge $labels (dict "app.kubernetes.io/instance" .Release.Name) -}}
{{- $labels = merge $labels (dict "app.kubernetes.io/managed-by" .Release.Service) -}}
{{- if .Chart.AppVersion }}
{{- $labels = merge $labels (dict "app.kubernetes.io/version" .Chart.AppVersion) -}}
{{- end }}
{{- if .Values.global.commonLabels }}
{{- $labels = merge $labels .Values.global.commonLabels -}}
{{- end }}
{{- toYaml $labels -}}
{{- end }}

{{- define "bitbucketRunnerAutoscaler.podLabels" -}}
{{- $component := .component -}}
{{- $context := .context -}}
{{- $labels := include "bitbucketRunnerAutoscaler.labels" $context | fromYaml -}}
{{- $labels = merge $labels (dict "app.kubernetes.io/component" $component) -}}
{{- $componentValues := index $context.Values $component -}}
{{- if $componentValues.podLabels }}
{{- $labels = merge $labels $componentValues.podLabels -}}
{{- end }}
{{- toYaml $labels }}
{{- end }}

{{- define "bitbucketRunnerAutoscaler.selectorLabels" -}}
{{- $component := .component -}}
{{- $context := .context -}}
{{- $labels := dict -}}
{{- $labels = merge $labels (dict "app.kubernetes.io/name" (include "bitbucketRunnerAutoscaler.name" $context)) -}}
{{- $labels = merge $labels (dict "app.kubernetes.io/instance" $context.Release.Name) -}}
{{- $labels = merge $labels (dict "app.kubernetes.io/component" $component) -}}
{{- toYaml $labels -}}
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
{{- if .Values.credentialsSecret.create }}
{{- default (include "bitbucketRunnerAutoscaler.fullname" .) .Values.credentialsSecret.name }}
{{- else }}
{{- default "default" .Values.credentialsSecret.name }}
{{- end }}
{{- end }}

{{/*
Define tolerations to be used for cleaner service
*/}}
{{- define "bitbucketRunnerAutoscaler.cleanerTolerations" -}}
{{- $tolerations := .Values.cleaner.tolerations | default .Values.global.tolerations | default (list) }}
{{- toYaml $tolerations }}
{{- end }}

{{/*
Define node selector for cleanup service
*/}}
{{- define "bitbucketRunnerAutoscaler.cleanerNodeSelector" -}}
{{- $nodeSelector := .Values.cleaner.nodeSelector | default .Values.global.nodeSelector | default (dict) }}
{{- toYaml $nodeSelector }}
{{- end }}

{{/*
Define tolerations to be used for controller service
*/}}
{{- define "bitbucketRunnerAutoscaler.controllerTolerations" -}}
{{- $tolerations := .Values.controller.tolerations | default .Values.global.tolerations | default (list) }}
{{- toYaml $tolerations }}
{{- end }}

{{/*
Define node selector for controller service
*/}}
{{- define "bitbucketRunnerAutoscaler.controllerNodeSelector" -}}
{{- $nodeSelector := .Values.controller.nodeSelector | default .Values.global.nodeSelector | default (dict) }}
{{- toYaml $nodeSelector }}
{{- end }}

{{/*
Define runner tolerations
*/}}
{{- define "bitbucketRunnerAutoscaler.runnerTolerations" -}}
{{- $tolerations := .Values.runner.tolerations  | default (list) }}
{{- toYaml $tolerations }}
{{- end }}

{{/*
Define runner node selector
*/}}
{{- define "bitbucketRunnerAutoscaler.runnerNodeSelector" -}}
{{- $nodeSelector := .Values.runner.nodeSelector | default (dict) }}
{{- toYaml $nodeSelector }}
{{- end }}

{{/*
Return the controller image name
*/}}
{{- define "bitbucketRunnerAutoscaler.controllerImage" -}}
{{- $registryName := .Values.controller.image.registry -}}
{{- $repositoryName := .Values.controller.image.repository -}}
{{- $tag := .Values.controller.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return the cleaner image name
*/}}
{{- define "bitbucketRunnerAutoscaler.cleanerImage" -}}
{{- $registryName := .Values.cleaner.image.registry -}}
{{- $repositoryName := .Values.cleaner.image.repository -}}
{{- $tag := .Values.cleaner.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return the runner image name
*/}}
{{- define "bitbucketRunnerAutoscaler.runnerImage" -}}
{{- $registryName := .Values.runner.image.registry -}}
{{- $repositoryName := .Values.runner.image.repository -}}
{{- $tag := .Values.runner.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{/*
Return the dind image name
*/}}
{{- define "bitbucketRunnerAutoscaler.dindImage" -}}
{{- $registryName := .Values.runner.dind.image.registry -}}
{{- $repositoryName := .Values.runner.dind.image.repository -}}
{{- $tag := .Values.runner.dind.image.tag | toString -}}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}

{{- define "bitbucketRunnerAutoscaler.pdbName" -}}
{{- $component := .component -}}
{{- $context := .context -}}
{{- printf "%s-%s-pdb" (include "bitbucketRunnerAutoscaler.fullname" $context) $component -}}
{{- end }}

{{- define "bitbucketRunnerAutoscaler.runnerNamespaces" -}}
  {{- $allNamespaces := list }}
  {{- range .Values.runner.config.groups }}
    {{- if eq .namespace $.Release.Namespace }}
      {{- fail (printf "Namespace '%s' cannot be the same as the operator namespace '%s'" .namespace $.Release.Namespace) }}
    {{- end }}
    {{- $allNamespaces = append $allNamespaces .namespace -}}
  {{- end }}
  {{- $uniqueNamespaces := uniq $allNamespaces }}
  {{- $_ := set . "Namespaces" $uniqueNamespaces }}
{{- end }}
