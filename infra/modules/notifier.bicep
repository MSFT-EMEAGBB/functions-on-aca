param name string
param location string
param image string

var abbrs = loadJsonContent('../abbreviations.json')
var containerAppName = 'notify'

var envVar = [
  {
    name: 'AzureFunctionsJobHost__functions__0'
    value: 'Notify'
  }
]

module containerApp 'containerapp.bicep' = {
  name: 'containerapp-${containerAppName}'
  params: {
    name: name
    storageAccountName: abbrs.storageAccountProcess
    location: location
    containerAppName: containerAppName
    envVars: envVar
    image: image
    ingress: true 
  }
}
