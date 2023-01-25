//param and variables
param location string

param subnetID string

param lbBackEndName string

@description('Scale Set')
param singlePlacementGroup bool = true
param platformFaultDomainCount int = 1
param instanceCount int = 3
var vmScaleSetName = 'vmScaleSet'

param loadBalancerName string

param vmSize string



@description('virtual machines param')
@secure()
param vmUsername string
@secure()
param vmPassword string

var imageReference = osVersion
param vmSku string = '2019-Datacenter'
var ipConfigName = '${vmScaleSetName}IP'

@description('vmType')
var osVersion = {
publisher: 'MicrosoftWindowsServer'
sku: vmSku
offer: 'WindowsServer'
version: 'latest'
}
//end param and variables

resource vmScaleSet1 'Microsoft.Compute/virtualMachineScaleSets@2021-11-01' = {
  name: vmScaleSetName
  location: location
  sku: {
    name: vmSize
    tier: 'Standard'
    capacity: instanceCount
  }
  properties: {
    overprovision: true
    upgradePolicy: {
      mode: 'Automatic'
    }
    singlePlacementGroup: singlePlacementGroup
    platformFaultDomainCount: platformFaultDomainCount
    virtualMachineProfile: {
      storageProfile: {
        osDisk: {
          caching: 'ReadWrite'
          createOption: 'FromImage'
        }
        imageReference: imageReference
      }
      osProfile: {
        adminUsername: vmUsername
        adminPassword: vmPassword
        computerNamePrefix: 'Scale'
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'vmNic'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: ipConfigName
                  properties: {
                    subnet: {
                      id: subnetID
                    }
                    loadBalancerBackendAddressPools: [
                      {
                        id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancerName, lbBackEndName)
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}
