<cfoutput>
	<h2>Sign in</h2>
	<form name="login" method="post" action="/login" role="form">
		<div class="form-group">
			<label for="emailAddress" class='control-label'>E-Mail</label>
			<input type="text" name="emailAddress" class="form-control" placeholder="Email Address" />
		</div>
		<div class="form-group">
			<label for="password" class='control-label'>Password</label>
			<input type="password" name="password" class="form-control" placeholder="Password" />
		</div>
		<div class="form-group">
			<div class="controls">
				<input type="submit" name="btnSave" value="Sign In" class='btn btn-primary' />			
			</div>
		</div>	
	</form>
	<p>Don't have an account with us? <a href='/register'>Click Here</a> to Register</p>
</cfoutput>