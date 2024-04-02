function main(workbook: ExcelScript.Workbook) {
	let selectedSheet = workbook.getActiveWorksheet();
	// Insert at range G:G on selectedSheet, move existing cells right
	selectedSheet.getRange("G:G").insert(ExcelScript.InsertShiftDirection.right);
	// Insert at range G:G on selectedSheet, move existing cells right
	selectedSheet.getRange("G:G").insert(ExcelScript.InsertShiftDirection.right);
	// Insert at range G:G on selectedSheet, move existing cells right
	selectedSheet.getRange("G:G").insert(ExcelScript.InsertShiftDirection.right);
	// Set range G1:I1 on selectedSheet
	selectedSheet.getRange("G1:I1").setValues([["Ticket Age","2 days Old","OSLA"]]);
	// Auto fit the columns of range F:F on selectedSheet
	//selectedSheet.getRange("F2:F$").getFormat().autofitColumns();
	// Set range G2 on selectedSheet
	//selectedSheet.getRange("G2:G$").setValue("=NETWORKDAYS(F2,TODAY())-(WEEKDAY(F2,2)<3)");
	// Auto fill range
	//selectedSheet.getRange("G2").autoFill("G2:G31", ExcelScript.AutoFillType.fillDefault);
	// Toggle auto filter on selectedSheet
	//selectedSheet.getAutoFilter().apply(selectedSheet.getRange("1:1"));
	// Apply values filter on selectedSheet
	//selectedSheet.getAutoFilter().apply(selectedSheet.getAutoFilter().getRange(), 7, { filterOn: ExcelScript.FilterOn.values, values: ["11", "224", "4", "6", "9"] });
	// Set range H26 on selectedSheet
	//selectedSheet.getRange("H26").setValue("Yes");
	// Paste to range H26:H31 on selectedSheet from range H26 on selectedSheet
	//selectedSheet.getRange("H26:H31").copyFrom(selectedSheet.getRange("H26"), ExcelScript.RangeCopyType.all, false, false);
	// Paste to range I31 on selectedSheet from range H26 on selectedSheet
	//selectedSheet.getRange("I31").copyFrom(selectedSheet.getRange("H26"), ExcelScript.RangeCopyType.all, false, false);
	// Clear auto filter on selectedSheet
	//selectedSheet.getAutoFilter().clearCriteria();
	// Set range F34:J53 on selectedSheet
	//selectedSheet.getRange("F34:J53").setValues([["Engineer","2 Days Older","OSLA Count","Within 2 Days","Grand Total"],["Ajith kumar Raja",0,0,0,1],["Akhil P",0,0,0,0],["BhavaniKrishna Yallamilli",0,0,0,1],["Chaitanya Kumar Paltur",0,0,0,10],["Madhu Kalyan Yekkala",0,0,0,0],["Mahesh Gowda",2,0,0,3],["Mani Shankar K",0,0,0,2],["Mohammadullah Khan",0,0,0,0],["Nagabhushan Mahesh",2,0,0,4],["Prajwal Kumar",1,1,0,4],["Raghavendra M",0,0,0,0],["SaiKrishna Nayak",1,0,0,1],["Sreenath Mangote",0,0,0,1],["Srinivasulu Valluru",0,0,0,0],["SYED JUNAID Noorulla",0,0,0,3],["VasuBapu Bobbili",0,0,0,0],["Vijay Pawar",0,0,0,0],["Unassigned",0,0,0,0],["Grand Total",0,0,0,0]]);
}