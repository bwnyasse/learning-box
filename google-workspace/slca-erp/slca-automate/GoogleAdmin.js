/**
 * #####################################################################
 * # ----------------  IMPLEMENTATION -------------------------------- #
 * #####################################################################
 */
 var sheetNameStackersCanada = "STACKERS_CANADA";
 var sheetNameStackersOthers = "STACKERS_OTHERS";
 
 class GoogleAdmin {
 
   /**
    * Lists all the users in a domain sorted by first name.
    */
   static getStackers() {
     var stackersCanada = Array();
     var stackersOthers = Array();
 
     var pageToken;
     var page;
     do {
       page = AdminDirectory.Users.list({
         domain: 'stack-labs.com',
         orderBy: 'email',
         maxResults: 150,
         pageToken: pageToken
       });
       var users = page.users;
       if (users) {
         for (var i = 0; i < users.length; i++) {
           var user = users[i];
           if (user.orgUnitPath == '/Canada') {
             stackersCanada.push([user.name.fullName, user.primaryEmail, user.suspended, user.name.givenName, user.name.familyName,]);
             if (!user.suspended) {
               Whoz.c_member(user.suspended, user.name.familyName, user.name.givenName, user.primaryEmail)
             }
 
           } else {
             if (!user.suspended) {
               stackersOthers.push([user.name.fullName, user.primaryEmail, user.suspended]);
             }
           }
         }
       } else {
         Logger.log('No users found.');
       }
       pageToken = page.nextPageToken;
     } while (pageToken);
 
 
     AutomateUtils.writeData(stackersCanada, sheetNameStackersCanada);
     AutomateUtils.writeData(stackersOthers, sheetNameStackersOthers);
 
     // Ensure a whoz User for tests purpose
     Whoz.c_member(false, 'FakeStacker', 'Canadien', 'workwith@stack-labs.com');
   }
 
 }
 
 /**
 * ###########################################################################
 * # -------------------------------- TEST -------------------------------- #
 * ###########################################################################
 */
 
 function test_getStackers() {
   GoogleAdmin.getStackers();
 }
 