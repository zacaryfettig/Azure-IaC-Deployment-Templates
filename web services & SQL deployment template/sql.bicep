//param and variables
@description('SQL variables')
param sqlServerName string
param administratorLogin string

@secure()
param administratorLoginPassword string

@allowed ([
  'development'
  'production'
  ])
  param environment string

  param location string
  var appName = 'webapp'
  var databaseName = '${appName}-sqldatabase${environment}'

  //end param and variables

@description('SQL Server to host database')
resource sqlServer 'Microsoft.Sql/servers@2014-04-01' ={
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

@description('SQL Database')
resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2014-04-01' = {
  parent: sqlServer
  name: databaseName
  location: location
 sku: {
  name: 'basic'
  tier: 'basic'
 }
}
