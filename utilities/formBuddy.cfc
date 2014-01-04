/**
*
* @file  /Volumes/Websites/integrated.sites/utilities/formBuddy.cfc
* @author  Christopher Vachon
* @description Replaces cfc.formBuddy. Changed to be completely self contianed.
*
* @usage
* signinForm = new utilities.formBuddy();
* signinForm.class("frmStandard");
* signinForm.action("/to/my/submit");
* signinForm.method("POST"); // GET / POST
* signinForm.id("MyID");
* signinForm.title("Sign In");
* signinForm.name("MyName");
* signinForm.validationErrors({"name"="My Validation Error Message"});
* signinForm.displayValidationErrorAfterLabel(false); // display validation errors after the label or at the end of the element block
* 
* signinForm.addElement({
*	label="Name",
*	type="text", // text, password, checkbox, radio, textarea, select, hidden, javaSelection, etc...
*	name="name",
*	value="My Name",
* 	validationError="My Validation Error Message",
* 	class="myElementClass",
* 	id="myElementID",
* 	data={country="CA"},
* 	labelClass="myLabelClass",
* 	labelID="myLabelID",
* 	blockClass="myBlockClass",
* 	blockID="myBlockID",
* 	// CheckBox, Radio, Select
* 	values = [
* 		{ label="Ontaio", value="ON", data={country="CA"} },
* 		{ label="California", value="CA", data={country="US"} }
*	] 
* 	
* });	
* writeOutput(signinForm.getForm());
*/

