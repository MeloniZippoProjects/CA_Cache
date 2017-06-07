BEGIN {
	output_csv = "data.csv"
	print "Technology node (nm);Transistor type;Size (KiB);Associativity;Access mode;Access time (ns);Cycle time (ns);Tag area (mm2);Data area (mm2);Read energy per access (nJ);Write energy per access (nJ); Total Leakage Power (mW)" > output_csv	
}

/FILE_START/ {
	#clean the row array content
	for(i in currentRow)
		delete currentRow[i]
}

/Technology size/ {
	currentRow["technology node"] = ($NF / 1)
}

/Data array cell type/ {
	switch($NF / 1)
	{
		case 0:
			type = "itrs-hp"
			break
		case 1:
			type = "itrs-lstp"
			break
		case 2:
			type = "itrs-lop"
			break
		default:
			type = "error"
			break
	}
	currentRow["transistor type"] = type
}

/Total cache size/ {
	currentRow["cache size"] = ($NF / 1024)
}

/Associativity:/ {
	currentRow["associativity"] = ($NF / 1)	
}

/Access mode/ {
	switch($NF / 1)
	{
		case 1:
			mode = "sequential"
			break
		case 2:
			mode = "fast"
			break
		default:
			mode = "error"
			break
	}
	currentRow["access mode"] = mode
}

/Access time/ {
	currentRow["access time"] = ($NF / 1)
}

/Cycle time/ {
	currentRow["cycle time"] = ($NF / 1)
}

/Tag array: Area/ {
	currentRow["tag area"] = ($NF / 1)
}

/Data array: Area/ {
	currentRow["data area"] = ($NF / 1)
}

/Total dynamic read energy per access/ {
	currentRow["read energy"] = ($NF / 1)
}

/Total dynamic write energy per access/ {
	currentRow["write energy"] = ($NF / 1)
}

/Total leakage power/ {

	if(!("leakagePower" in currentRow))
	{
		currentRow["leakagePower"] = $NF
	}
}

/FILE_END/ {
	print currentRow["technology node"] ";" currentRow["transistor type"] ";" currentRow["cache size"] ";" currentRow["associativity"] ";" currentRow["access mode"] ";" currentRow["access time"] ";" currentRow["cycle time"] ";" currentRow["tag area"] ";"  currentRow["data area"] ";" currentRow["read energy"] ";" currentRow["write energy"] ";" currentRow["leakagePower"] > output_csv 
}
