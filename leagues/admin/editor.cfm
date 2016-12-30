<STYLE>
SELECT.htmlEditSelect {font:8pt verdana,arial,sans-serif;background:#EEEEFF}
.htmlEditToolbar {margin-bottom:3pt;height:28;overflow:hidden;background:lightgrey;border:1px black solid}

.htmlEditHeading {color:navy;background:lightgrey}
</STYLE>
<SCRIPT>
// Copyright 1999 InsideDHTML.com, LLC.
// This code cannot be reproduced or reused without permission from InsideDHTML
var bLoad=false
oEdit = public_description=new Editor

function Editor() {
this.put_html=put_html;
this.get_html=get_html;
this.testHTML=testHTML;
this.TextMode = true
this.put_TextMode = put_TextMode;
this.get_TextMode = get_TextMode;

}

function put_TextMode(v) {
	this.TextMode = (v==true)
	document.all.tb3.style.display = this.TextMode ? "" : "none"
}

function get_TextMode() {
	return this.TextMode
}

function testHTML(bAllowHead,extras) {
  mW.click()
  var badStuff=new Array("IFRAME","SCRIPT","LAYER","ILAYER","OBJECT","APPLET","EMBED","FORM","INPUT","BUTTON","TEXTAREA"),headStuff=new Array("HTML","BODY","TITLE","BASE","LINK","META","STYLE"),hasStuff=new Array(),bodyTags=idEdit.document.body.all,i=0
  for (i=0;i<badStuff.length;i++)
    if (bodyTags.tags(badStuff[i]).length>0)
      hasStuff[hasStuff.length]=badStuff[i]
  if (!bAllowHead)
    for (i=0;i<headStuff.length;i++)
      if (bodyTags.tags(headStuff[i]).length>0)
        hasStuff[hasStuff.length]=headStuff[i]
  if (extras!=null)
    for (i=0;i<extras.length;i++) 
      if (bodyTags.tags(extras[i]).length>0)
        hasStuff[hasStuff.length]=extras[i]
  for (i=0;i<bodyTags.tags("FONT").length;i++)
	if (bodyTags.tags("FONT")[i].style.backgroundColor="#ffffff") {
		bodyTags.tags("FONT")[i].style.backgroundColor=""
		if (bodyTags.tags("FONT")[i].outerHTML.substring(0,6)=="<FONT>")
			bodyTags.tags("FONT")[i].outerHTML=bodyTags.tags("FONT")[i].innerHTML
	}
  var str=""
  if (hasStuff.length>0) {
    str="Please remove the following HTML Tags from your message and resubmit:"
    for (i=0;i<hasStuff.length;i++)
       str+="\n "+hasStuff[i]
    str+= "\nRemember, when using HTML Mode you may need to escape \nthe brackets surrounding tags (< and >) with &lt; and &gt;"
    setTimeout("mH.click()",0)
  }
  return str
}
function get_html() {
if (bMode) 
return idEdit.document.body.innerHTML 
else 
return idEdit.document.body.innerText;
}
function put_html(sVal) {
if (bMode) 
idEdit.document.body.innerHTML=sVal 
else 
idEdit.document.body.innerText=sVal
}

var sHeader="<BODY STYLE=\"font:10pt geneva,arial,sans-serif\">",bMode=true,sel=null,strErr="Formatting toolbar is not accessible in Edit Source mode"
function format(what,opt,ui) {
 if (!bMode) {
   alert(strErr);idEdit.focus();return
 }
 if (opt=="removeFormat") {
   what=opt;opt=null
 }
 ui = (ui==true)
 if (bMode) {
   if (opt==null)
     idEdit.document.execCommand(what,ui)
   else
     idEdit.document.execCommand(what,ui,opt)
   var s=idEdit.document.selection.createRange(),p=s.parentElement()  
   if ((p.tagName=="FONT") && (p.style.backgroundColor!=""))
     p.outerHTML=p.innerHTML
   idEdit.focus()
 } 
 sel=null
}

function getEl(sTag,start) {
  while ((start!=null) && (start.tagName!=sTag))
    start = start.parentElement
  return start
}

function createLink() {
 if (!bMode) {
  alert(strErr);idEdit.focus();return
 }
 var isA = getEl("A",idEdit.document.selection.createRange().parentElement())
 var str=prompt("Where do you want to link to?",isA ? isA.href : "http:\/\/")
 if ((str!=null) && (str!="http://")) {
   if (idEdit.document.selection.type=="None") {
     var sel=idEdit.document.selection.createRange()
     sel.pasteHTML("<A HREF=\""+str+"\">"+str+"</A> ")
     sel.select()
   }
   else
     format("CreateLink",str)
 }
 else
   idEdit.focus()
}

function setMode(bNewMode) {
 if (bNewMode!=bMode) {
  if (bNewMode) {
   var sContents=idEdit.document.body.innerText 
   idEdit.document.open()
   idEdit.document.write(sHeader)
   idEdit.document.close()
   idEdit.document.body.innerHTML=sContents
  }
  else {
   var fonts=idEdit.document.body.all.tags("FONT")
   for (var i=0;i<fonts.length;i++)
    if (fonts[i].style.backgroundColor!="") 
     fonts[i].outerHTML=fonts[i].innerHTML;
   var sContents=idEdit.document.body.innerHTML
   idEdit.document.open()
   idEdit.document.write("<BODY style=\"font:10pt courier, monospace\">")
   idEdit.document.close()
   idEdit.document.body.innerText=sContents
  }
  bMode=bNewMode
  for (var i=0;i<htmlOnly.children.length;i++)
   htmlOnly.children[i].disabled=(!bMode)
 }
 idEdit.focus()
}
</SCRIPT>

<DIV ID=idBox STYLE="width: 100%; text-align: center;visibility: hidden">
<TABLE ID=tb1 class="htmlEditToolbar" CELLSPACING=2 CELLPADDING=0 STYLE="padding-top: 1pt;margin-bottom: 2pt"><TR><TD VALIGN=MIDDLE NOWRAP ID=htmlOnly>
<SELECT class="htmlEditSelect" ONCHANGE="format('formatBlock',this[this.selectedIndex].value);this.selectedIndex=0">
	<OPTION CLASS="htmlEditHeading" SELECTED>Paragraph
	
		<OPTION VALUE="<P>">Normal &lt;P&gt; 
		<OPTION VALUE="<H1>">Heading 1 &lt;H1&gt; 
		<OPTION VALUE="<H2>">Heading 2 &lt;H2&gt; 
		<OPTION VALUE="<H3>">Heading 3 &lt;H3&gt; 
		<OPTION VALUE="<H4>">Heading 4 &lt;H4&gt; 
		<OPTION VALUE="<H5>">Heading 5 &lt;H5&gt; 
		<OPTION VALUE="<H6>">Heading 6 &lt;H6&gt; 
		<OPTION VALUE="<PRE>">Pre &lt;PRE&gt; 
		<OPTION VALUE="removeFormat" STYLE="color: darkred">Clear Formatting 
</SELECT><SELECT class="htmlEditSelect" ONCHANGE="format('fontname',this[this.selectedIndex].value);this.selectedIndex=0">
	<OPTION CLASS="htmlEditHeading" SELECTED>Font
	
		<OPTION VALUE="arial,geneva,sans-serif">Arial 
		<OPTION VALUE="verdana,arial,geneva,sans-serif">Verdana 
		<OPTION VALUE="times,serif">Times 
		<OPTION VALUE="courier,monospace">Courier 
</SELECT><SELECT class="htmlEditSelect"  ONCHANGE="format('fontSize',this[this.selectedIndex].value);this.selectedIndex=0">
	<OPTION CLASS="htmlEditHeading">Size
	
		<OPTION VALUE="1">1 
		<OPTION VALUE="2">2 
		<OPTION VALUE="3">3 
		<OPTION VALUE="4">4 
		<OPTION VALUE="5">5 
		<OPTION VALUE="6">6 
		<OPTION VALUE="7">7 
</SELECT><SELECT class="htmlEditSelect"  ONCHANGE="format('forecolor',this[this.selectedIndex].style.color);this.selectedIndex=0">
<OPTION CLASS="htmlEditHeading" SELECTED>Color
	
		<OPTION style="color:black">Black 
		<OPTION style="color:Gray">Gray 
		<OPTION style="color:Red">Red 
		<OPTION style="color:DarkRed">Dark Red 
		<OPTION style="color:blue">Blue 
		<OPTION style="color:navy">Navy 
		<OPTION style="color:green">Green 
		<OPTION style="color:darkgreen">Dark Green 
		<OPTION style="color:white">White 
</SELECT>

</TD></TR></TABLE>
<SCRIPT>
function getToolbar() {
var buttons=new Array(24,23,23,4,23,23,23,4,23,23,23,23,4,23,23,4,23),action=new Array("bold","italic","underline","","justifyleft","justifycenter","justifyright","","insertorderedlist","insertunorderedlist","outdent","indent","","createLink","insertImage","","setMode"),tooltip=new Array("Bold Text","Italic Text","Underline Text","","Left Justify","Center Justify","Right Justify","","Ordered List","Unordered List","Remove Indent","Indent","","Create Hyperlink","Insert Image","","Edit Source"),left=0,width=0
var s=""
for (var i=0;i<buttons.length;i++) {
 width+=buttons[i]
 s+="<SPAN STYLE='position:relative;height:26;width: " + buttons[i] + "'><SPAN STYLE='position:absolute;margin:0px;padding:0;height:26;top:0;left:0;width:" + (buttons[i]) + ";clip:rect(0 "+buttons[i]+" 25 "+0+");overflow:hidden'><IMG BORDER=0 SRC='<cfoutput>#rootdir#</cfoutput>wsimages/htmleditortoolbar.gif' STYLE='position:absolute;top:0;left:-" + left + "' WIDTH=317 HEIGHT=99"
 if (buttons[i]!=4) {
   switch (action[i]) {
     case "createLink":
       s+=" onmouseover='this.style.top=-25' onmouseout='this.style.top=0' ONCLICK=\""
       s+="createLink();this.style.top=0\" "
       s+="TITLE=\"" + tooltip[i] + "\""
     case "insertImage":
       s+=" onmouseover='this.style.top=-25' onmouseout='this.style.top=0' ONCLICK=\""
       s+="format('insertImage',null,true);this.style.top=0\" "
       s+="TITLE=\"" + tooltip[i] + "\""
     case "setMode":
       s+=" onmouseover='if (bMode) this.style.top=-25; else this.style.top=-49;' onmouseout='if (bMode) this.style.top=0; else this.style.top=-73;' ONCLICK=\""
       s+="if (bMode) this.style.top=-49; else this.style.top=0; setMode(!bMode)\" "
       s+="TITLE=\"" + tooltip[i] + "\""
     default:
      s+=" onmouseover='this.style.top=-25' onmouseout='this.style.top=0' ONCLICK=\""
      s+="format('" + action[i] + "');this.style.top=0\" "
      s+="TITLE=\"" + tooltip[i] + "\""
   }
 }
 s+="></SPAN></SPAN>"
 left+=buttons[i] 
}
return "<DIV ID=tb2 class=htmlEditToolbar STYLE=\"width: " + (width+3) + "\" ONSELECTSTART=\"return false\" ONDRAGSTART=\"return false\">" + s + "</DIV>"
}

document.write(getToolbar())
</SCRIPT>

<IFRAME name="idEdit" width="600" height="200"></IFRAME>



<TEXTAREA NAME="Body" STYLE="display:none">
</TEXTAREA>
<cfoutput>
<SCRIPT>
idEdit.document.open()
idEdit.document.write(sHeader)
idEdit.document.close()
idEdit.document.designMode="On"



if (!document.forms[0])
	alert('Error: The cfa_htmlEditor tag must be inside of a form to submit data.');
else
	document.forms[0].onsubmit = new Function("document.all['Body'].value = get_html();")

function initEditor() {
	bLoad=true;
	put_html('#REReplace( 
				replace( 
					replace( 
						prBody, "'", "\'", "ALL" 
					), chr(13) & chr(10), "\n", "ALL"
				), "[#chr(13)##chr(10)#]", "\n", "ALL"
			)#');
	idBox.style.visibility='';
}
document.body.onload = initEditor;
</SCRIPT>
</cfoutput>
</DIV>
