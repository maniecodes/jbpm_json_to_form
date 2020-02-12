library jbpm_json_to_form;

import 'dart:convert';

import 'package:flutter/material.dart';

class JbpmForm extends StatefulWidget {
  final String form;
  final Map formMap;
  final double padding;
  final Map errorMessages;
  final Widget buttonSave;
  final Function actionSave;
  final ValueChanged<dynamic> onChanged;

  const JbpmForm({
    @required this.form,
    @required this.onChanged,
    this.formMap,
    this.padding,
    this.errorMessages = const {},
    this.buttonSave,
    this.actionSave,
  });

  @override
  _JbpmFormState createState() => _JbpmFormState(formMap ?? json.decode(form));
}

class _JbpmFormState extends State<JbpmForm> {
  final dynamic formGeneral;

  String isRequired(item, value) {
    if (value.isEmpty) {
      return widget.errorMessages[item['name']] ?? 'Please enter some text';
    }
    return null;
  }

  String validateEmail(item, String value) {
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }
    return 'Email is not valid';
  }

  List<Widget> jbpmToForm() {
    List<Widget> listWidget = List<Widget>();
    for (var i = 0; i < formGeneral['fields'].length; i++) {
      Map item = formGeneral['fields'][i];

      if (item['code'] == 'TextBox' ||
          item['code'] == 'TextArea' ||
          item['code'] == 'IntergerBox') {
        listWidget.add(
          Container(
            margin: EdgeInsets.only(top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    item['label'],
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                TextFormField(
                  onSaved: (val) {
                    var d = '';
                    setState(() => d = val);
                    print(d);
                  },
                  controller: null,
                  keyboardType: item['code'] == 'IntergerBox'
                      ? TextInputType.number
                      : TextInputType.text,
                  initialValue: formGeneral['fields'][i]['value'] ?? null,
                  maxLength: item['maxLength'] ?? null,
                  maxLines: item['code'] == 'TextArea' ? 10 : 1,
                  onChanged: (String value) {
                    formGeneral['fields'][i]['value'] = value;
                    _handleChanged();
                  },
                  readOnly: item['readOnly'] ?? false,
                  obscureText: item['code'] == 'Password' ? true : false,
                  validator: (value) {
                    if (item['code'] == 'Email') {
                      return validateEmail(item, value);
                    }

                    if (item.containsKey('required')) {
                      if (item['required'] == true ||
                          item['required'] == 'True' ||
                          item['required'] == 'true') {
                        return isRequired(item, value);
                      }
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        );
      }
    }

    if (widget.buttonSave != null) {
      listWidget.add(
        Container(
          margin: EdgeInsets.only(top: 10.0),
          child: InkWell(
            onTap: () {
              if (_formKey.currentState.validate()) {
                widget.actionSave(formGeneral);
              }
            },
            child: widget.buttonSave,
          ),
        ),
      );
    }
    return listWidget;
  }

  _JbpmFormState(this.formGeneral);

  void _handleChanged() {
    widget.onChanged(formGeneral);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(formGeneral);
    return Form(
      autovalidate: formGeneral['autoValidated'] ?? false,
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(widget.padding ?? 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: jbpmToForm(),
        ),
      ),
    );
  }
}
