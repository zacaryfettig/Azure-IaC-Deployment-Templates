//param and variables
param location string


@description('VNet param')
var vnetName = 'vnet1'

@description('vmNic')
var vmNic = 'nic1'

@description('public IP')
param publicIpSku string


@description('public IP')
var publicIPName = 'publicip1'
var subnetName = 'vnet1/Subnets'
var publicIPAllocationMethod = 'static'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}


resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' = {
  name: subnetName
  dependsOn: [
    virtualNetwork
  ]
    properties: {
      addressPrefix: '10.0.0.0/24'
      
      networkSecurityGroup: {
        id: networkSecurityGroup.id
        }
      }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: vmNic
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIP.id
          }
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
}

//public IP
resource publicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: publicIPName
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: 'name'
  location: location
  properties: {
    securityRules: [
      {
        name: 'nsgRule'
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}

output subnetID string = subnet.id
