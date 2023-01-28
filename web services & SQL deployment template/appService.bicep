//params and variables
param location string
param appName string
param appPlanTier string
param virtualNetworkSubnetID string
var appPlanName = 'appPlan${uniqueString(deployment().name)}'
//end params and variables

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appPlanName
  location: location
  sku: {
    //pricing tier
    name: appPlanTier
    capacity: 1
  }
}



resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: virtualNetworkSubnetID
    httpsOnly: true
    siteConfig: {
      vnetRouteAllEnabled: true
      http20Enabled: true
    }
  }
}
