#Remember to dot source the script file before you try to execute it in a powershell scenario

Function SearchFiles{

Param(
    [ValidateScript({Test-Path $_ -PathType 'Container'})]
    [string]
    $path,

    [Parameter(Mandatory=$true)]
    [string]
    $text,

    [Parameter(Mandatory=$true)]
    [string]
    $extension,

    [bool]
    $out


)
$path = "C:\dev\PowerShellFileContentSearch\src"
$resultSet = @()
$resultsFile = $path + "\results.txt";

Get-ChildItem $Path -Filter "*.txt" |
   Where-Object { $_.Attributes -ne "Directory"} |
      ForEach-Object {
         If (Get-Content $_.FullName | Select-String -Pattern $text) {
            $resultSet += $_.FullName
         }
      }

If($out)
{
    $resultSet | % {$_} | Out-File $resultsFile
}


    Write-Host "Files that meet search criteria:"

    $resultSet | ForEach-Object {Write-Host $_ -ForegroundColor DarkGreen}
    If($resultSet.count -eq 0){
        Write-Host "No results that met the search criteria" -ForegroundColor DarkRed
    }

}

