<cfoutput>
	<form action="#buildURL('articles/editArticle')#" method="post" role="form">
		<cfif structKeyExists(RC,"articleID")>
			<input type="hidden" name="articleID" value="#RC.articleID#" />
		</cfif>
		<div class="form-group">
			<label for="title">Title</label>
			<input class="form-control" type="text" name="title" value="#((structKeyExists(RC,"title"))?RC.title:"")#" placeholder="Articles Headline" />
		</div>
		<div class="form-group">
			<label for="summary">Summary</label>
			<textarea class="form-control" name="summary">#((structKeyExists(RC,"summary"))?RC.summary:"")#</textarea>
		</div>
		<div class="form-group">
			<label for="body">Article Body</label>
			<textarea class="form-control" name="body">#((structKeyExists(RC,"body"))?RC.body:"")#</textarea>
		</div>
		<div class="form-group">
			<label for="publishDate">Publish Date</label>
			<div class="input-group">
				<input class="form-control" type="date" name="publishDate" value="#((structKeyExists(RC,"publishDate"))?RC.publishDate:"")#" placeholder="Today?" />
				<span class="input-group-addon"><i class='fa fa-calendar'></i></span>
			</div>
		</div>
		<input type="submit" name="btnSave" value="Save" class="btn btn-default" />
	</form>
</cfoutput>