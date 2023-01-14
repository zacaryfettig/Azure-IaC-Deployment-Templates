param location string
param resourceGroupName string

targetScope = 'subscription'
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}
