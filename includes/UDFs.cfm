
<!--- CFWebstore, version 6.50 --->

<!--- This page is used to call global functions used for CFWebstore pages. Include into your layout files --->

<!--- Function for formatting strings to safe filenames --->

<cfscript> 

// this function replaces illegal characters in product/category/feature/pages names for creating SES links
function SESFile(str,dummyext=request.SESdummyExtension){ 	
	var strip = LCase(Replace(str,' ','-', "ALL"));
	strip= ReReplace(strip,"[^\w\d-]+","","ALL");
	strip = strip & '.' & dummyext;
	return strip;
} 

// this function is used to determine if we are returning to a non-SES or an SES link and adds store paths accordingly
function doReturn(str){ 	
	var returnURL = '';	
	if ( FindNoCase(".admin", str ) OR FindNoCase("users.", str ) OR FindNoCase("shopping.checkout", str) ) {
		returnURL = Request.SecureSelf;
	} else {
		returnURL = Request.StoreSelf;
	}
	if ( FindNoCase("fuseaction=", str ) ) {
		returnURL = returnURL & "?" & str & "&redirect=yes";
	} else if ( Find("?", str ) ) {
		returnURL = returnURL & str & "&redirect=yes";
	} else if ( len( str ) ) {
		returnURL = returnURL & "?" & str & "&redirect=yes";
	}
	else  {
		returnURL = returnURL & "?redirect=yes";
	}
	return returnURL;
} 

// used to sanitize text strings to use in queries
function sanitize(str) {
	//remove HTML tags
	var strip = REReplace(str, "</?[^>]*>", "", "all" );
	//remove any other non-alphanumeric, non-whitespace characters
	strip= ReReplace(strip,"[^\w\d\s-\^]+","","ALL");
	return strip;
}

// this function outputs debug text to the page
function putDebug(strDebug){ 
	var strOutput = '<pre>' & arguments.strDebug & '</pre>';
	writeoutput(strOutput);
}

// this function replaces ambersands in a string with the ascii equivalent
function XHTMLFormat(str){ 	
	var formattedstr = Replace(str, "&", "&amp;", "ALL");
	return formattedstr;
} 

//removes zeros and decimal if they are at the end of a number
function stripZeros(str){ 	
	var returnStr = str;
	if (Right(str,3) IS ".00") {
		returnStr = Left(str,Len(str)-3);
	}
	return returnStr;
}

// used to make the text string that will output the javascript mouseover functions in link
function doMouseover(str){ 	
	var returnstring = '';
	//check for useJS=false
	if ( ArrayLen(arguments) LT 2 OR arguments[2] IS "true" ) {
		//replace any HTML
		str = ReReplaceNoCase(str, "<[^>]*>", " ", "ALL");
		//replace any double-quotes
		str = Replace(str, '"', '', 'ALL');
		str = JSStringFormat(str);
		returnstring = 'onmouseover="dmim(''' & str & '''); return document.returnValue;" ';
		returnstring = returnstring & 'onmouseout="dmim(''''); return document.returnValue;"';
	} 
	return returnstring;
} 

// used to output XHTML-safe selectboxes
function doSelected(fieldToCheck) {
	var returnstring = '';
	var theCheck = 0;
	//if there is a second argument, use that for the value to compare
	if(arrayLen(arguments) GT 1) {
		theCheck = arguments[2];
		if (fieldToCheck IS theCheck) 
			returnstring = 'selected="selected"';
		}
	//if no second argument, we are checking to see if this value is not 0
	else if (fieldToCheck IS NOT theCheck) {
		returnstring = 'selected="selected"';	
		}
		
	return returnstring;	
}

// used to output XHTML-safe checkboxes
function doChecked(fieldToCheck) {
	var returnstring = '';
	var theCheck = 0;
	//if there is a second argument, use that for the value to compare
	if(arrayLen(arguments) GT 1) {
		theCheck = arguments[2];
		if (fieldToCheck IS theCheck) 
			returnstring = 'checked="checked"';
		}
	//if no second argument, we are checking to see if this value is not 0
	else if (fieldToCheck IS NOT theCheck) {
		returnstring = 'checked="checked"';	
		}
	
	return returnstring;	
}


function doAdmin() {
	var returnstring = '';
	//set the default class
	var className = 'menu_admin';
	//check if we passed in the class, use that instead of default
	if (arrayLen(arguments) IS 1) {
		className = arguments[1];
	}
	returnstring = 'class="#className#" ';
	//if admin links open new window, create the link
	if (Request.AppSettings.admin_new_window) {
		returnstring = returnstring & 'target="admin"'; }
	
	return returnstring;
}

// used to convert the database values for the various Priority fields 
function doPriority(valueToCheck) {
	var returnstring = '';
	var theCheck = 9999;
	//if there is a second argument, use that as the default value to return
	if(arrayLen(arguments) GT 1)
		returnstring = arguments[2];
	//if there is a third argument, use that for the value to compare
	if(arrayLen(arguments) GT 2)
		theCheck = arguments[3];
	if (len(valueToCheck) AND valueToCheck IS NOT theCheck) 
		returnstring = valueToCheck;
	
	return returnstring;	
}

