# CONFIGURATION
    $executablePath = "~/CA_Cache/cacti/cactip";
    $targetFolder = "~/CA_Cache/cacti/configs-p"

    $cfgFilter = "*.cfg";
    $outExtension = ".txt";

# EXECUTION

    $cfgs = Get-ChildItem -Recurse -Filter ( $cfgFilter );

    $root = pwd;
    $progressCounter = 1;

    foreach( $cfg in $cfgs )
    {
        Write-Host ( "Processing " + $progressCounter + " out of " + $cfgs.length + "...");

        cd $cfg.DirectoryName
        $expression = $executablePath + ' -infile ' + $cfg.FullName + ' > ' + ( $cfg.Name + $outExtension );
        Invoke-Expression $expression;

        $progressCounter++;
    }

    cd $root;
