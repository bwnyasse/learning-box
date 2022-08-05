/**
 * ###########################################################################
 * # ----------------------------------------------------------------------- #
 * # ------------------- GLOBAL VARIABLES ---------------------------------- #
 * # ----------------------------------------------------------------------- #
 * ###########################################################################
 */

//WHO API & CREDENTIELS
var WHOZ_CLIENT_ID = TODO_WHOZ_CLIENT_ID;
var WHOZ_CLIENT_SECRET = TODO_WHOZ_CLIENT_SECRET;

// ------------
var WHOZ_OWNER_ID = TODO_WHOZ_OWNER_ID; // For now , the owner is Boris-Wilfried
var WHOZ_STACK_LABS_CANADA_WORKSPACE_ID = TODO_WHOZ_STACK_LABS_CANADA_WORKSPACE_ID;

var WHOZ_URL_API = 'https://www.whoz.com/api';
var WHOZ_URL_API_ACCOUNT = WHOZ_URL_API + '/account';
var WHOZ_URL_API_PROJECT = WHOZ_URL_API + '/project';
var WHOZ_URL_API_DOSSIER = WHOZ_URL_API + '/dossier';
var WHOZ_URL_API_MEMBER = WHOZ_URL_API + '/memberV2';
var WHOZ_URL_API_TIMESHEET = WHOZ_URL_API + '/timesheet';
var WHOZ_URL_API_TASK = WHOZ_URL_API + '/task';


// -------- Initialisation : This values will be populate in a init method()
var WHOZ_API_TOKEN = '';
var WHOZ_ACCOUNTS;
var WHOZ_PROJECTS;
var WHOZ_DOSSIERS;
var WHOZ_MEMBERS;
var INIT = false;
// --------

// -------- Members management
var WHOZ_MEMBERS_TO_EXCLUDE = [
  '61169aa2da886a601732f880', // WHOZ SUPPORT MEMBER
  '611a19a4c7dbb06e519d5ccf', // WHOZ API STACK LABS - MEMBER
  '61169c99da886a601732f884', // MEMBER -> Boris-Wilfried Nyasse en tant que Manager actuellement
  '615d9f2720b4015d2b44db82', // Stacker France => thibaut.dusanter@stack-labs.com
  '615d9f2b20b4015d2b44db83', // Stacker France => henri.delozanne@stack-labs.com
  '615d9f2c20b4015d2b44db84', // Stacker France => nicolas.espiau@stack-labs.com

  // LES STACKERS , on peut commenter pour aller rapidement ou faire des tests
  /* '62544a04a3b7ba78a9d3c881', // Generic Palooma
   '6268027604465d56f9e36483', // Generic Stack Labs France
   '6116e353c7dbb06e519d59fb',
   '6116e45bc7dbb06e519d59ff',
   '6116e4e4c7dbb06e519d5a02',
   '6116e61cc7dbb06e519d5a08',
   '6116e81cc7dbb06e519d5a0b',
   '611abcf2c7dbb06e519d5d95',
   '6121e5afc7dbb06e519d67eb',
   '613904add85e421df5142720',
   '613904aed85e421df5142722',
   '615d9f2220b4015d2b44db81',
   '619bac7ee9577c362a450994',
   '619bad59e9577c362a45099d',
   '61b86f3e698c834b91dde42d',
   '61dda44130d72738649c5228',
   '61dda44230d72738649c522a',
   '624c8369d2ac990f36e89012',*/
];
var MEMBERS_EMAIL_TO_EXCLUDE = [
  'boris.nyasse@stack-labs.com'
]
// --------

// gestion des jours fériés
var JOURS_FERIES_PUBLIC_HOLIDAYS_OFF_TASKNAME = 'JOURS FERIES - PUBLIC HOLIDAYS - OFF'
var JOURS_FERIES_PUBLIC_HOLIDAYS_DOSSIER_ID = '6122e248c7d9ab49edc9f4e0'
// --------------

// gestion des Stack days
var STACK_DAY_TASKNAME = 'STACK DAY'
var STACK_DAY_DOSSIER_ID = '611c35fec7d9ab49edb7a2da'
// --------------

function _ensureInitialisation() {
  if (!INIT) {
    WHOZ_API_TOKEN = WhozGet.token();
    WHOZ_ACCOUNTS = WhozGet.accounts();
    WHOZ_PROJECTS = WhozGet.projects();
    WHOZ_DOSSIERS = WhozGet.dossiers();
    WHOZ_MEMBERS = WhozGet.members();
    INIT = true
  }
}

