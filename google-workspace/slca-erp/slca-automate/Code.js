/**
 * ###########################################################################
 * # ----------------------------------------------------------------------- #
 * # --------------------------- Menu items -------------------------------- #
 * # ----------------------------------------------------------------------- #
 * ###########################################################################
 */

function onOpen() {
  //  Current SpreadSheet : 
  var ui = SpreadsheetApp.getUi();
  // Or DocumentApp or FormApp.
  ui.createMenu('SLCA - API Connector')
    .addItem('Hubspot -> Companies', 'Hubspot.getCompanies')
    .addSeparator()
    .addItem('Hubspot -> Contacts', 'Hubspot.getContacts')
    .addSeparator()
    .addItem('Hubspot -> Deals', 'Hubspot.getDeals')
    .addSeparator()
    .addItem('Hubspot -> All', 'Hubspot.all')
    .addSeparator()
    .addItem('Google -> All Stackers', 'GoogleAdmin.getStackers')
    .addSeparator()
    .addItem('Quebec -> Update Public Holidays', 'QuebecDaysOff.quebecHolidays_fetch_from_api')
    .addSeparator()
    .addItem('WHoz -> Stack Day & Public Holidays', 'Whoz.add_stackDay_and_publicholidays')
    .addSeparator()
    .addItem('WHoz -> Sync All Vacations', 'sync_into_whoz_all_stackers_conges')
    .addToUi();
}
