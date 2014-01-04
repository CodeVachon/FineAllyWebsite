<cfscript>
	if (structKeyExists(RC,"person")) { validationErrors = RC.person.validate(); }
	else { validationErrors = {}; }
</cfscript>
<cfoutput>
	<h2>Register</h2>
	<form name="login" method="post" action="/register" class=''>
		<div class="form-group">
			<label for="firstName" class='col-lg-2 control-label'>First Name</label>
			<div class="col-lg-10">
				<input type="text" name="firstName" placeholder="John" value="#((structKeyExists(RC,"firstName"))?RC.firstName:"")#" />
				<cfif structKeyExists(validationErrors,"firstName")>
					<p class="alert alert-error">#validationErrors["firstName"]#</p>
				</cfif>
			</div>
		</div>
		<div class="form-group">
			<label for="lastName" class='col-lg-2 control-label'>Last Name</label>
			<div class="col-lg-10">
				<input type="text" name="lastName" placeholder="Hancock" value="#((structKeyExists(RC,"lastName"))?RC.lastName:"")#" />
				<cfif structKeyExists(validationErrors,"lastName")>
					<p class="alert alert-error">#validationErrors["lastName"]#</p>
				</cfif>				
			</div>
		</div>		
		<div class="form-group">
			<label for="emailAddress" class='col-lg-2 control-label'>E-Mail</label>
			<div class="col-lg-10">
				<input type="text" name="emailAddress" placeholder="john.hancock@emailaddress.it" value="#((structKeyExists(RC,"emailAddress"))?RC.emailAddress:"")#" />
				<cfif structKeyExists(validationErrors,"emailAddress")>
					<p class="alert alert-error">#validationErrors["emailAddress"]#</p>
				</cfif>						
			</div>
		</div>
		<div class="form-group">
			<label for="password" class='col-lg-2 control-label'>Password</label>
			<div class="col-lg-10">
				<input type="password" name="password" />
				<cfif structKeyExists(validationErrors,"password")>
					<p class="alert alert-error">#validationErrors["password"]#</p>
				</cfif>							
			</div>
		</div>
		<div class="form-group">
			<div class="col-lg-10">
				<input type="submit" name="btnSave" value="Sign In" class='btn btn-default' />
			</div>
		</div>	
	</form>	
</cfoutput>