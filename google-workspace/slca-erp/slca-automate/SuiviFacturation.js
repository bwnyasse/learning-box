function test() {
    var value = 'DDDD #SDQDQSDAAZ'
    var startSubString = value.indexOf('#')
    //console.log(value.substring(startSubString, value.length))
  }
  
  function listeFacturationEmails() {
    var ss = SpreadsheetApp.getActiveSpreadsheet();
    var sheet = ss.getSheetByName('COMPANIES_FACTURATION');
    var data = sheet.getDataRange().getValues();
  
    var emailFacturations = Array();
  
    for (var i = 1; i < data.length; i++) {
      var client = data[i][0].toUpperCase()
      var emails = data[i][1]
      var json = {
        'client': client,
        'emails': emails,
      }
      emailFacturations.push(json);
    }
  
    return emailFacturations;
  }
  
  function getDealsWonInSpreadSheet() {
    var ss = SpreadsheetApp.getActiveSpreadsheet();
    var sheet = ss.getSheetByName(sheetNameDealsWon);
    var data = sheet.getDataRange().getValues();
  
    var dealWons = Array();
  
    for (var i = 2; i < data.length; i++) {
      var finalClient = data[i][1]
      var deal = data[i][2]
      var poNumber = data[i][3]
      var linkPo = data[i][12]
      var codeProjet = data[i][10]
      var devise = data[i][5]
      var clientToFacture = data[i][8] == '' ? finalClient : data[i][8]
      var json = {
        'client': clientToFacture,
        'deal': deal,
        'poNumber': poNumber,
        'linkPo': linkPo,
        'codeProjet': codeProjet,
        'devise': devise,
      }
      //console.log(json);
      dealWons.push(json);
    }
  
    return dealWons;
  }
  
  function getDealsWonsByCodeProjet(array, codeProjet) {
    var json = {}
    array.forEach(function (value) {
      //console.log("code project " + value.codeProjet)
      if (value.codeProjet == codeProjet) {
        json = value;
        return;
      }
    })
    return json;
  }
  
  function getFacturationEmailsByClient(array, client) {
    var emails;
    array.forEach(function (value) {
      if (value.client == client) {
        emails = value.emails;
        return;
      }
    })
    return emails;
  }
  
  function suiviFacturation(yyyyMM) {
    _ensureInitialisation();
    var dealsWons = getDealsWonInSpreadSheet();
    var emailsFacturations = listeFacturationEmails();
    var results = [];
  
    // Iterate over each member , and for every public holiday, clear all the taskid
    WHOZ_MEMBERS.forEach(function (member) {
      if (member.person && member.person.emails) {
        var personId = member.personId
        var json = WhozGet.someoneTimesheets(yyyyMM, personId);
  
        var aggregateWorklogs = new Map();
        json.forEach(function (entry) {
          entry.worklogs.forEach(function (worklog) {
            if (worklog.type == "TASK") {
              if (aggregateWorklogs.has(worklog.taskId)) {
                var updatedWorkload = aggregateWorklogs.get(worklog.taskId) + worklog.workload
                aggregateWorklogs.set(worklog.taskId, updatedWorkload)
              } else {
                aggregateWorklogs.set(worklog.taskId, worklog.workload)
              }
            }
          });
        })
        for (let [key, value] of aggregateWorklogs) {
          var data = WhozRegister.readTask(key);
          var dossierName;
  
          if (data.billable) {
            WHOZ_DOSSIERS.forEach(function (dossier) {
              if (dossier.id == data.dossierId) {
                dossierName = dossier.name;
                return;
              }
            });
            var tauxhoraire = data.unitRate.value / 7.5
            var workloadHours = value * 7.5
            var prixPartiel = tauxhoraire * workloadHours
            var tps = prixPartiel * 0.05
            var tvq = prixPartiel * 0.09975
            var total = prixPartiel + tps + tvq
            var startSubString = data.name.indexOf('#')
            var codeProjet = data.name.substring(startSubString, data.name.length)
            var dealsInfos = getDealsWonsByCodeProjet(dealsWons, codeProjet)
            var clientAFacturer = dealsInfos.client.toUpperCase()
            var facturation = getFacturationEmailsByClient(emailsFacturations, clientAFacturer)
            var json = {
              "Période": yyyyMM,
              "poNumber": dealsInfos.poNumber,
              "Client à Facturer": clientAFacturer,
              "Dossier dans Whoz & Hubspot": dossierName,
              "Stacker": member.person.firstName + ' ' + member.person.lastName,
              "Code Projet": codeProjet,
              "linkPo": dealsInfos.linkPo,
              "workload en jours": value,
              "workload en Heures": workloadHours,
              "Taux jour": data.unitRate.value,
              "Taux horaire": data.unitRate.value / 7.5,
              "Prix Partiel": prixPartiel,
              "Devise pour Facture": dealsInfos.devise,
              "TPS 5%": tps,
              "TVQ 9,975%": tvq,
              "total": total,
              "Facturation": facturation,
            }
            results.push([yyyyMM,
              dealsInfos.poNumber,
              clientAFacturer,
              dossierName,
              member.person.firstName + ' ' + member.person.lastName,
              codeProjet,
              dealsInfos.linkPo,
              value,
              workloadHours,
              data.unitRate.value,
              data.unitRate.value / 7.5,
              facturation,
              dealsInfos.devise,
            ])
          }
        }
      }
    });
    return results;
  }
  