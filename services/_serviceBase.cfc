component extends="utilities.object" displayname="_serviceBase" hint="I am the base of all services" {
	public _serviceBase function init(){ return super.init(); }


	public any function saveObject(required any objectToSave) {
		try {
			if (ARGUMENTS.objectToSave.doesValidate()) {
				transaction {
					entitySave(ARGUMENTS.objectToSave);
					transaction action="commit";
				}
			}
		} catch (any e) {
			writeDump(e);
			abort;
		}
		return ARGUMENTS.objectToSave;		
	} // close saveObject()


	public any function setValuesInObject(required any objectToInsertInto,required struct values) {
		// make sure we have the latest values
		ARGUMENTS.objectToInsertInto.refreshProperties();
		for (var key in ARGUMENTS.values) {
			if ((key != "id") && (isSimpleValue(ARGUMENTS.values[key])) && (ARGUMENTS.objectToInsertInto.hasProperty(key))) {
				ARGUMENTS.objectToInsertInto.setProperty(key,trim(ARGUMENTS.values[key]));
			}
		}
		return ARGUMENTS.objectToInsertInto;
	} // close setValuesInObject()
}