/**
 * ##################################
 * # -------------------- --------- #
 * # ----------- OPTIONS  ----------#
 * # -- GET | POST | PUT | DELETE - #
 * ##################################
 */
class WhozOptions {
  static getPOSTOptions(payload) {
    var options = {
      'method': 'post',
      'Accept-Version': 'V4',
      'contentType': 'application/json',
      'payload': payload,
      headers: {
        Authorization: 'Bearer ' + WHOZ_API_TOKEN
      },
    };
    return options;
  }

  static getPUTOptions(payload) {
    var options = {
      'method': 'put',
      'Accept-Version': 'V4',
      'contentType': 'application/json',
      'payload': payload,
      headers: {
        Authorization: 'Bearer ' + WHOZ_API_TOKEN
      },
    };
    return options;
  }

  static getDELETEOptions() {
    var options = {
      'method': 'delete',
      'Accept-Version': 'V4',
      'contentType': 'application/json',
      headers: {
        Authorization: 'Bearer ' + WHOZ_API_TOKEN
      },
    };
    return options;
  }

  static getGETOptions() {
    var options = {
      //'muteHttpExceptions': true,
      'method': 'get',
      'Accept-Version': 'V4',
      'contentType': 'application/json',
      headers: {
        Authorization: 'Bearer ' + WHOZ_API_TOKEN
      },
    };
    return options;
  }
}

/**
 * ###########################################################################
 * # ----------------------------------------------------------------------- #
 * # ------------------- PRIVATE ROUTINES  --------------------------------- #
 * # ----------------------------------------------------------------------- #
 * ###########################################################################
 */

function test() {
  Whoz.cu_stackday_and_publicholidays();
}

/**
 * ####################################
 * # - ROUTINES TO GET WHOZ OBJECTS - #
 * ####################################
 */
class WhozGet {

  // WHOZ TOKEN ----------
  static token() {
    var url = 'https://www.whoz.com/auth/realms/whoz/protocol/openid-connect/token';

    var options = {
      'method': 'post',
      'payload': "grant_type=client_credentials&client_id=" + WHOZ_CLIENT_ID + "&client_secret=" + WHOZ_CLIENT_SECRET

    };
    var response = UrlFetchApp.fetch(url, options);
    var data = JSON.parse(response);
    return data.access_token;
  }

  // WHOZ ACCOUNTS ----------
  static accounts() {
    var url = WHOZ_URL_API_ACCOUNT + '?workspaceId=' + WHOZ_STACK_LABS_CANADA_WORKSPACE_ID;

    var response = UrlFetchApp.fetch(url, WhozOptions.getGETOptions());
    if (response == "") {
      console.log("empty response from Account API");
      return;
    }
    var data = JSON.parse(response);
    var results = [];
    data.forEach(function (account) {
      if (!account.removed) {
        results.push(account)
      }
    });
    console.log("Accounts length : " + results.length);
    return results;
  }

  // WHOZ PROJECTS ----------
  static projects() {
    var url = WHOZ_URL_API_PROJECT + '?workspaceId=' + WHOZ_STACK_LABS_CANADA_WORKSPACE_ID;

    var response = UrlFetchApp.fetch(url, WhozOptions.getGETOptions());
    if (response == "") {
      console.log("empty response from Project API");
      return;
    }
    var data = JSON.parse(response);
    var results = [];
    data.forEach(function (project) {
      if (!project.removed) {
        results.push(project)
      }
    });
    console.log("Projects length : " + results.length);
    return results;
  }

  // WHOZ DOSSIERS ----------
  static dossiers() {
    var url = WHOZ_URL_API_DOSSIER + '?workspaceId=' + WHOZ_STACK_LABS_CANADA_WORKSPACE_ID;

    var response = UrlFetchApp.fetch(url, WhozOptions.getGETOptions());
    if (response == "") {
      console.log("empty response from Dossier API");
      return;
    }
    var data = JSON.parse(response);
    var results = [];
    data.forEach(function (dossier) {
      if (!dossier.removed) {
        results.push(dossier)
      }
    });
    console.log("Dossiers length : " + results.length);
    return results;
  }

