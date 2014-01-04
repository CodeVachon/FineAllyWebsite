<cfscript>
	if (structKeyExists(RC,"person")) { validationErrors = RC.person.validate(); }
	else { validationErrors = {}; }
</cfscript>
<cfoutput>
	<h3>Edit User</h3>
	<form name="editUser" method="post" action="/admin/editUser">
		<cfif structKeyExists(RC,"personID")><input type="hidden" name="personID" value="#RC.personID#" /></cfif>
		<div class="control-group">
			<label for="firstName" class='control-label'>First Name</label>
			<div class="controls">
				<input type="text" name="firstName" placeholder="John" value="#((structKeyExists(RC,"firstName"))?RC.firstName:"")#" />
				<cfif structKeyExists(validationErrors,"firstName")>
					<p class="alert alert-error">#validationErrors["firstName"]#</p>
				</cfif>
			</div>
		</div>
		<div class="control-group">
			<label for="lastName" class='control-label'>Last Name</label>
			<div class="controls">
				<input type="text" name="lastName" placeholder="Hancock" value="#((structKeyExists(RC,"lastName"))?RC.lastName:"")#" />
				<cfif structKeyExists(validationErrors,"lastName")>
					<p class="alert alert-error">#validationErrors["lastName"]#</p>
				</cfif>				
			</div>
		</div>		
		<div class="control-group">
			<label for="emailAddress" class='control-label'>E-Mail</label>
			<div class="controls">
				<input type="text" name="emailAddress" placeholder="john.hancock@emailaddress.it" value="#((structKeyExists(RC,"emailAddress"))?RC.emailAddress:"")#" />
				<cfif structKeyExists(validationErrors,"emailAddress")>
					<p class="alert alert-error">#validationErrors["emailAddress"]#</p>
				</cfif>						
			</div>
		</div>
		<div class="control-group">
			<label for="isAdmin" class='control-label'>Site Administrator</label>
			<div class="controls">
				<select name="isAdmin">
					<option value="false"<cfif structKeyExists(RC,"isAdmin") && !RC.isAdmin> selected='selected'</cfif>>No</option>
					<option value="true"<cfif structKeyExists(RC,"isAdmin") && RC.isAdmin> selected='selected'</cfif>>Yes</option>
				</select>
				<cfif structKeyExists(validationErrors,"isAdmin")>
					<p class="alert alert-error">#validationErrors["isAdmin"]#</p>
				</cfif>						
			</div>
		</div>		
		<div class="control-group">
			<div class="controls">
				<input type="submit" name="btnSave" value="Save" class='btn btn-primary' />
			</div>
		</div>	
	</form>	
</cfoutput>