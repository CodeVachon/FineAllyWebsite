component displayname="object" hint="this is the base object that all objects should extend from" {
	public any function init() {
		var variables.runDebug = false;
		var variables.runStrictMode = false; // throw on all incoming set errors
		var variables.errorText = "";
		
		var variables.createdTimestamp = dateDiff('s',createDate(1970,1,1),now());
		return this;
	}
	
	public void function setDebug(required boolean value) description="sets debug mode for this object" { variables.runDebug = value; }
	public void function setStrictMode(required boolean value) description="set strict mode for this object.  an error will be thrown to the compiler on all incoming errors." { variables.runStrictMode = value; }

	private void function writeToLogFile(required string logText,string type = "information") description="writes to a log file" hint="I write to a message to a log file" {
		if (variables.runDebug) {
			writeLog(text=trim(arguments.logText),type=trim(arguments.type),file="#this.getClassName()#");
		}
	}
	package void function setError(required string inputText) description="sets the error message" hint="I set an error message" {
		variables.errorText = arguments.inputText;
		writeToLogFile("[#this.getClassName()#] - " & arguments.inputText,"error");
		if (variables.runStrictMode) {
			throw("[#this.getClassName()#] - " & arguments.inputText);
		}
	}
	public string function error() description="get the last error messsge" hint="I return the last error message" { return variables.errorText; }
  	public string function getClassName() hint="return the name of this object" { return ListLast(GetMetaData(this).fullname,"."); }	
  	public void function dump(string label = "") description="dumps this" hint="I dump myself out to the page so you can see my methods and values" { writeDump(var=this,label=trim(arguments.label));  }
	
	private struct function reduceStructLevel(required struct structToCovert) {
		var tempStruct = structNew();
		for (var key in arguments.structToCovert) { tempStruct[key] = arguments.structToCovert[key]; }
		return tempStruct;
	}
}