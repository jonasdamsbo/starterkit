#create new azure pipeline
write-host "Trying to create pipeline in azure"
#$ymlPath = $PWD.Path + '\azurepipeline.yml'
$pipelinename = $repoName+"pipeline"
write-host $pipelinename
Read-Host "Press enter to continue..."
az pipelines create --name $pipelinename --yml-path '\scripts\azurepipeline.yml' --detect true
Read-Host "Press enter to continue..."