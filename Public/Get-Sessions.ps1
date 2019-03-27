function Get-Sessions {
    [CmdletBinding()]
    PARAM ([ValidateSet('CumulativeUpdate','Update')]
        [string]$Type,
        [switch]$GridView
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN" -ForegroundColor Green

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSBuilder'
        #===================================================================================================
        $Sessions = @()
        [xml]$XmlDocument = Get-Content -Path 'C:\Windows\Servicing\Sessions\Sessions.xml'
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) PROCESS" -ForegroundColor Green

		[xml]$XmlDocument = Get-Content -Path 'C:\Windows\servicing\Sessions\Sessions.xml'

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

$Sessions | Select -Property Id, KBNumber, TargetState, Client, Status, Complete | Sort-Object Complete -Descending
		
        $Sessions = $XmlDocument.Sessions.Session.Tasks.Phase.package
        $Sessions = $Sessions | Select -Property Id, Name, TargetState, Options
        $Sessions = $Sessions | Where-Object {$_.id -like "Package*"}
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END" -ForegroundColor Green
        if ($GridView.IsPresent) {Return $Sessions | Select -Property * | Out-GridView}
        else {Return $Sessions}
    }
}