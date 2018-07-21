choco feature enable -n allowGlobalConfirmation
Import-Csv "packages.csv" | Foreach-Object {
    foreach ($package in $_.PSObject.Properties)
    {
        choco install $package
    }
}
