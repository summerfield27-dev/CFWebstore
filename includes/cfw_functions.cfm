
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to call global functions used for CFWebstore pages. Include into your layout files --->

<!--- Function for formatting strings to safe filenames --->

<cfinclude template="UDFs.cfm">

<cfscript> 

function checkSQLInject() {
	/**
	 * Creates the RegEx to test a string for possible SQL injection.
	 * 
	 * @return Returns string. 
	 * @author Luis Melo (luism@grouptraveltech.com)
	 * @original author Gabriel Read
	 * @version 1, July 25, 2008
	 * @version 2, July 28, 2008
	 * @version 3, August 20, 2008
	 */ 
	// list of db objects/functions to protect 
	var insSql = 'insert|delete|select|update|create|alter|drop|truncate|grant|revoke|declare|' &
				 'exec|backup|restore|sp_|xp_|set|execute|dbcc|deny|union|Cast|Char|Varchar|nChar|nVarchar';
 
	 // Build the regex 
	 var regEx = '((or)+[[:space:]]*\(*''?[[:print:]]+''?' &
		  		 '([[:space:]]*[\+\-\/\*][[:space:]]*''?' &
		  		 '[[:print:]]+''?)*\)*[[:space:]]*' &
		  		 '(([=><!]{1,2}|(like))[[:space:]]*\(*''?' &
		  		 '[[:print:]]+''?([[:space:]]*[\+\-\/\*]' &
		 		 '[[:space:]]*''?[[:print:]]+''?)*\)*)|((in)' &
		 		 '[[:space:]]*\(+[[:space:]]*''?[[:print:]]+''?' &
		 		 '(\,[[:space:]]*''?[[:print:]]+''?)*\)+)|' &
		 		 '((between)[[:space:]]*\(*[[:space:]]*''?' &
		 		 '[[:print:]]+''?(\,[[:space:]]*''?[[:print:]]+''?)' &
		 		 '*\)*(and)[[:space:]]+\(*[[:space:]]*''?[[:print:]]+''?' &
		 		 '(\,[[:space:]]*''?[[:print:]]+''?)*\)*)|((;)([^a-z>]*)' &
		 		 '(#insSql#)([^a-z]+|$))|(union[^a-z]+(all|select))|(\/\*)|(--$))';
		  
	return regEx;
}

/** the completed regEx if needed for testing
  ((or)+[[:space:]]*\(*''?[[:print:]]+''?([[:space:]]*[\+\-\/\*][[:space:]]*''?[[:print:]]+''?)*\)*[[:space:]]*(([=><!]{1,2}|(like))[[:space:]]*\(*''?[[:print:]]+''?([[:space:]]*[\+\-\/\*][[:space:]]*''?[[:print:]]+''?)*\)*)|((in)[[:space:]]*\(+[[:space:]]*''?[[:print:]]+''?(\,[[:space:]]*''?[[:print:]]+''?)*\)+)|((between)[[:space:]]*\(*[[:space:]]*''?[[:print:]]+''?(\,[[:space:]]*''?[[:print:]]+''?)*\)*(and)[[:space:]]+\(*[[:space:]]*''?[[:print:]]+''?(\,[[:space:]]*''?[[:print:]]+''?)*\)*)|((;)([^a-z>]*)(insert|delete|select|update|create|alter|drop|truncate|grant|revoke|declare|exec|backup|restore|sp_|xp_|set|execute|dbcc|deny|union|Cast|Char|Varchar|nChar|nVarchar)([^a-z]+|$))|(union[^a-z]+(all|select))|(\/\*)|(--$))
*/


function loadPattern(strRegex) {
/**
 * Build the java pattern matcher
 * 
 * @return Returns object. 
 * @author Gabriel Read from CF-Talk (gabe@evolution7.com)
 * @version 1, July 28, 2008
 * @version 2, August 15, 2008
 */ 
	// Build the java pattern matcher 
	
	var reMatcher = '';
	
	var rePattern = createObject('java', 'java.util.regex.Pattern'); 
	rePattern = rePattern.compile(strRegex,rePattern.CASE_INSENSITIVE); 	
	return rePattern;
}


 
/**
 * This function checks the URL, cookie, and selected CGI variables for XSS and SQL Injection
 * The scope determines if this is for public users, if so include the form variables
 * 
 * @return Returns boolean. 
 * @author Mary Jo Sminkey
 * @version 1, July 25, 2008
 * @version 2, July 28, 2008
 * @version 3, August 15, 2008
 * @version 4, August 20, 2008
 * @version 5, July 5, 2009
 * @version 6, September 25, 2009
 * @version 7, November 25, 2013
 */ 
