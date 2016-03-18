
<cfhtmlhead text='<script type="text/javascript" src="#Request.StorePath#customtags/ckeditor/ckeditor.js"></script>'>

<cfparam name="ck_dirname" default="">
<cfparam name="ck_user" default="">

<cfoutput>
	
<cfsavecontent variable="ck_default">
	emailProtection: 'encode', enterMode: CKEDITOR.ENTER_BR, shiftEnterMode: CKEDITOR.ENTER_DIV,
	pasteFromWordPromptCleanup: true, 
</cfsavecontent>

<cfsavecontent variable="full_tool">
toolbar: [
    { name: 'document',    items : [ 'Source','-','Maximize','-','DocProps','Preview','Print','-','Templates' ] },
    { name: 'clipboard',   items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
    { name: 'editing',     items : [ 'Find','Replace','-','SelectAll', 'ShowBlocks','-','SpellChecker', 'Scayt' ] },	
    { name: 'tools',       items : [ 'About' ] },
	 '/',
    { name: 'paragraph',   items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
    { name: 'links',       items : [ 'Link','Unlink','Anchor' ] },
    { name: 'insert',      items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak' ] },
    '/',
   { name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
    { name: 'styles',      items : [ 'Styles','Format','Font','FontSize' ] },
    { name: 'colors',      items : [ 'TextColor','BGColor' ] }
]
</cfsavecontent>

<cfsavecontent variable="basic_tool">
toolbar: [ ['FitWindow','Source','-','Bold','Italic','-','OrderedList','UnorderedList','-','Link','Unlink','-','About'] ] 
</cfsavecontent>

<cfsavecontent variable="ck_image">
	filebrowserImageBrowseUrl: '#Request.SecureSelf#?fuseaction=home.admin&select=image#ck_dirname##ck_user#&redirect=yes',
</cfsavecontent>

<cfsavecontent variable="ck_files">
	filebrowserBrowseUrl: '#Request.SecureSelf#?fuseaction=home.admin&select=image&type=File#ck_dirname##ck_user#&redirect=yes',
	filebrowserFlashBrowseUrl: '#Request.SecureSelf#?fuseaction=home.admin&select=image&type=Flash#ck_user#&dirname=/flash&redirect=yes',
	filebrowserImageBrowseLinkUrl: '#Request.SecureSelf#?fuseaction=home.admin&select=image&type=File#ck_dirname##ck_user#&redirect=yes',	
</cfsavecontent>

</cfoutput>