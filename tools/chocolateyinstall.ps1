
$ErrorActionPreference = 'Stop';

$unzipLocation   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$PackageParameters = Get-PackageParameters
$PackageParameters | % {Write-Output($_ | Out-String)}
if (!$PackageParameters['Channel']) { 
  $PackageParameters['Channel'] = 'stable'
} elseif ($PackageParameters['Channel'] -notin 'stable','alpha','beta','rc') {
  Write-Warning("Parameter 'Channel' was not one of 'stable|alpha|beta|rc'. Defaulting to 'stable'")
  $PackageParameters['Channel'] = 'stable'
}
$channel = if ($PackageParameters['Channel'] -like 'stable') {
  [NullString]::Value
} else {
  $PackageParameters['Channel']
}

$mavenUrl = 'https://dl.google.com/dl/android/maven2/com/android/tools/build/aapt2'
$aapt2Url = "$mavenUrl/maven-metadata.xml"

Write-Output("`nChecking maven repository for latest aapt2 version on the $($PackageParameters['Channel']) channel.")
[xml]$data = (New-Object System.Net.WebClient).DownloadString($aapt2Url)
$versions = $data.metadata.versioning.versions.version | Where-Object { $_ -match "^[0-9]+\.[0-9]\.[0-9]-(?:$channel[0-9]{2}-)?[0-9]+$" }
$latest = $versions | Sort-Object -Descending | Select-Object -First 1
Write-Output("Using version $latest")

$existingAapt2 = Get-Command -Name aapt2.exe -ErrorAction SilentlyContinue
if (($null -ne $existingAapt2) -and ($existingAapt2.Path.StartsWith($env:ChocolateyInstall) -eq $false)) {
  Write-Warning "aapt2.exe already exists: $($existingAapt2.Path)"
}

$url        = "$mavenUrl/$latest/aapt2-$latest-windows.jar"
Write-Output("Downloading from $url`n")

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $unzipLocation
  url           = $url
}

Install-ChocolateyZipPackage @packageArgs

Remove-Item (Join-Path "$unzipLocation" "META-INF") -Recurse
Remove-Item (Join-Path "$unzipLocation" "NOTICE")