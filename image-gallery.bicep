param galleryName string
param location string
param imageDefinitionConfig array

resource partnerGallery 'Microsoft.Compute/galleries@2022-01-03' = {
  location: location
  name: galleryName
  properties: {
    identifier: {}
  }
}

resource partnerImageDefinition 'Microsoft.Compute/galleries/images@2022-01-03' = [for (config, i) in imageDefinitionConfig:{
  parent: partnerGallery
  location: location
  name: config.name
  properties: {
    architecture: config.architecture
    hyperVGeneration: 'V2'
    identifier: {
      offer: config.offer
      publisher: config.publisher
      sku: config.sku
    }
    osState: 'Generalized'
    osType: config.osType
    purchasePlan: ((!empty(config.purchasePlan)) ? config.purchasePlan : {})
  }
}]
