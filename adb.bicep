targetScope = 'subscription'
param disablePublicIp bool = true
param publicNetworkAccess string = 'Enabled'

@description('Indicates whether to retain or remove the AzureDatabricks outbound NSG rule - possible values are AllRules or NoAzureDatabricksRules.')
@allowed([
  'AllRules'
  'NoAzureDatabricksRules'
])
param requiredNsgRules string = 'AllRules'

@description('Location for all resources.')
param location string //= resourceGroup().location

param pricingTier string = 'premium'

@description('The name of the public subnet to create.')
param publicSubnetName string = 'sn-dbw-public'

@description('The name of the private subnet to create.')
param privateSubnetName string = 'sn-dbw-private'

param vnetResourceGroupName string = 'rg-sec-dbw-prod'

param vnetName string = 'vnet-sec-dbw-prod'

param ProdsubscriptionID string = '2f054702-74ef-49dc-8055-920692478b36'

resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: vnetName
  scope: resourceGroup(ProdsubscriptionID,vnetResourceGroupName)
}

@description('The name of the Azure Databricks workspace to create.')
param workspaceName string

var managedResourceGroupName = 'databricks-rg-${workspaceName}-${uniqueString(workspaceName, resourceGroup().id)}'
var trimmedMRGName = substring(managedResourceGroupName, 0, min(length(managedResourceGroupName), 90))
var managedResourceGroupId = '${subscription().id}/resourceGroups/${trimmedMRGName}'

resource symbolicname 'Microsoft.Databricks/workspaces@2023-02-01' = {
  name: workspaceName
  location: location
  sku: {
    name: pricingTier
  }
  properties: {
    managedResourceGroupId: managedResourceGroupId
    parameters: {
      customVirtualNetworkId: {
        value: vnet.id
        //value: '/subscriptions/2f054702-74ef-49dc-8055-920692478b36/resourceGroups/rg-sec-dbw-prod/providers/Microsoft.Network/virtualNetworks/vnet-sec-dbw-prod'
      }
      customPublicSubnetName: {
        value: publicSubnetName
      }
      customPrivateSubnetName: {
        value: privateSubnetName
      }
      enableNoPublicIp: {
        value: disablePublicIp
      }
    }
    publicNetworkAccess: publicNetworkAccess
    requiredNsgRules: requiredNsgRules
  }
}
