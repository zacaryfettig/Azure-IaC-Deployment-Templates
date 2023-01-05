var location = 'westus'
var appName = 'webapp'


@allowed ([
'development'
'production'
])
param environment string

@description('storing web content')
resource storage1 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'uniquename2'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'BlobStorage'
}

resource blobcontainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: 'blob'
}

resource sqlServer 'Microsoft.Sql/servers@2014-04-01' ={
  name: 'unique name1'
  location: location
  properties: {
    administratorLogin: 'db_admin'
    administratorLoginPassword: '7a3tui5c'
    //change password to keyvault credential
  }
}

resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2014-04-01' = {
  parent: sqlServer
  name: '${appName}-sqldatabase${environment}'
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    edition: 'Basic'
    maxSizeBytes: '34359738368'
    requestedServiceObjectiveName: 'Basic'
  }
}

resource firewall 'Microsoft.Network/azureFirewalls@2022-07-01' = {
  name: 
}

resource privateend 'Microsoft.Network/privateEndpoints@2022-07-01' = {
  name: 
}