component extends="object" output="false" displayname="form buddy"  {

	property name="action";
	property name="method";
	property name="name";
	property name="class";
	property name="id";
	property name="title";
	property name="elements" type="array";

	property name="displayValidationErrorAfterLabel" type="boolean";
	property name="validationErrors" type="struct";

	public formBuddy function init() {
		VARIABLES.action = "/";
		VARIABLES.method = "post";
		VARIABLES.name = "form";
		VARIABLES.class = "";
		VARIABLES.id = "";
		VARIABLES.title = "";

		VARIABLES.displayValidationErrorAfterLabel = false;

		VARIABLES.elements = arrayNew(1);
		VARIABLES.validationErrors = structNew();

		VARIABLES.newLine = chr(10) & chr(13);

		return super.init();
	}
	public any function validationErrors() {
		var propertyName = "validationErrors";
		if (structCount(ARGUMENTS) == 0) {
			return this.get(propertyName);
		} else {
			if (!isStruct(ARGUMENTS[1])) { throw("EXPECTED STRUCT to be passed in to #propertyName#") }
			this.set(propertyName,ARGUMENTS[1]);
		}		
	}
	public any function displayValidationErrorAfterLabel() {
		var propertyName = "displayValidationErrorAfterLabel";
		if (structCount(ARGUMENTS) == 0) {
			return this.get(propertyName);
		} else {
			if (!isBoolean(ARGUMENTS[1])) { throw("EXPECTED BOOLEAN to be passed in to #propertyName#") }
			this.set(propertyName,ARGUMENTS[1]);
		}
	}	
	public any function action() {
		var propertyName = "action";
		if (structCount(ARGUMENTS) == 0) {
			return this.get(propertyName);
		} else {
			this.set(propertyName,ARGUMENTS[1]);
		}
	}
	public any function title() {
		var propertyName = "title";
		if (structCount(ARGUMENTS) == 0) {
			return this.get(propertyName);
		} else {
			this.set(propertyName,ARGUMENTS[1]);
		}
	}	
	public any function method() {
		var propertyName = "method";
		if (structCount(ARGUMENTS) == 0) {
			return this.get(propertyName);
		} else {
			if (ARGUMENTS[1] == "get" || ARGUMENTS[1] == "post") {
				this.set(propertyName,ARGUMENTS[1]);
			} else {
				throw("Invalid Value [#ARGUMENTS[1]#] Method can only be a 'Get' or a 'Post'");
			}
		}
	}	
	public any function name() {
		var propertyName = "name";
		if (structCount(ARGUMENTS) == 0) {
			return this.get(propertyName);
		} else {
			this.set(propertyName,ARGUMENTS[1]);
		}
	}	
	public any function class() {
		var propertyName = "class";
		if (structCount(ARGUMENTS) == 0) {
			return this.get(propertyName);
		} else {
			this.set(propertyName,ARGUMENTS[1]);
		}
	}
	public any function id() {
		var propertyName = "id";
		if (structCount(ARGUMENTS) == 0) {
			return this.get(propertyName);
		} else {
			this.set(propertyName,ARGUMENTS[1]);
		}
	}				
	public void function set(required string property, required any value) {
		VARIABLES[trim(ARGUMENTS.property)] = ARGUMENTS.value;
	}
	public any function get(required string property) {
		return VARIABLES[trim(ARGUMENTS.property)];
	}
	public string function getForm() {
		var _output = "<form";
		for (property in listToArray("name,id,class,action,method,title")) {
			if (len(VARIABLES[property])) { _output &= " #property#='#VARIABLES[property]#'"; }
		}
		_output &= ">" & VARIABLES.newLine;

		for (var _element in VARIABLES.elements) {

			if (structKeyExists(VARIABLES.validationErrors,_element.name)) {
				_element.validationError = VARIABLES.validationErrors[_element.name];
			}

			switch(_element.type) {
				case "select":
					_output &= buildSelect(_element);
					break;
				case "radio":
				case "checkbox":
					_output &= buildMultiSelect(_element);
					break;
				case "textarea": 
					_output &= buildTextarea(_element);
					break;
				case "javaSelection":
					_output &= buildJavaSelectionElement(_element);
					break;
				default: // text, password...
					_output &= buildSimpleElement(_element);
					break;
			}
		}

		_output &= "</form><!-- close #VARIABLES.name# -->" & VARIABLES.newLine;
		return _output;
	}
	public void function addElement() {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		for (var requiredArg in listToArray("name")) {
			if (!structKeyExists(ARGUMENTS,requiredArg)) { throw("REQUIRED PROPERTY MISSING [#requiredArg#]"); }
		}
		for (var requiredValueArg in listToArray("name,label,type")) {
			if (structKeyExists(ARGUMENTS,requiredValueArg) && len(ARGUMENTS[requiredValueArg]) == 0) { throw("INVALID VALUE #requiredValueArg# [#ARGUMENTS[requiredValueArg]#]"); }
		}
		if (!structKeyExists(ARGUMENTS,"type")) { ARGUMENTS.type = "text"; }

		var _element = structNew();
		for (var key in listToArray("name,label,type,value,validationError,class,id,blockClass,labelClass,blockID,labelID")) {
			if (structKeyExists(ARGUMENTS,key)) { _element[key] = trim(ARGUMENTS[key]); }
		}
		if (structKeyExists(ARGUMENTS,"data")) {
			 if (isStruct(ARGUMENTS.data)) { _element["data"] = ARGUMENTS.data; }
			 else { throw("DATA must be a structure: { name=value, name=value }"); }
		}
		switch(_element.type) {
			case "javaSelection":
				if (structKeyExists(ARGUMENTS,"json")) {
					_element.json = trim(ARGUMENTS.json);
				} else {
					throw("JAVA SELECTIONS REQUIRE A [JSON] SELECTION SOURCE");
				}
			case "radio":
			case "checkbox":
			case "select":
				if (!structKeyExists(ARGUMENTS,"values") || !isArray(ARGUMENTS.values)) { throw("#_element.type# REQUIRES an Array of Values: values: [{label='Canada',value='CA'}]"); }
				for (var arg in ARGUMENTS.values) {
					if (!isStruct(arg)) { throw("INVALID VALUE SET PASSED IN VALUES | element #_element.name#"); }
					if (!structKeyExists(arg, "label") || !structKeyExists(arg, "value")) {
						throw("INVALID VALUE SET PASSED IN VALUES | REQUIRED {label='Canada',value='CA'} | element #_element.name#");
					}
				}
				_element.values = ARGUMENTS.values;
				break;
		}
		arrayAppend(VARIABLES.elements, _element);
	}

	private string function buildSelect(required struct element) {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }

		var _class = "";
		if (structKeyExists(ARGUMENTS,"class")) { _class = ARGUMENTS.class; } 
		if (len(_class) > 0) { _class = " class='#_class#'"; }
		var _id = "";
		if (structKeyExists(ARGUMENTS,"id")) { _id = ARGUMENTS.id; } 
		if (len(_id) > 0) { _id = " id='#_id#'"; }
		var _data = "";
		if (structKeyExists(ARGUMENTS,"data")) {
			for (var arg in ARGUMENTS.data) {
				_data &= " data-#lcase(arg)#='#ARGUMENTS.data[arg]#'";
			}
		}

		var _value = ((structKeyExists(ARGUMENTS,"value"))?ARGUMENTS.value:'');
		var _return = wrapLabel(ARGUMENTS);
		_return &= "<select#_id##_class# name='#ARGUMENTS.name#'#_data#>" & VARIABLES.newLine;
		for (var elem in ARGUMENTS.values) {
			var _selected = ((elem.value == _value)?" selected='selected'":"");
			var _opt_class = "";
			if (structKeyExists(elem,"class")) { _opt_class = elem.class; } 
			if (len(_opt_class) > 0) { _opt_class = " class='#_opt_class#'"; }
			var _data = "";
			if (structKeyExists(elem,"data")) {
				for (var arg in elem.data) {
					_data &= " data-#lcase(arg)#='#elem.data[arg]#'";
				}
			}
			_return &= "<option#_opt_class##_data# value='#elem.value#'#_selected#>#elem.label#</option>" & VARIABLES.newLine;
		}
		_return &= "</select>" & VARIABLES.newLine;
		return wrapElement(ARGUMENTS,_return);
	}
	private string function buildMultiSelect(required struct element) {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }

		var _class = "";
		if (structKeyExists(ARGUMENTS,"class")) { _class = ARGUMENTS.class; } 
		if (len(_class) > 0) { _class = " class='#_class#'"; }
		var _id = "";
		if (structKeyExists(ARGUMENTS,"id")) { _id = ARGUMENTS.id; } 
		if (len(_id) > 0) { _id = " id='#_id#'"; }

		var _value = ((structKeyExists(ARGUMENTS,"value"))?ARGUMENTS.value:'');
		var _return = wrapLabel(ARGUMENTS);
		for (var elem in ARGUMENTS.values) {
			var _checked = ((elem.value == _value)?"checked='checked'":"");
			if (structKeyExists(elem,"class")) { _class = elem.class; } 
			if (len(_class) > 0) { _class = " class='#_class#'"; }
			var _data = "";
			if (structKeyExists(elem,"data")) {
				for (var arg in elem.data) {
					_data &= " data-#lcase(arg)#='#elem.data[arg]#'";
				}
			}				
			_return &= "<span><input#_id##_class##_data# type='#ARGUMENTS.type#' name='#ARGUMENTS.name#' value='#elem.value#' #_checked#/> #elem.label#</span>" & VARIABLES.newLine;
		}
		return wrapElement(ARGUMENTS,_return);
	}
	private string function buildTextarea(required struct element) {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }

		var _class = "";
		if (structKeyExists(ARGUMENTS,"class")) { _class = ARGUMENTS.class; } 
		if (len(_class) > 0) { _class = " class='#_class#'"; }
		var _id = "";
		if (structKeyExists(ARGUMENTS,"id")) { _id = ARGUMENTS.id; } 
		if (len(_id) > 0) { _id = " id='#_id#'"; }
		var _data = "";
		if (structKeyExists(ARGUMENTS,"data")) {
			for (var arg in ARGUMENTS.data) {
				_data &= " data-#lcase(arg)#='#ARGUMENTS.data[arg]#'";
			}
		}	

		var _value = ((structKeyExists(ARGUMENTS,"value"))?ARGUMENTS.value:'');
		var _return = wrapLabel(ARGUMENTS);
		_return &= "<textarea#_id##_class##_data# name='#ARGUMENTS.name#'>#_value#</textarea>" & VARIABLES.newLine;
		return wrapElement(ARGUMENTS,_return);
	}
	private string function buildSimpleElement(required struct element) {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }

		var _class = "";
		if (structKeyExists(ARGUMENTS,"class")) { _class = ARGUMENTS.class; } 
		if (len(_class) > 0) { _class = " class='#_class#'"; }
		var _id = "";
		if (structKeyExists(ARGUMENTS,"id")) { _id = ARGUMENTS.id; } 
		if (len(_id) > 0) { _id = " id='#_id#'"; }
		var _data = "";
		if (structKeyExists(ARGUMENTS,"data")) {
			for (var arg in ARGUMENTS.data) {
				_data &= " data-#lcase(arg)#='#ARGUMENTS.data[arg]#'";
			}
		}

		var _value = ((structKeyExists(ARGUMENTS,"value"))?ARGUMENTS.value:'');
		var _input = "<input#_id##_class##_data# type='#ARGUMENTS.type#' name='#ARGUMENTS.name#' value='#_value#' />" & VARIABLES.newLine;
		if (ARGUMENTS.type == "hidden") {
			return _input;
		} else {
			var _return = wrapLabel(ARGUMENTS);
			_return &= _input;
			return wrapElement(ARGUMENTS,_return);
		}
	}
	private string function buildJavaSelectionElement(required struct element) {
		if (isStruct(ARGUMENTS[1])) { ARGUMENTS = reduceStructLevel(ARGUMENTS[1]); }
		var _input = "<div class='javaSelect'>";
		for (value in element.values) {
			_input &= "<span class='item removeOnClick'><input type='hidden' name='#ARGUMENTS.name#' value='#value.value#'> <span class='label'>#value.label#</span></span>";
		}
		_input &= "<span class='btn btnAdd#ARGUMENTS.name#' data-json='#element.json#' data-name='#ARGUMENTS.name#'>Add #ARGUMENTS.label#</span>";
		//_input &= "<span class='btn clear'>Clear</span>";
		_input &= "</div>";
		var _return = wrapLabel(ARGUMENTS);
		_return &= _input;
		return wrapElement(ARGUMENTS,_return);		
	}
	private string function wrapElement(required struct element,required string output) {
		var _blockClass = "block";
		if (structKeyExists(ARGUMENTS.element,"blockClass")) { _blockClass = ARGUMENTS.element.blockClass; } 
		var _blockID = "";
		if (structKeyExists(ARGUMENTS.element,"blockID")) { _blockID = ARGUMENTS.element.blockID; } 
		if (len(_blockID) > 0) { _blockID = " id='#_blockID#'"; }

		var _return = "<div#_blockID# class='#_blockClass# #ARGUMENTS.element.type# #ARGUMENTS.element.name#'>"  & VARIABLES.newLine & ARGUMENTS.output;
		if (!VARIABLES.displayValidationErrorAfterLabel) {
			_return &= wrapValidationError(ARGUMENTS.element);
		}
		_return &= "</div><!-- close #ARGUMENTS.element.name# -->" & VARIABLES.newLine;
		return _return;
	}
	private string function wrapLabel(required struct element) {
		_return = "";
		var _labelClass = "";
		if (structKeyExists(ARGUMENTS.element,"labelClass")) { _labelClass = ARGUMENTS.element.labelClass; }
		if (len(_labelClass) > 0) { _labelClass = " class='#_labelClass#'"; }
		var _labelID = "";
		if (structKeyExists(ARGUMENTS.element,"labelID")) { _labelID = ARGUMENTS.element.labelID; }
		if (len(_labelID) > 0) { _labelID = " id='#_labelID#'"; }

		if (structKeyExists(ARGUMENTS.element,"label") && len(ARGUMENTS.element.label)) {
			_return &= "<label#_labelID##_labelClass# for='#ARGUMENTS.element.name#'>#ARGUMENTS.element.label#</label>" & VARIABLES.newLine;
		}
		if (VARIABLES.displayValidationErrorAfterLabel) {
			_return &= wrapValidationError(ARGUMENTS.element);
		}
		return _return;
	}
	private string function wrapValidationError(required struct element) {
		_return = "";
		if (structKeyExists(ARGUMENTS.element,"validationError") && len(ARGUMENTS.element.validationError)) {
			_return &= "<p class='error'>#ARGUMENTS.element.validationError#</p>" & VARIABLES.newLine;
		}
		return _return;
	}
}