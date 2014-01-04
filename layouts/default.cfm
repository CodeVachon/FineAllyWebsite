<cfscript>
	
	//writeDump(REQUEST.template.getCSSFiles());
	
	local.cssFiles = "";
	for (_file in REQUEST.template.getCSSFiles()) {
		local.cssFiles &= chr(10) & chr(13) & chr(9) & chr(9) & "<link rel='stylesheet' href='#_file#' />";
	}

	local.jsFiles = "";
	for (_file in REQUEST.template.getJSFiles()) {
		local.jsFiles &= chr(10) & chr(13) & chr(9) & "<script type='text/javascript' src='#_file#'></script>";
	}	

//<link rel="icon" type="image/png" href="http://www.labwrench.com/images/site/favicon.png" /> 

	REQUEST.template.addMetaTag(property="og:description",content=((len(REQUEST.template.getDescription()) > 0)?REQUEST.template.getDescription():"Fine Alley is a Band based out of Midland Ontario"));
	REQUEST.template.addMetaTag(property="og:title",content=((len(REQUEST.template.getPageTitle()) > 0)?REQUEST.template.getPageTitle():"Live Entertainment"));		
	
	_navArray = [];
	arrayAppend(_navArray,{label="Home",url="/",class=((getItem()=="homepage")?"active":"")});
	arrayAppend(_navArray,{label="Events",url="/events",class=((getItem()=="events")?"active":"")});
	arrayAppend(_navArray,{label="Media",url="/media",class=((getItem()=="media")?"active":"")});
	arrayAppend(_navArray,{label="About",url="/about",class=((getItem()=="about")?"active":"")});
	arrayAppend(_navArray,{label="Contact",url="/contact",class=((getItem()=="contact")?"active":"")});

	_nav = "";
	for (item in _navArray) {
		_nav &= '<li class="#item.class#"><a href="#item.url#">#item.label#</a></li>';
	}

</cfscript>

<cfcontent reset="true"><cfoutput><!DOCTYPE html>
<html lang="en">
	<head>
		<title><cfif len(REQUEST.template.getPageTitle()) gt 0>#REQUEST.template.getPageTitle()# | </cfif>#REQUEST.template.getSiteName()#</title>
		<meta charset="utf-8" />
  		<meta http-equiv="Content-Language" content="en" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		#REQUEST.template.writeMetaTags()#
#local.cssFiles#
		<!--[if lt IE 9]><script src="/includes/js/html5shiv.js"></script><![endif]-->			
	</head>
	<body>
		<div class='container' id="Top">
			<header>
				<h1 class='sr-only'>#REQUEST.template.getSiteName()#</h1>
				<div id="headerCarousel" class="carousel slide">
					<ol class="carousel-indicators hidden-xs">
						<li data-target="##headerCarousel" data-slide-to="0" class="active"></li>
						<li data-target="##headerCarousel" data-slide-to="1"></li>
					</ol>
					<div class="carousel-inner">
						<div class="item active">
							<img src="/includes/img/slideshow/finealleySlide1140x350.jpg" alt="Fine Alley" />
							<div class="carousel-caption hidden-xs">
								<p class="lead">Website is Running</p>
							</div>			
						</div>
						<div class="item">
							<img src="/includes/img/slideshow/summerama1140x350.jpg" alt="Fine Alley Plays Summerama 2013" />
							<div class="carousel-caption hidden-xs">
								<p class="lead">Fine Alley Played at Summerama 2013</p>
							</div>			
						</div>		
					</div>
					<a class="left carousel-control hidden-xs" href="##headerCarousel" data-slide="prev"><span class="icon-prev"></span></a>
					<a class="right carousel-control hidden-xs" href="##headerCarousel" data-slide="next"><span class="icon-next"></span></a>
				</div><!-- close carousel -->
				<nav class="navbar navbar-inverse" role="navigation">
					<div class="navbar-header">
						<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-main-collapse">
							<span class="sr-only">Toggle navigation</span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
						</button>
						<a class="navbar-brand" href="##">
							<img src="/includes/img/finealley170.jpg" alt="#REQUEST.template.getSiteName()#" class="img-thumbnail img-responsive" />
						</a>
					</div>
					<div class="collapse navbar-collapse navbar-main-collapse">
						<ul class="nav navbar-nav">
							#_nav#
						</ul>
						<cfif REQUEST.security.isAdmin()>
							<ul class='nav navbar-nav pull-right'>
								<li>
									<a href='##' class="dropdown-toggle" data-toggle="dropdown">Admin <b class="caret"></b></a>
									<ul class='dropdown-menu'>
										<li><a href='#buildURL('admin/listArticles')#'>Articles</a></li>
										<li><a href='#buildURL('admin/listUsers')#'>Users</a></li>
										<li class="divider"></li>
										<li><a href='/logout'>Logout</a></li>
									</ul>								
								</li>
							</ul>
						</cfif>
  					</div><!-- close .navbar-collapse -->
				</nav>
			</header>
			<div class='content row'>
				<div class='col-sm-7 col-md-8 main'>
					#body#
				</div>
				<div class='col-sm-5 col-md-4 sidebar'>
					<h2>More About #REQUEST.template.getSiteName()#</h2>
					<aside>
						<h3>Upcoming Events</h3>
						<ul>
							<li>Next Event</li>
							<li>Next Event</li>
							<li>Next Event</li>
							<li>Next Event</li>

						</ul>
					</aside>
					<aside class='facebook'>
						<cfscript>
							_appID = "272812729524274";;
							_appSecrect = "597f1635cfe9b5bf85aa9664a023379f";
							facebookFineAlleyID = "417727031647789";
							_accessToken = "#_appID#|#_appSecrect#";
							facebookGraphAPI = new utilities.FacebookGraphAPI().init(_accessToken,_appID);
							facebookData = facebookGraphAPI.getObject(id=facebookFineAlleyID);
						</cfscript>
						<h3>#REQUEST.template.getSiteName()# on Facebook</h3>
						<header>
							<img src="#facebookData.cover.source#" class="img-responsive" alt="facebook Cover Image" />
							<div class='bar'>
								<div class='image'>
									<img src="https://graph.facebook.com/#facebookData.id#/picture?width=200&height=200" class="img-responsive img-thumbnail" alt="facebook Profile Image">
								</div>
								<div class='title'>
									<a href='#facebookData.link#'>#facebookData.name#</a>
								</div>
							</div>
							<table class="table clearfix"> 
								<tr>
									<th>Band Members</th>
									<td>#facebookData.band_members#</td>
								</tr>
								<tr>
									<th>Genre</th>
									<td>#facebookData.genre#</td>
								</tr>								
							</table>
						<header>
					</aside>
				</div>
			</div>
			<footer class="row">
				<div class='col-sm-4'>
					<ul>
						<li class='visible-xs'><a href='##Top'>Back to the Top</a></li>
						#_nav#
						<cfif REQUEST.security.isSignedIn()>
							<li><a href='/logout'>Logout</a></li>
						<cfelse>
							<li><a href='/login'>Login</a></li>
						</cfif>
						
					</ul>
				</div>				
				<div class='col-sm-8'>
					<p>We (the band members of Fine Alley and/or the band as a whole) do not claim rights or ownership to any music we play unless otherwise specified.</p>
					<p>Hosted By: <a href=''>Rabey Creative</a></p>
					<p>&copy; Fine Alley 2013 | <a href=''>Privacy Policy</a> | <a href=''>Term of Use</a></p>
				</div>
			</footer>
		</div>
		#local.jsFiles#
	</body>
</html></cfoutput>