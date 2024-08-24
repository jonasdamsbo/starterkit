# pre
cd $PWD.Path

# run clonestarterkit

# run createrepo

# run replaceazurepipeline
$scriptpath = $PWD.Path + '\replaceazurepipeline.ps1'
write-host $scriptpath
& $scriptpath run
read-host

# run replaceterraform

# run replacesetupscript