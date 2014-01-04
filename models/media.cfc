/**
*
* @file  /C/inetpub/wwwroot/finealley/models/media.cfc
* @author  
* @description
*
*/

component extends="_ormBase" persistent="true" table="media" {

	property name="label" type="string";
	property name="desc" type="string";
	property name="url" type="string";

	property name="type" type="string";


	public function init(){
		return super.init();
	}

	public void function refreshProperties() {
		super.refreshProperties();
		if (!structKeyExists(VARIABLES,"label")) { VARIABLES["label"] = ""; }
		if (!structKeyExists(VARIABLES,"desc")) { VARIABLES["desc"] = ""; }

		if (!structKeyExists(VARIABLES,"url")) { VARIABLES["url"] = ""; }
		if (!structKeyExists(VARIABLES,"type")) { VARIABLES["type"] = ""; }		
	}
}