/**
*
* @file  /C/inetpub/wwwroot/finealley/controllers/home.cfm
* @author  
* @description
*
*/

component output="false" displayname=""  {
	public any function init(fw = '') {
		variables.fw = fw;
	}
	public void function homepage(struct RC) {
	}
	public void function events(struct RC) {
		REQUEST.template.setPageTitle("Events");
	}
	public void function media(struct RC) {
		REQUEST.template.setPageTitle("Meida");
	}
	public void function about(struct RC) {
		REQUEST.template.setPageTitle("About the Band");
	}	
	public void function contact(struct RC) {
		REQUEST.template.setPageTitle("Contact the Band");
	}
	public void function startLogin(struct RC) {
		if (structKeyExists(RC,"btnSave")) {
			VARIABLES.fw.service("securityService.signInUser","isSignedIn",RC);
		}		
	}
	public void function login(struct RC) {
		REQUEST.template.setPageTitle("Login");
	}
	public void function endLogin(struct RC) {
		if (structKeyExists(RC,"btnSave") && RC.isSignedIn) {
			VARIABLES.fw.redirect("home.homepage");
		}
	}	
	public void function logout(struct RC) {
		REQUEST.template.setPageTitle("Logout");
		VARIABLES.fw.service("securityService.signOutUser","result");
	}	
	public void function startRegister(struct RC) {
		if (structKeyExists(RC,"btnSave")) {
			VARIABLES.fw.service("personService.editPersonAndSave","person",RC);
			VARIABLES.fw.service("securityService.signInUser","isSignedIn",RC);
		}
	}
	public void function register(struct RC) {
		REQUEST.template.setPageTitle("Register");
	}
	public void function endRegister(struct RC) {
		if (structKeyExists(RC,"btnSave") && RC.person.doesValidate() && RC.isSignedIn) {
			VARIABLES.fw.redirect("home.homepage");
		}
	}

	public void function denied(struct RC) {
		REQUEST.template.setPageTitle("Access Denied");
	}
}