/**
 * Makes a row of a query into a structure.
 * 
 * @param query 	 The query to work with. 
 * @param row 	 Row number to check. Defaults to row 1. 
 * @return Returns a structure. 
 * @author Nathan Dintenfass (nathan@changemedia.com) 
 * @version 1, December 11, 2001 
 */
function queryRowToStruct(query){
	//by default, do this to the first row of the query
	var row = 1;
	//a var for looping
	var ii = 1;
	//the cols to loop over
	var cols = listToArray(query.columnList);
	//the struct to return
	var stReturn = structnew();
	//if there is a second argument, use that for the row number
	if(arrayLen(arguments) GT 1)
		row = arguments[2];
	//loop over the cols and build the struct from the query row
	for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
		stReturn[cols[ii]] = query[cols[ii]][row];
	}		
	//return the struct
	return stReturn;
}

/**
 * Tests passed value to see if it is a valid e-mail address (supports subdomain nesting and new top-level domains).
 * Update by David Kearns to support '
 * SBrown@xacting.com pointing out regex still wasn't accepting ' correctly.
 * More TLDs
 * Version 4 by P Farrel, supports limits on u/h
 * 
 * @param str 	 The string to check. (Required)
 * @return Returns a boolean. 
 * @author Jeff Guillaume (SBrown@xacting.comjeff@kazoomis.com) 
 * @version 4, December 30, 2005 
 */
function isEmail(str) {
    return (REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name|jobs|travel))$",
arguments.str) AND len(listGetAt(arguments.str, 1, "@")) LTE 64 AND
len(listGetAt(arguments.str, 2, "@")) LTE 255) IS 1;
}

function CheckNull(val) {
	var returnval = YesNoFormat(not Len(trim(val)));
	return returnval;
}

</cfscript>

<cffunction name="CleanHighAscii" access="public" returntype="string" output="false"
	hint="Cleans extended ascii values to make the as web safe as possible.">
 
	<!--- Define arguments. --->
	<cfargument name="Text" type="string" required="true" hint="The string that we are going to be cleaning." />
 
	<!--- Set up local scope. --->
	<cfset var LOCAL = {} />
 
	<!---
		When cleaning the string, there are going to be ascii values that we want to target, but there are also going
		to be high ascii values that we don't expect. Therefore, we have to create a pattern that simply matches all non
		low-ASCII characters. This will find all characters that are NOT in the first 127 ascii values. To do this, we
		are using the 2-digit hex encoding of values.
	--->
	<cfset LOCAL.Pattern = CreateObject( "java", "java.util.regex.Pattern" ).Compile( JavaCast( "string", "[^\x00-\x7F]" ) ) />
 
	<!---
		Create the pattern matcher for our target text. The matcher will be able to loop through all the high
		ascii values found in the target string.
	--->
	<cfset LOCAL.Matcher = LOCAL.Pattern.Matcher( JavaCast( "string", ARGUMENTS.Text ) ) />
 
 
	<!---
		As we clean the string, we are going to need to build a results string buffer into which the Matcher will
		be able to store the clean values.
	--->
	<cfset LOCAL.Buffer = CreateObject( "java", "java.lang.StringBuffer" ).Init() />
 
 
	<!--- Keep looping over high ascii values. --->
	<cfloop condition="LOCAL.Matcher.Find()">
 
		<!--- Get the matched high ascii value. --->
		<cfset LOCAL.Value = LOCAL.Matcher.Group() />
 
		<!--- Get the ascii value of our character. --->
		<cfset LOCAL.AsciiValue = Asc( LOCAL.Value ) />
 
		<!---
			Now that we have the high ascii value, we need to figure out what to do with it. There are explicit
			tests we can perform for our replacements. However, if we don't have a match, we need a default
			strategy and that will be to just store it as an escaped value.
		--->
 
		<!--- Check for Microsoft double smart quotes. --->
		<cfif ( (LOCAL.AsciiValue EQ 8220) OR (LOCAL.AsciiValue EQ 8221) )>
 
			<!--- Use standard quote. --->
			<cfset LOCAL.Value = """" />
 
		<!--- Check for Microsoft single smart quotes. --->
		<cfelseif ( (LOCAL.AsciiValue EQ 8216) OR (LOCAL.AsciiValue EQ 8217) )>
 
			<!--- Use standard quote. --->
			<cfset LOCAL.Value = "'" />
 
		<!--- Check for Microsoft elipse. --->
		<cfelseif (LOCAL.AsciiValue EQ 8230)>
 
			<!--- Use several periods. --->
			<cfset LOCAL.Value = "..." />
 
		<cfelse>
 			<!--- 	Add the cleaned high ascii character into the results buffer. Since we know we will only be
			working with extended values, we know that we don't have to worry about escaping any special characters
			in our target string.
			--->
			<cfset LOCAL.Value = "&###LOCAL.AsciiValue#;" />
 
		</cfif>
		<!---
		At this point there are no further high ascii values in the string. Add the rest of the target text to the
		results buffer.
		--->
		<cfset LOCAL.Matcher.AppendReplacement( LOCAL.Buffer, JavaCast( "string", LOCAL.Value )	) />
 
	</cfloop>
 
	<cfset LOCAL.Matcher.AppendTail(LOCAL.Buffer) />
 
 
	<!--- Return the resultant string. --->
	<cfreturn LOCAL.Buffer.ToString() />
</cffunction>


