# Deploying infrastructure for a web app with SQL based Database
Template used to create a Resource Group in a subscription

## Resources created in Template
* Resource Group: Container to hold resources for use with other templates

--Prompts for resource group name and location at runtime

## Resource Deployment

new-azsubscriptionDeployment -DeploymentName -Location "yourLocation" -templatefile main.bicep

### Deployment Terms
DeploymentName: Name of deployment which will also be the name of the resource group

location: valid location for the resource group to be located in
