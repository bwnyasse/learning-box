var CongeDateUtilsVar_ = {
    HALF_DAY_LABEL: 'Midi',
    DAY_MILLIS: 24 * 60 * 60 * 1000,
  };
  
  class CongeDateUtils {
  
    /**
     * dayFrom = yyyy/MM/dd
     * dayTo = yyyy/MM/dd
     * startPeriod = midi ou matin
     * endPeriod = midi ou matin
     */
    static getDaysConges(dayFrom, dayTo) {
      var dayOffs = QuebecDaysOff.quebecHolidays_dates();
      var a = new Date(dayFrom);
      var b = new Date(dayTo);
      var conges = [];
      CongeDateUtils.createDateSpan(a, b).forEach(function (d) {
        var formattedDate = Utilities.formatDate(d, "GMT+1", "yyyy/MM/dd");
        // Remove SUNDAY AND SATURDAY AND PUBLIC HOLIDAY IN QUEBEC
        if (d.getDay() != 0 && d.getDay() != 6 && !dayOffs.includes(formattedDate)) {
          conges.push(d);
        }
      });
      return conges;
    }
  
    static dateCompare(a, b) {
      return a.getFullYear() === b.getFullYear() &&
        a.getMonth() === b.getMonth() &&
        a.getDate() === b.getDate();
    }
  
    static createDateSpan(startDate, endDate) {
      if (startDate.getTime() > endDate.getTime()) {
        throw Error('Start is later than end');
      }
      var dates = [];
  
      var curDate = new Date(startDate.getTime());
      while (!CongeDateUtils.dateCompare(curDate, endDate)) {
        dates.push(curDate);
        curDate = new Date(curDate.getTime() + CongeDateUtilsVar_.DAY_MILLIS);
      }
      dates.push(endDate);
      return dates;
    }
  
    /**
     * Return the table of json 
     * {
     *  'date': formattedDate,
     *  'value': value ( where value is 0.5 or 1)
     * }
     * 
     */
    static getNumberDaysCongesAsJsonForTimeSheet(dayFrom, dayTo, startPeriod, endPeriod) {
      var dates = [];
      var conges = CongeDateUtils.getDaysConges(dayFrom, dayTo);
      var count = conges.length;
      var index = 0
      while (index < count) {
        var formattedDate = Utilities.formatDate(conges[index], "GMT+1", "yyyy-MM-dd");
        if ((index == 0 && startPeriod.includes(CongeDateUtilsVar_.HALF_DAY_LABEL))
          || (index == count - 1 && endPeriod.includes(CongeDateUtilsVar_.HALF_DAY_LABEL))) {
          dates.push({
            'date': formattedDate,
            'value': 0.5
          })
        } else {
          dates.push({
            'date': formattedDate,
            'value': 1
          })
        }
        index++;
      }
  
      return dates;
    }
  
    static stackerHolidaysToWhozVacation(holidayType) {
      if (holidayType.includes("Congés payés") || holidayType.includes("Congés anticipés")) {
        return "VACATION"
      } else if (holidayType.includes("Congés sans solde")) {
        return "VACATION_UNPAID"
      }
  
      return "VACATION_OTHER"
    }
  
    static allConges() {
      // Spreadsheet des demandes de congés : https://docs.google.com/spreadsheets/d/1d4HUOe9G6k6MAvfXKa_OQ6qzC5pYGhySkUEXKWLP2CA/
      var sheet = SpreadsheetApp.openById("1d4HUOe9G6k6MAvfXKa_OQ6qzC5pYGhySkUEXKWLP2CA").getSheetByName('Réponses au formulaire 1');
      var data = sheet.getDataRange().getValues();
      var listOfConges = []
      data.shift(); // Omit first line
      data.forEach(function (row) {
        var email = row[1];
        var startDate = row[2];
        var startPeriod = row[3];
        var endDate = row[4];
        var endPeriod = row[5];
        var type = row[6];
        var isAccepted = row[8].includes("ACCEPT");
  
        var formattedstartDate = Utilities.formatDate(startDate, "GMT+1", "yyyy/MM/dd");
        var formattedendDate = Utilities.formatDate(endDate, "GMT+1", "yyyy/MM/dd");
        var dates = CongeDateUtils.getNumberDaysCongesAsJsonForTimeSheet(formattedstartDate, formattedendDate, startPeriod, endPeriod);
        var jsonData = {
          'email': email,
          'dates': dates,
          'type': CongeDateUtils.stackerHolidaysToWhozVacation(type),
          'isAccepted': isAccepted
        }
        listOfConges.push(jsonData);
      });
      return listOfConges;
    }
  }
  
  /**
   * dayFrom = yyyy/MM/dd
   * dayTo = yyyy/MM/dd
   * startPeriod = midi ou matin
   * endPeriod = midi ou matin
   */
  function getNumberDaysConges(dayFrom, dayTo, startPeriod, endPeriod) {
    var conges = CongeDateUtils.getDaysConges(dayFrom, dayTo);
    var count = conges.length;
    if (count > 0) {
      if (startPeriod.includes(CongeDateUtilsVar_.HALF_DAY_LABEL)) {
        count = count - 0.5
      }
      if (endPeriod.includes(CongeDateUtilsVar_.HALF_DAY_LABEL)) {
        count = count - 0.5
      }
    }
    return count;
  }
  
  function test_getNumberDaysCongesAsJson_() {
    console.log(CongeDateUtils.getNumberDaysCongesAsJsonForTimeSheet("2021/08/13", "2021/08/30", "Midi", "Soir"));
  }
  
  function test_allConges_() {
    console.log(CongeDateUtils.allConges());
  }
  