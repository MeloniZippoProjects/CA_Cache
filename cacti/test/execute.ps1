$executablePath = "~/CA_Cache/cacti/cactip";

$cfgFilter = "*.cfg";
$outExtension = ".txt";

$cfgs = Get-ChildItem -Recurse -Filter ( $cfgFilter);

$root = pwd;
$progress = 1;

foreach($cfg in $cfgs)
{
	Write-Host ( "Processing " + $progress + " out of " + $cfgs.length + "...");

    cd $cfg.DirectoryName
    $expression = $executablePath + ' -infile ' + $cfg.FullName + ' > ' + ( $cfg.Name + $outExtension );
    Invoke-Expression $expression;

	$progress++;
}

cd $root;
