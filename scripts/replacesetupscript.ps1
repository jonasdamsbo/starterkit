# replace setup script in newRepoName folder 

# push everything to newRepoName repo

#create new azure pipeline
write-host "Trying to create pipeline in azure"
#$ymlPath = $PWD.Path + '\azurepipeline.yml'
az pipelines create --name "testpipeline" --yml-path '\scripts\azurepipeline.yml' --detect true
Read-Host "Press enter to continue..."