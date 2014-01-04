component extends="frameworkOne.framework" {
	this.name = 'FineAlleyWebsiteVr1.0';
	this.sessionManagement = true;
	this.sessionTimeout = CreateTimespan(0,0,20,0);
	
	this.datasource = "FineAlley";
	this.ormEnabled = true;
	this.ormSettings = {
		//dbcreate = "none",
		dbcreate = "update",
		eventHandling = true,
		cfclocation = 'models',
		flushatrequestend = false,
		namingstrategy = "smart",
		dialect = "MySQL",
		sqlscript = "/sql/orm.sql",
		logsql = "true"
	};
	

	VARIABLES.framework = {
		//defaultSection = 'splash', defaultItem = 'default',
		defaultSection = 'home', defaultItem = 'default',
		reload = 'reload',
		password = 'true',
		error = 'home.error',
		reloadApplicationOnEveryRequest = true,
		generateSES = true,
		SESOmitIndex = true,
		applicationKey = 'frameworkOne',
		routes = [
			{"/splash"="/splash/default"},
			{"/events"="/home/events"},
			{"/media"="/home/media"},
			{"/about"="/home/about"},
			{"/contact"="/home/contact"},
			{"/login"="/home/login"},
			{"/logout"="/home/logout"},
			{"/register"="/home/register"},
			{"/article/:year/:month/:day/:title"="/articles/view/publishDate/:year-:month-:day/title/:title"}
		]
	};

	public void function setupRequest() {
		// use setupRequest to do initialization per request
		//REQUEST.context.startTime = getTickCount();

		ORMreload();

		REQUEST.template = new utilities.template();
		REQUEST.template.setSiteName("Fine Alley");
		REQUEST.template.addFile('http://code.jquery.com/jquery-1.10.1.min.js');
		//REQUEST.template.addFile('//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css','//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap-theme.min.css','//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js');
		REQUEST.template.addFile('//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css');
		REQUEST.template.addFile('/includes/css/bootstrap.min.css');
		REQUEST.template.addFile('/includes/css/bootstrap-theme.min.css');
		REQUEST.template.addFile('/includes/js/bootstrap.min.js');
		REQUEST.template.addFile('/includes/css/finealley2.css');
		REQUEST.template.addFile('/includes/js/global.js');
		//REQUEST.template.addFile('/includes/js/fbFeed.js');

		//REQUEST.template.addMetaTag(property="fb:admins",content="1");

		REQUEST.template.addMetaTag(property="fb:app_id",content="272812729524274");
		REQUEST.template.addMetaTag(property="og:url",content="http://www.finealley.com#buildUrl(getSectionAndItem())#");
		REQUEST.template.addMetaTag(property="og:site_name",content="Fine Alley");
		REQUEST.template.addMetaTag(property="og:type",content="website");
		REQUEST.template.addMetaTag(property="og:locale",content="en_US");
		REQUEST.template.addMetaTag(property="og:image",content="http://www.finealley.com/includes/img/finealleySplash1500.jpg");


		REQUEST.security = new utilities.security();
		if (REQUEST.security.isSignedIn()) {
			securityService = new services.securityService();
			securityService.loadPersonIntoSession(personID=SESSION.person.personID);
		}
	}
}