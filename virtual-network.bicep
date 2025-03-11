param location string

param virtualNetworkName string
param delegatedSubnetNSGName string

resource delegatedSubnetNSG 'Microsoft.Network/networkSecurityGroups@2022-11-01' existing = {
  name: delegatedSubnetNSGName
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
        addressPrefixes: [
            '10.0.0.0/22'
        ]
    }
    subnets: [
        {
            name: 'default'
            properties: {
                addressPrefix: '10.0.0.0/23'
                serviceEndpoints: []
                delegations: []
                privateEndpointNetworkPolicies: 'Enabled'
                privateLinkServiceNetworkPolicies: 'Enabled'
            }
            type: 'Microsoft.Network/virtualNetworks/subnets'
        }
        {
            name: 'gh-deligated-sbnt'
            properties: {
                addressPrefix: '10.0.2.0/23'
                networkSecurityGroup: {
                  id: delegatedSubnetNSG.id
                }
                serviceEndpoints: []
                delegations: [
                  {
                      name: 'GitHub.Network/networkSettings'
                      properties: {
                          serviceName: 'GitHub.Network/networkSettings'
                      }
                      type: 'Microsoft.Network/virtualNetworks/subnets/delegations'
                  }
              ]
                privateEndpointNetworkPolicies: 'Enabled'
                privateLinkServiceNetworkPolicies: 'Enabled'
            }
            type: 'Microsoft.Network/virtualNetworks/subnets'
        }
    ]
    enableDdosProtection: false
}
}
