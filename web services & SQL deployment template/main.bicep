//params and variables
@description('SQL variables')
param sqlServerName string = 'sqlServer${uniqueString(resourceGroup().id)}'
param administratorLogin string
@secure()
param administratorLoginPassword string

@allowed ([
  'development'
  'production'
  ])
  param environment string

@description('keyVault variables')
param tenantID string = '09aedc25-108f-49fe-8f2a-8fcf474f365d'
param accountObjectID string = 'fc2cdf01-0d2f-41a9-90f4-25f3064e5344'

param location string = 'westus'

param appName string = 'webapp'
param appPlanTier string = 'F1'


//params and variables end


@description('SQL Server and Database')
module sqlServerDatabase 'sql.bicep' = {
  name: 'sqlModule'
  params: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    environment: environment
    location: location
    sqlServerName: sqlServerName
  }
}

module networking 'networking.bicep' = {
  name: 'networkingModule'
  params: {
    location: location
  }
}

module keyVault 'keyVault.bicep' = {
  name: 'keyVaultModule'
  params: {
    accountObjectID: accountObjectID
    administratorLoginPassword: administratorLoginPassword
    location: location
    tenantID: tenantID
  }
}

module appService 'appService.bicep' = {
  name: 'appServiceModule'
  params: {
    appName: appName
    appPlanTier: appPlanTier
    location: location
    virtualNetworkSubnetID: networking.outputs.networkingVnet
  }
}
