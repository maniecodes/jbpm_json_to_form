library jbpm_json_to_form;

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JbpmForm extends StatefulWidget {
  final String form;
  final Map formMap;
  final double padding;
  final Map errorMessages;
  final Widget buttonSave;
  final Map decorations;
  final Function actionSave;
  final ValueChanged<dynamic> onChanged;

  const JbpmForm({
    @required this.form,
    @required this.onChanged,
    this.formMap,
    this.padding,
    this.errorMessages = const {},
    this.decorations = const {},
    this.buttonSave,
    this.actionSave,
  });

  @override
  _JbpmFormState createState() => _JbpmFormState(formMap ?? json.decode(form));
}

class _JbpmFormState extends State<JbpmForm> {
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = true;
  bool _hasValidMime = false;
  FileType _pickingType;

  final dynamic formGeneral;

  int radioValue;

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

  bool labelHidden(item) {
    if (item.containsKey('hiddenLabel')) {
      if (item['hiddenLabel'] is bool) {
        return !item['hiddenLabel'];
      }
    } else {
      return true;
    }
    return false;
  }

  List<Widget> jbpmToForm() {
    List<Widget> listWidget = List<Widget>();
    print('I got inside JBPM');
    for (var i = 0; i < formGeneral['fields'].length; i++) {
      Map item = formGeneral['fields'][i];

      if (item['code'] == 'TextBox' ||
          item['code'] == 'TextArea' ||
          item['code'] == 'IntegerBox') {
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
                  keyboardType: item['code'] == 'IntegerBox'
                      ? TextInputType.number
                      : TextInputType.text,
                  initialValue: formGeneral['fields'][i]['value'] ?? null,
                  decoration: item['decoration'] ??
                      widget.decorations[item['code']] ??
                      InputDecoration(
                        hintText: item['placeholder'] ?? "",
                        helperText: item['helpText'] ?? "",
                      ),
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

      if (item['code'] == 'CheckBox') {
        bool formValue = false;

        var val = formGeneral['fields'][i]['value'];

        if (item['value'] != null && (val != false && val != 'false')) {
          formValue = true;
        }
        List<Widget> checkboxes = [];
        if (labelHidden(item)) {
          checkboxes.add(Text(item['label'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)));
        }

        checkboxes.add(
          Row(
            children: <Widget>[
              Expanded(child: Text(formGeneral['fields'][i]['label'])),
              Checkbox(
                value: formValue,
                onChanged: (bool value) {
                  this.setState(
                    () {
                      formGeneral['fields'][i]['value'] = value;
                      _handleChanged();
                    },
                  );
                },
              ),
            ],
          ),
        );

        listWidget.add(
          new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: checkboxes,
            ),
          ),
        );
      }

      if (item['code'] == 'RadioGroup') {
        listWidget.add(Container(
          margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Text(
            item['label'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ));

        radioValue = item['value'];
        for (var i = 0; i < item['options'].length; i++) {
          listWidget.add(Row(
            children: <Widget>[
              Expanded(child: Text(item['options'][i]['text'])),
              Radio<int>(
                  value: int.parse(item['options'][i]['value']),
                  groupValue: radioValue == null ? 1 : radioValue,
                  onChanged: (int value) {
                    this.setState(() {
                      radioValue = value;
                      item['value'] = value;
                      _handleChanged();
                    });
                  }),
            ],
          ));
        }
      }

      if (item['code'] == 'Document') {
        listWidget.add(Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  setState(() => _loadingPath = true);
                  try {
                    _path = null;
                    _paths = await FilePicker.getMultiFilePath(
                        type: _pickingType, fileExtension: _extension);
                    formGeneral['fields'][i]['value'] = _paths;
                    _handleChanged();
                  } on PlatformException catch (e) {
                    print("Unsupported operation" + e.toString());
                  }
                  if (!mounted) return;
                  setState(() {
                    _loadingPath = false;
                    _fileName = _path != null
                        ? _path.split('/').last
                        : _paths != null ? _paths.keys.toString() : '...';
                  });
                  //  }
                },
                child: Text('Open file'),
              ),
              Builder(
                builder: (BuildContext context) => _loadingPath
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: const CircularProgressIndicator())
                    : _path != null || _paths != null
                        ? new Container(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            height: MediaQuery.of(context).size.height * 0.50,
                            child: new Scrollbar(
                                child: new ListView.separated(
                              itemCount: _paths != null && _paths.isNotEmpty
                                  ? _paths.length
                                  : 1,
                              itemBuilder: (BuildContext context, int index) {
                                final bool isMultiPath =
                                    _paths != null && _paths.isNotEmpty;
                                final String name = 'File $index: ' +
                                    (isMultiPath
                                        ? _paths.keys.toList()[index]
                                        : _fileName ?? '...');
                                final path = isMultiPath
                                    ? _paths.values.toList()[index].toString()
                                    : _path;

                                return new ListTile(
                                  title: new Text(
                                    name,
                                  ),
                                  subtitle: new Text(path),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      new Divider(),
                            )),
                          )
                        : new Container(),
              ),
            ],
          ),
        ));
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
    // print(formGeneral);
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
