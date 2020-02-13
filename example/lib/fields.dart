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
        "id": "field_831172453834416E10",
        "name": "caseFile_ordered",
        "label": "CaseFile_ordered",
        "required": false,
        "readOnly": false,
        "validateOnChange": true,
        "binding": "caseFile_ordered",
        "standaloneClassName": "java.lang.Boolean",
        "code": "CheckBox",
        "serializedFieldClassName":
            "org.kie.workbench.common.forms.fields.shared.fieldTypes.basic.checkBox.definition.CheckBoxFieldDefinition"
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
