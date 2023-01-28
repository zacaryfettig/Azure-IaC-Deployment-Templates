//param and variables
var appName = 'webapp'
param location string
var privateEndpointName = 'SQLtoAPP'

@description('vnet')
var vnetName = '${appName}vnet'
var vnetAddressPrefix = '10.0.0.0/16'
var subnetName = 'subnet-${appName}'
var subnetName2 = 'subnet-2${appName}'
var subnetAddressPrefix = '10.0.0.0/24'
var subnetAddressPrefix2 = '10.0.1.0/24'
param privateLinkServiceId string

//end param and variables

@description('Connect SQL to AppService over Microsoft backbone')
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: privateEndpointName
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: [
            'sqlserver'
          ]
        }
      }
    ]
    subnet: {
      id: vnet.properties.subnets[1].id
    }
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
      {
        name: subnetName2
        properties: {
          addressPrefix: subnetAddressPrefix2
        }
      }
    ]
  }
}

@description('output to main for appService param pass through')
output networkingVnet string = vnet.properties.subnets[0].id
