function _test_quebecHolidays_fetch_from_api() {
    QuebecDaysOff.quebecHolidays_fetch_from_api();
  }
  
  function _test_quebecHolidays_dates() {
    QuebecDaysOff.quebecHolidays_dates();
  }
  
  function _test_quebecStackDays() {
    QuebecDaysOff.quebecStackDays();
  }
  
  /**
   * #####################################################################
   * # ----------------  IMPLEMENTATION -------------------------------- #
   * #####################################################################
   */
  class QuebecDaysOff {
  
    /**
     * Every other friday ( STACK DAY ) from FRIDAY 22/01/2021
     */
    static quebecStackDays() {
      var stackdays = [];
      var ss = SpreadsheetApp.getActiveSpreadsheet();
      var sheet = ss.getSheetByName('STACK_DAYS');
      var dates = sheet.getRange("D3:E").getValues();
      var notEmpty = dates.filter(String);
      notEmpty.forEach(function (value) {
        if (value[0] && value[1] == true) {
          var formattedDate = Utilities.formatDate(value[0], "GMT+1", "yyyy-MM-dd");
          stackdays.push(formattedDate)
        }
      });
      return stackdays;
    }
  
  
    /**
     * Use the public api canada-holidays.ca to retrieve the list of public holidays in Quebec
     * The idea is to auto populate the sheet named PUBLIC_HOLIDAY_QUEBEC
     */
    static quebecHolidays_fetch_from_api() {
      var options = {
        'method': 'get',
        'Accept-Version': 'V4',
        'contentType': 'application/json',
      };
      var api_url = "https://canada-holidays.ca/api/v1/provinces/QC";
      var yearsToCover = ['2020','2021','2022'];
      var datesAndNames = [];
      yearsToCover.forEach(function (year) {
        var url = api_url + "?year=" + year;
        var response = UrlFetchApp.fetch(url, options);
        if (response == "") {
          console.log("empty response from " + url);
          return;
        }
        var data = JSON.parse(response);
        data.province.holidays.forEach(function (value) {
          datesAndNames.push([value.date, value.nameEn, value.nameFr]);
        })
      });
      AutomateUtils.writeData(datesAndNames, 'PUBLIC_HOLIDAY_QUEBEC');
    }
  
    /**
   * From the sheet PUBLIC_HOLIDAY_QUEBEC
   * The idea is to retrieve only the list on public hoidays
   * We retrieve this list through the sheet to avoid making extra call to canada-holidays api
   *  MEMO to format date : var curDate = Utilities.formatDate(new Date(), "GMT+1", "MM/dd/yyyy")
   */
    static quebecHolidays_dates() {
      var holidays = [];
      var ss = SpreadsheetApp.getActiveSpreadsheet();
      var sheet = ss.getSheetByName('PUBLIC_HOLIDAY_QUEBEC');
      var dates = sheet.getRange("A3:A").getValues();
      var notEmpty = dates.filter(String);
      notEmpty.forEach(function (value) {
        var formattedDate = Utilities.formatDate(value[0], "GMT+1", "yyyy-MM-dd");
        holidays.push(formattedDate);
      });
      return holidays;
    }
  }
  
  
  
  
  