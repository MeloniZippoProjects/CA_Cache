param (
    [parameter(Mandatory=$true)][string]$gawkPath,
    [parameter(Mandatory=$true)][string]$cfgFolder
)

$gawkAbsolutePath = Resolve-Path $gawkPath;

$origin = pwd;
cd $cfgFolder;

$files = gci -Recurse -Filter "*.txt";
$gawkInput;

foreach($file in $files)
{
    $gawkInput += "FILE_START`n";
    $gawkInput += ( Get-Content $file.FullName | Out-String);
    $gawkInput += "FILE_END`n";
}

$gawkInput | gawk -f $gawkAbsolutePath;
cd $origin;
