/**
*
* @file  /C/inetpub/wwwroot/finealley/utilities/security.cfc
* @author  
* @description
*
*/

component output="false" displayname="security" extends="object" {

	public function init(){
		return super.init();
	}


	public boolean function isSignedIn() {
		if (structKeyExists(SESSION,"person") && structKeyExists(SESSION.person,"personID")) {
			return true;
		} else {
			return false;
		}
	}


	public boolean function isAdmin() {
		var _result = false;
		if (this.isSignedIn()) {
			_result = SESSION.person.isAdmin;
		}
		return _result;
	}
}