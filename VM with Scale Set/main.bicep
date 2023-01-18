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

@description('public IP')
var publicIPName = 'publicip1'
var subnetName = 'Subnet-1'
var publicIPAllocationMethod = 'static'

param publicIpSku string = 'standard'

param skuCapacity int = 1
var vmScaleSetName = 'vmScaleSet'

@description('load balancer')
var loadBalancerName = 'loadBalancerName'
var lbFrontEndName = 'lbFrontEndName'
var lbBackEndName = 'lbBackEndName'
var lbProbeName = 'lbProbe'



//param and variables


resource loadBalancerInternal 'Microsoft.Network/loadBalancers@2022-07-01' = {
  name: loadBalancerName
  location: location
  properties: {
    frontendIPConfigurations: [
      {
        name: lbFrontEndName
        properties: {
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: lbBackEndName
        properties: {
loadBalancerBackendAddresses: [
 
]
        }
      }
    ]
    loadBalancingRules: [
      {
        name: 'rule1'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIpConfigurations', loadBalancerName, lbFrontEndName)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancerName, lbBackEndName)
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 5
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', loadBalancerName, lbProbeName)
          }
        }
      }
    ]
    probes: [
      {
        name: lbProbeName
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

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: publicIPName
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}

resource nsg1 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: 'nsg1'
  properties: {
     securityRules: [
       
     ]
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
    properties: {
      addressPrefix: '10.0.0.0/24'
      networkSecurityGroup: {
        id: nsg1.id
        }
      }
  
}




resource vmScaleSet 'Microsoft.Compute/virtualMachineScaleSets@2022-08-01' = {
  name: vmScaleSetName
  location: location
  sku: {
     name:vmSku
     tier: 'standard'
     capacity: skuCapacity
  }
  properties: {
    
  }
}

resource vmScaleSet1 'Microsoft.Compute/virtualMachineScaleSets@2021-11-01' = {
  name: vmScaleSetName
  location: location
  sku: {
    name: vmSku
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
        computerNamePrefix: vmScaleSetName
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: nicName
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: ipConfigName
                  properties: {
                    subnet: {
                      id: vNet.properties.subnets[0].id
                    }
                    loadBalancerBackendAddressPools: [
                      {
                        id: lbPoolID
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
      extensionProfile: {
        extensions: [
          {
            name: 'Microsoft.Powershell.DSC'
            properties: {
              publisher: 'Microsoft.Powershell'
              type: 'DSC'
              typeHandlerVersion: '2.9'
              autoUpgradeMinorVersion: true
              forceUpdateTag: powershelldscUpdateTagVersion
              settings: {
                configuration: {
                  url: powershelldscZipFullPath
                  script: 'InstallIIS.ps1'
                  function: 'InstallIIS'
                }
                configurationArguments: {
                  nodeName: 'localhost'
                  WebDeployPackagePath: webDeployPackageFullPath
                }
              }
            }
          }
        ]
      }
    }
  }
}
