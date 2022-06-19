choco feature enable -n allowGlobalConfirmation
Import-Csv "packages.csv" | Foreach-Object {
    foreach ($line in $_.PSObject.Properties)
    {
        $package = $line.Value
        choco install $package
    }
}
