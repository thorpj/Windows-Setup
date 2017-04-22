clear
if ( !(test-path listdisk.txt)) {
    new-item -name listdisk.txt -itemtype file -force | out-null
    add-content -path listdisk.txt "List Disk"
    new-item -path format_disk.txt -itemtype file -force | out-null
}
$listdisk=(diskpart /s listdisk.txt)
$listdisk
$disk_selection=read-host -prompt "Disk number"
$disk_format=read-host -prompt "Disk format"
$disk_label=read-host -prompt "Disk name"

# $disk_selection
# $disk_format
# $disk_label
add-content -path format_disk.txt "select disk $disk_selection"
add-content -path format_disk.txt "clean"
add-content -path format_disk.txt "create partition primary"
add-content -path format_disk.txt "format fs=$disk_format label=$disk_label quick"

$format_disk=(diskpart /s format_disk.txt)

if (Test-Path listdisk.txt) {
    Remove-Item -path listdisk.txt
}

if (Test-Path format_disk.txt) {
    Remove-Item -path format_disk.txt
}