  // WHOZ MEMBERS ----------
  static members() {
    var url = WHOZ_URL_API_MEMBER + '?workspaceId=' + WHOZ_STACK_LABS_CANADA_WORKSPACE_ID;

    var response = UrlFetchApp.fetch(url, WhozOptions.getGETOptions());
    if (response == "") {
      console.log("empty response from Members API.");
      return;
    }
    var data = JSON.parse(response);
    var results = [];
    data.forEach(function (member) {
      if (!member.removed && !WHOZ_MEMBERS_TO_EXCLUDE.includes(member.id)) {
        // console.log(member.person.lastName + ' - ' +member.id);
        results.push(member)
      }
    });
    console.log("Members length : " + results.length);
    return results;
  }

  // WHOZ SOMEONE TIMESHEET ----------
  static someoneTimesheets(month, personId) {

    _ensureInitialisation();

    var url = WHOZ_URL_API_TIMESHEET + '?workspaceId=' + WHOZ_STACK_LABS_CANADA_WORKSPACE_ID
      + '&personId=' + personId
      + '&month=' + month;

    var response = UrlFetchApp.fetch(url, WhozOptions.getGETOptions());
    return JSON.parse(response);
  }

  // WHOZ SOMEONE TIMESHEET ID ----------
  static someoneTimesheetsId(month, personId) {

    _ensureInitialisation();

    var data = WhozGet.someoneTimesheets(month, personId)
    return data[0].id;
  }

  // List of Tasks into workspace 
  // API : https://www.whoz.com/api-docs/whoz-api-V4.html#operation/taskList
  static tasks() {
    _ensureInitialisation();
    var url = WHOZ_URL_API_TASK + '?workspaceId=' + WHOZ_STACK_LABS_CANADA_WORKSPACE_ID;

    var response = UrlFetchApp.fetch(url, WhozOptions.getGETOptions());
    var data = JSON.parse(response);
    /*data.forEach(function (task) {
      console.log("Task is : " + task.name + "  id : " + task.id + " Dossier id : " + task.dossierId);
    });*/
    return data;
  }

  // Get personId by Email
  static personIdByEmail(email) {
    var personId = '';
    WHOZ_MEMBERS.forEach(function (member) {
      if (member.person && member.person.emails && member.person.emails[0].address == email) {
        personId = member.personId
        return;
      }
    });
    return personId;
  }

  // Get Member by Email
  static memberIdByEmail(email) {
    var memberId = '';
    WHOZ_MEMBERS.forEach(function (member) {
      if (member.person && member.person.emails && member.person.emails[0].address == email) {
        memberId = member.id
        return;
      }
    });
    return memberId;
  }

}

/**
 * #######################################
 * # - ROUTINES TO DELETE WHOZ OBJECTS - #
 * #######################################
 */
class WhozDelete {
  static existing_account() {
    _ensureInitialisation();
    WHOZ_ACCOUNTS.forEach(function (account) {
      // DANGER : Don't have to use it for the moment
      // UrlFetchApp.fetch(WHOZ_URL_API_ACCOUNT + '/' + account.id, WhozOptions.getDELETEOptions());
    });
    return false;
  }

  static existing_dossiers() {
    _ensureInitialisation();
    WHOZ_DOSSIERS.forEach(function (dossier) {
      if (dossier.accountId != '611c6eacc7d9ab49edb818c8') { // ID - INTERNAL -- DONT DELETE IT
        console.log("name : " + dossier.name + " -- accountid : " + dossier.accountId);
        // DANGER : Don't have to use it for the moment
        UrlFetchApp.fetch(WHOZ_URL_API_DOSSIER + '/' + dossier.id, WhozOptions.getDELETEOptions());
      }

    });
    return false;
  }

}
/**
 * #################################################
 * # - ROUTINES TO CHECK IF OBJECT EXISTS IN WHOZ -#
 * #################################################
 */
class WhozExists {
  //
  // the project id if the account with @name exists
  // empty otherwise
  //
  static project(accountName) {
    var value = '';
    WHOZ_PROJECTS.forEach(function (project) {
      if (project.name.toUpperCase() == "PROJECTS WITH " + accountName.toUpperCase()) {
        value = project.id;
        return;
      }
    });
    return value;
  }

  //
  // the account id if the account with @name exists
  // empty otherwise
  //
  static account(name) {
    var value = '';
    WHOZ_ACCOUNTS.forEach(function (account) {
      if (account.name.toUpperCase() == name.toUpperCase()) {
        value = account.id;
        return;
      }
    });
    return value;
  }

