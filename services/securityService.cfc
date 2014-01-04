/**
*
* @file  /C/inetpub/wwwroot/finealley/services/securityService.cfc
* @author  
* @description
*
*/

component output="false" extends="_serviceBase" displayname="securityService"  {
	public function init(){ return super.init(); }

	public boolean function signInUser() {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }

		var _person = ORMExecuteQuery("SELECT DISTINCT p.id FROM person p WHERE emailAddress = :emailAddress AND password = :password",{emailAddress=ARGUMENTS.emailAddress,password=hash(ARGUMENTS.password,"md5")},false);
		if (arrayLen(_person) == 1) {
			loadPersonIntoSession(personID=_person[1]);
			return true;
		} else {
			return false;
		}
	} // close signInUser()


	public void function signOutUser() {
		structDelete(SESSION,"person");
	} // close signOutUser()	


	public void function loadPersonIntoSession() {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }

		var personService = new personService();
		var _person = personService.getPerson(ARGUMENTS);

		if (isNull(_person)) { return false; }
		else {
			SESSION.person = {
				personID = _person.getID(),
				firstName = _person.getFirstName(),
				lastName = _person.getLastName(),
				emailAddress = _person.getEmailAddress(),
				isAdmin = _person.getIsAdmin()
			};
		}		
	} // close loadPersonIntoSession()
}