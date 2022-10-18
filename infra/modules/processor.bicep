param name string
param location string
param image string

var queueName = 'processing-queue'

var containerAppName = 'processor'

var scaleRules = [
  {
     name: 'queue-scaler'
     azureQueue: {
          auth: [{
            secretRef: 'storage-account-shared'
            triggerParameter: 'connection'
          }]
           queueLength: 3
           queueName: queueName
     }
  }
]

module containerApp 'containerapp.bicep' = {
  name: 'containerapp-${containerAppName}'
  params: {
    name: name
    location: location
    containerAppName: containerAppName
    storageAccountName: 'stp'
    scaleRules: scaleRules
    minReplicas: 0
    maxReplicas: 30
    functions: 'Process'
    image: image
    ingress: true
  }
}
