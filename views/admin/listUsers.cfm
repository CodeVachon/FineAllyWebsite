<cfoutput>
	<h2>List Users</h2>
	<table class="table">
		<thead>
			<tr>
				<th>Name</th>
				<th>Email Address</th>
				<th>Actions</th>
			</tr>
		</thead>
		<tfoot>
			<tr>
				<td colspan='3'>#arrayLen(RC.people)# people found | <a href='/register'>Register New User</a></td>
			</tr>
		</tfoot>
		<tbody>
			<cfloop array="#RC.people#" index="person">
				<tr<cfif person.getIsAdmin()> class='info'</cfif>>
					<td>#person.getName()#</td>
					<td><a href='mailto:#person.getEmailAddress()#'>#person.getEmailAddress()#</a></td>
					<td>
						<div class='btn-group'>
							<a href='#buildURL('admin.editUser')#/personID/#person.getID()#' class='btn btn-default btn-mini'>Edit</a>
							<a href='#buildURL('admin.editUser')#/personID/#person.getID()#/isAdmin/#((person.getIsAdmin())?false:true)#/btnSave/true' class='btn btn-default btn-mini'>#((person.getIsAdmin())?"Remove":"Set")# Admin</a>
						</div>
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>