  static dossier(accountId, projectId, name) {
    var value = '';
    WHOZ_DOSSIERS.forEach(function (dossier) {
      if (dossier.accountId == accountId && dossier.projectId == projectId && dossier.name == name) {
        value = dossier.id;
        return;
      }
    });
    return value;
  }

  // Check if the member with this email already exists∆
  static member(email) {
    var exist = false;
    WHOZ_MEMBERS.forEach(function (member) {
      if (member.person && member.person.emails && member.person.emails[0].address == email) {
        console.log("personid: " + member.personId + " id: " + member.id + " member = " + email);
        exist = true
        return;
      }
    });
    return exist;
  }
  //
  // the project id if the project with @accountExternalId exists
  // empty otherwise
  //
  static projectByAccountExternalId(accountExternalId) {
    var value = '';
    WHOZ_PROJECTS.forEach(function (project) {
      if (project.externalId == 'projects_with_' + accountExternalId) {
        value = project.id;
        return;
      }
    });
    return value;
  }

  /**
   * Get the task id if it exists for the pattern "taskName - email"
   * for this giving email
   */
  static taskGenericByNameExist(taskName) {
    var exists = '';
    WhozGet.tasks().forEach(function (task) {
      if (task.name == taskName) {
        exists = task.id;
        return
      }
    });
    return exists;
  }
}

/**
 * #######################################
 * # - ROUTINES TO CREATE WHOZ OBJECTS - #
 * #######################################
 */
class WhozCreate {

  static genericTaskForEveryStacker(taskName, email, dossierId, memberId) {

    _ensureInitialisation();

    var url = WHOZ_URL_API_TASK + '?workspaceId=' + WHOZ_STACK_LABS_CANADA_WORKSPACE_ID;
    var nameToCreate = taskName + ' for ' + email;
    var taskId = WhozExists.taskGenericByNameExist(nameToCreate, email);
    if (taskId) {
      //TODO - Update
      console.log("Update Generic Task " + nameToCreate + " with id " + taskId + " for stacker " + email)
    } else {
      console.log("Create Generic Task " + nameToCreate + " ==> stacker " + email)
      var jsonDataTaskToCreate = {
        "remoteable": true,
        "name": nameToCreate,
        "billable": false,
        "dossierId": dossierId,
        "startDate": "2021-01-01",
        "ownerId": WHOZ_OWNER_ID,
        "workspaceId": WHOZ_STACK_LABS_CANADA_WORKSPACE_ID,
      }
      // - Create Task Here
      UrlFetchApp.fetch(url, WhozOptions.getPOSTOptions(JSON.stringify(jsonDataTaskToCreate)));
      taskId = WhozExists.taskGenericByNameExist(nameToCreate, email);
    }

    WhozRegister.addMemberOnATask(taskId, memberId)
    WhozRegister.startTask(taskId, memberId);

    return taskId;
  }
}

/**
 * #########################################
 * # - ROUTINES TO REGISTER WHOZ OBJECTS - #
 * #########################################
 */
class WhozRegister {
  static addMemberOnATask(taskId, memberId) {
    _ensureInitialisation();
    var url = WHOZ_URL_API_TASK + '/' + taskId + '/set-candidate?workspaceId=' + WHOZ_STACK_LABS_CANADA_WORKSPACE_ID;
    var jsonData = {
      "memberId": memberId,
      "selectionType": "SELECTED"
    };
    var response = UrlFetchApp.fetch(url, WhozOptions.getPOSTOptions(JSON.stringify(jsonData)));
    var data = JSON.parse(response);
    return data;
  }

  static readTask(taskId) {
    _ensureInitialisation();
    var url = WHOZ_URL_API_TASK + '/' + taskId + '?workspaceId=' + WHOZ_STACK_LABS_CANADA_WORKSPACE_ID;

    var response = UrlFetchApp.fetch(url, WhozOptions.getGETOptions());
    return JSON.parse(response);
  }

  static readTaskStatus(taskId) {
    _ensureInitialisation();

    var data = WhozRegister.readTask(taskId);
    return data.status;
  }

  static startTask(taskId, memberId) {
    var data = '';
    _ensureInitialisation();
    if (WhozRegister.readTaskStatus(taskId) == 'REQUEST') {
      var url = WHOZ_URL_API_TASK + '/' + taskId + '/start?workspaceId=' + WHOZ_STACK_LABS_CANADA_WORKSPACE_ID;
      var jsonData = {
        "assigneeId": memberId,
      };
      var response = UrlFetchApp.fetch(url, WhozOptions.getPOSTOptions(JSON.stringify(jsonData)));
      data = JSON.parse(response);
    }

    return data;
  }

