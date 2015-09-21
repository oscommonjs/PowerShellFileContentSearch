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

If($extension.ToLower() -eq "any"){
    $extensionToSearch = "*.*";
}
Else{
    $extensionToSearch = "*." + $extension;
}


Get-ChildItem $Path -Filter $extensionToSearch -Recurse |
   Where-Object { $_.Attributes -ne "Directory"} |
      ForEach-Object {
         If (Get-Content $_.FullName | Select-String -Pattern $text) {
            $resultSet += $_.FullName
         }
      }

    If($resultSet.count -gt 0){
        Write-Host "Files that meet search criteria:"
        $resultSet | ForEach-Object {Write-Host $_ -ForegroundColor DarkGreen}
    }
    Else{
        Write-Host "No results for '$text'" -ForegroundColor DarkRed
    }

    If($out)
    {
        $resultSet | % {$_} | Out-File $resultsFile
    }
    

}

