#dot source the script if using outside the ISE

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

    #work this out in a future version
    #[bool]
    #$caseSensitive

)

If($path.Length -eq 0)
{
    $path = $PSScriptRoot
}

$resultSet = @()
$resultsFile = $path + "\results.txt";

If($extension.ToLower() -eq "any")
{
    $extensionToSearch = "*.*";
}
Else{
    $extension = $extension.Replace(".","");
    $extensionToSearch = "*." + $extension;
}

Get-ChildItem $Path -Filter $extensionToSearch -Recurse |
   Where-Object { $_.Attributes -ne "Directory"} |
      ForEach-Object {
         If (Get-Content $_.FullName | Select-String -Pattern $text) {
            $resultSet += $_.FullName
         }
      }

If($resultSet.count -gt 0)
{
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

