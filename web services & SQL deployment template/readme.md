# Deploying infrastructure for a web app with SQL based Database
Template objective is hosting a .net web app with SQL database while maintaining connection security from the SQL Database to the web app.

## Resources created in Template
* App Service: Hosting Web App using App Service

* Azure SQL Database Server: Creation of Azure Databases server resource

* Azure SQL Database: Database storing website database

* Networking VNet: Connect SQL Service to App over private VNet

* Private Endpoint: Connecting SQL privatly over vnet

* App Service Vnet Integration: Connect App Service privatly to VNet

* Key Vault: Store SQL Database Admin password securly in Key Vault. secret is created at template runtime.

## Resource Deployment
```
New-AzResourceGroupDeployment -ResourceGroupName "resourceGroup" -SQLedition "edition" -sqlserverName "serverName" -environment "production" -appPlanTier "appPlan" -TemplateFile main.bicep
```
#### Deployment Terms
SQL edition: options for tier of SQL server in the link https://azure.microsoft.com/en-us/pricing/details/azure-sql-database/single/#pricing

environment: web app development or production staging slot

App Plan Tier: app plan tier options shown in the link
https://azure.microsoft.com/en-us/pricing/details/app-service/windows/#purchase-options

location: valid location for the resource group to be located in

* Username and password for SQL Server prompted at runtime
