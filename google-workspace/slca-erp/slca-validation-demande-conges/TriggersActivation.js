function reloadValidationDaemon() {
    var allTriggers = ScriptApp.getProjectTriggers()
    for (var i = 0; i < allTriggers.length; i++) {
      if (allTriggers[i].getHandlerFunction() == 'onValidationAttempt') {
        ScriptApp.deleteTrigger(allTriggers[i])
      }
    }
    
    setupOnEditTrigger()
  }
  
  function setupAutomatizationUiButton() {
    var ui = SpreadsheetApp.getUi()
    
    ui.createMenu('Automatisation').addItem('Activer le trigger pour mon compte', 'reloadValidationDaemon').addToUi()
  }