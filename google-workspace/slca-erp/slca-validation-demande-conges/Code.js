
var STACKER_MAIL_COLUMN = 2
var START_DATE_COLUMN = 3
var START_PERIOD_COLUMN = 4
var END_DATE_COLUMN = 5
var END_PERIOD_COLUMN = 6
var VALIDATION_COLUMN = 9
var VALIDATOR_COLUMN = 10
var VALIDATION_DATE_COLUMN = 11
var COUNT_DAYS_COLUMN = 12
var COUNT_HOURS_COLUMN = 13
var YEAR_TO_APPLY = 14
var ACCEPTED = 'ACCEPTÉ'
var REFUSED = 'REFUSÉ'
var MAIL_SUBJECT = 'Statut sur votre demande de congés'
var MAIL_SUBJECT_OFFICE_MANAGEMENT = 'CANADA : Validation d\'une demande de congés '

function getDemandInformation(row) {
  demandValues = SpreadsheetApp.getActiveSheet().getRange(row, STACKER_MAIL_COLUMN, 1, 12).getValues()[0]

  return {
    stackerEmailAddress: demandValues[0],
    dayFrom: demandValues[1],
    momentFrom: demandValues[2],
    dayTo: demandValues[3],
    momentTo: demandValues[4],
    holidayType: demandValues[5],
    reason: demandValues[6],
    countDays: demandValues[10],
    countHours: demandValues[11]
  }
}

function getCountDay_(row) {
  startDate = SpreadsheetApp.getActiveSheet().getRange(row, START_DATE_COLUMN).getValue()
  startPeriod = SpreadsheetApp.getActiveSheet().getRange(row, START_PERIOD_COLUMN).getValue()
  endDate = SpreadsheetApp.getActiveSheet().getRange(row, END_DATE_COLUMN).getValue()
  endPeriod = SpreadsheetApp.getActiveSheet().getRange(row, END_PERIOD_COLUMN).getValue()

  var formattedstartDate = Utilities.formatDate(startDate, "GMT+1", "yyyy/MM/dd");
  var formattedendDate = Utilities.formatDate(endDate, "GMT+1", "yyyy/MM/dd");

  return SuiviSLCAAutomate.getNumberDaysConges(formattedstartDate, formattedendDate, startPeriod, endPeriod);
}


function isValidatedRow_(row) {
  return SpreadsheetApp.getActiveSheet().getRange(row, VALIDATOR_COLUMN).getValue() != ''
}

function isValidationEvent_(editEvent) {
  if (editEvent == undefined) {
    return false
  }

  const editedRow = editEvent.range.getRow()
  const editedColumn = editEvent.range.getColumn()

  return (editEvent.value == ACCEPTED || editEvent.value == REFUSED) && editedColumn == VALIDATION_COLUMN && !isValidatedRow_(editedRow)
}

function isAccepted_(editEvent) {
  return editEvent.value == ACCEPTED
}

function updateValidatedRow_(editEvent) {
  const editedRow = editEvent.range.getRow()
  countDays = getCountDay_(editedRow)
  countHours = countDays * 8.0
  SpreadsheetApp.getActiveSheet().getRange(editedRow, VALIDATOR_COLUMN).setValue(editEvent.user)
  SpreadsheetApp.getActiveSheet().getRange(editedRow, VALIDATION_DATE_COLUMN).setValue(new Date())
  SpreadsheetApp.getActiveSheet().getRange(editedRow, COUNT_DAYS_COLUMN).setValue(countDays)
  SpreadsheetApp.getActiveSheet().getRange(editedRow, COUNT_HOURS_COLUMN).setValue(countHours)
  SpreadsheetApp.getActiveSheet().getRange(editedRow, YEAR_TO_APPLY).setValue(startDate.getFullYear())
}

function prepareNotification_(row, validationType) {
  if (validationType == ACCEPTED) {
    htmlFile = 'AcceptedHoliday'
  } else if (validationType == REFUSED) {
    htmlFile = 'RefusedHoliday'
  }

  if (htmlFile == undefined) {
    return null
  }

  var html = HtmlService.createTemplateFromFile(htmlFile)
  html.data = getDemandInformation(row)

  return html.evaluate().getContent()
}

function notifyOfficeManagementByMail_(editedRow) {
  htmlFile = 'AcceptedOfficeHoliday'
  var html = HtmlService.createTemplateFromFile(htmlFile)
  html.data = getDemandInformation(editedRow)

  message = html.evaluate().getContent()
  if (message == null) {
    return
  }
  subject = "👍 " + MAIL_SUBJECT_OFFICE_MANAGEMENT

  MailApp.sendEmail({
    to: 'office@stack-labs.com',
    cc: 'boris.nyasse@stack-labs.com',
    subject: subject,
    htmlBody: message
  })
}

function notifyStackerByMail_(editEvent) {
  const editedRow = editEvent.range.getRow()
  const message = prepareNotification_(editedRow, editEvent.value)
  if (message == null) {
    return
  }

  subject = MAIL_SUBJECT
  var isAccepted = isAccepted_(editEvent)
  if (isAccepted) {
    subject = "👍 " + MAIL_SUBJECT
  } else {
    subject = "👎 " + MAIL_SUBJECT
  }

  MailApp.sendEmail({
    to: SpreadsheetApp.getActiveSheet().getRange(editedRow, STACKER_MAIL_COLUMN).getValue(),
    subject: subject,
    htmlBody: message
  })

  if (isAccepted_(editEvent)) {
    notifyOfficeManagementByMail_(editedRow)
  }
}

function getStackerActivityCalendar_(stackerMailAddress) {
  const calendars = CalendarApp.getAllCalendars()

  for (var i = 0; i < calendars.length; i++) {
    calendar = calendars[i]

    if (calendar.getName().indexOf("Activity_") == 0 && calendar.getDescription().indexOf(stackerMailAddress) != -1) {
      return calendar
    }
  }

  return null
}

function translateHolidayTypeInCode_(holidayType) {
  switch (holidayType) {
    case "Congés payés":
      return "#CP"
    case "Congés sans solde":
      return "#CSS"
    case "Congés anticipés":
      return "#CPA"
    case "Congés maladie":
      return "#CMALADIE"
    case "RTT":
      return "#RTT"
    case "Congés conventionnels":
      return "#CCOLL"
  }

  return "#CCOLL"
}

function addEventInActivityCalendar_(editEvent) {
  demand = getDemandInformation(editEvent.range.getRow())

  const holidayType = translateHolidayTypeInCode_(demand.holidayType)
  const calendar = getStackerActivityCalendar_(demand.stackerEmailAddress)

  if (calendar == null) {
    Logger.log("no calendar was found")
    return
  }

  var beginning = demand.dayFrom
  if (demand.momentFrom == 'Midi') {
    beginning.setHours(12)
  } else {
    beginning.setHours(9)
  }

  var ending = demand.dayTo
  if (demand.momentTo == 'Soir') {
    ending.setHours(17)
  } else {
    ending.setHours(12)
  }

  calendar.createEvent(holidayType, beginning, ending)
}

function onValidationAttempt(event) {
  if (isValidationEvent_(event)) {
    Logger.log('Received a validation event')

    updateValidatedRow_(event)

    if (isAccepted_(event)) {
      // Temporairement désactivé, la mise à jour du calendrier
    //  addEventInActivityCalendar_(event)
    }

    notifyStackerByMail_(event)
  } else {
    Logger.log('Not a validation event')
  }
}

function setupOnEditTrigger() {
  ScriptApp.newTrigger('onValidationAttempt')
    .forSpreadsheet(SpreadsheetApp.getActive())
    .onEdit()
    .create()
}