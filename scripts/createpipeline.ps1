# remove these when done v
$fullOrgName = "https://dev.azure.com/JonasDamsbo/"
# remove these when done ^

#create new azure pipeline
write-host "Trying to create pipeline in azure"
#$ymlPath = $PWD.Path + '\azurepipeline.yml'
$pipelinename = $projectName+"pipeline"
write-host $pipelinename
Read-Host "Press enter to continue..."
az pipelines create --name $pipelinename --yml-path '\.azure\azurepipeline.yml' --org $fullOrgName
Read-Host "Press enter to continue..."