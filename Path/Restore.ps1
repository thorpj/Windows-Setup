$EnvironmentVariables = Import-Clixml ./env-vars.clixml
foreach ($EnvironmentVariable in $EnvironmentVariables) {
    [System.Environment]::SetEnvironmentVariable($EnvironmentVariable.Name, $EnvironmentVariable.Value, [System.EnvironmentVariableTarget]::Machine)
}