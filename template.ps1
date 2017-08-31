Function Set-LPSFunctionName
{
<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER SqlInstance
The SQL Server that you're connecting to.

.PARAMETER Credential
Credential object used to connect to the SQL Server as a different user be it Windows or SQL Server. Windows users are determiend by the existence of a backslash, so if you are intending to use an alternative Windows connection instead of a SQL login, ensure it contains a backslash.
	
.NOTES

.LINK

.EXAMPLE

	
#>	
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[object]$SqlInstance,
		[Alias("SqlCredential")]
		[System.Management.Automation.PSCredential]$Credential
	)	
	BEGIN 
    { 
        #Preprocessing 
    }

	PROCESS
	{
		#Processing 
	}

    End 
    { 
        #Post Processing 
    }
}