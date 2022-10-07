param location string = resourceGroup().location


@secure()
param registryPassword string
param registryUsername string
param containerRegistry string

param func1Image string
param fun2Image string

// create the aca environment
module env 'modules/ca-environment.bicep' = {
  name: 'containerAppEnvironment'
}

// create the various config pairs
var env_vars = [
  
]

var secrets = [
  {
    name: 'container-registry-password'
    value: registryPassword
  }
]    



module backstage 'modules/container.bicep' = {
  name: 'func1'
  params: {
    name: 'func1'
    location: location
    registryUsername: registryUsername
    containerAppEnvironmentId: env.outputs.id
    registry: containerRegistry
    envVars: env_vars
    sec: secrets
    externalIngress: true
    repositoryImage: func1Image
    port: 80
    aadAuth: false
    probes:[
      {
        failureThreshold: 5
        httpGet: {
          path: '/healthcheck'
          port: 80
        }
        initialDelaySeconds: 60
        periodSeconds: 10
        timeoutSeconds: 3
        type: 'liveness'
      }
      {
        failureThreshold: 5
        httpGet: {
          path: '/healthcheck'
          port: 80
        }
        initialDelaySeconds: 20
        periodSeconds: 10
        timeoutSeconds: 3
        type: 'startup'
      }
      {
        failureThreshold: 5
        httpGet: {
          path: '/healthcheck'
          port: 80
        }
        initialDelaySeconds: 40
        periodSeconds: 10
        timeoutSeconds: 3
        type: 'readiness'
      }
    ]
  }
}





