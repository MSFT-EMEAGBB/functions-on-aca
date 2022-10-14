param name string
param image string
param location string
param containerAppName string
param storageAccountName string
param ingress bool = false
param functions string
param port int = 80
param minReplicas int = 1
param maxReplicas int = 1
param scaleRules array = []

var resourceToken = toLower(uniqueString(subscription().id, name, location))
var tags = { 'azd-env-name': name }
var abbrs = loadJsonContent('../abbreviations.json')


resource acr 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' existing = {
  name: '${abbrs.containerRegistryRegistries}${resourceToken}'
}

resource ai 'Microsoft.Insights/components@2020-02-02' existing = {
  name: '${abbrs.insightsComponents}${resourceToken}'
}

resource env 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: '${abbrs.appManagedEnvironments}${resourceToken}'
}

resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: '${storageAccountName}${resourceToken}'
}

resource sharedStorage 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: '${abbrs.storageAccountShared}${resourceToken}'
}

var sharedAccountConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${sharedStorage.name};AccountKey=${sharedStorage.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
var storageAccountConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storage.name};AccountKey=${storage.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'

var envVars = [
  {
    name: 'AzureWebJobsStorage'
    value: storageAccountConnectionString
  }
  {
    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
    value: ai.properties.InstrumentationKey
  }
  {
    name: 'FUNCTIONS_EXTENSION_VERSION'
    value: '~4'
  }
  {
    name: 'FUNCTIONS_WORKER_RUNTIME'
    value: 'dotnet-isolated'
  }
  {
    name: 'AzureWebJobsSharedStorage'
    value: sharedAccountConnectionString
  }
  {
    name: 'AzureFunctionsJobHost__functions__0'
    value: functions
  }
] 


// We have to use ${name}service_name for now because we don't deploy it in azd provision and azd deploy won't find it
// But the backup search logic will find it via this name.
resource containerapp 'Microsoft.App/containerApps@2022-06-01-preview' = {
  name: '${name}${containerAppName}'
  location: location
  tags: union(tags, { 'azd-service-name': containerAppName })
  properties: {
    environmentId: env.id
    configuration: {
      activeRevisionsMode: 'single'
      secrets: [
        {
          name: 'container-registry-password'
          value: acr.listCredentials().passwords[0].value
        }
        {
          name: 'storage-account-shared'
          value: sharedAccountConnectionString
        }
      ]
      registries: [
        {
          server: '${acr.name}.azurecr.io'
          username: acr.name
          passwordSecretRef: 'container-registry-password'
        }
      ]
      ingress: {
        external: ingress
        targetPort: port
      }
    }
    template: {
      containers: [
        {
          image: image
          name: containerAppName
          env: envVars
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
        rules: scaleRules
      }
    }
  }
}
