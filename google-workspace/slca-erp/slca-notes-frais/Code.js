
var STACKER_MAIL_COLUMN = 2
var LINK_EXPENSES_SHEET = 3
var LINK_EXPENSES_RECEIPT = 4
var VALIDATION_COLUMN = 5
var VALIDATOR_COLUMN = 6
var VALIDATION_DATE_COLUMN = 7

var ACCEPTED = 'ACCEPTÉ'
var REFUSED = 'REFUSÉ'

var MAIL_SUBJECT = 'Votre notes de frais / Your Expense Report '
var MAIL_SUBJECT_OFFICE_MANAGEMENT = 'CANADA : Demande de paiement d\' une note de frais'

function getDemandInformation(row) {
  demandValues = SpreadsheetApp.getActiveSheet().getRange(row, STACKER_MAIL_COLUMN, 1, 3).getValues()[0]

  return {
    stackerEmailAddress: demandValues[0],
    linkExpensesSheet: demandValues[1],
    linkExpensesReceipt: demandValues[2],
  }
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
  SpreadsheetApp.getActiveSheet().getRange(editedRow, VALIDATOR_COLUMN).setValue(editEvent.user)
  SpreadsheetApp.getActiveSheet().getRange(editedRow, VALIDATION_DATE_COLUMN).setValue(new Date())
}

function prepareNotification_(row, validationType) {
  if (validationType == ACCEPTED) {
    htmlFile = 'Accepted'
  } else if (validationType == REFUSED) {
    htmlFile = 'Refused'
  }

  if (htmlFile == undefined) {
    return null
  }

  var html = HtmlService.createTemplateFromFile(htmlFile)
  html.data = getDemandInformation(row)

  return html.evaluate().getContent()
}

function notifyOfficeManagementByMail_(editedRow) {
  htmlFile = 'AcceptedOffice'
  var html = HtmlService.createTemplateFromFile(htmlFile)
  html.data = getDemandInformation(editedRow)

  message = html.evaluate().getContent()
  if (message == null) {
    return
  }
  subject = "💵 💵" + MAIL_SUBJECT_OFFICE_MANAGEMENT + " - " +  html.data.stackerEmailAddress

  MailApp.sendEmail({
    to: 'office@stack-labs.com',
    cc: 'boris@stack-labs.com',
    subject: subject,
    htmlBody: message,
    noReply: true,
  })
}

function notifyStackerByMail_(editEvent) {
  const editedRow = editEvent.range.getRow()

  const message = prepareNotification_(editedRow, editEvent.value)
  if (message == null) {
    return
  }

  subject = MAIL_SUBJECT
  if (isAccepted_(editEvent)) {
    subject = "👍 " + MAIL_SUBJECT
  } else {
    subject = "👎 " + MAIL_SUBJECT
  }

  MailApp.sendEmail({
    to: SpreadsheetApp.getActiveSheet().getRange(editedRow, STACKER_MAIL_COLUMN).getValue(),
    subject: subject,
    htmlBody: message,
    noReply: true,
  })

  if (isAccepted_(editEvent)) {
    notifyOfficeManagementByMail_(editedRow)
  }
}

function onValidationAttempt(event) {
  if (isValidationEvent_(event)) {
    Logger.log('Received a validation event')

    updateValidatedRow_(event)

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