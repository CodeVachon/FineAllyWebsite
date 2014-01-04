/**
*
* @file  /C/inetpub/wwwroot/finealley/controllers/articles.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {

	public any function init(fw = '') {
		variables.fw = fw;
	}


	public void function default(required struct RC) {
		VARIABLES.fw.service("articleService.getArticles","articles");
	}


	public void function view(required struct RC) {
		VARIABLES.fw.service("articleService.getArticle","article");
	}


	public void function startEditArticle(required struct RC) {
		if (!REQUEST.security.isAdmin()) { VARIABLES.fw.redirect("home.denied"); }
		if (structKeyExists(RC,"btnSave")) {
			VARIABLES.fw.service("articleService.editArticleAndSave","article");
		} else if (structKeyExists(RC,"articleID")) {
			VARIABLES.fw.service("articleService.getArticle","article");
		}
	}
	public void function editArticle(required struct RC) {

	}
	public void function endEditArticle(required struct RC) {
		REQUEST.template.addFile('/includes/js/jHtmlArea.js','/includes/css/jHtmlArea.css');
		REQUEST.template.addFile('/includes/js/editArticle.js');
		if (structKeyExists(RC,"btnSave")) {
			VARIABLES.fw.redirect("articles.view","articleID");
		} else if (structKeyExists(RC,"article")) {
			for (property in RC.article.getPropertyStruct()) {
				RC[property] = RC.article.getProperty(property);
			}
		}
	} // close editArticle
}