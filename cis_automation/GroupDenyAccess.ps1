# groups to be added to the deny polivy
$groups = "Guests", "Administrators", "Local account"

# Define a temporary file path for the security template
$tempFilePath = Join-Path -Path $env:TEMP -ChildPath "SecurityTemplate.inf"

# Generate a security template with the new "Deny access to this computer from the network" policy
@"
[Unicode]
Unicode=yes
[System Access]
"Deny access to this computer from the network"="$($groups -join ";")
"@ | Out-File -FilePath $tempFilePath -Encoding Unicode

# Apply the security template using secedit.exe
& secedit.exe /configure /db secedit.sdb /cfg $tempFilePath /areas SECURITYPOLICY

# Remove the temporary file
Remove-Item -Path $tempFilePath
