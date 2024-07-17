# Replace $source and $target with the respective directories you want to search for a file ($source) and then the target directory to relocate ($target)
$source = 'C:\Initial\Folder'
$target = 'C:\Target\Folder'

# This line finds the files older than x days and relocates to target folder
# Replace (-x) with the amount of days old you wish to search. Keep the "-". Ex: -120 will search for files older than 120 days
Get-ChildItem -Path $source | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-x)} | ForEach-Object { Move-Item $_.FullName -Destination $target }