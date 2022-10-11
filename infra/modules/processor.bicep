param name string
param location string
param image string

var abbrs = loadJsonContent('../abbreviations.json')
var containerAppName = 'gamecontroller'

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
