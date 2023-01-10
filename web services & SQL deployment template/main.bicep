param administratorLogin string
@secure()
param administratorLoginPassword string

param tenantID string
param accountObjectID string = 'fc2cdf01-0d2f-41a9-90f4-25f3064e5344'

var location = 'westus'
var appName = 'webapp'


@allowed ([
'development'
'production'
])
param environment string

@description('vnet')
var vnetName = '${appName}vnet'
var vnetAddressPrefix = '10.10.30.0/16'
var subnetName = '${appName}sn'
var subnetAddressPrefix = '10.10.30.0/24'

//add resource group

@description('SQL Server to host database')
resource sqlServer 'Microsoft.Sql/servers@2014-04-01' ={
  name: 'unique name1'
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

@description('SQL Database')
resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2014-04-01' = {
  parent: sqlServer
  name: '${appName}-sqldatabase${environment}'
  location: location
 sku: {
  name: 'basic'
  tier: 'basic'
 }
}


@description('Connect SQL to AppService over Microsoft backbone')
resource privateend 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: 'SQLtoAPP'
  location: location
  
  properties: { 
     privateLinkServiceConnections: [
     
     ]
  }
}



@description('Store DB Password')
resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: 'name'
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: tenantID
    accessPolicies: [
      {
        tenantId: tenantID
        objectId: accountObjectID
        permissions: {
          keys: [
            'get'
          ]
          secrets: [
            'list'
            'get'
          ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A' 
    }
  }
}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  parent: keyVault
  name: 'sqlPass'
  properties: {
    value: administratorLoginPassword
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

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'name'
  location: location
  sku: {
    //pricing tier
    name: 'F1'
    capacity: 1
  }
}

resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: vnet.properties.subnets[0].id
    httpsOnly: true
    siteConfig: {
      vnetRouteAllEnabled: true
      http20Enabled: true
    }

  }
}
