import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jbpm_json_to_form/jbpm_to_form.dart';

class Fields extends StatefulWidget {
  Fields({Key key}) : super(key: key);
  @override
  _FieldsState createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  String form = json.encode({
    'autoValidated': false,
    'fields': [
      {
        "maxLength": 100,
        "placeHolder": "Employee",
        "id": "field_740177746345817E11",
        "name": "employee",
        "label": "Employee",
        "required": true,
        "readOnly": false,
        "validateOnChange": true,
        "binding": "employee",
        "standaloneClassName": "java.lang.String",
        "code": "TextBox",
        "serializedFieldClassName":
            "org.kie.workbench.common.forms.fields.shared.fieldTypes.basic.textBox.definition.TextBoxFieldDefinition"
      },
      {
        "placeHolder": "Reason",
        "rows": 4,
        "id": "field_282038126127015E11",
        "name": "reason",
        "label": "Reason",
        "required": true,
        "readOnly": false,
        "validateOnChange": true,
        "binding": "reason",
        "standaloneClassName": "java.lang.String",
        "code": "TextArea",
        "serializedFieldClassName":
            "org.kie.workbench.common.forms.fields.shared.fieldTypes.basic.textArea.definition.TextAreaFieldDefinition"
      },
      {
        "maxDocuments": 0,
        "id": "field_1361",
        "name": "uploadfiles",
        "label": "Upload Files",
        "required": true,
        "readOnly": false,
        "validateOnChange": true,
        "helpMessage": "",
        "binding": "uploadfiles",
        "standaloneClassName": "org.jbpm.document.DocumentCollection",
        "code": "DocumentCollection",
        "serializedFieldClassName":
            "org.kie.workbench.common.forms.jbpm.model.authoring.documents.definition.DocumentCollectionFieldDefinition"
      },
      {
        "id": "field_206",
        "name": "intern",
        "label": "Intern",
        "required": true,
        "readOnly": false,
        "validateOnChange": true,
        "helpMessage": "",
        "binding": "intern",
        "standaloneClassName": "java.lang.Boolean",
        "code": "CheckBox",
        "serializedFieldClassName":
            "org.kie.workbench.common.forms.fields.shared.fieldTypes.basic.checkBox.definition.CheckBoxFieldDefinition"
      },
      {
        "options": [
          {"value": "Male", "text": "Male"},
          {"value": "Female", "text": "Female"}
        ],
        "inline": false,
        "dataProvider": "",
        "id": "field_24332",
        "name": "gender",
        "label": "Gender",
        "required": true,
        "readOnly": false,
        "validateOnChange": true,
        "helpMessage": "",
        "binding": "gender",
        "standaloneClassName": "java.lang.String",
        "code": "RadioGroup",
        "serializedFieldClassName":
            "org.kie.workbench.common.forms.fields.shared.fieldTypes.basic.selectors.radioGroup.definition.StringRadioGroupFieldDefinition"
      },
      {
        "id": "field_2355",
        "name": "document",
        "label": "Document",
        "required": false,
        "readOnly": false,
        "validateOnChange": true,
        "helpMessage": "",
        "binding": "document",
        "standaloneClassName": "org.jbpm.document.Document",
        "code": "Document",
        "serializedFieldClassName":
            "org.kie.workbench.common.forms.jbpm.model.authoring.document.definition.DocumentFieldDefinition"
      },
      {
        "options": [
          {"value": "Lagos", "text": "Lagos"},
          {"value": "Abuja", "text": "Abuja"}
        ],
        "addEmptyOption": true,
        "dataProvider": "",
        "id": "field_248",
        "name": "states",
        "label": "States",
        "required": true,
        "readOnly": false,
        "validateOnChange": true,
        "helpMessage": "",
        "binding": "states",
        "standaloneClassName": "java.lang.String",
        "code": "ListBox",
        "serializedFieldClassName":
            "org.kie.workbench.common.forms.fields.shared.fieldTypes.basic.selectors.listBox.definition.StringListBoxFieldDefinition"
      }
    ]
  });
  dynamic response;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Login"),
      ),
      body: new SingleChildScrollView(
        child: new Center(
          child: new Column(children: <Widget>[
            new Container(
              child: new Text(
                "Evaluation Form",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.only(top: 10.0),
            ),
            new JbpmForm(
              form: form,
              onChanged: (dynamic response) {
                this.response = response;
              },
              actionSave: (data) {
                print(data);
              },
              buttonSave: new Container(
                height: 40.0,
                color: Colors.blueAccent,
                child: Center(
                  child: Text("Submit",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
