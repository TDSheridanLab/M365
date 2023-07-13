#----- Daily Performance Logs-----#
# Written on May 1st, 2015
# Created by Terry Sheridan 
# Use with Windows Task Scheduler to run daily or as needed
#
#----- define parameters -----#
#----- get current date ----#
$Now = Get-Date
#----- define amount of days ----#
$Days = "3"
#----- define folder where files are located ----#
$TargetFolder = "C:\Program Files\Microsoft\Exchange Server\V15\Logging\Diagnostics\DailyPerformanceLogs"
#----- define extension ----#
$Extension = "*.blg"
#----- define LastWriteTime parameter based on $Days ---#
$LastWrite = $Now.AddDays(-$Days)
$Files = Get-Childitem $TargetFolder -Include $Extension -Recurse | Where-Object {$_.LastWriteTime -le "$LastWrite"}
Remove-Item $Files

#----- W3SVC1 Folder-----#
#----- define folder where files are located ----#
$TargetFolder1 = "C:\inetpub\logs\LogFiles\W3SVC1"
#----- define extension ----#
$Extension1 = "*.log"
#----- define LastWriteTime parameter based on $Days ---#
$LastWrite = $Now.AddDays(-$Days)
$Files1 = Get-Childitem $TargetFolder1 -Include $Extension1 -Recurse | Where-Object {$_.LastWriteTime -le "$LastWrite"}
Remove-Item $Files1

#----- W3SVC2 Folder-----#
#----- define folder where files are located ----#
$TargetFolder2 = "C:\inetpub\logs\LogFiles\W3SVC2"
#----- define extension ----#
$Extension2 = "*.log"
#----- define LastWriteTime parameter based on $Days ---#
$LastWrite = $Now.AddDays(-$Days)
$Files2 = Get-Childitem $TargetFolder2 -Include $Extension2 -Recurse | Where-Object {$_.LastWriteTime -le "$LastWrite"}
Remove-Item $Files2