  static datesInWorklogs(datesArray, personId, taskId, workload) {
    datesArray.forEach(function (dateString) {
      var yyyyMM = Utilities.formatDate(new Date(dateString), "GMT+1", "yyyy-MM");
      var currentTimesheetId = WhozGet.someoneTimesheetsId(yyyyMM, personId);
      WhozRegister.worklogs(currentTimesheetId, dateString, personId, taskId, 'TASK', workload);
    });
  }


  /**
 * Register a worklogs into a timesheet
 * API: https://www.whoz.com/api-docs/whoz-api-V4.html#operation/timesheetRegisterWorklogs
 */
  static worklogs(timesheetId, date, personId, taskId, typeTask, workload) {
    _ensureInitialisation();
    var url = WHOZ_URL_API_TIMESHEET + '/' + timesheetId + '/worklogs?workspaceId=' + WHOZ_STACK_LABS_CANADA_WORKSPACE_ID;

    var jsonData = [{
      "date": date,
      "personId": personId,
      "taskId": taskId,
      "type": typeTask,
      "workload": workload
    }];
    var response = UrlFetchApp.fetch(url, WhozOptions.getPOSTOptions(JSON.stringify(jsonData)));
    var data = JSON.parse(response);
    return data;
  }


}



/**
 * ###########################################################################
 * # ----------------  IMPLEMENTATION -------------------------------------- #
 * # ------  PUBLIC ROUTINES THAT CAN BE USED OUTSIDE OF WHoz.gs  ---------- #
 * # ------------------- INTERACT WITH WHOZ -------------------------------- #
 * # ----------------------------------------------------------------------- #
 * ###########################################################################
 */

function test_cu_all_stackers_conges() {
  Whoz.cu_all_stackers_conges();
}

function test_clear_tasks_if_publicholidays() {
  Whoz.clear_tasks_if_publicholidays();
}

class Whoz {

  static cu_all_stackers_conges() {
    _ensureInitialisation();
    var allConges = CongeDateUtils.allConges();
    var allStackDays = QuebecDaysOff.quebecStackDays();
    allConges.forEach(function (conges) {
      var personId = WhozGet.personIdByEmail(conges.email)
      if (personId) {
        //console.log(personId + " " + conges.email + " " + conges.type);
        conges.dates.forEach(function (entry) {
          var dateString = entry.date;
          var workload = conges.isAccepted ? entry.value : 0;
          console.log("Conges accepted = " + conges.isAccepted + " stacker = " + conges.email + " => " + dateString + ' - ' + workload)
          var yyyyMM = Utilities.formatDate(new Date(dateString), "GMT+1", "yyyy-MM");
          var currentTimesheetId = WhozGet.someoneTimesheetsId(yyyyMM, personId);
          WhozRegister.worklogs(currentTimesheetId, dateString, personId, '', conges.type, workload);

          if (allStackDays.includes(dateString)) {
            // Efface le stack day dans le calendrier
            var memberId = WhozGet.memberIdByEmail(conges.email)
            var taskId = WhozCreate.genericTaskForEveryStacker(STACK_DAY_TASKNAME, conges.email, STACK_DAY_DOSSIER_ID, memberId);
            WhozRegister.worklogs(currentTimesheetId, dateString, personId, taskId, 'TASK', 0);
          }
        });

      }
    });
  }

  static add_stackDay_and_publicholidays() {
    // Ensure Stack Days and Public Holidays OK 
    Whoz.cu_stackday_and_publicholidays();
    Whoz.clear_tasks_if_publicholidays()
  }

