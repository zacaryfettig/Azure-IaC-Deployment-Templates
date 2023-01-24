//param and variables
param location string = resourceGroup().location

@description('virtual machines param')
@secure()
param vmUsername string
@secure()
param vmPassword string

param lbFrontEndName string = 'lbFrontEndName'
param lbBackEndName string = 'lbBackEndName'


@description('public IP')
param publicIpSku string = 'standard'

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
    vmPassword: vmUsername
    vmUsername: vmPassword
    lbBackEndName: lbFrontEndName
    lbFrontEndName: lbFrontEndName
  }
}

module loadBalancer 'loadBalancer.bicep' = {
  name: 'loadBalancer'
  params: {
    location: location
    subnetID: networkingModule.outputs.subnetID
    lbBackEndName: lbBackEndName
    lbFrontEndName: lbFrontEndName
  }
}
