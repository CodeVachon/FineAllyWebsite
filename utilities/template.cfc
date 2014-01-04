component {

	property name="jsFiles" type="array";
	property name="cssFiles" type="array";
	property name="icoFiles" type="array";

	property name="siteName" type="string";
	property name="pageTitle" type="string";

	property name="keyWords" type="string";
	property name="description" type="string";

	property name="metaTags" type="array";

	property name="inLineCSS" type="string";

	public any function init() {

		VARIABLES.siteName = "";
		VARIABLES.pageTitle = "";
		VARIABLES.keyWords = "";
		VARIABLES.description = "";

		VARIABLES.jsFiles = arrayNew(1);
		VARIABLES.cssFiles = arrayNew(1);
		VARIABLES.icoFiles = arrayNew(1);

		VARIABLES.metaTags = arrayNew(1);

		VARIABLES.inLineCSS = "";

		return this;
	}

	public string function getSiteName() { return VARIABLES.siteName; }
	public boolean function setSiteName(required string value) { return setString("siteName",ARGUMENTS.value); }
	public boolean function appendSiteName(required string value) { return appendString("siteName",ARGUMENTS.value); }
	public boolean function prependSiteName(required string value) { return prependString("siteName",ARGUMENTS.value); }

	public string function getPageTitle() { return VARIABLES.pageTitle; }
	public boolean function setPageTitle(required string value) { return setString("pageTitle",ARGUMENTS.value); }
	public boolean function appendPageTitle(required string value) { return appendString("pageTitle",ARGUMENTS.value); }
	public boolean function prependPageTitle(required string value) { return prependString("pageTitle",ARGUMENTS.value); }	

	public string function getKeyWords() { return VARIABLES.keyWords; }
	public boolean function setKeyWords(required string value) { return setString("keyWords",ARGUMENTS.value); }
	public boolean function appendKeyWords(required string value) { return appendString("keyWords","," & ARGUMENTS.value); }
	public boolean function prependKeyWords(required string value) { return prependString("keyWords",ARGUMENTS.value); }

	public string function getDescription() { return VARIABLES.description; }
	public boolean function setDescription(required string value) { return setString("description",ARGUMENTS.value); }
	public boolean function appendDescription(required string value) { return appendString("description",ARGUMENTS.value); }
	public boolean function prependDescription(required string value) { return prependString("description",ARGUMENTS.value); }	

	public array function getCSSFiles() { return VARIABLES.cssFiles; }
	public array function getJSFiles() { return VARIABLES.jsFiles; }
	public array function getICOFiles() { return VARIABLES.icoFiles; }

	public string function getInlineCSS() { return VARIABLES.InlineCSS; }
	public boolean function setInlineCSS(required string value) { return setString("InlineCSS",ARGUMENTS.value); }
	public boolean function appendInlineCSS(required string value) { return appendString("InlineCSS",ARGUMENTS.value); }
	public boolean function prependInlineCSS(required string value) { return prependString("InlineCSS",ARGUMENTS.value); }		

	public any function get(required string key) {
		return VARIABLES[key];
	}
	
	public boolean function addMetaTag() {
		if ((!structKeyExists(ARGUMENTS,"name")) && (!structKeyExists(ARGUMENTS,"property"))) { throw("META tag requires a NAME and/or PROPERTY"); }
		if (!structKeyExists(ARGUMENTS,"content")) { throw("META tag requires a CONTENT value"); }
		var metaData = structNew();
		if (structKeyExists(ARGUMENTS,"name")) { metaData["name"] = trim(ARGUMENTS.name); }
		if (structKeyExists(ARGUMENTS,"property")) { metaData["property"] = trim(ARGUMENTS.property); }
		if (structKeyExists(ARGUMENTS,"content")) { metaData["content"] = trim(ARGUMENTS.content); }
		return arrayAppend(VARIABLES.metaTags,metaData);
	}
	public array function getMetaTags() {
		return VARIABLES.metaTags;
	}
	public string function writeMetaTags() {
		var _output = "";
		for (var tag in this.getMetaTags()) {
			_output &= "<meta ";
			if (structKeyExists(tag,"property")) { _output &= 'property="#tag.property#" ';  }
			if (structKeyExists(tag,"name")) { _output &= 'name="#tag.name#" ';  }

			_output &= 'content="#tag.content#" />' & chr(10);
		}
		return _output;
	}
	
	public boolean function addFile(required string path) {
		if (len(ARGUMENTS.path) == 0) { throw("invalid path"); }
		else {
			if (structCount(ARGUMENTS) > 1) {
				for (key in ARGUMENTS) {
					if (len(ARGUMENTS[key]) > 0) {
						ARGUMENTS.path = listAppend(ARGUMENTS.path,ARGUMENTS[key]);
					}
				}
			}

			for (var i=1;i<=listLen(ARGUMENTS.path);i++) {
				var thisPath = listGetAt(ARGUMENTS.path,i);
				var thisVar = "";
				switch(reReplaceNoCase(thisPath,".+(\.\w{2,3})$","\1","one")) {
					case ".png":
					case ".ico": thisVar="icoFiles"; break;
					case ".css": thisVar="cssFiles"; break;
					default: thisVar="jsFiles"; break;
				}
				if (thisVar != "") { validateAndAddToArray(thisPath,thisVar); }
			}
		}
		return true;
	}
	private boolean function validateAndAddToArray(required string value, required string toArray) {
		// checks to see if the file already exists, if not, add it... 
		if (arrayFind(VARIABLES[ARGUMENTS.toArray],ARGUMENTS.value) == 0) {
			return arrayAppend(VARIABLES[ARGUMENTS.toArray],ARGUMENTS.value);
		} else {
			return false;
		}
	}
	private boolean function setString(required string key,required string value) {
		if (len(key) == 0) { throw("EPIC FAIL!"); }
		VARIABLES[ARGUMENTS.key] = ARGUMENTS.value;
		return true;
	}
	private boolean function appendString(required string key,required string value) {
		if (len(key) == 0) { throw("EPIC FAIL!"); }
		VARIABLES[ARGUMENTS.key] &= ARGUMENTS.value;
		return true;
	}
	private boolean function prependString(required string key,required string value) {
		if (len(key) == 0) { throw("EPIC FAIL!"); }
		VARIABLES[ARGUMENTS.key] = ARGUMENTS.value & VARIABLES[ARGUMENTS.key];
		return true;
	}		
}