#Connection to M365 using Azure Automation and non interactive login 
Connect-ExchangeOnline -CertificateThumbPrint 'CertThumbprint' -AppID 'AppID' -Organization 'tenant Url'
Connect-MGgraph -ClientID 'AppID' -TenantId 'GUID of Tenant' -CertificateThumbPrint 'CertThumbprint'

#Variables 
$UserMailboxGroupID = 'Some Group ID'
$UserMailboxGroupMembers = Get-MgGroupMember -GroupId $UserMailboxGroupID -All
$SharedMailboxGroupID = 'Some Group ID'
$SharedMailboxGroupMembers = Get-MgGroupMember -GroupId $SharedMailboxGroupID -All 
$UserMailboxes = Get-ExoRecipient -ResultSize Unlimited -RecipientTypeDetails UserMailbox
$SharedMailboxes = Get-ExoRecipient -ResultSize Unlimited -RecipientTypeDetails SharedMailbox
$RoomMailboxes = Get-ExoRecipient -ResultSize Unlimited -RecipientTypeDetails RoomMailbox

# User Mailbox Processing 
foreach ($UserMailbox in $UserMailboxes) {
    if($UserMailboxGroupMembers.Id -contains $UserMailbox.ExternalDirectoryObjectId) {
        Write-Output "$UserMailbox is a member of the Group"
    } else {
        Write-Output "$UserMailbox is NOT member of the group. Let's fix that!"
        New-MgGroupMember -GroupId $UserMailboxGroupID -DirectoryObjectId $UserMailbox.ExternalDirectoryObjectId
        Write-Output "$UserMailbox is a member of the group now!"
    }
}
# Shared Mailbox Processing
foreach ($SharedMailbox in $SharedMailboxes) {
    if($SharedMailboxGroupMembers.Id -contains $SharedMailbox.ExternalDirectoryObjectId) {
        Write-Output "$SharedMailbox is a member of the Group"
    } else {
        Write-Output "$SharedMailbox is NOT member of the group. Let's fix that!"
        New-MgGroupMember -GroupId $SharedMailboxGroupID -DirectoryObjectId $SharedMailbox.ExternalDirectoryObjectId
        Write-Output "$SharedMailbox is a member of the group now!"
    }
}
# Room Mailbox Processing
foreach ($RoomMailbox in $RoomMailboxes) {
    if($SharedMailboxGroupMembers.Id -contains $RoomMailbox.ExternalDirectoryObjectId) {
        Write-Output "$RoomMailbox is a member of the Group"
    } else {
        Write-Output "$RoomMailbox is NOT member of the group. Let's fix that!"
        New-MgGroupMember -GroupId $SharedMailboxesGroupID -DirectoryObjectId $RoomMailbox.ExternalDirectoryObjectId
        Write-Output "$RoomMailbox is a member of the group now!"
    }
}