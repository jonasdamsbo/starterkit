# push repofolder to repo

### init git and push initial commit, create branches

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

# add master branch lock
az repos policy create --config '\.azure\branch-policy.json'


Read-Host "Press enter to continue..."