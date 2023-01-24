param resourceGroupName string = deployment().name
param location string = deployment().location

targetScope = 'subscription'
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}
