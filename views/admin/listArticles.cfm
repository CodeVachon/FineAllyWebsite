<cfparam name="RC.articles" default="#arrayNew(1)#" />
<cfoutput>
	<h2>List Articles</h2>
	<table class='table'>
		<thead>
			<tr>
				<th>Article</th>
				<th>Publish Date</th>
				<th></th>
			</tr>
		</thead>
		<tfoot>
			<tr>
				<td colspan='3'>
					<a href='##' class='btn btn-sm btn-default'>Add New Article</a>
				</td>
			</tr>
		</tfoot>
		<tbody>
			<cfloop array="#RC.articles#" index="local.article">
				<tr>
					<td>#local.article.getTitle()#</td>
					<td>#local.article.getPublishDate()#</td>
					<td>
						<div class='btn-group'>
							<a href="#buildURL('articles.editArticle')#/articleid/#local.article.getID()#" class='btn btn-sm btn-default'>View</a>
							<a href="#buildURL('articles.editArticle')#/articleid/#local.article.getID()#" class='btn btn-sm btn-default'>Edit</a>
						</div>
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>