#CONFIGS
	$baseFilename = "clean-p.cfg";

#DATA

	#Technology nodes
		$techFolderNames = ("22nm", "32nm");
		$techSettingLine = "-technology (u) ";
		$techSettingValues = ( "0.022", "0.032" );
		$techSettingPlaceholder = "TECHNODE";

	#Transistors type
		$typeFolderNames = ( "hp", "lop", "lstp" );
		$typeSettingLines = ( "-Data array cell type - ", "-Data array peripheral type - ", "-Tag array cell type - ", "-Tag array peripheral type - ");
		$typeSettingValues = ( '`"itrs-hp`"', '`"itrs-lop`"', '`"itrs-lstp`"');
		$typeSettingPlaceholders = ( "DATA_ARRAY_CELL_TYPE", "DATA_ARRAY_PERIPH_TYPE", "TAG_ARRAY_CELL_TYPE", "TAG_ARRAY_PERIPH_TYPE");

	#Sizes
		$sizeFileNames = ( "32k", "64k", "256k", "1m", "8m" );
		$sizeSettingLine = "-size (bytes) ";
		$sizeSettingValues = ( "32768", "65536", "262144", "1048576", "8388608" );
		$sizeSettingPlaceholder = "CACHESIZE";

	#Associativity
		$associativityAggregateValues = @{};
			$associativityAggregateValues["32k"] 	= ("2", "4");
			$associativityAggregateValues["64k"] 	= ("4", "8");
			$associativityAggregateValues["256k"]	= ("4", "8");
			$associativityAggregateValues["1m"] 	= ("4", "8");
			$associativityAggregateValues["8m"] 	= ("4", "8");
		$associativitySettingLine = "-associativity ";
		$associativityPlaceholder = "ASSOCIATIVITY";

	#Access mode
		$accessModeAggregateValues = @{};
			$accessModeAggregateValues["32k"] 	= @("fast");
			$accessModeAggregateValues["64k"] 	= @("fast", "sequential");
			$accessModeAggregateValues["256k"]	= @("sequential");
			$accessModeAggregateValues["1m"] 	= @("sequential");
			$accessModeAggregateValues["8m"] 	= @("sequential");
		$accessModeSettingLine = "-access mode (normal, sequential, fast) - ";
		$accessModePlaceholder = "ACCESSMODE";

#EXECUTION

	$cleanContent = Get-Content -Path $baseFilename;

	function substituteLine($content, $placeholder, $newLine)
	{
		$matches = ( $content | Select-String -Pattern $placeholder -CaseSensitive);
     	$tempContent = $content.Clone();
     	$tempContent[($matches[0]).LineNumber - 1] = $newLine;
     	$tempContent
	}

	#For tech nodes...
	for( $techIndex = 0; $techIndex -lt $techFolderNames.length; $techIndex++)
	{
		$techLevelContent = substituteLine $cleanContent $techSettingPlaceholder ($techSettingLine + $techSettingValues[$techIndex]);

        mkdir -Force $techFolderNames[$techIndex];
        cd $techFolderNames[$techIndex];

        #For transistor types...
        for( $typeIndex = 0; $typeIndex -lt $typeSettingValues.length; $typeIndex++)
        {
        	$typeLevelContent = $techLevelContent.Clone();
        	
        	for( $typeSettingIndex = 0; $typeSettingIndex -lt $typeSettingPlaceholders.length; $typeSettingIndex++)
        	{
    		$typeLevelContent = substituteLine $typeLevelContent $typeSettingPlaceholders[$typeSettingIndex] ($typeSettingLines[$typeSettingIndex] + $typeSettingValues[$typeIndex]);
        	}

        	mkdir -Force $typeFolderNames[$typeIndex];
        	cd $typeFolderNames[$typeIndex];

        	#For cache sizes...
        	for( $sizeIndex = 0; $sizeIndex -lt $sizeSettingValues.length; $sizeIndex++)
        	{
        		$sizeLevelContent = substituteLine $typeLevelContent $sizeSettingPlaceholder ($sizeSettingLine + $sizeSettingValues[$sizeIndex]);

        		#For associativity...
        		$associativityValues = $associativityAggregateValues[$sizeFileNames[$sizeIndex]];
        		for( $associativityIndex = 0; $associativityIndex -lt $associativityValues.length; $associativityIndex++)
        		{
        			$associativityLevelContent = substituteLine $sizeLevelContent $associativityPlaceholder ($associativitySettingLine + $associativityValues[$associativityIndex]);

        			#For access modes...
        			$accessModeValues = $accessModeAggregateValues[$sizeFileNames[$sizeIndex]];
	        		for( $accessModeIndex = 0; $accessModeIndex -lt $accessModeValues.length; $accessModeIndex++)
	        		{
	        			$accessModeLevelContent = substituteLine $associativityLevelContent $accessModePlaceholder ($accessModeSettingLine + $accessModeValues[$accessModeIndex]);

	        			$filename = $sizeFileNames[$sizeIndex] + "_" + $associativityValues[$associativityIndex] + "_" + $accessModeValues[$accessModeIndex] + ".cfg";
	        			Set-Content -Value $accessModeLevelContent -Path $filename;
	        		}
        		}
        	}

        	cd ..
        }

        cd ..
	}