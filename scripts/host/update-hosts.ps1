$DefaultHostsFilePath = "~\.ssh\config"

Function Add-Host-Entry([string]$Entry, [string]$HostsFilePath = $DefaultHostsFilePath) {
    # First line of the entry should contain the hostname
    $Bits = [regex]::Split($Entry, "\s+")
    #Assert that the first bit is "Host"
    if ($Bits[0] -ne "Host") {
        throw "Invalid host entry. First line must start with 'Host'"
    }
    $HostName = $Bits[1]

    Remove-Host-Entry $HostName $HostsFilePath
    "$Entry" | Out-File -Encoding ASCII -Append $HostsFilePath
}

Function Remove-Host-Entry([string]$HostName, [string]$HostsFilePath = $DefaultHostsFilePath) {
    $Content = Get-Content $HostsFilePath
    $NewLines = @()

    $Hosts = Get-Host-Entries $HostsFilePath
    foreach ($ThisHost in $Hosts.Keys) {
        if ($ThisHost -eq $HostName) {
            continue
        } else {
            $NewLines += $Hosts[$ThisHost].TrimEnd()
        }
    }
    
    # Write file
    Clear-Content $HostsFilePath
    foreach ($Line in $NewLines) {
        # Write line with a newline appended
        $Line | Out-File -Encoding ASCII -Append $HostsFilePath
    }
}

Function Get-Host-Entries([string]$HostsFilePath = $DefaultHostsFilePath) {
    $Content = Get-Content $HostsFilePath
    
    $Result = [ordered]@{}
    $CurrentHost = ""
    foreach ($Line in $Content) {
        $Bits = [regex]::Split($Line, "\s+")
        if ($Bits[0] -eq "Host") {
            $CurrentHost = $Bits[1]
            $Result[$CurrentHost] = @()
        }

        if ($CurrentHost -ne "") {
            $Result[$CurrentHost] += "$Line"
        }
    }
    return $Result;
}

Write-Host "Adding vagrant host entry to $DefaultHostsFilePath"
$Entry = vagrant ssh-config | Out-String
Add-Host-Entry "$Entry"
