$smoversions = "13.0.0.0", "12.0.0.0", "11.0.0.0", "10.0.0.0", "14.0.0.0", "9.0.242.0", "9.0.0.0"

foreach ($smoversion in $smoversions)
{
	try
	{
		Add-Type -AssemblyName "Microsoft.SqlServer.Smo, Version=$smoversion, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
		$smoadded = $true
	}
	catch
	{
		$smoadded = $false
	}
	
	if ($smoadded -eq $true) { break }
}

if ($smoadded -eq $false) { throw "Can't load SMO assemblies. You must have SQL Server Management Studio installed to proceed." }

$assemblies = "Management.Common", "Dmf", "Instapi", "SqlWmiManagement", "ConnectionInfo", "SmoExtended", "SqlTDiagM", "Management.Utility",
"SString", "Management.RegisteredServers", "Management.Sdk.Sfc", "SqlEnum", "RegSvrEnum", "WmiEnum", "ServiceBrokerEnum", "Management.XEvent",
"ConnectionInfoExtended", "Management.Collector", "Management.CollectorEnum", "Management.Dac", "Management.DacEnum", "Management.IntegrationServices"

foreach ($assembly in $assemblies)
{
	try
	{
		Add-Type -AssemblyName "Microsoft.SqlServer.$assembly, Version=$smoversion, Culture=neutral, PublicKeyToken=89845dcd8080cc91" -ErrorAction Stop
	}
	catch
	{
		Write-Verbose "$assembly not loaded for version $smoversion"
	}
}

# Load internal and functions dir 
# All internal functions privately avaialble within the toolset
foreach ($function in (Get-ChildItem "$PSScriptRoot\internal\*.ps1")) { . $function }

# All exported functions
foreach ($function in (Get-ChildItem "$PSScriptRoot\functions\*.ps1")) { . $function }

