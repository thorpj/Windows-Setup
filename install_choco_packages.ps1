$csv = Import-Csv "packages.csv"
foreach($package in $csv)
{
	choco install $package
}