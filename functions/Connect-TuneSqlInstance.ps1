Function Connect-TuneSqlInstance
{
<#
.SYNOPSIS
Connects to an SMO SQL Server object. 

.DESCRIPTION
Creates an SMO object of the SQL server to be worked on. 

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
        [Alias("ServerInstance", "SqlServer")]
        [object]$SqlInstance,
        [Alias("SqlCredential")]
        [PSCredential]$Credential
    )	

	PROCESS
	{
		if ($SqlInstance.GetType() -eq [Microsoft.SqlServer.Management.Smo.Server]) {
			
            if ($SqlInstance.ConnectionContext.IsOpen -eq $false) {
                $SqlInstance.ConnectionContext.Connect()
            }
            return $SqlInstance
        }

		$server = New-Object Microsoft.SqlServer.Management.SMO.server $SqlInstance		 

		$server.ConnectionContext.ApplicationName = 'Mitch tools'
			
		try { 
			if ( $Credential.UserName -ne $null ) { 

				$authtype = "SQL Authentication"
				$username = ($Credential.username).TrimStart("\")

				$server.ConnectionContext.LoginSecure = $false
				$server.ConnectionContext.Set_login($username)
				$server.ConnectionContext.set_SecurePassword($Credential.Password)			
			}
			
			$server.ConnectionContext.Connect()
		}
		catch {
				$message = $_.Exception.InnerException.InnerException
				$message = $message.ToString()
				$message = ($message -Split '-->')[0]
				$message = ($message -Split 'at System.Data.SqlClient')[0]
				$message = ($message -Split 'at System.Data.ProviderBase')[0]
				throw "Can't connect to $SqlInstance`: $message "
		}		

		 return $server 
	}
}