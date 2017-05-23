$executablePath = "~/CA_Cache/cacti/cactip";

$cfgFilter = "*.cfg";
$outExtension = ".txt";

$cfgs = Get-ChildItem -Recurse -Filter ( $cfgFilter);

$root = pwd;

foreach($cfg in $cfgs)
{
    cd $cfg.DirectoryName
    $expression = $executablePath + ' -infile ' + $cfg.FullName + ' > ' + ( $cfg.Name + $outExtension );
    Invoke-Expression $expression;
}

cd $root;
