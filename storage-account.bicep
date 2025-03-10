param storageAccountName string
param location string
param containerNames array

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    allowCrossTenantReplication: false
    accessTier: 'Hot'
    encryption: {
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
      keySource: 'Microsoft.Storage'
    }
    minimumTlsVersion: 'TLS1_2'
    allowSharedKeyAccess: false
    largeFileSharesState: 'Enabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      ipRules: []
      virtualNetworkRules: []
    }
    supportsHttpsTrafficOnly: true
  }
}

resource storageAccountBlobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    cors: {
        corsRules: []
    }
    deleteRetentionPolicy: {
        allowPermanentDelete: false
        enabled: false
    }
    isVersioningEnabled: false
    changeFeed: {
        enabled: false
    }
    restorePolicy: {
        enabled: false
    }
    containerDeleteRetentionPolicy: {
        enabled: false
    }
  }
}

resource storageAccountContainers 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = [for name in containerNames:{
  name: name
  parent: storageAccountBlobService
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    metadata: {}
    publicAccess: 'None'
  }
}]
