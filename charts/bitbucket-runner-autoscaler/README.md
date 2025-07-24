# bitbucket-runner-autoscaler

Chart for deploying Bitbucket Runner Autoscaler.

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.9.0](https://img.shields.io/badge/AppVersion-3.9.0-informational?style=flat-square)

## About
bitbucket-runner-autoscaler Helm chart

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cleaner.affinity | object | `{}` |  |
| cleaner.create | bool | `true` |  |
| cleaner.image.pullPolicy | string | `"IfNotPresent"` |  |
| cleaner.image.registry | string | `"docker.io"` |  |
| cleaner.image.repository | string | `"bitbucketpipelines/runners-autoscaler"` |  |
| cleaner.image.tag | string | `"3.9.0"` |  |
| cleaner.nodeSelector | object | `{}` |  |
| cleaner.pdb.enabled | bool | `false` |  |
| cleaner.pdb.minAvailable | int | `1` |  |
| cleaner.podLabels | object | `{}` |  |
| cleaner.priorityClassName | string | `""` |  |
| cleaner.replicas | int | `1` |  |
| cleaner.tolerations | list | `[]` |  |
| cleaner.topologySpreadConstraints | list | `[]` |  |
| controller.affinity | object | `{}` |  |
| controller.create | bool | `true` |  |
| controller.image.pullPolicy | string | `"IfNotPresent"` |  |
| controller.image.registry | string | `"docker.io"` |  |
| controller.image.repository | string | `"bitbucketpipelines/runners-autoscaler"` |  |
| controller.image.tag | string | `"3.9.0"` |  |
| controller.nodeSelector | object | `{}` |  |
| controller.pdb.enabled | bool | `false` |  |
| controller.pdb.minAvailable | int | `1` |  |
| controller.podLabels | object | `{}` |  |
| controller.priorityClassName | string | `""` |  |
| controller.replicas | int | `1` |  |
| controller.tolerations | list | `[]` |  |
| controller.topologySpreadConstraints | list | `[]` |  |
| credentialsSecret.atlassianAccountEmail | string | `""` |  |
| credentialsSecret.atlassianApiToken | string | `""` |  |
| credentialsSecret.bitbucketAppPassword | string | `""` |  |
| credentialsSecret.bitbucketUsername | string | `""` |  |
| credentialsSecret.create | bool | `true` |  |
| credentialsSecret.name | string | `""` |  |
| extraManifests | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| global.commonLabels | object | `{}` |  |
| global.nodeSelector | object | `{}` |  |
| global.tolerations | list | `[]` |  |
| nameOverride | string | `""` |  |
| rbac.create | bool | `true` |  |
| runner.affinity | object | `{}` |  |
| runner.config.constants.default_sleep_time_runner_delete | int | `5` |  |
| runner.config.constants.default_sleep_time_runner_setup | int | `10` |  |
| runner.config.constants.runner_api_polling_interval | int | `600` |  |
| runner.config.constants.runner_cool_down_period | int | `300` |  |
| runner.config.groups[0].labels[0] | string | `"my.group"` |  |
| runner.config.groups[0].name | string | `"default"` |  |
| runner.config.groups[0].namespace | string | `"bitbucket-runner"` |  |
| runner.config.groups[0].parameters.max | int | `10` |  |
| runner.config.groups[0].parameters.min | int | `1` |  |
| runner.config.groups[0].parameters.scale_down_multiplier | float | `0.5` |  |
| runner.config.groups[0].parameters.scale_down_threshold | float | `0.2` |  |
| runner.config.groups[0].parameters.scale_up_multiplier | float | `1.5` |  |
| runner.config.groups[0].parameters.scale_up_threshold | float | `0.5` |  |
| runner.config.groups[0].strategy | string | `"percentageRunnersIdle"` |  |
| runner.config.groups[0].workspace | string | `""` |  |
| runner.dind.daemonConfigFile | string | `"/etc/docker/daemon.json"` |  |
| runner.dind.image.pullPolicy | string | `"IfNotPresent"` |  |
| runner.dind.image.registry | string | `"docker.io"` |  |
| runner.dind.image.repository | string | `"docker"` |  |
| runner.dind.image.tag | string | `"dind"` |  |
| runner.dind.registryMirrors | list | `[]` |  |
| runner.image.pullPolicy | string | `"IfNotPresent"` |  |
| runner.image.registry | string | `"docker-public.packages.atlassian.com"` |  |
| runner.image.repository | string | `"sox/atlassian/bitbucket-pipelines-runner"` |  |
| runner.image.tag | string | `"1"` |  |
| runner.nodeSelector | object | `{}` |  |
| runner.priorityClassName | string | `""` |  |
| runner.serviceAccount.annotations | object | `{}` |  |
| runner.serviceAccount.create | bool | `true` |  |
| runner.serviceAccount.name | string | `""` |  |
| runner.template.job | string | `"apiVersion: batch/v1\nkind: Job\nmetadata:\n  name: runner-<%runner_uuid%>  # mandatory, don't modify\nspec:\n  template:\n    metadata:\n      labels:\n        customer: shared\n        account_uuid: <%account_uuid%>  # mandatory, don't modify\n        runner_uuid: <%runner_uuid%>  # mandatory, don't modify\n    {%- if repository_uuid %}\n        repository_uuid: <%repository_uuid%>  # mandatory, don't modify\n    {%- endif %}\n        runner_namespace: <%runner_namespace%>  # mandatory, don't modify\n    spec:\n      tolerations: {{ include \"bitbucketRunnerAutoscaler.runnerTolerations\" . | nindent 16 }}\n      nodeSelector: {{ include \"bitbucketRunnerAutoscaler.runnerNodeSelector\" . | nindent 16 }}\n      topologySpreadConstraints: {{ .Values.runner.topologySpreadConstraints | toYaml | nindent 16 }}\n      affinity: {{ .Values.runner.affinity | toYaml | nindent 16 }}\n      priorityClassName: {{ .Values.runner.priorityClassName }}\n      serviceAccountName: {{ include \"bitbucketRunnerAutoscaler.fullname\" . }}-runner\n      containers:\n        - name: runner\n          image: {{ include \"bitbucketRunnerAutoscaler.runnerImage\" . }} # This autoscaler needs the runner image to run, you can use the latest or pin any version you want.\n          imagePullPolicy: {{ .Values.runner.image.pullPolicy }}\n          resources:  # This is memory and cpu resources section that you can configure via config map settings file.\n            requests:\n              memory: \"<%requests_memory%>\"  # mandatory, don't modify\n              cpu: \"<%requests_cpu%>\"  # mandatory, don't modify\n            limits:\n              memory: \"<%limits_memory%>\"  # mandatory, don't modify\n              cpu: \"<%limits_cpu%>\"  # mandatory, don't modify\n          env:\n            - name: ACCOUNT_UUID  # mandatory, don't modify\n              value: \"{<%account_uuid%>}\"  # mandatory, don't modify\n        {%- if repository_uuid %}\n            - name: REPOSITORY_UUID  # mandatory, don't modify\n              value: \"{<%repository_uuid%>}\"  # mandatory, don't modify\n        {%- endif %}\n            - name: RUNNER_UUID  # mandatory, don't modify\n              value: \"{<%runner_uuid%>}\"  # mandatory, don't modify\n            - name: OAUTH_CLIENT_ID\n              valueFrom:\n                secretKeyRef:\n                  name: runner-oauth-credentials-<%runner_uuid%>\n                  key: oauth_client_id\n            - name: OAUTH_CLIENT_SECRET\n              valueFrom:\n                secretKeyRef:\n                  name: runner-oauth-credentials-<%runner_uuid%>\n                  key: oauth_client_secret\n            - name: WORKING_DIRECTORY\n              value: \"/tmp\"\n          volumeMounts:\n            - name: tmp\n              mountPath: /tmp\n            - name: docker-containers\n              mountPath: /var/lib/docker/containers\n              readOnly: true\n            - name: var-run\n              mountPath: /var/run\n        - name: docker\n          image: {{ include \"bitbucketRunnerAutoscaler.dindImage\" . }}\n          imagePullPolicy: {{ .Values.runner.dind.image.pullPolicy }}\n          securityContext:\n            privileged: true\n          volumeMounts:\n            - name: tmp\n              mountPath: /tmp\n            - name: docker-containers\n              mountPath: /var/lib/docker/containers\n            - name: var-run\n              mountPath: /var/run\n            {{- if .Values.runner.dind.registryMirrors }}\n            - name: dind\n              mountPath: {{ .Values.runner.dind.daemonConfigFile }}\n              subPath: daemon.json\n            {{- end }}\n      restartPolicy: OnFailure\n      volumes:\n        - name: tmp\n        - name: docker-containers\n        - name: var-run\n        {{- if .Values.runner.dind.registryMirrors }}\n        - name: dind\n          configMap:\n            name: {{ include \"bitbucketRunnerAutoscaler.fullname\" . }}-dind\n        {{- end }}\n  backoffLimit: 6\n  completions: 1\n  parallelism: 1\n"` |  |
| runner.template.secret | string | `"apiVersion: v1\nkind: Secret\nmetadata:\n  name: runner-oauth-credentials-<%runner_uuid%>  # mandatory, don't modify\n  labels:\n    account_uuid: <%account_uuid%>  # mandatory, don't modify\n{%- if repository_uuid %}\n    repository_uuid: <%repository_uuid%>  # mandatory, don't modify\n{%- endif %}\n    runner_uuid: <%runner_uuid%>  # mandatory, don't modify\n    runner_namespace: <%runner_namespace%>  # mandatory, don't modify\ndata:\n  oauth_client_id: <%oauth_client_id_base64%>\n  oauth_client_secret: <%oauth_client_secret_base64%>\n"` |  |
| runner.tolerations | list | `[]` |  |
| runner.topologySpreadConstraints | list | `[]` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Labyrinth Labs | <contact@lablabs.io> | <https://lablabs.io> |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
