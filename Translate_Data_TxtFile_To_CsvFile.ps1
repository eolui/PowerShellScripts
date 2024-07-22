$source = "C:\USERNAME\Downloads\MC46"
# Path to log file
# Replace $logPath with the path to the directory where you want to save the log file
$logPath = "C:\USERNAME\Downloads\Log"
# Log file name
$logFile = $logPath + "\" + "FileTranslationLogs" + ".txt" 

# Message to be written in the log file
$message = ""

$linesToSkip = 10

# Accessing the source directory
cd $source

Get-ChildItem -Path $source -Recurse -Include MC*.txt | ForEach-Object{
    # Sets the full path and filename of the Text to the variable $txtFile
  $txtFile = $_.FullName

  # Sets the base name of the file to the variable $BaseFNm (basename is filename without extension)
  $BaseNm = $_.BaseName

# Split the base name of the file by "_"
  $Parts = $BaseNm -split "_"

  # Set the prefix to the first three parts of the base name of the file separated by "~"
  $prefix = $Parts[0] + "~" + $Parts[1] + "~" + $Parts[2] + "~"

  $CurrentDate = Get-Date -Format "yyyy-MM-dd"
    
  #create a new filename by replacing the extension of the file with .csv
  $csvFile = "New" + $BaseNm + ".csv"

  #create a header for the csv file
  $header = "TCode~Plant~Analysis Date~Material~Short Text~Days Since Consumption~InsertDt"
 
  #read the content of the text file, remove the first 10 lines, remove "-" and "|"
  $content = Get-Content $txtFile | Select-Object -Skip $linesToSkip | ForEach-Object {$_ -replace "\|", ""} | ForEach-Object {$_ -replace "-", ""}

  #replace 4 or more spaces with "~"
  $content = $content | ForEach-Object{ 
    $prefix + ($_ -replace "\s{3,}", "~") + $CurrentDate
  }

  #Remove the ~ at the end
  $content.TrimEnd("~") | Set-Content $csvFile -Force

  #Join header to the content
  $finalContent = $header + "`n" + ($content -join "`n")

  #Write the content to the csv file
  $finalContent | Set-Content $csvFile -Force

  Import-Csv $csvFile -Header DocumentNumber, CompanyCode, FiscalYear, Preparer, PreparerTS, Approver, ApproverTS, Flag
}