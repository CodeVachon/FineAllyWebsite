component displayname="History" table="history" persistent="true" hint="I represent an objects values at a point of time" {

	property name="id" fieldType="id" setter="false" column="id" type="string" ormtype="string";
	property name="historyDate" type="date" ormtype="timestamp" setter="false" sqltype="datetime";
	property name="className" type="string" ormtype="string" sqltype="varchar(500)";
	property name="objectID" type="string" ormtype="string" sqltype="varchar(100)";
	property name="values" type="string" ormtype="string" sqltype="blob" getter="false";

	public any function init() {
		this.refreshProperties();
		return this;
	}
	public void function refreshProperties() {
		if (!structKeyExists(VARIABLES,"id")) { VARIABLES.id = createUUID(); }
		if (!structKeyExists(VARIABLES,"historyDate")) { VARIABLES.historyDate = now(); }
		if (!structKeyExists(VARIABLES,"className")) { VARIABLES.className = ""; }
		if (!structKeyExists(VARIABLES,"objectID")) { VARIABLES.objectID = ""; }
		if (!structKeyExists(VARIABLES,"values")) { VARIABLES.values = ""; }
	}
	public struct function getValues() {
		return deserializeJSON(VARIABLES.values);
	}
	public string function getRawValues() {
		return VARIABLES.values;
	}
}