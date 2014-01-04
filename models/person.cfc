/**
*
* @file  /C/inetpub/wwwroot/finealley/models/person.cfc
* @author  
* @description
*
*/

component output="false" displayname="" extends="_ormBase" persistent="true" table="people" {

	property name="firstName" type="string";
	property name="lastName" type="string";

	property name="emailAddress" type="string" sqltype="varchar(500)";
	property name="password" type="string" sqltype="varchar(1000)" setter="false";

	property name="isAdmin" type="boolean";

	public function init(){
		this.refreshProperties();
		return super.init();
	}

	public void function refreshProperties() {
		super.refreshProperties();
		if (!structKeyExists(VARIABLES,"firstName")) { VARIABLES["firstName"] = ""; }
		if (!structKeyExists(VARIABLES,"lastName")) { VARIABLES["lastName"] = ""; }

		if (!structKeyExists(VARIABLES,"emailAddress")) { VARIABLES["emailAddress"] = ""; }
		if (!structKeyExists(VARIABLES,"password")) { VARIABLES["password"] = ""; }	

		if (!structKeyExists(VARIABLES,"isAdmin")) { VARIABLES["isAdmin"] = false; }		
	}

	public struct function validate() {
		var _validationErrors = super.validate();

		if (len(VARIABLES["firstName"]) == 0) { _validationErrors["firstName"] = "invalid lenth for First Name"; }
		if (len(VARIABLES["lastName"]) == 0) { _validationErrors["lastName"] = "invalid lenth for Last Name"; }
		if (len(VARIABLES["emailAddress"]) == 0) { _validationErrors["emailAddress"] = "invalid lenth for Email Address"; }
		else if (arrayLen(reMatch("^[a-zA-Z0-9-_\.]+@[a-zA-Z0-9-_\.]+\.[a-zA-Z]{2,5}$",VARIABLES.emailAddress)) == 0) { _validationErrors["emailAddress"] = "invalid format for Email Address"; }
		else if (arrayLen(ORMExecuteQuery("
								SELECT DISTINCT p
								FROM person p
								WHERE p.emailAddress=:emailAddress
								AND p.id != :thisID
								",{
									thisId=VARIABLES.ID,
									emailAddress=VARIABLES.EmailAddress
								},false)
				) > 0) {
			_validationErrors["emailAddress"] = "Email Address is already in use";
		}
		if (len(VARIABLES["password"]) == 0) { _validationErrors["password"] = "invalid lenth for Password"; }

		return _validationErrors;
	}

	public string function getName() {
		return this.getFirstName() & " " & this.getLastName();
	}

	public void function setPassword(required string value) {
		VARIABLES.password = hash(ARGUMENTS.value,"md5");
	}
}