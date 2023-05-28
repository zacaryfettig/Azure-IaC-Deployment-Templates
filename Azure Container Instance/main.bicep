//Container Variables
@description('Name for the container group')
param containerName string = 'acilinuxpublicipcontainergroup'
@description('Container image to deploy')
param image string = 'mcr.microsoft.com/mssql/server:2022-latest'
@description('Port to open on the container and the public IP address.')
param port int = 80
@description('number of CPU')
param cpuCores int = 1
@description('amount of memory')
param memoryInGb int = 2
@description('Location')
param location string = resourceGroup().location

@description('The behavior of container when stopped.')
@allowed([
  'Always'
  'Never'
  'OnFailure'
])
param restartPolicy string = 'Always'

@description('SQL Server and Database')
module container 'container.bicep' = {
  name: 'containerModule'
  params: {
    containerName: containerName
    image: image
    port: port
    cpuCores: cpuCores
    memoryInGb: memoryInGb
    restartPolicy: restartPolicy
    location: location
  }
}
