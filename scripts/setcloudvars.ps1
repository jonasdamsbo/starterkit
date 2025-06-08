### setting app env vars and db ips
write-host "SETTING CLOUD VARS"


### Set temp variables

    # set directly from projectcreator
        $resourcename = ${env:RESOURCENAME} # tempresourcename
        
        write-host $resourcename

        $resourcegroupname = ${env:RESOURCEGROUPNAME}
        $appname = $resourcename+"app"
        $sqlservername = ${env:SQLSERVERNAME}


### get app ip

    $appip = az webapp show --resource-group $resourcegroupname --name $appname
    $appip = $appip | ConvertFrom-Json
    $appips = $appip.possibleOutboundIpAddresses
    $appipssplit = $appips.Split(',')
    $appip = $appipssplit[0]


### add app ip to sqldb

    write-host "### Update sqldb"
    $appindex = 1
    foreach ($appitem in $appipssplit)
    {
        $apprulename = "appip"+$appindex
        az sql server firewall-rule create --resource-group $resourcegroupname -s $sqlservername --name $apprulename --start-ip-address $appitem --end-ip-address $appitem
        $appindex = $appindex + 1
    }


write-host "DONE SETTING CLOUD VARS"
