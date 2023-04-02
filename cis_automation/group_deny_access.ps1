$userGroups = "Guests","Local account","Administrators group"
$userSIDs = @()
foreach ($group in $userGroups) {
    $user = Get-WmiObject -Class Win32_Group -Filter "LocalAccount=True AND Name='$group'"
    if ($user) {
        $userSIDs += $user.SID
    }
}

$seceditPath = "$env:SystemRoot\system32\secedit.exe"
$policyFile = "C:\Windows\Temp\security_policy.inf"
$policyTemplate = @"
[Unicode]
Unicode=yes
[Version]
signature="$Windows NT$"
[Privilege Rights]
SeDenyNetworkLogonRight = $userSIDs
"@
$policyTemplate | Out-File $policyFile -Encoding Unicode
Start-Process $seceditPath "-configure -db secedit.sdb -cfg $policyFile -overwrite -quiet" -Wait
