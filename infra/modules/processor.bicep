param name string
param location string
param image string

var abbrs = loadJsonContent('../abbreviations.json')
var containerAppName = 'processor'

var envVar = [
  {
    name: 'AzureFunctionsJobHost__functions__0'
    value: 'Process'
  }
]

module containerApp 'containerapp.bicep' = {
  name: 'containerapp-${containerAppName}'
  params: {
    name: name
    location: location
    containerAppName: containerAppName
    storageAccountName: abbrs.storageAccountProcess
    image: image
    ingress: true
  }
}
