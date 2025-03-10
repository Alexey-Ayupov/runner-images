param location string

param virtualNetworkRG string
param virtualNetworkName string
param delegatedSubnetNSGName string

param galleryRG string
param galleryName string
param imageDefinitionConfig array

param storageRG string
param storageAccountName string
param containerNames array


module storageModule './storage-account.bicep' = {
  name: 'storac-deploy'
  scope: resourceGroup(storageRG)
  params: {
    storageAccountName: storageAccountName
    location: location
    containerNames: containerNames
  }
}

module delegatedSubnetNSGModule './delegated-subnet-nsg.bicep' = {
  name: 'nsg-deploy'
  scope: resourceGroup(virtualNetworkRG)
  params: {
    delegatedSubnetNSGName: delegatedSubnetNSGName
    location: location
  }
}

module virtualNetworkModule './virtual-network.bicep' = {
  name: 'vnet-deploy'
  scope: resourceGroup(virtualNetworkRG)
  params: {
    virtualNetworkName: virtualNetworkName
    delegatedSubnetNSGName: delegatedSubnetNSGName
    location: location
  }
}

module imageGalleryModule './image-gallery.bicep' = {
  name: 'gallery-deploy'
  scope: resourceGroup(galleryRG)
  params: {
    galleryName: galleryName
    location: location
    imageDefinitionConfig: imageDefinitionConfig
  }
}
