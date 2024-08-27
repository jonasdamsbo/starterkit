### run terraform with chosen projectname prepended on services names
# devops project
# devops repository
# devops variable group
# devops pipeline/build definition
# azure billing scope
# azure subscription
# azure resourcegroup
# azure app service plan
# azure web app
# azure api app
# azure sql server
# azure sql database
# azure cosmos account
# azure cosmos mongodb

# cd terraform folder
cd ".terraform"

# terraform initial plan/apply
terraform plan
terraform apply


### replace before 2nd terraform apply, own file?

# get mongodb and mssqldb connectionstrings

# get webappurl

# get apiurl

# get local ip

# get webapp ip

# get api ip

# add apiurl to webapp

# add local ip and webapp ip to api

# add mongodb and mssqldb connectionstrings to api

# add local ip and api ip to mongodb and mssqldb

# terraform plan/apply
terraform plan
terraform apply


### Replace and push, own file?
cd ..

# replace temp vars in readme, -> add connectionstrings, webappurl and apiurl to readme?
# replace temp vars in setup -> git repo url, etc?

# flip branch policy to enabled aka "no direct push to master"-rule

# init git repo
git init
git remote add origin "https://"+"$orgName"+"@dev.azure.com/"+"$orgName$projectName"+"_git/"+"$projectName"

# push
git add .
git commit -m "initial commit"
git push

# create test and production branches
git fetch
git pull
git branch "test"
git branch "pre-production"
git branch "production"
git checkout "main"
git push origin "test"
git push origin "pre-production"
git push origin "production"

# push
git add .
git commit -m "created branches"
git push

Read-Host "Press enter to continue..."