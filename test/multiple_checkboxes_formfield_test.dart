import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiple_checkboxes_formfield/multiple_checkboxes_formfield.dart';

void main() {
  group('MultipleCheckboxFormField Basic', () {
    testWidgets('Test 3 items touch and save', (WidgetTester tester) async {
      final _formKey = GlobalKey<FormState>();
      List<String> items = List.generate(3, (index) => 'Question ${index + 1}');
      List<bool> result = <bool>[false, false, false];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              height: 300,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    MultipleCheckboxFormField(
                      requireAtLeastOne: true,
                      initialCheckedIndexes: [],
                      items: items,
                      onChanged: (int index, bool value) {
                        result[index] = value;
                      },
                      onSaved: (List<bool> value) {
                        result = value;
                      },
                    ),
                    RaisedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        _formKey.currentState.save();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text(items[0]), findsOneWidget);
      expect(find.text(items[1]), findsOneWidget);
      expect(find.text(items[2]), findsOneWidget);

      await tester.tap(find.text(items[0]));
      await tester.pump();
      expect(result, <bool>[true, false, false]);

      await tester.tap(find.text(items[1]));
      await tester.pump();
      expect(result, <bool>[true, true, false]);

      await tester.tap(find.text(items[0]));
      await tester.pump();
      expect(result, <bool>[false, true, false]);

      await tester.tap(find.text('Submit'));
      await tester.pump();
      expect(result, <bool>[false, true, false]);
    });
  });

  group('MultipleCheckboxFormField with Validation', () {
    testWidgets('validate with at least one', (WidgetTester tester) async {
      final _formKey = GlobalKey<FormState>();
      List<String> items = List.generate(3, (index) => 'Question ${index + 1}');
      List<bool> result = <bool>[false, false, false];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              height: 300,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    MultipleCheckboxFormField(
                      requireAtLeastOne: true,
                      initialCheckedIndexes: [],
                      items: items,
                      onChanged: (int index, bool value) {
                        result[index] = value;
                      },
                      onSaved: (List<bool> value) {
                        result = value;
                      },
                    ),
                    RaisedButton(
                      key: Key('submit_button'),
                      child: Text('Submit'),
                      onPressed: () {
                        _formKey.currentState.validate();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text(items[0]), findsOneWidget);
      expect(find.text(items[1]), findsOneWidget);
      expect(find.text(items[2]), findsOneWidget);

      await tester.tap(find.byKey(Key('submit_button')));
      await tester.pump();

      expect(find.text('Please check item at least one'), findsOneWidget);

      await tester.tap(find.text(items[1]));
      await tester.pump();

      await tester.tap(find.byKey(Key('submit_button')));
      await tester.pump();

      expect(find.text('Please check item at least one'), findsNothing);
    });
  });

  testWidgets('initial checked value', (WidgetTester tester) async {
    final _formKey = GlobalKey<FormState>();
    List<String> items = List.generate(3, (index) => 'Question ${index + 1}');
    List<bool> result = <bool>[false, false, false];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Container(
            height: 300,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  MultipleCheckboxFormField(
                    items: items,
                    initialCheckedIndexes: [
                      0
                    ], // `index` must be more than `items.length`
                    onChanged: (int index, bool value) {
                      result[index] = value;
                    },
                    onSaved: (List<bool> value) {
                      result = value;
                    },
                  ),
                  RaisedButton(
                    key: Key('submit_button'),
                    child: Text('Submit'),
                    onPressed: () {
                      _formKey.currentState.validate();
                      _formKey.currentState.save();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(Key('submit_button')));
    await tester.pump();

    expect(result, <bool>[true, false, false]);
  });
}
