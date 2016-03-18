<cfsilent>
<!--- CFWebstore, version 6.50 --->

<!--- Used to set variables for databases and store, called by main fbx_settings.cfm --->

<!--- Set Datasource Name and login  --->
<cfparam name="Request.ds" default="cfwebstorefb6">
<cfparam name="Request.DSuser" default="">
<cfparam name="Request.DSpass" default="">

<!--- Set database type, used for some queries. Options are 'Access' 'MSSQL' and 'MySQL' --->
<cfparam name="Request.dbtype" default="MySQL">

<!--- Set server type, used when setting file paths. Options are 'Unix' or 'Windows'. 
	For other servers, choose the one that matches the same file paths as yours.  --->
<cfparam name="Request.servertype" default="Unix">

<!--- For CC Encryption, just enter a random string here when setting up a new store --->
<!--- Don't change this after your store goes live unless all orders are filled! --->
<!--- If you have user credit cards turned on and save card data for your customers, change this only ONCE when you set up your site for the first time.  --->
<!--- Be sure to save your key elsewhere as well, in the event it accidentally gets lost or overwritten.  --->
<cfparam name="Request.encrypt_key" default="mykey">

<!--- This is a prefix appended to the front of the table names in your database. Useful if you need to run multiple stores from one database. Leave blank for normal installations. --->
<cfparam name="Request.DB_Prefix" default="">

<!--- Be sure to set this to "No" for production sites. You can set to YES for development to prevent caching, skip CSRF checks, etc. --->
<cfset Request.DevelopmentMode = "no">

<!--- For CF10, you will need to set this to 'htm' or 'html', earlier servers can use 'cfm' --->
<cfset Request.SESdummyExtension = "htm">

<!--- Set Store and Secure site URLS. MUST include a trailing slash! 
EXAMPLE: <cfparam name="Request.StoreURL" default="http://localhost:8500/cfwebstorefb6/"> --->	
<cfparam name="Request.StoreURL" default="http://local.cfwebstorefb6.com/">
<cfparam name="Request.SecureURL" default="http://local.cfwebstorefb6.com/"> 

<!--- Set this to "yes" if your SSL is shared, or otherwise does not match your main URL (i.e. secure.domain.com versus www.domain.com) --->
<!--- PLEASE NOTE that setting this to "yes" will append session IDs to the URL which is somewhat of a security risk, but is necessary to maintain sessions. 
		It is strongly recommended that you purchase your own SSL (godaddy.com is a cheap source) so you can turn this setting off. --->
<cfparam name="Request.SharedSSL" default="no"> 

<!--- Path to store directory from your web root. Typically the setting below will work for most stores and does not need to be modified. 
		If you are running CFWebstore as an include in another application, such as Mura, you typically will need to manually set this. 
		An example of a path set manually would be <cfset Request.StorePath = "/cfwebstorefb6/" --->
<cfset Request.StorePath = getdirectoryfrompath(cgi.script_name)>

<!--- 	Mapping on ColdFusion to the CFCs directory, you can leave this as is unless you want to set up a custom mapping
		If you have periods in your storepath above, or are using an SSL with a different URL path, 
		you may need to use a custom mapping to the cfcs directory, as those configurations will cause problems here --->
<cfset Request.CFCMapping = "#Request.StorePath#cfcs">

<!--- Path on the server to your downloads directory. Used if you sell any electonic downloadable files. --->
<!--- The downloads directory can be located away from your web root for the best security  --->
<cfset Request.DownloadPath = "c:\cfusionmx\wwwroot\cfwebstorefb6\downloads">

<!--- Path on the server to a temporary uploads directory. Leave this blank if you don't want to use it, but if you allow public uploads on your site, 
		such as the Contact Us with Attachment form, you definitely should use a temp directory for uploads for additional security. It's a good idea to 
		use it on any site for protection against external hack attempts. You can use GetTempDirectory() for this, but a specific directory is preferred. --->
<!--- The temp directory should be located away from your web root for the best security  --->
<!--- Example: <cfset Request.TempPath = "c:\cfusionmx\wwwroot\tempfiles"> --->
<cfset Request.TempPath = "">

<!--- Mime types allowed for downloads, and matching file extensions. Any uploads must be one of the mime types you list here. --->
<!--- Be careful what files you allow! Do not configure this to allow octect stream or other executable file types. --->
<!--- You can also upload other files through regular FTP --->
<cfset Request.MimeTypes = "image/gif, image/jpeg, image/pjpeg, image/png, application/x-zip-compressed, application/zip, application/msword, application/powerpoint, application/x-excel, text/plain, application/pdf, audio/mpeg, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.openxmlformats-officedocument.spreadsheetml.template, application/vnd.openxmlformats-officedocument.presentationml.template, application/vnd.openxmlformats-officedocument.presentationml.slideshow, application/vnd.openxmlformats-officedocument.presentationml.presentation, application/vnd.openxmlformats-officedocument.presentationml.slide, application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/vnd.openxmlformats-officedocument.wordprocessingml.template, application/vnd.ms-excel.addin.macroEnabled.12, application/vnd.ms-excel.sheet.binary.macroEnabled.12">
<cfset Request.AllowExtensions = "jpg,jpeg,gif,png,pdf,doc,mov,ppt,zip,txt,xls,xlsx,xltx,potx,ppsx,pptx,sldx,docx,dotx,xlam,xlsb">

<!--- Demo mode is used for demoing the software and will disable certain features, such as signing up for UPS and Fedex, setting payment gateways, uploading files, or modifying the admin account --->
<cfset Request.DemoMode = "no">

<!--- Uncomment this line to use an image for the gift registry button (this setting will eventually be moved to the DB) --->
<cfset Request.RegistryButton = "addtoregistry.gif">

</cfsilent>
