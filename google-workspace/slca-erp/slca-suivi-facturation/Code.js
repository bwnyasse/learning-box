/**
 * ###########################################################################
 * # ----------------------------------------------------------------------- #
 * # --------------------------- Menu items -------------------------------- #
 * # ----------------------------------------------------------------------- #
 * ###########################################################################
 */


 function getyyyyMM() {
    var results = [];
    const monthIndex = [
      '01', '02', '03', '04', '05', '06',
      '07', '08', '09', '10', '11', '12',
    ];
  
    const date = new Date();
    const year = `${date.getFullYear()}`;
    const mt = date.getMonth() + 1;
    //results.push("suivi_2022_04");
    monthIndex.forEach(function (value) {
      if (value >= mt) {
        results.push("suivi_" + year + '_' + value);
      }
    });
    return results;
  }
  
  function installFunctions() {
  
    // Samples
    var array = [];
    getyyyyMM().forEach(function (value) {
      array.push({ name: value, args: value });
    })
    var menu = SpreadsheetApp.getUi().createMenu("Init nouveau suivi facturation");
    for (var i = 0; i < array.length; i++) {
      const element = array[i];
      var functionName = "_" + element.name;
      var args = element.args;
      this[functionName] = dynamicItem(args);
      menu.addItem(element.name, functionName);
    }
    menu.addToUi();
  }
  
  installFunctions(); // This function is run when the Spreadsheet is opened and each menu is selected.
  
  function onOpen() { }
  
  function dynamicItem(args) {
    return function () {
      var value = args.toString().replace("suivi_", "")
      value = value.replace("_", "-");
      logique(value);
    };
  }
  
  function logique(month) {
    var results = SuiviSLCAAutomate.suiviFacturation(month);
    deletedRowsByMonth(month)
    writeData(results)
  
  }
  
  function deletedRowsByMonth(month) {
    var ss = SpreadsheetApp.getActiveSpreadsheet();
    var sheet = ss.getSheetByName('SUIVI');
    var rows = sheet.getDataRange();
    var numRows = rows.getNumRows();
    var values = rows.getValues();
  
    var rowsDeleted = 0;
    for (var i = 0; i <= numRows - 1; i++) {
      var row = values[i];
      var formattedDate = Utilities.formatDate(new Date(row[0]), "GMT+1", "yyyy-MM");
      if (formattedDate == month) {
        sheet.deleteRow((parseInt(i) + 1) - rowsDeleted);
        rowsDeleted++;
      }
    }
  };
  
  function writeData(data) {
    var ss = SpreadsheetApp.getActiveSpreadsheet();
    var sheet = ss.getSheetByName('SUIVI');
  
    var matrix = data;
  
    // Writing the table to the spreadsheet
    var lastRow = sheet.getLastRow();
    var range = sheet.getRange(lastRow + 1, 1, matrix.length, matrix[0].length);
    range.setValues(matrix);
  
    var moneyColums = Array();
    moneyColums.push(sheet.getRange("K3:K"));
    moneyColums.push(sheet.getRange("L3:L"));
    moneyColums.push(sheet.getRange("M3:M"));
    moneyColums.push(sheet.getRange("O3:O"));
    moneyColums.push(sheet.getRange("P3:P"));
    moneyColums.push(sheet.getRange("Q3:Q"));
  
    for (var i = 0; i < moneyColums.length; i++) {
      moneyColums[i].setNumberFormat("$#,##0.00;$(#,##0.00)"); // Money format
    }
  
    // Sort by Date that is the first column
    var range = sheet.getRange("A3:Q");
    range.sort({ column: 1 });
  }
  
  