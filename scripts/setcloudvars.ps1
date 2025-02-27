### setting app env vars and db ips
write-host "SETTING CLOUD VARS"


### Set temp variables

    # set directly from projectcreator
        $resourcename = ${env:RESOURCENAME} # tempresourcename
        
        write-host $resourcename

        #$resourcegroupname = $resourcename+"resourcegroup"
        $resourcegroupname = ${env:RESOURCEGROUPNAME}
        $webappname = $resourcename+"webapp"
        $apiappname = $resourcename+"apiapp"
        #$sqlservername = $resourcename+"mssqlserver"
        $sqlservername = ${env:SQLSERVERNAME}


### get webappip

    $webappip = az webapp show --resource-group $resourcegroupname --name $webappname
    $webappip = $webappip | ConvertFrom-Json
    $webappip = $webappip.possibleOutboundIpAddresses
    $webappips = $webappip.Split(',')
    $webappip = $webappips[0]

    
### get apiapp ip

    $apiappip = az webapp show --resource-group $resourcegroupname --name $apiappname
    $apiappip = $apiappip | ConvertFrom-Json
    $apiappips = $apiappip.possibleOutboundIpAddresses
    $apiappipssplit = $apiappips.Split(',')
    $apiappip = $apiappipssplit[0]


### add webapp ip to api

    write-host "### Update apiapp"
    $xindex = 1
    foreach ($item in $webappips)
    {
        $rulename = "webappip"+$xindex
        az webapp config access-restriction add --resource-group $resourcegroupname --name $apiappname --rule-name $rulename --action Allow --ip-address $item --priority 1
        $xindex = $xindex + 1
    }


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
