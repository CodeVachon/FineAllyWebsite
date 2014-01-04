/**
*
* @file  /C/inetpub/wwwroot/finealley/models/_ormBase.cfc
* @author  
* @description
*
*/

component output="false" displayname="" mappedSuperClass="true" extends="utilities.object" {

	property name="id" fieldType="id" setter="false" type="string" ormtype="string" sqltype="varchar(50)";
	
	property name="createdDate" type="date" ormtype="timestamp" setter="false" sqltype="datetime";
	property name="lastUpdated" type="date" ormtype="timestamp" setter="false" sqltype="datetime";
	
	property name="isDeleted" type="boolean" ormtype="boolean" sqltype="bit" default="false" notnull="true";


	public function init(){
		this.refreshProperties();
		return super.init();
	}

	public struct function validate() hint="I return a structure of validation errors. old system: REQUEST.stValidationErrors" {
		return structNew();
	} // close function validate 
	public boolean function doesValidate() hint="I return if the object passed validation or not" {
		return (structCount(this.validate())==0);
	}	

	public boolean function hasProperty(required string propertyName) hint="returns if object has the specified property" {
		arguments.propertyName = trim(arguments.propertyName);
		if (arguments.propertyName == "id") {
			return true;
		} else {
			return structKeyExists(variables,arguments.propertyName);
		}
	}
	public any function getProperty(required string propertyName) hint="returns the value of the specified property" {
		// I provide functionality to dynamically get a property value 
		arguments.propertyName = trim(arguments.propertyName);
		if (this.hasProperty(arguments.propertyName) && isDefined("variables.#arguments.propertyName#")) {
			return variables[arguments.propertyName];
		} else {
			return javaCast("null","");
		}
	}
	public boolean function setProperty(required string propertyName,required any value) {
		arguments.propertyName = trim(arguments.propertyName);
		if (this.hasProperty(arguments.propertyName)) {
			if (!len(ARGUMENTS.value)) {
				variables[arguments.propertyName] =  javaCast( "null", 0 );
			} else {
				variables[arguments.propertyName] = arguments.value;
			}
			return true;
		}
		this.setError("Property [#arguments.propertyName#] does not exists");
		return false;
	}


	public void function refreshProperties() {
		if (!structKeyExists(VARIABLES,'id')) { VARIABLES.id = createUUID(); }
		if (!structKeyExists(VARIABLES,'lastUpdated')) { VARIABLES.lastUpdated = ""; }
		if (!structKeyExists(VARIABLES,'isDeleted')) { VARIABLES.isDeleted = false; }
		if (!structKeyExists(VARIABLES,'createdDate')) { VARIABLES.createdDate = now(); }
	}
	public array function getHistory(numeric lastEdits = 5) hint="I retrieve this objects history" {
		return ORMExecuteQuery("FROM history WHERE objectID=:thisID AND className=:thisClass ORDER BY historyDate DESC",{thisID=this.getID(),thisClass=this.getClassName()},false,{maxresults=ARGUMENTS.lastEdits});
	}


	public void function preLoad() hint="call before this being populated" {}
	public void function postLoad() hint="call after this being populated" {
		this.refreshProperties();
	}
	public void function preInsert() hint="call before this being inserted" {}
	public void function postInsert() hint="call after this being inserted" {}
	public void function preUpdate(Struct oldData) hint="call before this being updated" {
		// this automatcially sets the lastUpdated timestamp before updating the object 
		VARIABLES.lastUpdated = now();

		// SAVE THE HISTORY OF THIS OBJECT BEFORE UPDATING
		var thisHistory = entityNew("history");
		thisHistory.setClassName(this.getClassName());
		thisHistory.setObjectID(this.getID());
		thisHistory.setValues(serializeJSON(ARGUMENTS.oldData));
		entitySave(thisHistory);
	}
	public void function postUpdate() hint="call after this being populated" {
	}
	public void function preDelete() hint="call before this being deleted" {}
	public void function postDelete() hint="call after this being deleted" {}


public void function dump(string label = "") description="dumps this" hint="I dump myself out to the page so you can see my methods and values" { 		
		metaData = GetMetaData(this);
		
		thisObjectDetails = structNew();
		thisObjectDetails.properties = structNew();
		thisObjectDetails.methods = structNew();
		if (structKeyExists(metaData,"EXTENDS")) { thisObjectDetails.extends = getExtendedObjects(metaData); }		
		// GET THE METHODS 
		
		thisObjectDetails.methods = getTheseMethods(metaData);
		// GET THE PROPERTIES 
		thisObjectDetails.properties = getTheseProperties(metaData);
		writeDump(var=thisObjectDetails,label=this.getClassName());
	}
	public void function dumpMethods() description="dumps this properties" hint="I the properties of this object" {
		writeDump(var=getTheseMethods(GetMetaData(this)),label=this.getClassName() & " methods");		
	}	
	public void function dumpProperties() description="dumps this properties" hint="I the properties of this object" {
		writeDump(var=this.getPropertyStruct(),label=this.getClassName() & " properties");		
	}
	public struct function getPropertyStruct() hint="returns a structure of current properties"  {
		return getTheseProperties(GetMetaData(this));
	}
	public string function toJSON() hint="I return a string of Java Script Object Notation (JSON) of this object" {
		return serializeJSON(this.getPropertyStruct());
	}

	private struct function getTheseProperties(struct metaData = GetMetaData(this)) {
		var properties = structNew();
		if (structKeyExists(arguments.metaData,"PROPERTIES")) {
			// loop through all defined properties 
			for (var i=1;i<=arrayLen(arguments.metaData.PROPERTIES);i++) {
				var property = arguments.metaData.PROPERTIES[i];
				if (isObject(property)) {
					properties[property.name] = property.getTheseProperties();
				} else if (isArray(property)) {
					properties[property.name] = arrayNew(1);
					for (var j=1;j<=arrayLen(property);j++) {
						var arrayValue = property[j];
						if (isObject(arrayValue)) {
							arrayAppend(properties[property.name],arrayValue.getTheseProperties());
						} else {
							arrayAppend(properties[property.name],arrayValue);
						}
					}
				} else {
					properties[property.name] = this.getProperty(property.name);
				} // close if object/array
			} // close For
			// lets get any super properties 
			if (structKeyExists(arguments.metaData,"EXTENDS") && structKeyExists(arguments.metaData.extends,"PROPERTIES")) {
				var extendedProperties = getTheseProperties(arguments.metaData.extends);
				// merge in the super properties 
				structAppend(properties,extendedProperties);
			}
		}
		return properties;
	}
	private struct function getTheseMethods(struct metaData = GetMetaData(this)) {
		var methods = structNew();
		if (structKeyExists(arguments.metaData,"functions")) {
			// loop through all defined properties 
			for (var i=1;i<=arrayLen(arguments.metaData.functions);i++) {
				var method = arguments.metaData.functions[i];
				if ((structKeyExists(method,"access")) && (method.access != "private")) {
					
					var keyName = method.name;
					keyName &= "(";
					for (var j=1;j<=arrayLen(method.parameters);j++) {
						var parameter = method.parameters[j];
						var parameterText = "";
						if (parameter.required){ parameterText &= "required"; }
						if (parameter.type != "any"){ parameterText &= " " & parameter.type; }
						parameterText &= " " & parameter.name;
						keyName &= trim(parameterText);
						if ((arrayLen(method.parameters) > 1) && (j != arrayLen(method.parameters))) {
							keyName &= ", ";
						}
					}
					keyName &= ")";
					
					methods[keyName] = method;					
				}
			}
			// lets get any super properties 
			if (structKeyExists(arguments.metaData,"EXTENDS") && structKeyExists(arguments.metaData.extends,"functions")) {
				var extendedMethods = getTheseMethods(arguments.metaData.extends);
				// merge in the super properties 
				structAppend(methods,extendedMethods);
			}
		}
		return methods;
	}
	private array function getExtendedObjects(struct metaData = GetMetaData(this)) {
		var exendedObjectArray = arrayNew(1);
		if (structKeyExists(arguments.metaData,"EXTENDS")) {
			arrayAppend(exendedObjectArray,arguments.metaData.extends.fullName);
			var extendedOject = getExtendedObjects(arguments.metaData.extends);
			for (i=1;i<=arrayLen(extendedOject);i++) {
				arrayAppend(exendedObjectArray,extendedOject[i]);
			}
		}
		return exendedObjectArray;
	}
}