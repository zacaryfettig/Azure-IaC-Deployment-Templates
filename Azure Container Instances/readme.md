# Azure Container Instances
Template objective is to create a container in Azure container instances

## Resources created in Template
* Container Group: Group for containers specifiying common OS type and IP address data 

* Container: Holds application code and files on are shared OS

* Virtual Network: internal network/network connection

## Resource Deployment
```
New-AzResourceGroupDeployment -ResourceGroupName "groupName" -TemplateFile main.bicep -DeploymentName "ContainerInstance" -location "location"
```
#### Deployment Terms
DeploymentName: Name of the deployment 

location: valid location for the resource group to be located in