  ///
  // Create or Update STACK DAY and PUBLIC HOLIDAYs FOR EVERY MEMBER
  //
  static cu_stackday_and_publicholidays() {
    _ensureInitialisation();
    var taskId;
    WHOZ_MEMBERS.forEach(function (member) {
      if (member.person && member.person.emails) {
        var email = member.person.emails[0].address
        console.log("cu_stackday_and_publicholidays  ==> stacker " + email + "Id : " + member.id)
        // UPDATE STACK DAY IN TIMESHEET 
        taskId = WhozCreate.genericTaskForEveryStacker(STACK_DAY_TASKNAME, email, STACK_DAY_DOSSIER_ID, member.id);
        WhozRegister.datesInWorklogs(QuebecDaysOff.quebecStackDays(), member.personId, taskId, 0.5);

        // UPDATE PUBLIC HOLIDAYS IN TIMESHEET
        taskId = WhozCreate.genericTaskForEveryStacker(JOURS_FERIES_PUBLIC_HOLIDAYS_OFF_TASKNAME, email, JOURS_FERIES_PUBLIC_HOLIDAYS_DOSSIER_ID, member.id);
        WhozRegister.datesInWorklogs(QuebecDaysOff.quebecHolidays_dates(), member.personId, taskId, 1);
      }
    });
  }


  static clear_tasks_if_publicholidays() {
    //Get all Stacks that are not public holidays
    var taskIdsToClear = [];
    WhozGet.tasks().forEach(function (task) {
      if (!task.name.includes("JOURS FERIES")) {
        if (task.candidates[0]) {
          taskIdsToClear.push({
            'id': task.id,
            'memberId': task.candidates[0].memberId,
            'name': task.name,
            'status': task.status,
          });
        }

      }
    });

    // Iterate over each member , and for every public holiday, clear all the taskid
    WHOZ_MEMBERS.forEach(function (member) {
      if (member.person && member.person.emails) {
        var personId = member.personId
        console.log(personId)
        QuebecDaysOff.quebecHolidays_dates().forEach(function (dateString) {
          var yyyyMM = Utilities.formatDate(new Date(dateString), "GMT+1", "yyyy-MM");
          var currentTimesheetId = WhozGet.someoneTimesheetsId(yyyyMM, personId);
          taskIdsToClear.forEach(function (value) {
            if (value.memberId == member.id && value.status == "IN_PROGRESS") {
              console.log("clear " + dateString + " for " + personId + " on task " + value.name);
              WhozRegister.worklogs(currentTimesheetId, dateString, personId, value.id, 'TASK', 0);
            }
          })
        })

      }
    });



  }

  ///
  // 
  // Create  a member if doesn't exist and populate public holidays in his timesheet
  //
  // POST - Create a member :  https://www.whoz.com/api-docs/whoz-api-V4.html#operation/memberCreate
  // MEMO: personid: 6121e5afc7dbb06e519d67ea id: 6121e5afc7dbb06e519d67eb member = workwith@stack-labs.com
  //
  static c_member(isSuspended, lastName, firstName, email) {
    if (!MEMBERS_EMAIL_TO_EXCLUDE.includes(email)) {

      // Initialisation
      _ensureInitialisation();

      if (!isSuspended) { // ensure to avoid adding gmai user who has been suspended
        if (WhozExists.member(email)) {
          Logger.log("Member already exists - email : " + email);
        } else {
          Logger.log("Attemp to create member - email : " + email);

          var jsonData = {
            "scope": "EMPLOYEE",
            "recruitmentStage": "VALIDATED",
            "managerId": "61169c99da886a601732f884", // Boris-Wilfried Member ID,
            "role": "COLLABORATOR",
            "staffable": true,
            "workspaceId": WHOZ_STACK_LABS_CANADA_WORKSPACE_ID,
            "person": {
              "emails": [
                {
                  "address": email,
                  "main": true,
                  "validated": true
                }
              ],
              "firstName": firstName,
              "lastName": lastName,
              "mainWorkspaceId": WHOZ_STACK_LABS_CANADA_WORKSPACE_ID
            },
          };

          var options = WhozOptions.getPOSTOptions(JSON.stringify(jsonData));
          UrlFetchApp.fetch(WHOZ_URL_API_MEMBER, options);
        }

      }
    } else {
      Logger.log('Avoid to sync to Whoz : ' + email);
    }
  }

