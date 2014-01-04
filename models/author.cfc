/**
*
* @file  /C/inetpub/wwwroot/finealley/models/author.cfc
* @author  
* @description
*
*/

component extends="_ormBase" persistent="true" table="authors" {

	property name="firstName" type="string";
	property name="lastName" type="string";
	property name="thumbnail" type="array" fieldtype="many-to-one" fkcolumn="fk_author" cfc="media";

	public function init(){
		this.refreshProperties();
		return super.init();
	}

	public void function refreshProperties() {
		super.refreshProperties();
		if (!structKeyExists(VARIABLES,"firstName")) { VARIABLES["firstName"] = ""; }
		if (!structKeyExists(VARIABLES,"lastName")) { VARIABLES["lastName"] = ""; }
		if (!structKeyExists(VARIABLES,"thumbnail")) { VARIABLES["thumbnail"] = javaCast("null",""); }
	}
}