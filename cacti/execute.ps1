$executablePath = "~/CA_Cache/cacti/cactip";

$targetFilenames = ( "32k", "64k", "256k", "1m", "8m" );

$cfgExtension = ".cfg";
$outExtension = ".txt";

foreach( $filename in $targetFilenames)
{
    $cfgs = Get-ChildItem -Recurse -Filter ($filename + $cfgExtension);

    foreach($cfg in $cfgs)
    {
        $expression = $executablePath + ' -infile ' + $cfg.DirectoryName + ' > ' + ( $filename + $outExtension );
        Invoke-Expression $expression;
    }
}