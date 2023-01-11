//param and variables
var appName = 'webapp'
param location string
var privateEndpointName = 'SQLtoAPP'

@description('vnet')
var vnetName = '${appName}vnet'
var vnetAddressPrefix = '10.10.30.0/16'
var subnetName = 'subnet-${appName}'
var subnetAddressPrefix = '10.10.30.0/24'

//end param and variables

@description('Connect SQL to AppService over Microsoft backbone')
resource privateendpoint 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: privateEndpointName
  location: location
  
  properties: { 
     privateLinkServiceConnections: [
     
     ]
  }
}

@description('virtual network creation')
resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
}

@description('output to main for appService param pass through')
output networkingVnet string = vnet.properties.subnets[0].id
