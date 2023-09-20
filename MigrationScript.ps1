Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Install-Script -Name Get-WindowsAutoPilotInfo
# Approve all of the Installation sources and the downloaded from PSGallery
Get-WindowsAutoPilotInfo -Online
# This will download the Intune and Azure Modules onto the computer.
# After the addional Powershell modules are installed the process will prompt
# with an Microsoft 365 login, sign in with account we provide and the script 
# will add the computer to the new M365 Intune Autopilot account.
systemreset.exe
# Do a full wipe of the computer. systemreset with a full wipe on windows 10/11
# does not change the required information for Autopilot.
# When the computer comes be up and gets an internet connection, it will check in 
# and recieve the AutoPilot Configuration. 