$scriptPath = "C:\USERPROFILE\Downloads"
$logPath = "C:\USERPROFILE\Downloads\Log"
$csvPathInb = "C:\USERPROFILE\Downloads\MC46"
#Construct full path and filename for a log file
$logFile = $logPath + "\" + "Load_CCMSAPMJEfiles_" + ".txt" 

# Setting up a message
$message="$(Get-Date) | INFO | STEP NAME - Starting $PSCommandPath"

$linesToSkip = 1

#Display the message
echo $message
echo "" >> $logFile
echo $message >> $logFile

# Check if the directory contains files starting with MC
# If the directory does not contain the files, the script will exit
if (!(Test-Path $csvPathInb\MC*)) {
  $message="$(Get-Date) | INFO | STEP NAME - Check for SAP MJE Files - files not found"
  echo $message
  echo "" >> $logFile  
  echo $message >> $logFile
  write-host "$(Get-Date) | WARN | SAP MJE File(s) not found in $csvPathInb...Exiting"
  exit 2
}

# Starts a instance of Excel
$Excel = new-object -comobject excel.application

foreach ($f in Get-ChildItem -Path $csvPathInb -recurse -Include MC*.xlsx ) { 
  # Sets the full path and filename of the Excel to the variable $xlsFile
  $xlsFile = $f.FullName
  # Sets the base name of the file to the variable $BaseFNm (basename is filename without extension)
  $BaseFNm = $f.BaseName

  #Divide filename into parts. _ is the delimiter
  $Parts = $BaseFNm -split "_"

  #Use the first part of the filename as the prefix
  $prefix = $Parts[1] + "~"

  #Get the current date
  $CurrentDate = Get-Date -Format "yyyy-MM-dd"
  
  #create a new filename by replacing the extension of the file with .csv
  $csvFile = "C:\USERPROFILE\Downloads\MC46\" + "New" + $BaseFNm + ".csv"

  #create a header for the csv file
  $header = "Analysis Date~Plant~Plant Description~Material~Material Description~Material Group~Material Group~Description~Month~ValStckVal~ValStckVal~Val. stock~Val. stock~CnsgtStock~CnsgtStock~InsertDt"

 $message="$(Get-Date) STEP NAME - Processing file $xlsFile"
  echo $message
  echo $message >> $logFile
	
  ## Open Excel file and save as CSV and then close it
  $WorkBook = $Excel.Workbooks.Open($xlsFile)
  $WorkBook.SaveAs($csvFile,6)
  $WorkBook.Close($true)
  
#----------------------------------------------------------------------------------------
# Forced replacing the delimiter used by Excel
#----------------------------------------------------------------------------------------

# Read the content of the csv file, skip the first 1 line (header line)
$content = Get-Content $csvFile | Select-Object -Skip $linesToSkip

# Replace the delimiter used by Excel with ~
$content = $content -replace ",", "~"

$content = $content | ForEach-Object{ 
  # Get the first 4 characters of the line
  $initialPlant = $_.Substring(0, [Math]::Min(4, $_.Length))

  # Trim the first 4 characters from the line
  # TrimStart() removes leading spaces
  $trimIntFour = $_.Substring([Math]::Min(4, $_.Length)).TrimStart()

  # Combine the parts with proper delimiters
  # {3,} means 3 or more spaces
  $prefix + $initialPlant + "~" + ($trimIntFour -replace ",", "~" -replace "\s{3,}", "~") + "~" + $CurrentDate
}
# Set the content to the csv file
$finalContent = $header + "`n" + ($content -join "`n")
$finalContent | Set-Content $csvFile -Force

}
#--------------------------------------------------------------------------------------------------
# Open Task Manager and End Excel Task when done                                                  -
$ Tried Excel.Quit but it still wouldn't end the task                                             -
#--------------------------------------------------------------------------------------------------
