param name string
param location string = resourceGroup().location
param containerAppEnvironmentId string
param repositoryImage string
param envVars array = []
param sec array = []
param probes array = []
param registry string
param minReplicas int = 1
param maxReplicas int = 1
param port int
param externalIngress bool = false
param allowInsecure bool = true
param transport string = 'http'
param registryUsername string
param aadAuth bool
param aadClientId string = ''
param aadTenantId string = ''

resource containerApp 'Microsoft.App/containerApps@2022-03-01' ={
  name: name
  location: location
  
  properties:{
    managedEnvironmentId: containerAppEnvironmentId
    
    configuration: {
      activeRevisionsMode: 'single'
      
      secrets: sec  
      registries: [
        {
          server: registry
          username: registryUsername
          passwordSecretRef: 'container-registry-password'
        }
      ]
      ingress: {
        external: externalIngress
        targetPort: port
        transport: transport
        allowInsecure: allowInsecure
      }
    }
    template: {
      containers: [
        {
          image: repositoryImage
          name: name
          env: envVars
          probes: probes
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
}

resource azureAdAuth 'Microsoft.App/containerApps/authConfigs@2022-03-01' = if (aadAuth) {
  name: 'current'
  parent: containerApp
  properties: {
    globalValidation: {
      unauthenticatedClientAction: 'RedirectToLoginPage'
       redirectToProvider: 'azureactivedirectory'
    }
    identityProviders: {
      azureActiveDirectory: {
        enabled: true
        registration: {
          clientId:  aadClientId
          clientSecretSettingName: 'microsoft-provider-authentication-secret'
          openIdIssuer: 'https://sts.windows.net/${aadTenantId}/v2.0'
        }
        validation: {
          allowedAudiences: [
            'api://${aadClientId}'
          ]
        }
      }
    }
    login: {
      preserveUrlFragmentsForLogins: false
    }
    platform: {
      enabled: true
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
