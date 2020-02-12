library jbpm_json_to_form;

import 'dart:convert';

import 'package:flutter/material.dart';

class JbpmForm extends StatefulWidget {
  final String form;
  final Map formMap;
  final Widget buttonSave;
  final ValueChanged<dynamic> onChanged;

  const JbpmForm({
    @required this.form,
    @required this.onChanged,
    this.formMap,
    this.buttonSave,
  });

  @override
  _JbpmFormState createState() => _JbpmFormState(formMap ?? json.decode(form));
}

class _JbpmFormState extends State<JbpmForm> {
  final dynamic formGeneral;

  _JbpmFormState(this.formGeneral);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
