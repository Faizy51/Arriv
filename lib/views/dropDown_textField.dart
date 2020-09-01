import 'package:Arriv/constants.dart';
import 'package:Arriv/models/stops.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class DropDownTextField extends StatelessWidget {
  const DropDownTextField({
    Key key,
    @required TextEditingController textInputController,
    @required String labelText
  }) : _textController = textInputController, _labelText = labelText, super(key: key);

  final TextEditingController _textController;
  final String _labelText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: DROPDOWN_WIDTH, 
        height: DROPDOWN_HEIGHT,
        child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: _textController,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: _labelText, border: OutlineInputBorder())),
        suggestionsCallback: (pattern) {
          return StopsService.getSuggestions(pattern);
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            // leading: Icon(Icons.location_city),
            title: Text(suggestion),
            // subtitle: Text('9:00'),
          );
        },
        onSuggestionSelected: (selectedValue) {
          _textController.text = selectedValue;
        },
      ),
    );
  }
}
