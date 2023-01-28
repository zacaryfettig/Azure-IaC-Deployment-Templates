//params and variables
param location string = resourceGroup().location

@description('SQL variables')

@allowed( [
  'basic'
  'standard'
  'premium'
])
param SQLedition string

param sqlserverName string = 'sqlServer${uniqueString(deployment().name)}'
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

@description('webApp')
param appName string = 'webapp809'
param appPlanTier string


//params and variables end


@description('SQL Server and Database')
module sqlServerDatabase 'sql.bicep' = {
  name: 'sqlModule'
  params: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    environment: environment
    location: location
    sqlServerName: sqlserverName
    SQLedition: SQLedition
  }
}

module networking 'networking.bicep' = {
  name: 'networkingModule'
  params: {
    location: location
   privateLinkServiceId: sqlServerDatabase.outputs.sqlserverID
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
