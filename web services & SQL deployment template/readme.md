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
