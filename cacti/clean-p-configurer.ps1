#CONFIGS


#DATA

	#Technology nodes
		$nodeFolderNames = ("22nm", "32nm");
		$techSettingLine = "-technology (u) ";
		$techSettingValues = ( "0.022", "0.032" );
		$settingPlaceholder = "TECHNODE";

	#Transistors type
		$typeFolderNames = ( "hp", "lop", "lstp" );
		$typeSettingLines = ( "-Data array cell type - ", "-Data array peripheral type - ", "-Tag array cell type - ", "-Tag array peripheral type - ");
		$typeSettingValues = ( '`"itrs-hp`"', '`"itrs-lop`"', '`"itrs-lstp`"');
		$typeSettingPlaceholders = ( "DATA_ARRAY_CELL_TYPE", "DATA_ARRAY_PERIPH_TYPE", "TAG_ARRAY_CELL_TYPE", "TAG_ARRAY_PERIPH_TYPE");

	#Sizes
		$sizeFileNames = ( "32k", "64k", "256k", "1m", "8m" );
		$sizeSettingLine = "-size (bytes) ";
		$typeSettingValues = ( "32768", "65536", "262144", "1048576", "8388608" );
		$typeSettingPlaceholder = "CACHESIZE";

	#Associativity
		$associativityValues = @{};
			$associativityValues["32k"] 	= ("2", "4");
			$associativityValues["64k"] 	= ("4", "8");
			$associativityValues["256k"]	= ("4", "8");
			$associativityValues["1m"] 		= ("4", "8");
			$associativityValues["8m"] 		= ("4", "8");
		$associativitySettingLine = "-associativity ";
		$associativityPlaceholder = "ASSOCIATIVITY";

	#Access mode
		$accessModeValues = @{};
			$accessModeValues["32k"] 	= ("fast");
			$accessModeValues["64k"] 	= ("fast", "sequential");
			$accessModeValues["256k"]	= ("sequential");
			$accessModeValues["1m"] 	= ("sequential");
			$accessModeValues["8m"] 	= ("sequential");
		$accessModeSettingLine = "-access mode (normal, sequential, fast) - ";
		$accessModePlaceholder = "ACCESSMODE";

#EXECUTION

