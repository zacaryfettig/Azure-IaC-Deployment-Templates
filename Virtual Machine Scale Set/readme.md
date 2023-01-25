# Virtual Machine Scale Set
Template objective is hosting a server application that has the ability to size up/down depending on the amount of users

## Resources created in Template
* Virtual Machine: Hosting the Windows based application

* VM Scale set: provide the ability to scale up/down and load balance between instances

* VNet: network communication between resources

* NSG: securing VM connectivity

## Resource Deployment
```
New-AzResourceGroupDeployment -ResourceGroupName "groupName" -TemplateFile main.bicep -DeploymentName scaleset1 -location "location"
```
#### Deployment Terms
DeploymentName: Name of the deployment 

location: valid location for the resource group to be located in
