# Directory you want to organize files
# Replace $source with the path to the directory you want to organize
$source = "C:\Path\To\Directory"

# Path to log file
# Replace $logPath with the path to the directory where you want to save the log file
$logPath = "C:\Path\To\Log\File"
# Log file name
$logFile = $logPath + "\" + "FileOrganizerLogs" + ".txt" 

# Message to be written in the log file
$message = ""

# Accessing the source directory
cd $source

# Scan though the files in the source directory
foreach ($file in Get-ChildItem)
{
    # Checking if the file is a folder
    if ($file.PSIsContainer)
    {
        # If it is a folder, skip it
        continue
    }
    # If not a folder, do the following
    else 
    {
        # Getting the file extension
        $fileType = $file.Extension

        # Checking if files are being read and getting their extensions
        # $message = $fileType
        # echo $message >> $logFile

        # Creating a folder for the file type
        $folder = New-Item -Path $source -Name $fileType -ItemType Directory -Force

        # Moving the file to the folder
        Move-Item -Path $file.FullName -Destination $folder.FullName -Force

    }

}