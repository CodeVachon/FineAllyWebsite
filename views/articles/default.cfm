<cfoutput>
	<h2>Articles List</h2>
	<cfif REQUEST.security.isAdmin()>
		<div class='btn-group btn-group-sm'>
			<a href='#buildURL('articles/editArticle')#' class='btn btn-default'>Add Article</a>
		</div>
	</cfif>

	<cfloop array="#RC.articles#" index="RC.article">
		#view('articles/article/summary')#
	</cfloop>
</cfoutput>