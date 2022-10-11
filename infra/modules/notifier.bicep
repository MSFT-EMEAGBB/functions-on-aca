param name string
param location string
param image string

var abbrs = loadJsonContent('../abbreviations.json')
var containerAppName = 'gamecontroller'

// create the various config pairs
var envVars = [
  {
    name: 'FUNCTIONS_EXTENSION_VERSION'
    value: '~4'
  }
  {
    name: 'FUNCTIONS_WORKER_RUNTIME'
    value: 'dotnet'
  }
]

module containerApp 'containerapp.bicep' = {
  name: 'containerapp-${containerAppName}'
  params: {
    name: name
    storageAccountName: abbrs.storageAccountProcess
    location: location
    envVars: envVars
    containerAppName: containerAppName
    image: image
    ingress: true 
  }
}
