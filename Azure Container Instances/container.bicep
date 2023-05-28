//Container Variables
@description('Name for the container group')
param containerName string
@description('Container image to deploy')
param image string
@description('Port to open on the container and the public IP address.')
param port int
@description('number of CPU cores')
param cpuCores int
@description('amount of memory')
param memoryInGb int
@description('Location')
param location string
@description('The behavior of container when stopped.')
param restartPolicy string

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: containerName
  location: location
  properties: {
    containers: [
      {
        name: containerName
        properties: {
          image: image
          ports: [
            {
              port: port
              protocol: 'TCP'
            }
          ]
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryInGb
            }
          }
        }
      }
    ]
    osType: 'Linux'
    restartPolicy: restartPolicy
    ipAddress: {
      type: 'Public'
      ports: [
        {
          port: port
          protocol: 'TCP'
        }
      ]
    }
  }
}
