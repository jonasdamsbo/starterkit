### setting app env vars and db ips
write-host "SETTING CLOUD VARS"


### Set temp variables

    # set directly from projectcreator
        $resourcename = ${env:RESOURCENAME} # tempresourcename
        
        write-host $resourcename

        $resourcegroupname = ${env:RESOURCEGROUPNAME}
        $apiappname = $resourcename+"app"
        $sqlservername = ${env:SQLSERVERNAME}


### get apiapp ip

    $apiappip = az webapp show --resource-group $resourcegroupname --name $apiappname
    $apiappip = $apiappip | ConvertFrom-Json
    $apiappips = $apiappip.possibleOutboundIpAddresses
    $apiappipssplit = $apiappips.Split(',')
    $apiappip = $apiappipssplit[0]


### add apiapp ip to sqldb

    write-host "### Update sqldb"
    $xindex = 1
    foreach ($item in $apiappipssplit)
    {
        $rulename = "apiappip"+$xindex
        az sql server firewall-rule create --resource-group $resourcegroupname -s $sqlservername --name $rulename --start-ip-address $item --end-ip-address $item
        $xindex = $xindex + 1
    }


write-host "DONE SETTING CLOUD VARS"
