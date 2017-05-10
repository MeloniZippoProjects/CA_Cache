$setting = "-size (bytes)";
$matchSetting = '-size';

$insertPosition = 1;
$toInsert = ( "33554432", "67108864", "268435456", "1073741824", "8589934592" );

$originFilename = "cache.cfg";
$backupFilename = "cache.cfg.bk";
$cleanFilename = "cleaned_cache.cfg";
$targetFilenames = ( "32k", "64k", "256k", "1m", "8m" );

$files = Get-ChildItem -Recurse -Filter $originFilename;

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