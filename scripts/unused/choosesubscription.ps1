# remove these when done v
#$projectName = "jgdtest"
# remove these when done ^

# check if azure subscription exists
#$subName = $projectName+"subscription"
$subName = ""
$subId = ""
$fullSubId = ""
$subExists = "false"
write-host "Subname: "$subName

while($subExists -ne "true")
{
    $subName = read-host "What is the name your Azure Subscription?"
    write-host "Checking if subscription exists..."
    $tempSubName = az account show --name $subName --query "[name]" --output tsv 2>$null
    write-host "AzSub: "$tempSubName
    #read-host "hmm"

    if($tempSubName -eq $subName -and $tempSubName -ne "")
    {
        $subExists = "true"
        
        $subId = az account show --name $subName --query "[id]" --output tsv 2>$null
        $subIdFormatted = "("+$subId+")"
        $fullSubId = $subName + " " + $subIdFormatted
        write-host "FullSubId: "$fullSubId

        # prompt if wanna use, else prompt subname with while loop if no
    }
    else
    {
        write-host "Can't find subscription"
        $subExists = "false"
    }

    #write-host $listOfsubs -erroraction 'silentlycontinue'
    write-host $subExists
    write-host "Done checking if subscription exists..."
}

read-host "Enter to proceed..."