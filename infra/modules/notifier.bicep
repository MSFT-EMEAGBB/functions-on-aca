param name string
param location string
param image string

var containerAppName = 'notifier'

module containerApp 'containerapp.bicep' = {
  name: 'containerapp-${containerAppName}'
  params: {
    name: name
    storageAccountName: 'stn'
    location: location
    containerAppName: containerAppName
    functions: 'Notify'
    image: image
    ingress: true 
  }
}
