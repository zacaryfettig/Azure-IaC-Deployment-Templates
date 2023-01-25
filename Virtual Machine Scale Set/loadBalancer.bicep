//param and variables
param location string

@description('load balancer')
param loadBalancerName string
param lbFrontEndName string
param lbBackEndName string
var lbProbeName = 'lbProbe'
param subnetID string

//end param and variables

resource loadBalancerInternal 'Microsoft.Network/loadBalancers@2022-07-01' = {
  name: loadBalancerName
  location: location
  properties: {
    frontendIPConfigurations: [
      {
        name: lbFrontEndName
        properties: {
          subnet: {
            id: subnetID
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: lbBackEndName
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