function checkforAttack (scope) {
	
	var hackattempt = 'no';
	var testvar = '';
	var SQLMatcher = '';
	var XSSMatcher = '';
	var strRegex = '';
	var CGIvars = 'script_name,remote_addr,path_info,http_referer,http_user_agent,server_name';
	var Tokens = 'CFID,CFTOKEN';
	var i = 1;
	
	//Make sure the regex matcher objects are available in Application Scope
	if (NOT StructKeyExists(Application, 'SQLChecker')) {
		strBlacklist = checkSQLInject();
		Application.SQLChecker = loadPattern(strBlacklist);
	}
	
	if (NOT StructKeyExists(Application, 'XSSChecker')) {
		strXSS = "((\%3C)|<)((\%2F)|\/)*[a-zA-Z0-9\%]+";
		Application.XSSChecker = loadPattern(strXSS);
	}
	
	//load matchers
	SQLMatcher = Application.SQLChecker.matcher('');
	XSSMatcher = Application.XSSChecker.matcher('');
	
	//Check URL scope for SQL Injection and XSS attacks
	for (testvar in URL) {
		if (SQLMatcher.reset(URL[testvar]).find()) {
			hackattempt="yes";
			}
		else if (XSSMatcher.reset(URL[testvar]).find()) {
			hackattempt="yes";
			}
		else if (ListFindNoCase(Tokens,testvar) AND sanitize(URL[testvar]) NEQ URL[testvar]) {
			hackattempt="yes";
			}
	}
	
	//Check cookie scope
	for (testvar in COOKIE) {
		if (StructKeyExists(COOKIE,testvar) AND len(COOKIE[testvar])) {
			if (SQLMatcher.reset(COOKIE[testvar]).find()) {
				hackattempt="yes";
			}
			else if (XSSMatcher.reset(COOKIE[testvar]).find()) {
				hackattempt="yes";
				}
			else if (ListFindNoCase(Tokens,testvar) AND sanitize(COOKIE[testvar]) NEQ COOKIE[testvar]) {
				hackattempt="yes";
				}
		}
	}
	
	//Check CGI scope 
	for (i=1; i LTE ListLen(CGIvars); i=i+1) {
		testvar = ListGetAt(CGIvars, i);
		if (StructKeyExists(CGI, testvar) AND SQLMatcher.reset(CGI[testvar]).find()) {
			hackattempt="yes";
		}
		else if (StructKeyExists(CGI, testvar) AND XSSMatcher.reset(CGI[testvar]).find()) {
			hackattempt="yes";
			}
	}
	
	//additional XSS check on query string
	if (XSSMatcher.reset(CGI.query_string).find()) { 
		hackattempt="yes";
	}
	
	//check form scope, handle arrays on CF 10 servers
	if (scope IS "public") {
		for (testvar in FORM) {
			if ((isSimpleValue(FORM[testvar])) AND (testvar IS NOT "fieldnames")) {
				if (SQLMatcher.reset(FORM[testvar]).find()) {
					hackattempt="yes";
				}
				else if (XSSMatcher.reset(FORM[testvar]).find()) {
					hackattempt="yes";
				}
			} else if (isArray(FORM[testvar])) {
				arrTest = FORM[testvar];
				//writeDump(FORM[testvar]);
				for (arrItem in arrTest) {
					//writeoutput(arrItem & "<br/>");
					if (isSimpleValue(arrItem)) {
						if (SQLMatcher.reset(arrItem).find()) {
							hackattempt="yes";
						}
						else if (XSSMatcher.reset(arrItem).find()) {
							hackattempt="yes";
						}
					}
				}
			}
		}
	}
	

	return hackattempt;
}
 

