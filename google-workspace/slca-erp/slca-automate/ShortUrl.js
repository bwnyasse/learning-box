function shortProposalUrl() {
    var ss = SpreadsheetApp.getActiveSpreadsheet();
    var sheet = ss.getSheetByName('PROPOSAL');
    var data = sheet.getDataRange().getValues();
    var col = 5;
    var row = 2;
    for (var i = row - 1; i < data.length; i++) {
  
      var longUrl = data[i][col - 1];
      console.log(longUrl);
      if (!longUrl.includes('tinyurl')) {
        var shortUrl = _tinyurlGetShortLink(longUrl);
        sheet.getRange(i + 1, col).setValue(shortUrl);
      }
    }
  }
  
  function _tinyurlGetShortLink(url) {
    try {
      if (url == undefined) {
        throw 'url is empty or is not a valid url!'
      }
      let content = UrlFetchApp.fetch('https://tinyurl.com/api-create.php?url=' + encodeURI(url));
      if (content.getResponseCode() != 200) {
        return 'An error occured: [ ' + content.getContentText() + ' ]';
      }
      return content.getContentText();
    } catch (e) {
      return 'An error occured: [ ' + e + ' ]';
    }
  }