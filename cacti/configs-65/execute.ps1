$executablePath = "~/CA_Cache/cacti/cacti65";

$targetFilenames = ( "32k", "64k", "256k", "1m", "8m" );

$cfgExtension = ".cfg";
$outExtension = ".txt";

$root = pwd;

foreach( $filename in $targetFilenames)
{
    $cfgs = Get-ChildItem -Recurse -Filter ($filename + $cfgExtension);

    foreach($cfg in $cfgs)
    {
        cd $cfg.DirectoryName;
        $expression = $executablePath + ' -infile ' + $cfg.FullName + ' > ' + ( $filename + $outExtension );
        Invoke-Expression $expression;
    }

    cd $root;
}
