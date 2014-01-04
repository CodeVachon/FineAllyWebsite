<cfparam name="RC.article" default="#entityNew('article')#" />
<cfoutput>
	<div class="media">
		<a class="pull-left thumbnail" href="##">
			<img class="media-object" src="/includes/img/icon128.png" alt="">
		</a>
		<div class="media-body">
			<h4 class="media-heading"><a href=''>#RC.article.getTitle()#</a></h4>
			<p>#RC.article.getSummary()#</p>
			<cfif REQUEST.security.isAdmin()>
				<div class='btn-group btn-group-sm'>
					<a href='#buildURL('articles/editArticle/articleID/#RC.article.getID()#')#' class='btn btn-default'>Edit Article</a>
				</div>				
			</cfif>
		</div>
	</div>	
</cfoutput>