$executablePath = "~/CA_Cache/cacti/cactip";

$cfgFilter = "*.cfg";
$outExtension = ".txt";

$cfgs = Get-ChildItem -Recurse -Filter ( $cfgFilter);

foreach($cfg in $cfgs)
{
    cd $cfg.DirectoryNameò
    $expression = $executablePath + ' -infile ' + $cfg.FullName + ' > ' + ( $cfg.Name + $outExtension );
    Invoke-Expression $expression;
}