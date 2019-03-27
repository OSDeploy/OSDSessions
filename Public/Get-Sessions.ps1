function Get-Sessions {
    [CmdletBinding()]
    PARAM (
        [switch]$GridView
    )
	[xml]$XmlDocument = Get-Content -Path "$env:SystemRoot\Servicing\Sessions\Sessions.xml"

    $Sessions = $XmlDocument.SelectNodes('Sessions/Session') | ForEach-Object {
        New-Object -Type PSObject -Property @{
            Id = $_.Tasks.Phase.package.id
            KBNumber = $_.Tasks.Phase.package.name
            TargetState = $_.Tasks.Phase.package.targetState
            Client = $_.Client
            Complete = $_.Complete
            Status = $_.Status
        }
    }

    $Sessions = $Sessions | Where-Object {$_.Id -like "Package*"}
    $Sessions | Select-Object -Property Id, KBNumber, TargetState, Client, Status, Complete | Sort-Object Complete -Descending

    if ($GridView.IsPresent) {Return $Sessions | Select-Object -Property * | Out-GridView}
    else {Return $Sessions}
}