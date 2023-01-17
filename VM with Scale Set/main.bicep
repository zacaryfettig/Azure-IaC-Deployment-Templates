//param and variables
@description('virtual machines param')
param vmName string = 'vmss1'
param vmSize string = 'standard_DS1_v2'
param location string = resourceGroup().location
param adminUsername string = 'User'
var vmDisk = 'vmssDisk'

@description('vmType')
var publisher = 'MicrosoftWindowsServer'
var offer = 'WindowsServer'
param vmSku string = '2019-Datacenter'
var version = 'latest'

@description('vmNic')
var vmNic = 'nic1'

@secure()
param vmUsername string
@secure()
param vmPassword string

@description('VNet param')
var vnetName = 'vnet1'



//param and variables

resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: vmUsername
      adminPassword: vmPassword
    }
    storageProfile: {
      imageReference: {
        publisher: publisher
        offer: offer
        sku: vmSku
        version: version
      }
      osDisk: {
        name: vmDisk
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: 'id'
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri:  'storageUri'
      }
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
            id: pip.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vn.name, subnetName)
          }
        }
      }
    ]
  }
}

resource nsg1 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: 
  properties: {
     securityRules: [
       
     ]
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
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



resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'Subnet-1'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
           id: nsg1.id
          }
        }
      }
    ]
  }
}



resource loadBalancerInternal 'Microsoft.Network/loadBalancers@2020-11-01' = {
  name: 'lb1'
  location: location
  properties: {
    frontendIPConfigurations: [
      {
        name: 'name'
        properties: {
          privateIPAddress: '0.0.0.0'
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: 'subnet.id'
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'name'
      }
    ]
    loadBalancingRules: [
      {
        name: 'name'
        properties: {
          frontendIPConfiguration: {
            id: 'frontendIPConfiguration.id'
          }
          backendAddressPool: {
            id: 'backendAddressPool.id'
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 5
          probe: {
            id: 'probe.id'
          }
        }
      }
    ]
    probes: [
      {
        name: 'name'
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]
  }
}

resource vmScaleSet 'Microsoft.Compute/virtualMachineScaleSets@2022-08-01' = {
  name: 
  location: location
  sku: {
     name:vmSku
     tier: 'standard'
     capacity: 
  }
  properties: {
    
  }
}
