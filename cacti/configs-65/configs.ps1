$setting = "-size (bytes)";
$matchSetting = '-size';

$insertPosition = 1;
$toInsert = ( "32768", "65536", "262144", "1048576", "8388608" );

$originFilename = "cache.cfg";
$backupFilename = "cache.cfg.bk";
$cleanFilename = "cleaned_cache.cfg";
$targetFilenames = ( "32k", "64k", "256k", "1m", "8m" );

$files = Get-ChildItem -Recurse -Filter $originFilename;

$root = pwd;

foreach( $file in $files)
{
    cd $file.DirectoryName;

    Get-Content $originFilename | Set-Content $backupFilename;
    Get-Content $originFilename | Where-Object {$_ -notmatch $matchSetting} | Set-Content $cleanFilename;
    $content = Get-Content $cleanFilename;

    for( $idx = 0; $idx -lt $toInsert.length; $idx++)
    {
        $content[$insertPosition] = ($setting + ' ' + $toInsert[$idx]);
        $content | Set-Content -Path ($targetFilenames[$idx] + ".cfg");
    }
}

cd $root;