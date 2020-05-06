library multiple_checkboxes_formfield;

import 'package:flutter/material.dart';

/// [MultipleCheckboxFormField] is FormField has multiple checkboxes.
///
/// [items] is list with String
/// [items] must be has at least one item.
/// if [requiredAtLeastOne] `true`, must be check one.
/// if [requiredAtLeastOne] `true`, You can set [errorTextWhenRequireAtLeastOne] for error message.
/// Default message is `Please check item at least one`.
/// [listTileControlAffinity] property can you set checkbox position. Default is platform.
/// [initialCheckedIndexes] property can you set default checked list.
/// [autovalidate] property serve auto validate same as [CheckBoxListTile].
/// [onSaved] and [onChanged] fire when changed and validated, saved.
class MultipleCheckboxFormField extends StatefulWidget {
  final bool requireAtLeastOne;
  final bool autovalidate;
  final bool enabled;
  final List<String> items;
  final List<int> initialCheckedIndexes;
  final String errorTextWhenRequireAtLeastOne;
  final ListTileControlAffinity listTileControlAffinity;
  final Function(List<bool>) onSaved;
  final Function(int index, bool value) onChanged;

  MultipleCheckboxFormField({
    Key key,
    @required this.items,
    this.initialCheckedIndexes = const <int>[],
    this.requireAtLeastOne = false,
    this.autovalidate = false,
    this.enabled = true,
    this.listTileControlAffinity = ListTileControlAffinity.platform,
    this.errorTextWhenRequireAtLeastOne = 'Please check item at least one',
    this.onChanged,
    this.onSaved,
  }) {
    assert(this.items.length > 0);
    if (this.initialCheckedIndexes != null) {
      assert(this.items.length >= this.initialCheckedIndexes.length);
      assert(this
          .initialCheckedIndexes
          .every((int index) => this.items.length > index));
    }

    if (requireAtLeastOne) {
      assert(errorTextWhenRequireAtLeastOne.isNotEmpty);
    }
  }

  @override
  _MultipleCheckboxFormFieldState createState() =>
      _MultipleCheckboxFormFieldState();
}

class _MultipleCheckboxFormFieldState extends State<MultipleCheckboxFormField> {
  List<bool> _checked = <bool>[];
  final _formFieldKey = GlobalKey<FormFieldState>();
  TextStyle errorTextStyle = TextStyle(
    color: Colors.red,
  );

  @override
  void initState() {
    setState(() {
      _checked = List.generate(widget.items.length, (int index) => false);
      widget.initialCheckedIndexes.forEach((int index) {
        _checked[index] = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      key: _formFieldKey,
      enabled: widget.enabled,
      autovalidate: widget.autovalidate,
      initialValue: _checked,
      onSaved: (List<bool> checked) {
        setState(() {
          _checked = checked;
        });
        if (widget.onSaved != null) {
          widget.onSaved(_checked);
        }
      },
      validator: (value) {
        if (value == null) {
          return widget.errorTextWhenRequireAtLeastOne;
        }

        if (widget.requireAtLeastOne &&
            value.every(((item) => item == false))) {
          return widget.errorTextWhenRequireAtLeastOne;
        }
        return null;
      },
      builder: (FormFieldState<List<bool>> state) {
        List<CheckboxListTile> checkboxes = widget.items.map((item) {
          int index = widget.items.indexOf(item);
          bool value = _checked[index];
          return CheckboxListTile(
            controlAffinity: widget.listTileControlAffinity,
            value: value,
            title: Text(item),
            onChanged: (bool value) {
              setState(() {
                _checked[index] = value;
              });
              widget.onChanged(index, value);
              state.didChange(_checked);
            },
          );
        }).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...checkboxes,
            if (state.hasError)
              _MultipleCheckboxFormFieldError(text: state.errorText),
          ],
        );
      },
    );
  }
}

class _MultipleCheckboxFormFieldError extends StatelessWidget {
  final String text;
  const _MultipleCheckboxFormFieldError({
    Key key,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
