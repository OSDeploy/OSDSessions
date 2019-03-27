function Get-OSDSessions {
    [CmdletBinding()]
    PARAM (
        [switch]$GridView
    )
	[xml]$XmlDocument = Get-Content -Path "$env:SystemRoot\Servicing\Sessions\Sessions.xml"

    $OSDSessions = $XmlDocument.SelectNodes('Sessions/Session') | ForEach-Object {
        New-Object -Type PSObject -Property @{
            Id = $_.Tasks.Phase.package.id
            KBNumber = $_.Tasks.Phase.package.name
            TargetState = $_.Tasks.Phase.package.targetState
            Client = $_.Client
            Complete = $_.Complete
            Status = $_.Status
        }
    }

    $OSDSessions = $OSDSessions | Where-Object {$_.Id -like "Package*"}
    $OSDSessions | Select-Object -Property Id, KBNumber, TargetState, Client, Status, Complete | Sort-Object Complete -Descending

    if ($GridView.IsPresent) {Return $OSDSessions | Select-Object -Property * | Out-GridView}
    else {Return $OSDSessions}
}