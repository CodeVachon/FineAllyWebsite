/**
*
* @file  /C/inetpub/wwwroot/finealley/controllers/admin.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {
	public any function init(fw = '') {
		variables.fw = fw;
	}

	public void function before(struct RC) {
		if (!REQUEST.security.isAdmin()) {
			VARIABLES.fw.redirect("home.denied");
		}
	}

	public void function listUsers(struct RC) {
		VARIABLES.fw.service("personService.getPeople","people",RC);
		REQUEST.template.setPageTitle("List Users");
	} // close listUsers


	public void function startEditUser(struct RC) {
		if (structKeyExists(RC,"btnSave")) {
			VARIABLES.fw.service("personService.editPersonAndSave","person",RC);
		} else if (structKeyExists(RC,"personID")) {
			VARIABLES.fw.service("personService.getPerson","person",RC);
		}
	}
	public void function editUser(struct RC) {
		REQUEST.template.setPageTitle("Edit User");		
	}
	public void function endEditUser(struct RC) {
		if (structKeyExists(RC,"btnSave") && RC.person.doesValidate()) {
			VARIABLES.fw.redirect("admin.listUsers");
		} else if (structKeyExists(RC,"person")) {
			for (property in RC.person.getPropertyStruct()) {
				RC[property] = RC.person.getProperty(property);
			}			
		}		
	} // close editUser()


	public void function listArticles(struct RC) {
		VARIABLES.fw.service("articleService.getArticles","articles");
	}
}