param (
    [parameter(Mandatory=$true)][string]$cactiPath,
    [parameter(Mandatory=$true)][string]$cfgFolder,
    [int]$parallelProcesses = 1
)

$origin = pwd;

$cactiAbsolutePath = Resolve-Path $cactiPath;

cd $cfgFolder;
$cfgs = Get-ChildItem -Recurse -Filter ( "*.cfg" );

if(!($parallelProcesses -eq 1))
{
    $jobBody = 
    {
        param($cfg, $cactiAbsolutePath);

        cd $cfg.DirectoryName;
        $expression = '' + $cactiAbsolutePath + ' -infile ' + $cfg.FullName + ' 2>&1 > ' + ( $cfg.Name + ".txt" );
        Invoke-Expression $expression;        
    }

    if($parallelProcesses -eq 0)  
    {
        foreach( $cfg in $cfgs )
        {
            Start-Job -ScriptBlock $jobBody -ArgumentList ($cfg, $cactiAbsolutePath) | Out-Null;
        }

        Write-Host "Parallel execution started";
        Get-Job | Wait-Job | Out-Null;
        Write-Host "Execution completed";
    }
    else
    {
        $counter = [pscustomobject] @{ Value = 0 }
        $groupSize = 100

        $cfgsBatches = $cfgs | Group-Object -Property { [math]::Floor($counter.Value++ / $parallelProcesses) }

        $progressCounter = 0;

        foreach($cfgsBatch in $cfgsBatches)
        {
            foreach( $cfg in $cfgsBatch.Group )
            {
                Start-Job -ScriptBlock $jobBody -ArgumentList ($cfg, $cactiAbsolutePath) | Out-Null;
            }

            Write-Host "Parallel execution of $parallelProcesses started";
            Get-Job | Wait-Job | Out-Null;
            $progressCounter += $parallelProcesses;
            Write-Host "Batch completed: executed $progressCounter out of" $cfgs.length;
        }
    }
}
else
{
    $progressCounter = 0;

    foreach( $cfg in $cfgs )
    {
        Write-Host ( "" + $progressCounter + " out of " + $cfgs.length + " completed");

        cd $cfg.DirectoryName
        $expression = '' + $cactiAbsolutePath + ' -infile ' + $cfg.FullName + ' 2>&1 > ' + ( $cfg.Name + ".txt" );
        Invoke-Expression $expression;

        $progressCounter++;
    }

    Write-Host "Execution completed";
}

cd $origin;
