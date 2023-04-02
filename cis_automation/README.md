**CF Project / CIS-Automation**

I decided to address the Missing CIS Benchmarks for windows 2019 with Powershell code

Code can be found here: https://github.com/Pylekotter/cf-project/tree/main/cis_automation

To "Ensure Deny Access to this Computer from the Network", I wrote a Powershell script that does the following:

- Gets the SIDs of the specified user groups
- Generates a security policy template that denies access to the computer from the network for those groups
- Uses secedit to apply the template

For "Configure Attack Surface Reduction rules" I used One line of Powershell that will enable the provided ID as an attack surface rule.


*References Used:*
group_deny_access 
https://www.top-password.com/blog/export-and-import-local-security-policy-in-windows/

https://stigviewer.com/stig/windows_server_2016/2019-12-12/finding/V-73757

attack_surface_reduction 
https://endpointcave.com/configure-all-available-asr-rules-with-microsoft-intune/

Ideally I would have liked to have used Ansible for this process, but with Windows I ran into some issues with generating a certificate for winrm to enable ansible connectivity to the Windows Machine. So instead I decided that coming up with some Powershell to do the job felt a little more effecient.