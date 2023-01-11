//param and variables
@description('keyVault variables')
param tenantID string
param accountObjectID string

@secure()
param administratorLoginPassword string

param location string
var keyVaultName = 'KeyVault'

//end param and variables

@description('keyVault creation')
resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultName
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

@description('KeyVault Secret creation')
resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  parent: keyVault
  name: 'sqlPassword'
  properties: {
    value: administratorLoginPassword
  }
}
