/**
*
* @file  /C/inetpub/wwwroot/finealley/models/article.cfc
* @author  
* @description
*
*/

component extends="_ormBase" persistent="true" table="articles" {

	property name="title" type="string" length="500";
	property name="uriTitle" type="string" length="500" setter="false";
	property name="summary" type="string" length="2500";
	property name="body" type="string" length="25000";

	property name="publishDate" type="string";

	property name="type" type="string";

	property name="author" type="array" fieldtype="many-to-many" linktable="articleAuthors" fkcolumn="fk_article" inversejoincolumn="fk_author" cfc="media";

	public function init() {
		this.refreshProperties();
		return super.init();
	}


	public void function refreshProperties() {
		super.refreshProperties();
		if (!structKeyExists(VARIABLES,"title")) { VARIABLES["title"] = ""; }
		if (!structKeyExists(VARIABLES,"uriTitle")) { VARIABLES["uriTitle"] = ""; }
		if (!structKeyExists(VARIABLES,"summary")) { VARIABLES["summary"] = ""; }
		if (!structKeyExists(VARIABLES,"body")) { VARIABLES["body"] = ""; }
		if (!structKeyExists(VARIABLES,"publishDate")) { VARIABLES["publishDate"] = now(); }

		if (!structKeyExists(VARIABLES,"type")) { VARIABLES["type"] = ""; }

		if (!structKeyExists(VARIABLES,"author")) { VARIABLES["author"] = []; }
	}


	public void function preInsert() hint="call before this being inserted" { 
		setURITitle();
		super.preInsert(); 
	}
	public void function preUpdate(Struct oldData) hint="call before this being updated" {
		setURITitle();
		super.preUpdate(oldData);
	}


	private void function setURITitle() {
		VARIABLES["uriTitle"] = reReplaceNoCase(trim(this.getTitle()),"\W{1,}","-","ALL");
	}
}