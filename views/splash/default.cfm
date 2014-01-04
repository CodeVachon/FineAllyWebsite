<cfscript>
	
	local.cssFiles = "";
	for (_file in REQUEST.template.getCSSFiles()) {
		local.cssFiles &= chr(10) & chr(13) & chr(9) & chr(9) & "<link rel='stylesheet' type='text/css' href='#_file#' />";
	}

</cfscript>
<cfcontent reset="true"><cfoutput><!DOCTYPE html>
<html lang="en">
	<head>
		<title>#REQUEST.template.getSiteName()#</title>
		<meta charset="utf-8" />
  		<meta http-equiv="Content-Language" content="en" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
#local.cssFiles#
		<!--[if lt IE 9]><script src="/includes/js/html5shiv.js"></script><![endif]-->			
	</head>
	<body>
		<header>
			<h1>Fine Alley</h1>
			<h2>Live Entertainment</h2>
		</header>
		<p>We are still setting up our webpage.  In the mean time, check us out on <a href='https://www.facebook.com/pages/Fine-Alley/417727031647789'>Facebook</a> for more information and upcoming events.  Or send an email to theBand(a)finealley.com for more information.</p>
	</body>
</html></cfoutput>