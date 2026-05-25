# Helm chart for csi-s3

This chart adds S3 volume support to your cluster.

## Install chart

- Helm 2.x:
  `helm install [--set secret.accessKey=... --set secret.secretKey=... ...] --namespace kube-system --name csi-s3 .`
- Helm 3.x: `helm install [--set secret.accessKey=... --set secret.secretKey=... ...] --namespace kube-system csi-s3 .`

After installation succeeds, you can get a status of Chart: `helm status csi-s3`.

## Delete Chart

- Helm 2.x: `helm delete --purge csi-s3`
- Helm 3.x: `helm uninstall csi-s3 --namespace kube-system`

## Configuration

By default, this chart creates a secret and a storage class. You should at least set `secret.accessKey` and
`secret.secretKey`
to your [Yandex Object Storage](https://cloud.yandex.com/en-ru/services/storage) keys for it to work.

The following table lists all configuration parameters and their default values.

| Parameter                                               | Description                                                                                                                  | Default                                                          |
|---------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------|
| `customLabels`                                          | optional extra labels added to all k8s resources deployed by the chart                                                       | `{}`                                                             |
| `images.s3`                                             | csi-s3 driver image                                                                                                          | `docker.io/thxcode/csi-s3-driver:0.43.7`                         |
| `images.csiProvisioner`                                 | csi-provisioner image                                                                                                        | `registry.k8s.io/sig-storage/csi-provisioner:v6.1.0`             |
| `images.livenessProbe`                                  | liveness-probe image                                                                                                         | `registry.k8s.io/sig-storage/livenessprobe:v2.17.0`              |
| `images.nodeDriverRegistrar`                            | csi-node-driver-registrar image                                                                                              | `registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.15.0`  |
| `imagePullPolicy`                                       | image pull policy applied to all containers                                                                                  | `IfNotPresent`                                                   |
| `imagePullSecrets`                                      | docker-registry secret names used to pull images                                                                             | `[]`                                                             |
| `driver.name`                                           | CSI driver name                                                                                                              | `ru.yandex.s3.csi`                                               |
| `kubeletDir`                                            | kubelet working directory on the host                                                                                        | `/var/lib/kubelet`                                               |
| `serviceAccount.create`                                 | create service accounts for controller and node                                                                              | `true`                                                           |
| `serviceAccount.controller`                             | name of the controller service account                                                                                       | `csi-s3-controller-sa`                                           |
| `serviceAccount.node`                                   | name of the node service account                                                                                             | `csi-s3-node-sa`                                                 |
| `rbac.create`                                           | create RBAC resources                                                                                                        | `true`                                                           |
| `rbac.name`                                             | base name used for RBAC resources                                                                                            | `s3`                                                             |
| `controller.name`                                       | controller deployment name                                                                                                   | `csi-s3-controller`                                              |
| `controller.replicas`                                   | replica count of the controller deployment                                                                                   | `1`                                                              |
| `controller.strategyType`                               | controller deployment strategy type                                                                                          | `Recreate`                                                       |
| `controller.runOnMaster`                                | tolerate scheduling onto master nodes (deprecated on k8s 1.25+)                                                              | `false`                                                          |
| `controller.runOnControlPlane`                          | tolerate scheduling onto control-plane nodes                                                                                 | `false`                                                          |
| `controller.logLevel`                                   | controller driver log level                                                                                                  | `5`                                                              |
| `controller.affinity`                                   | controller pod affinity                                                                                                      | `{}`                                                             |
| `controller.nodeSelector`                               | controller pod node selector                                                                                                 | `{}`                                                             |
| `controller.tolerations`                                | controller pod tolerations                                                                                                   | tolerations for master / control-plane / `CriticalAddonsOnly`    |
| `controller.priorityClassName`                          | controller pod priorityClassName                                                                                             | `system-cluster-critical`                                        |
| `controller.resources.csiProvisioner.limits.memory`     | csi-provisioner memory limits                                                                                                | `400Mi`                                                          |
| `controller.resources.csiProvisioner.requests.cpu`      | csi-provisioner cpu requests                                                                                                 | `10m`                                                            |
| `controller.resources.csiProvisioner.requests.memory`   | csi-provisioner memory requests                                                                                              | `20Mi`                                                           |
| `controller.resources.s3.limits.memory`                 | csi-s3 driver memory limits                                                                                                  | `200Mi`                                                          |
| `controller.resources.s3.requests.cpu`                  | csi-s3 driver cpu requests                                                                                                   | `10m`                                                            |
| `controller.resources.s3.requests.memory`               | csi-s3 driver memory requests                                                                                                | `20Mi`                                                           |
| `nodeDriverRegistrar.healthPort`                        | health check port for node-driver-registrar liveness probe                                                                   | `19819`                                                          |
| `nodeDriverRegistrar.livenessProbe.enabled`             | enable node-driver-registrar liveness probe                                                                                  | `true`                                                           |
| `nodeDriverRegistrar.livenessProbe.initialDelaySeconds` | node-driver-registrar liveness probe initialDelaySeconds                                                                     | `20`                                                             |
| `nodeDriverRegistrar.livenessProbe.timeoutSeconds`      | node-driver-registrar liveness probe timeoutSeconds                                                                          | `10`                                                             |
| `nodeDriverRegistrar.livenessProbe.periodSeconds`       | node-driver-registrar liveness probe periodSeconds                                                                           | `5`                                                              |
| `nodeDriverRegistrar.livenessProbe.failureThreshold`    | node-driver-registrar liveness probe failureThreshold                                                                        | `2`                                                              |
| `node.name`                                             | driver node daemonset name                                                                                                   | `csi-s3-node`                                                    |
| `node.dnsPolicy`                                        | dnsPolicy of driver node daemonset, available values: `Default`, `ClusterFirstWithHostNet`, `ClusterFirst`                   | `ClusterFirstWithHostNet`                                        |
| `node.maxUnavailable`                                   | `maxUnavailable` value of driver node daemonset                                                                              | `1`                                                              |
| `node.logLevel`                                         | node driver log level                                                                                                        | `5`                                                              |
| `node.livenessProbe.healthPort`                         | health check port for the node liveness probe                                                                                | `29663`                                                          |
| `node.affinity`                                         | node pod affinity                                                                                                            | `{}`                                                             |
| `node.nodeSelector`                                     | node pod node selector                                                                                                       | `{}`                                                             |
| `node.priorityClassName`                                | node pod priority class name                                                                                                 | `system-cluster-critical`                                        |
| `node.tolerations`                                      | node pod tolerations                                                                                                         | `- operator: "Exists"`                                           |
| `node.resources.livenessProbe.limits.memory`            | liveness-probe memory limits                                                                                                 | `100Mi`                                                          |
| `node.resources.livenessProbe.requests.cpu`             | liveness-probe cpu requests                                                                                                  | `10m`                                                            |
| `node.resources.livenessProbe.requests.memory`          | liveness-probe memory requests                                                                                               | `20Mi`                                                           |
| `node.resources.nodeDriverRegistrar.limits.memory`      | csi-node-driver-registrar memory limits                                                                                      | `100Mi`                                                          |
| `node.resources.nodeDriverRegistrar.requests.cpu`       | csi-node-driver-registrar cpu requests                                                                                       | `10m`                                                            |
| `node.resources.nodeDriverRegistrar.requests.memory`    | csi-node-driver-registrar memory requests                                                                                    | `20Mi`                                                           |
| `node.resources.s3.limits.memory`                       | csi-s3 driver memory limits                                                                                                  | `300Mi`                                                          |
| `node.resources.s3.requests.cpu`                        | csi-s3 driver cpu requests                                                                                                   | `10m`                                                            |
| `node.resources.s3.requests.memory`                     | csi-s3 driver memory requests                                                                                                | `20Mi`                                                           |
| `secret.create`                                         | create the S3 credentials Secret                                                                                             | `false`                                                          |
| `secret.name`                                           | name of the credentials Secret                                                                                               | _(unset)_                                                        |
| `secret.endpoint`                                       | S3 endpoint URL                                                                                                              | _(unset)_                                                        |
| `secret.region`                                         | S3 region                                                                                                                    | _(unset)_                                                        |
| `secret.accessKey`                                      | S3 access key ID                                                                                                             | _(unset)_                                                        |
| `secret.secretKey`                                      | S3 secret access key                                                                                                         | _(unset)_                                                        |
| `storageClass.create`                                   | create a StorageClass                                                                                                        | `false`                                                          |
| `storageClass.name`                                     | name of the StorageClass                                                                                                     | _(unset)_                                                        |
| `storageClass.annotations`                              | annotations applied to the StorageClass (e.g. to mark it as default)                                                         | `{}`                                                             |
| `storageClass.parameters.mounter`                       | mounter used by the driver                                                                                                   | `geesefs`                                                        |
| `storageClass.parameters.options`                       | mounter options string                                                                                                       | _(unset)_                                                        |
| `storageClass.parameters.bucket`                        | single bucket used for all dynamically provisioned PVs                                                                       | _(unset)_                                                        |
| `storageClass.parameters.prefix`                        | prefix used for all dynamically provisioned PVs within the bucket                                                            | _(unset)_                                                        |
| `storageClass.reclaimPolicy`                            | StorageClass reclaim policy                                                                                                  | `Delete`                                                         |
| `storageClass.volumeBindingMode`                        | StorageClass volume binding mode                                                                                             | `Immediate`                                                      |
| `storageClasses`                                        | create multiple StorageClasses (used in addition to `storageClass.create`)                                                   | `[]`                                                             |

### Tips

#### `storageClass.parameters.prefix` parameter supports following pv/pvc metadata conversion

> if `storageClass.parameters.prefix` value contains following strings, it would be converted into corresponding pv/pvc
> name or namespace

- `${pvc.metadata.name}`
- `${pvc.metadata.namespace}`
- `${pv.metadata.name}`
