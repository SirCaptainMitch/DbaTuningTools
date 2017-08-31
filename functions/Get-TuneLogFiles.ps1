Function Get-TuneLogFiles
{
<#
.SYNOPSIS
Returns a breakdown of VLF's per database log file

.DESCRIPTION
Returns a list of objects with breakdown of Database log files VLF

.PARAMETER SqlInstance
The SQL Server that you're connecting to.

.PARAMETER Credential
Credential object used to connect to the SQL Server as a different user be it Windows or SQL Server. Windows users are determiend by the existence of a backslash, so if you are intending to use an alternative Windows connection instead of a SQL login, ensure it contains a backslash.
	
.NOTES

.LINK
# https://sqldbawithabeard.com/2014/10/06/number-of-vlfs-and-autogrowth-settings-colour-coded-to-excel-with-powershell/

.EXAMPLE

	
#>	
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[object]$SqlInstance,
		[Alias("SqlCredential")]
		[PSCredential]$Credential
	)	
	BEGIN 
    { 
        if ($SqlInstance.GetType() -eq [Microsoft.SqlServer.Management.Smo.Server]) {
			
            if ($SqlInstance.ConnectionContext.IsOpen -eq $false) {
                $SqlInstance.ConnectionContext.Connect()
            }
        } else { 
            $SqlInstance = Connect-TuneSqlInstance -SqlInstance $SqlInstance -Credential $Credential
        }
    }

	PROCESS
	{
		foreach ($db in $SqlInstance.Databases | Where-Object {$_.isAccessible -eq $True } ) 
        { 
            $logFile = $db.LogFiles | Select-Object Growth, GrowthType, Size, UsedSpace, Name, FileName, ID
            $Name = $DB.name
            $VLFs = $DB.ExecuteWithResults("DBCC LOGINFO").Tables[0].Rows | 
                        Group-Object -Property FileId | 
                        Select-Object -Property Name, Count

            foreach ( $file in $LogFile )
            {         
                [PSCustomObject]@{ 
                    Database = $Name 
                    FileName = $File.Name
                    VLFCount = $($VLFs | Where-Object -Property Name -eq $file.ID | Select-Object -Property Count ).Count
                    SizeInGB = [math]::Round(($file.Size / 1024 / 1024 ), 2) 
                    UsedSpaceInGB = [math]::Round(($File.UsedSpace / 1024 / 1024 ), 2) 
                    GrowthInGB = [math]::Round(($file.Growth / 1024 / 1024) , 2) 
                    GrowthType = $File.GrowthType
                    FileLocation = $file.FileName
                }
            }
        } 
	}
}