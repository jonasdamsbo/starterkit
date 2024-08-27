#show list of everything

# prompt for 3 options: update, delete, create

#if delete (show list of everything (local project(+deleteDockerContainers), repo, pipeline, cloud, ALL) and pick, move and leave Setup.ps1 in downloads)?

#if update (show list of everything (repo, pipeline(kan gøres direkte i azurepipeline fil)?, cloud) and pick)? 
#   -> prøv 2 ting for a bypass login: 1(Allow other azure resources), 2(send org med)
#   -> lav tjek som sammenligner local repo/pipeline/cloud filer med data fra cloud, og kører create/update/delete hvis diff
#   -> tjek repo folder for repo config files, tjek om nye navne findes
#   -> tjek pipeline folder for pipeline files, tjek om nye navne findes
#   -> tjek cloud folder for cloud file(s), tjek om nye navne findes
#   -> lav/update/slet repo for hver diff
#   -> lav/update/slet pipeline for hver diff (og release?)
#   -> lav/update/slet service for hver diff

#if create (show list of everything (repo?, pipeline, cloud) and pick)?