  //
  // 
  // Create or Update an account
  //
  // POST - Create an account :  https://www.whoz.com/api-docs/whoz-api-V4.html#operation/accountCreate
  // PUT - Update an account : https://www.whoz.com/api-docs/whoz-api-V4.html#operation/accountUpdate
  //
  // our externalId will be the hubspot id
  //
  static cu_account(name, website, externalId, description, city, countryCode, industry) {

    // Initialisation
    _ensureInitialisation();

    var jsonData = {
      "address": {
        "city": city,
        "countryCode": countryCode,
      },
      "description": description.toString(),
      "externalId": externalId,
      "name": name,
      "ownerId": WHOZ_OWNER_ID,
      "tags": [
        "hubspot",
        industry,
      ],
      "type": "CUSTOMER",
      "website": website,
      "workspaceId": WHOZ_STACK_LABS_CANADA_WORKSPACE_ID,
    };

    var options;
    // Check if the account exists
    var accountId = WhozExists.account(name);
    if (accountId != '') {
      //console.log("Account : " + name + ":" + accountId + " already exists , will try to update it");
      options = WhozOptions.getPUTOptions(JSON.stringify(jsonData));
      UrlFetchApp.fetch(WHOZ_URL_API_ACCOUNT + '/' + accountId, options);
    } else {
      options = WhozOptions.getPOSTOptions(JSON.stringify(jsonData));
      UrlFetchApp.fetch(WHOZ_URL_API_ACCOUNT, options);
    }

    // Create or Update Project
    var accountName = name
    var accountExternalId = externalId
    var accountIndustry = industry
    Whoz.cu_project(accountName, accountId, accountExternalId, accountIndustry)
  }

  /**
   * CREATE OR UPDATE PROJECT
   */
  static cu_project(accountName, accountId, accountExternalId, accountIndustry) {

    if (accountName.includes("TECHNOLOGIES STACK LABS CANADA".toLowerCase())) {
      return;
    }

    var jsonData = {
      "ownerId": WHOZ_OWNER_ID,
      "accountId": accountId,
      "externalId": "projects_with_" + accountExternalId,
      "name": "PROJECTS WITH " + accountName.toUpperCase(),
      "status": "ONGOING",
      "category": accountIndustry,
      "goodToKnow": " All the projects that we are doing with " + accountName.toUpperCase(),
      "workspaceId": WHOZ_STACK_LABS_CANADA_WORKSPACE_ID,
    };
    var options
    // Check if the account exists
    var projectId = WhozExists.projectByAccountExternalId(accountExternalId);

    if (projectId != '') {
      //console.log("update project pour " + accountName + ':' + projectId)
      options = WhozOptions.getPUTOptions(JSON.stringify(jsonData));
      UrlFetchApp.fetch(WHOZ_URL_API_PROJECT + '/' + projectId, options);
    } else {
      options = WhozOptions.getPOSTOptions(JSON.stringify(jsonData));
      UrlFetchApp.fetch(WHOZ_URL_API_PROJECT, options);
    }
  }

  //
  // 
  // Create or Update a dossier
  //
  // POST - Create a dossier :  https://www.whoz.com/api-docs/whoz-api-V4.html#operation/dossierCreate
  // PUT - Update a dossier : https://www.whoz.com/api-docs/whoz-api-V4.html#operation/dossierUpdate
  //
  // our externalId will be the hubspot id
  //
  static cu_dossier(dealId, companyName, rang1CompanyName, amount, dealCurrencyCode, billingType, name, tags) {

    // Initialisation
    _ensureInitialisation();

    var accountId = WhozExists.account(companyName);
    var projectId;
    if (rang1CompanyName) {
      projectId = WhozExists.project(rang1CompanyName);
    } else {
      projectId = WhozExists.project(companyName);
    }

    var jsonData = {
      "accountId": accountId,
      "amount": {
        "value": amount,
        "currencyCode": dealCurrencyCode
      },
      "billingType": billingType,
      "externalId": dealId.toString(),
      "name": name,
      "ownerId": WHOZ_OWNER_ID,
      "projectId": projectId,
      "stage": "CLOSED_WON",
      "tags": tags,
      "workspaceId": WHOZ_STACK_LABS_CANADA_WORKSPACE_ID,
    };

    var options
    // Check if the account exists
    var dossierId = WhozExists.dossier(accountId, projectId, name); //TODO: It is not the best way to check if dossierExists. If someone update the name , it is a bug. The external id is not working
    if (dossierId != '') {
      //console.log("update project pour " + accountName + ':' + projectId)
      options = WhozOptions.getPUTOptions(JSON.stringify(jsonData));
      UrlFetchApp.fetch(WHOZ_URL_API_DOSSIER + '/' + dossierId, options);
    } else {
      //console.log('create')
      options = WhozOptions.getPOSTOptions(JSON.stringify(jsonData));
      UrlFetchApp.fetch(WHOZ_URL_API_DOSSIER, options);
    }
  }


}
