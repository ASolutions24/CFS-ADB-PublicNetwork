@description('Virtual Network name')
param vnetName string //= 'vnet-sec-dbw-prod'

@description('Virtual Network resource group name')
param vnetResourceGroupName string //= 'rg-sec-dbw-prod'

//@description('Virtual Network subnet name')
//param vnetSubnetName string = 'sn-dbw-private-ep'

var privateDnsZoneName = 'privatelink.azuredatabricks.net'

// Import the existing vnet and subnet to get the subnet id for deployment
resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroupName)
}
//output vnetid string = vnet.id

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}


resource privateDnsZoneName_privateDnsZoneName_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: '${privateDnsZoneName}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

