#Connections
Connect-ExchangeOnline
Connect-MGgraph 

#Variables 
$UserMailboxGroupID = 'Some Group ID'
$UserMailboxGroupMembers = Get-MgGroupMember -GroupId $UserMailboxGroupID -All
$SharedMailboxGroupID = 'Some Group ID'
$SharedMailboxGroupMembers = Get-MgGroupMember -GroupId $SharedMailboxGroupID -All 
$UserMailboxes = Get-ExoRecipient -ResultSize Unlimited -RecipientTypeDetails UserMailbox
$SharedMailboxes = Get-ExoRecipient -ResultSize Unlimited -RecipientTypeDetails SharedMailbox
$RoomMailboxes = Get-ExoRecipient -ResultSize Unlimited -RecipientTypeDetails RoomMailbox

#Log File Location
$timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$UserLogFile = "C:\Temp\$timestamp-BackupGroupUserLog.txt"
$SharedLogFile = "C:\Temp\$timestamp-BackupGroupSharedLog.txt"
$RoomLogFile = "C:\Temp\$timestamp-BackupGroupRoomLog.txt"

# User Mailbox Processing 
foreach ($UserMailbox in $UserMailboxes) {
    if($UserMailboxGRoupMembers.Id -contains $UserMailbox.ExternalDirectoryObjectId) {
        Write-Host "$UserMailbox is a member of the Group"
        Add-Content -Path $UserLogFile "$UserMailbox is a member of the Group"
    } else {
        Write-Host "$UserMailbox is NOT member of the group. Let's fix that!"
        Add-Content -Path $UserLogFile "$UserMailbox NOT member of the group. Let's fix that!"
        New-MgGroupMember -GroupId $UserMailboxGroupID -DirectoryObjectId $UserMailbox.ExternalDirectoryObjectId
        Write-Host "$UserMailbox is a member of the group now!"
        Add-Content -Path $UserLogFile "$UserMailbox is a member of the group now!"
    }
}
# Shared Mailbox Processing
foreach ($SharedMailbox in $SharedMailboxes) {
    if($SharedMailboxGroupMembers.Id -contains $SharedMailbox.ExternalDirectoryObjectId) {
        Write-Host "$SharedMailbox is a member of the Group"
        Add-Content -Path $SharedLogFile "$SharedMailbox is a member of the Group"
    } else {
        Write-Host "$SharedMailbox is NOT member of the group. Let's fix that!"
        Add-Content -Path $SharedLogFile "$SharedMailbox NOT member of the group. Let's fix that!"
        New-MgGroupMember -GroupId $SharedMailboxGroupID -DirectoryObjectId $SharedMailbox.ExternalDirectoryObjectId
        Write-Host "$SharedMailbox is a member of the group now!"
        Add-Content -Path $SharedLogFile "$SharedMailbox is a member of the group now!"
    }
}
# Room Mailbox Processing
foreach ($RoomMailbox in $RoomMailboxes) {
    if($SharedMailboxGroupMembers.Id -contains $RoomMailbox.ExternalDirectoryObjectId) {
        Write-Host "$RoomMailbox is a member of the Group"
        Add-Content -Path $RoomLogFile "$RoomMailbox is a member of the group"
    } else {
        Write-Host "$RoomMailbox is NOT member of the group. Let's fix that!"
        Add-Content -Path $RoomLogFile "$RoomMailbox is NOT member of the group. Let's fix that!"
        New-MgGroupMember -GroupId $SharedMailboxesGroupID -DirectoryObjectId $RoomMailbox.ExternalDirectoryObjectId
        Write-Host "$RoomMailbox is a member of the group now!"
        Add-Content -Path $RoomLogFile "$RoomMailbox is a member of the group now!"
    }
}
