az login
az pipelines create --name "testtest" --yml-path '\.azure\azurepipeline.yml' --detect true
#$azureorg = 'tempAzureOrg'
#az devops project list --org $azureorg