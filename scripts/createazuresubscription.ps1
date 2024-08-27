# remove these when done v
$projectName = "jgdtest"
# remove these when done ^

# create azure sub if name doesns exist

$subName = $projectName+"subscription"
$subExists = "false"
write-host "Subname: "$subName

$listOfsubs = az account show --name $subName --query "[name]" --output tsv 2>$null
write-host "Sublist: "$listOfsubs
read-host "hmm"

if($listOfsubs -eq $subName)
{
    $subExists = "true"
    # prompt if wanna use, else prompt subname with while loop if no
}
else
{
    $subExists = "false"
    #az account create --enrollment-account-name --offer-type {MS-AZR-0017P, MS-AZR-0148P, MS-AZR-USGOV-0015P, MS-AZR-USGOV-0017P, MS-AZR-USGOV-0148P}
}

#write-host $listOfsubs -erroraction 'silentlycontinue'
write-host $subExists
read-host