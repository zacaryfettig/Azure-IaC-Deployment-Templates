# Deploying a new Resource Group in a subscription

## Resources created in Template
Resource Group: container to hold Azure resources

## Resource Deployment
```
new-azsubscriptionDeployment -DeploymentName -Location "yourLocation" -templatefile main.bicep
```
#### Deployment Terms
DeploymentName: Name of deployment which will also be the name of the resource group

location: valid location for the resource group to be located in
