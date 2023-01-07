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

@description('SQL Server to host database')
resource sqlServer 'Microsoft.Sql/servers@2014-04-01' ={
  name: 'unique name1'
  location: location
  properties: {
    administratorLogin: 'db_admin'
    administratorLoginPassword: '7a3tui5c'
    //change password to keyvault credential
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
}

@description('Store DB Password')
resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: 'name'
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: 'tenantId'
    accessPolicies: [
      {
        tenantId: 'tenantId'
        objectId: 'objectId'
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
  name: 'keyVaultName/name'
  properties: {
    value: 'value'
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
