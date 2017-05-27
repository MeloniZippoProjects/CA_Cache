BEGIN {
	output_csv = "out.csv"
	print "Technology node;Transistor type;Size;Associativity;Access mode;Access time;Cycle time;Tag area;Data area;Read energy per access;Write energy per access" > output_csv	
}

/FILE_START/ {
	#clean the row array content
	for(i in currentRow)
		delete currentRow[i]
}

/Technology size/ {
	currentRow["technology node"] = ($4 / 1) " nm"
}

/Data array cell type/ {
	switch($6 / 1)
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
	currentRow["cache size"] = ($5 / 1024) " kb"
}

/Associativity:/ {
	currentRow["associativity"] = ($2 / 1)	
}

/Access mode/ {
	switch($4 / 1)
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
	currentRow["access time"] = ($4 / 1) " ns"
}

/Cycle time/ {
	currentRow["cycle time"] = ($4 / 1) " ns"
}

/Tag array: Area/ {
	currentRow["tag area"] = ($5 / 1) " mm2"
}

/Data array: Area/ {
	currentRow["data area"] = ($5 / 1) " mm2"
}

/Total dynamic read energy per access/ {
	currentRow["read energy"] = ($8 / 1) " nJ"
}

/Total dynamic write energy per access/ {
	currentRow["write energy"] = ($8 / 1) " nJ"
}

/FILE_END/ {
	print currentRow["technology node"] ";" currentRow["transistor type"] ";" currentRow["cache size"] ";" currentRow["associativity"] ";" currentRow["access mode"] ";" currentRow["access time"] ";" currentRow["cycle time"] ";" currentRow["tag area"] ";"  currentRow["data area"] ";" currentRow["read energy"] ";" currentRow["write energy"] > output_csv 
}