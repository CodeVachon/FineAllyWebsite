/**
*
* @file  /C/inetpub/wwwroot/finealley/services/articleService.cfc
* @author  
* @description
*
*/

component output="false" displayname="articleService" extends="_serviceBase"  {

	public function init(){ return super.init(); }


	public models.article function getArticle() {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }

		var _article = javaCast("NULL","");

		if (structKeyExists(ARGUMENTS,'articleID')) {
			_article = entityLoadByPK("article",ARGUMENTS.articleID);
		} else if (structKeyExists(ARGUMENTS,'publishDate') && structKeyExists(ARGUMENTS,'title')) {
			_article = ORMExecuteQuery("FROM article WHERE publishDate=:publishDate AND title=:title",{
				publishDate=ARGUMENTS.publishDate,
				title=ARGUMENTS.title
			},true);
		}

		if (isNull(_article)) { _article = entityNew("article"); }
		return _article;
	} // close getArticle();


	public array function getArticles() {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		return ORMExecuteQuery("FROM article",{},false);
	} // close getArticles();


	public models.article function editArticle() {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		var _article = this.setValuesInObject(this.getArticle(ARGUMENTS),ARGUMENTS);
		return _article;
	} // close editArticle()


	public models.article function editArticleAndSave() {
		return this.saveObject(this.editArticle(ARGUMENTS));
	} // close editArticleAndSave() 		
}