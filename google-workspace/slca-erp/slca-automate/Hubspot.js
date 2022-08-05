/**
 * ###########################################################################
 * # ----------------------------------------------------------------------- #
 * # ------------------------------- CONFIG -------------------------------- #
 * # ----------------------------------------------------------------------- #
 * ###########################################################################
 */

/**
 * Fill in the following variables
 */
 var HUBSPOT_API_KEY = TODO;
 var HUBSPOT_API_URL = "https://api.hubapi.com";
 var HUBSPOT_API_URL_COMPANIES = HUBSPOT_API_URL + '/crm/v3/objects/companies/';
 var HUBSPOT_API_URL_CONTACTS = HUBSPOT_API_URL + '/crm/v3/objects/contacts/';
 
 // Working sheet
 var sheetNameContacts = "CONTACTS";
 var sheetNameCompanies = "COMPANIES";
 var sheetNameDealsWon = "DEALS_WON";
 var sheetNameDealsOpportunities = "DEALS_OPPORTUNITIES";
 var sheetNameCodeProjetsDeals = "CODES_PROJETS_DEALS";
 
 /**
  * ###########################################################################
  * # ----------------------------------------------------------------------- #
  * # ----------------------------- ROUTINES -------------------------------- #
  * # ----------------------------------------------------------------------- #
  * ###########################################################################
  */
 function isOwnedByStackLabsCanada_(field) {
   if (field.properties.hasOwnProperty("hubspot_owner_id")) {
     // Boris-Wilfried Nyasse id is 39996991 
     // Alexandre Lauzière id is 103265606
     if (field.properties.hubspot_owner_id.value == 39996991 || field.properties.hubspot_owner_id.value == 103265606) {
       return true;
     }
     return false;
   }
   return false;
 }
 
 function loadCompany_(companyId) {
 
   var url = HUBSPOT_API_URL_COMPANIES + companyId + '?properties=website&properties=name&hapikey=' + HUBSPOT_API_KEY;
   var response = UrlFetchApp.fetch(url, { 'muteHttpExceptions': true });
   var data = JSON.parse(response);
   if (data.properties) {
     return data;
   }
   else return null;
 }
 
 
 function loadContact_(contactId) {
 
   var url = HUBSPOT_API_URL_CONTACTS + contactId + '?hapikey=' + HUBSPOT_API_KEY;
   var response = UrlFetchApp.fetch(url, { 'muteHttpExceptions': true });
   var data = JSON.parse(response);
   if (data.properties) {
     return data;
   }
   else return null;
 }
 
 /**
  * #####################################################################
  * # ----------------  IMPLEMENTATION -------------------------------- #
  * #####################################################################
  */
 class Hubspot {
 
   static all() {
     Hubspot.getCompanies();
     Hubspot.getContacts();
     Hubspot.getDeals();
   }
 
   /**
    * COMPANIES FROM HUBSPOT
    */
   static getCompanies() {
     var headers = { headers: { 'muteHttpExceptions': true } };
 
     // Prepare pagination
     // Hubspot lets you take max 250 deals per request. 
     // We need to make multiple request until we get all the deals.
     var keep_going = true;
     var offset = 0;
     var companies = Array();
 
     while (keep_going) {
       // All Engagements Endpoint
       var url = HUBSPOT_API_URL + "/companies/v2/companies/paged?limit=250&offset=" + offset + "&hapikey=" + HUBSPOT_API_KEY
         + '&properties=name'
         + '&properties=website'
         + '&properties=city'
         + '&properties=country'
         + '&properties=industry'
         + '&properties=hubspot_owner_id'
         + '&properties=description';
 
       var response = UrlFetchApp.fetch(url, headers);
       var result = JSON.parse(response.getContentText());
 
       // Are there any more results, should we stop the pagination ?
       keep_going = result["has-more"];
       offset = result.offset;
 
       // For each deal, we take the stageId, source & amount
       result.companies.forEach(function (company) {
         if (isOwnedByStackLabsCanada_(company)) {
           var name = (company.properties.hasOwnProperty("name")) ? company.properties.name.value : "";
           var website = (company.properties.hasOwnProperty("website")) ? company.properties.website.value : "";
           var city = (company.properties.hasOwnProperty("city")) ? company.properties.city.value : "";
           var country = (company.properties.hasOwnProperty("country")) ? company.properties.country.value : "";
           var owner = (company.properties.hasOwnProperty("hubspot_owner_id")) ? company.properties.hubspot_owner_id.value : "";
           var industry = (company.properties.hasOwnProperty("industry")) ? company.properties.industry.value : "";
           var description = (company.properties.hasOwnProperty("description")) ? company.properties.description.value : "";
           var countryCode = AutomateUtils.getCountryISOCode(country);
           companies.push([name, website, city, country, owner, company.companyId, countryCode, industry, description,]);
           Whoz.cu_account(name, website, company.companyId, description, city, countryCode, industry);
         }
       });
     }
 
     AutomateUtils.writeData(companies, sheetNameCompanies);
   }
 
   /**
  * CONTACTS FROM HUBSPOT
  */
   static getContacts() {
     var headers = { headers: { 'muteHttpExceptions': true } };
 
     // Prepare pagination
     // Hubspot lets you take max 250 deals per request. 
     // We need to make multiple request until we get all the deals.
     var keep_going = true;
     var offset = 0;
     var contacts = Array();
 
     // All Company ID for the owner
     var ss = SpreadsheetApp.getActiveSpreadsheet();
     var sheet = ss.getSheetByName(sheetNameCompanies);
     var allCompanyIds = sheet.getRange("F3:F").getValues();
     while (keep_going) {
       // We'll take three properties from the deals: the source, the stage & the amount of the deal
       var url = HUBSPOT_API_URL + "/contacts/v1/lists/all/contacts/all?propertyMode=value_and_history&property=hs_lead_status&includeAssociations=true&property=createdate&property=vid&property=hs_content_membership_notes&property=num_contacted_notes&property=num_notes&property=email&property=firstname&property=lastname&property=company&property=lifecyclestage&property=c2c_first_page_seen&property=c2c_referrer&property=associatedcompanyid&property=hubspot_owner_id&property=contact_type&property=hs_lifecyclestage_lead_date&property=hs_lifecyclestage_marketingqualifiedlead_date&property=hs_lifecyclestage_salesqualifiedlead_date&property=hs_lifecyclestage_opportunity_date&property=hs_lifecyclestage_customer_date&property=channel&property=source&property=organic_referral_url&property=utm_campaign&property=utm_medium&property=utm_source&property=country&property=hs_analytics_source&property=hs_analytics_first_url&property=hs_analytics_first_referrer&property=hs_analytics_num_page_views&count=100&vidOffset=" + offset + "&hapikey=" + HUBSPOT_API_KEY;
 
       var response = UrlFetchApp.fetch(url, headers);
       var result = JSON.parse(response.getContentText());
 
       // Are there any more results, should we stop the pagination ?
       keep_going = result["has-more"];
       offset = result["vid-offset"];
 
       // For each deal, we take the stageId, source & amount
       result.contacts.forEach(function (contact) {
         var firstname = (contact.properties.hasOwnProperty("firstname")) ? contact.properties.firstname.value : "";
         var lastname = (contact.properties.hasOwnProperty("lastname")) ? contact.properties.lastname.value : "";
         var email = (contact.properties.hasOwnProperty("email")) ? contact.properties.email.value : "";
         var company = (contact.properties.hasOwnProperty("company")) ? contact.properties.company.value : "";
         contacts.push([firstname + " " + lastname, email, company]);
       });
     }
     AutomateUtils.writeData(contacts, sheetNameContacts);
   }
 
   /**
  * DEALS ON STAGE WON FROM HUBSPOT
  */
   static getDeals() {
 
     var headers = { headers: { 'muteHttpExceptions': true } };
 
     // Prepare pagination
     // Hubspot lets you take max 250 deals per request. 
     // We need to make multiple request until we get all the deals.
     var keep_going = true;
     var after = 0;
     var dealsWon = Array();
     var dealsOpportunities = Array();
     var codeProjectsDeals = Array();
     var suffixAfter = ''
     while (keep_going) {
       // All Engagements Endpoint
       if (after == 0) {
         suffixAfter = ''
       } else {
         suffixAfter = '&after=' + after
       }
       var url = HUBSPOT_API_URL + '/crm/v3/objects/deals?limit=100' + suffixAfter + '&archived=false&hapikey=' + HUBSPOT_API_KEY
         + '&properties=dealname'
         + '&properties=entite'
         + '&properties=dealstage'
         + '&properties=deal_currency'
         + '&properties=amount'
         + '&properties=devis_interne'
         + '&properties=engagement_executive'
         + '&properties=po_number'
         + '&properties=signed_contract_or_po_file_link'
         + '&properties=proposal_url'
         + '&properties=rentabilite_devis'
         + '&properties=closedate'
         + '&properties=hubspot_owner_id'
         + '&properties=type_engagement'
         + '&properties=deal_currency_code'
         + '&properties=description'
         + '&properties=domaines'
         + '&properties=facturation'
         + '&properties=entreprise___rang_1'
         + '&properties=code_projet_deal'
         + '&properties=resell'
         + '&associations=company,contact';
 
 
       var response = UrlFetchApp.fetch(url, headers);
       var result = JSON.parse(response.getContentText());
 
       // Are there any more results, should we stop the pagination ?
       if (result.paging) {
         keep_going = true
         after = result.paging.next.after
       } else {
         keep_going = false
       }
 
       // For each deal, we take the stageId, source & amount
       if (result) {
 
 
         result.results.forEach(function (deal) {
 
           // only deal from SL CANADA
 
           if (deal.properties.entite == 'SL CANADA' && deal.properties.dealstage == 'closedwon') {
             console.log(deal.properties.dealname)
             /// [START] - DEAL WON
             var companyName = (loadCompany_(deal.associations.companies.results[0].id).properties.name).toUpperCase();
             var dossierName = companyName + ' - ' + deal.properties.dealname;
             var formattedCloseDate = Utilities.formatDate(new Date(deal.properties.closedate), "GMT+1", "yyyy/MM/dd");
             //push the deal 
             dealsWon.push([deal.id,
               companyName,
               dossierName,
             deal.properties.po_number,
             deal.properties.amount,
             deal.properties.deal_currency_code,
             deal.properties.domaines,
             deal.properties.facturation,
             deal.properties.entreprise___rang_1,
             loadContact_(deal.associations.contacts.results[0].id).properties.email,
             deal.properties.code_projet_deal,
             deal.properties.resell,
             deal.properties.signed_contract_or_po_file_link,
               formattedCloseDate,]);
 
             //push the code projects 
             if (deal.properties.code_projet_deal) {
               deal.properties.code_projet_deal.split(";").forEach(function (codeprojet) {
                 if (!codeProjectsDeals.includes(codeprojet)) {
                   console.log(codeprojet + ' - ' + dossierName)
                   codeProjectsDeals.push([codeprojet])
                 }
               });
             }
 
 
             // SEND TO WHOZ
             Whoz.cu_dossier(deal.id, companyName, deal.properties.entreprise___rang_1, deal.properties.amount, deal.properties.deal_currency_code, deal.properties.facturation, dossierName, (deal.properties.domaines).split(";"))
 
             /// [END] - DEAL WON
           } else if (deal.properties.entite == 'SL CANADA' && (deal.properties.dealstage == 'qualifiedtobuy' || deal.properties.dealstage == 'presentationscheduled')) {
 
             /// [START] - DEAL OPPORTUNITIES
             var companyName = (loadCompany_(deal.associations.companies.results[0].id).properties.name).toUpperCase();
             var dossierName = companyName + ' - ' + deal.properties.dealname;
             var formattedCloseDate = Utilities.formatDate(new Date(deal.properties.closedate), "GMT+1", "yyyy/MM/dd");
             //push the deal 
             dealsOpportunities.push([deal.id,
               companyName,
               dossierName,
             deal.properties.po_number,
             deal.properties.amount,
             deal.properties.deal_currency_code,
             deal.properties.domaines,
             deal.properties.facturation,
             deal.properties.entreprise___rang_1,
             deal.associations.contacts ? loadContact_(deal.associations.contacts.results[0].id).properties.email : '',
             deal.properties.code_projet_deal,
             deal.properties.resell,
             deal.properties.signed_contract_or_po_file_link,
               formattedCloseDate,]);
             /// [END] - DEAL OPPORTUNITIES
           }
         });
       }
     }
 
     AutomateUtils.writeData(dealsOpportunities, sheetNameDealsOpportunities);
     AutomateUtils.writeData(dealsWon, sheetNameDealsWon);
     AutomateUtils.writeData(codeProjectsDeals, sheetNameCodeProjetsDeals);
 
   }
 }
 
 
 /**
  * #################################################
  * # ----------------  TEST ---------------------- #
  * #################################################
  */
 
 function test_getCompanies() {
   Hubspot.getCompanies();
 }
 
 function test_getContacts() {
   Hubspot.getContacts();
 }
 
 function test_getDeals() {
   Hubspot.getDeals();
 }