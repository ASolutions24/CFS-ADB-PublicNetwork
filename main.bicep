param stgActName string


@allowed([
  'Standard_LRS'
  'Standard_GRS'
]
)
param stgActSku string = 'Standard_LRS'

param stgTags object = {
  Environment: 'Lab'
  Dept: 'IT'
}

resource storage 'Microsoft.Storage/storageAccounts@2021-02-01' = {

  name: stgActName
  sku:{
    name: stgActSku
  }
  kind:'StorageV2'
  location:'australiaeast'
  tags:stgTags
}
