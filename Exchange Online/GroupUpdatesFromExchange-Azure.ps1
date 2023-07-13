#Connection to M365 using Azure Automation and non interactive login 
Connect-ExchangeOnline -CertificateThumbPrint 'CertThumbprint' -AppID 'AppID' -Organization 'tenant Url'
Connect-MGgraph -ClientID 'AppID' -TenantId 'GUID of Tenant' -CertificateThumbPrint 'CertThumbprint'

#Variables 
#Security Groups
$UserMailboxGroupID = 'Some Group ID'
$UserMailboxGroupMembers = Get-MgGroupMember -GroupId $UserMailboxGroupID -All
$UserGroupCount = $UserMailboxGroupMembers.Count
$SharedMailboxGroupID = 'Some Group ID'
$SharedMailboxGroupMembers = Get-MgGroupMember -GroupId $SharedMailboxGroupID -All 
$SharedGroupCount = $SharedMailboxGroupMembers.Count

#Exchnage Mailboxes
$UserMailboxes = Get-ExoRecipient -ResultSize Unlimited -RecipientTypeDetails UserMailbox
$ExchangeUserMailboxes = $UserMailboxes.count
$SharedMailboxes = Get-ExoRecipient -ResultSize Unlimited -RecipientTypeDetails SharedMailbox
$ExchangeSharedMailboxes = $SharedMailboxes.Count
$RoomMailboxes = Get-ExoRecipient -ResultSize Unlimited -RecipientTypeDetails RoomMailbox
$ExchangeRoomMailboxes = $RoomMailboxes.Count
$SchedulingMailboxes = Get-ExoRecipient -ResultSize Unlimited -RecipientTypeDetails SchedulingMailbox
$ExchangeSchedulingMailboxes = $SchedulingMailboxes.Count

#Change Math
$SumofShared = [int]$ExchangeSharedMailboxes + [int]$ExchangeRoomMailboxes + [int]$ExchangeSchedulingMailboxes
$AdditionalUsers = [int]$ExchangeUserMailboxes - [int]$UserGroupCount
$AdditionalSharedResources = [int]$SumofShared - [int]$SharedGroupCount

#Teams Notification
$TeamsChannelURI = 'Teams Channel Webhook Connector URL'

# User Mailbox Processing 
foreach ($UserMailbox in $UserMailboxes) {
    if($UserMailboxGRoupMembers.Id -contains $UserMailbox.ExternalDirectoryObjectId) {
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
# Scheduling Mailbox Processing
foreach ($SchedulingMailbox in $SchedulingMailboxes) {
    if($SharedMailboxGroupMembers.Id -contains $SchedulingMailbox.ExternalDirectoryObjectId) {
        Write-Output "$SchedulingMailbox is a member of the Group"
    } else {
        Write-Output "$SchedulingMailbox is NOT member of the group. Let's fix that!"
        New-MgGroupMember -GroupId $SharedMailboxesGroupID -DirectoryObjectId $SchedulingMailbox.ExternalDirectoryObjectId
        Write-Output "$SchedulingMailbox is a member of the group now!"
    }
}
#Teams Channel Notification
$JSONBody = [PSCustomObject][Ordered]@{
    "@type" = "MessageCard"
    "@context" = "http://schema.org/extensions"
    "summary" = "Group Processing Complete!"
    "themeColor" = '0078d7'
    "title" = "Group Processing Complete!"
    "sections" = @(
        @{
            "activityTitle" = "Group Processing is complete! Here are the details"
            "facts" = @(
                @{
                    "name" = "New Users:"
                    "value" = "$AdditionalUsers"
                }
                @{
                    "name" = "New Shared Resources:"
                    "value" = "$AdditionalSharedResources"
                }
                @{
                    "name" = "M365 Users:"
                    "value" = "$ExchangeUserMailboxes"
                }
                @{
                    "name" = "Shared Mailboxes:"
                    "value" = "$ExchangeSharedMailboxes"
                }
                @{
                    "name" = "Resource Rooms:"
                    "value" = "$ExchangeRoomMailboxes"
                }
                @{
                    "name" = "Bookings Mailboxes:"
                    "value" = "$ExchangeSchedulingMailboxes"
                }
            ) 
        }
    )    
}

$TeamsMessageBody = ConvertTo-Json $JSONBody -Depth 20

$parameters = @{
    'URI' = $TeamsChannelURI
    "Method" = 'Post'
    "Body" = $TeamsMessageBody
    "ContentType" = 'application/json'
 }

Invoke-RestMethod @parameters

Write-Output "Teams Message Sent, Job Complete"