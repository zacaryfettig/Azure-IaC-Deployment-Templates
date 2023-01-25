//param and variables
param location string

@description('virtual machines param')

param vmUsername string = 'username1'

@secure()
param vmPassword string

param lbFrontEndName string = 'lbFrontEndName'
param lbBackEndName string = 'lbBackEndName'
param loadBalancerName string = 'loadBalancerName'


@description('public IP')
param publicIpSku string = 'standard'

param vmSize string = 'Standard_A1_v2'

//end param and variables

module networkingModule 'networking.bicep' = {
  name: 'networkingModule'
  params: {
    location: location
    publicIpSku: publicIpSku
  }
}

module vmScaleSet 'scaleSet.bicep' = {
  name: 'vmScaleSet'
  params: {
    location: location
    subnetID: networkingModule.outputs.subnetID
    vmPassword: vmPassword
    vmUsername: vmUsername
    lbBackEndName: lbBackEndName
    vmSize: vmSize
    loadBalancerName: loadBalancerName
  }
}

module loadBalancer 'loadBalancer.bicep' = {
  name: loadBalancerName
  params: {
    location: location
    subnetID: networkingModule.outputs.subnetID
    lbBackEndName: lbBackEndName
    lbFrontEndName: lbFrontEndName
    loadBalancerName: loadBalancerName
  }
}