/**
 * This function checks the Form scope only for XSS and SQL injection
 * This is used only for public users
 * 
 * @return Returns boolean. 
 * @author Mary Jo Sminkey
 * @version 1, July 25, 2008
 * @version 2, July 28, 2008
 * @version 3, August 15, 2008
 * @version 4, August 20, 2008
 * @version 5, July 5, 2009
 */ 
function checkforFormAttack() {
	
	var hackattempt = 'no';
	var testvar = '';
	var SQLMatcher = '';
	var XSSMatcher = '';
	var strRegex = '';
	var i = 1;
	
	//Make sure the regex matcher objects are available in Application Scope
	if (NOT StructKeyExists(Application, 'SQLChecker')) {
		strBlacklist = checkSQLInject();
		Application.SQLChecker = loadPattern(strBlacklist);
	}
	
	if (NOT StructKeyExists(Application, 'XSSChecker')) {
		strXSS = "((\%3C)|<)((\%2F)|\/)*[a-z0-9\%]+";
		Application.XSSChecker = loadPattern(strXSS);
	}	
	
	//load matchers
	SQLMatcher = Application.SQLChecker.matcher('');
	XSSMatcher = Application.XSSChecker.matcher('');	

	return hackattempt;
}

// this function determines the type of browser being used, to detect search engine crawlers
function getBrowserType(user_agent){ 
	
	var BrowserType = StructNew();
	
	BrowserType.browserName="Unknown"; 
	BrowserType.browserVersion="0"; 
	
	if (Len(user_agent)) { 

		if (FindNoCase("spider", user_agent)
		or FindNoCase("crawl", user_agent)
		or ReFindNoCase("bot\b", user_agent)
		or ReFindNoCase("\brss", user_agent)
		or FindNoCase("seek", user_agent)
		or FindNoCase("feed", user_agent)
		or FindNoCase("news", user_agent)
		or FindNoCase("blog", user_agent)
		or FindNoCase("reader", user_agent)
		or FindNoCase("syndication", user_agent)
		or FindNoCase("zyborg", user_agent)
		or FindNoCase("emonitor", user_agent)
		or FindNoCase("jeeves", user_agent)
		or FindNoCase("gulliver", user_agent)
		or FindNoCase("vista", user_agent)
		or FindNoCase("yahoo", user_agent)
		or FindNoCase("widow", user_agent)
		or FindNoCase("wiki", user_agent)
		or FindNoCase("slurp", user_agent)
		or FindNoCase("netattache", user_agent)
		or FindNoCase("crescent", user_agent)
		or FindNoCase("check", user_agent)
		or FindNoCase("heritrix", user_agent)
		or FindNoCase("locator", user_agent)
		or FindNoCase("scooter", user_agent)
		or FindNoCase("archive", user_agent)
		or FindNoCase("Crescent", user_agent)
		or FindNoCase("Yandex", user_agent)
		or FindNoCase("webtrends", user_agent)) {
		 BrowserType.browserName="spider"; 
		}
		
	  else if (FindNoCase("LWP::Simple", user_agent)  	
		or FindNoCase("libwww-perl", user_agent)) {
	  	BrowserType.browserName="hack attempt"; 
		}
		
	  else if (Find("MSIE",user_agent)) {
	    BrowserType.browserName="MSIE"; 
		BrowserType.browserVersion=Val(RemoveChars(user_agent,1,Find("MSIE",user_agent)+4)); 
	  } 
	  
	  else if (Find("Firefox",user_agent)) {
	    BrowserType.browserName="Firefox"; 
		BrowserType.browserVersion=Val(RemoveChars(user_agent,1,Find("Firefox/",user_agent)));
	  } 
	  
	  else if (Find("Mozilla",user_agent)) {
	
	      if (not Find("compatible",user_agent)) {
	        BrowserType.browserName="Netscape"; 
			BrowserType.browserVersion=Val(RemoveChars(user_agent,1,Find("/",user_agent))); 
	      } 
	      else { 
	        BrowserType.browserName="compatible"; 
	      } 
		 }
	   else if (Find("ColdFusion",user_agent)) {
	      BrowserType.browserName="ColdFusion"; 
	    } 
  } 
  
  return BrowserType;
	
}

</cfscript>


