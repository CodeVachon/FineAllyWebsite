/**
*
* @file  /C/inetpub/wwwroot/finealley/controllers/splash.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {
	public any function init(fw = '') {
		variables.fw = fw;
	}
	public void function default(struct RC) {
		REQUEST.template.addFile('/includes/css/finealleySplashScreen.css');
		REQUEST.layout = false;
	}
}