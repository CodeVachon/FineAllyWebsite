<cfparam name="RC.article" default="#entityNew('article')#" />
<cfoutput>
	<h2 class="media-heading">#RC.article.getTitle()#</h2>
	<p>#RC.article.getBody()#</p>
	<cfif REQUEST.security.isAdmin()>
		<div class='btn-group btn-group-sm'>
			<a href='#buildURL('articles/editArticle/articleID/#RC.article.getID()#')#' class='btn btn-default'>Edit Article</a>
		</div>
	</cfif>	
</cfoutput>