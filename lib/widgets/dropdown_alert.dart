import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miru_anime/constants/app_colors.dart';

enum DropdownAlertType { checkbox, radio }

class DropdownAlert extends StatefulWidget {
  final String labelPefix;
  final Map<Object, Map<String, Object>> filterMap;
  final DropdownAlertType type;
  final Function? fun;

  const DropdownAlert(
      {Key? key,
      required this.filterMap,
      required this.type,
      this.fun,
      required this.labelPefix})
      : super(key: key);

  @override
  _DropdownAlertState createState() => _DropdownAlertState();
}

class _DropdownAlertState extends State<DropdownAlert> {
  String _dropDownLabel = '';
  String get _prefix => widget.labelPefix;

  Map<Object, Map<String, Object>> get _filterMap => widget.filterMap;

  void _updateGenreDropdownLabel() {
    final numberOfSelected =
        _filterMap.values.where((final x) => x['selected'] as bool).length;
    if (numberOfSelected == 0 && widget.type == DropdownAlertType.checkbox) {
      setState(() => _dropDownLabel = '$_prefix · Tutti');
    } else {
      setState(() => _dropDownLabel = _prefix);
    }
    if (numberOfSelected == 1) {
      final String label = _filterMap.values
          .firstWhere((final x) => x['selected'] as bool)['label'] as String;
      setState(() => _dropDownLabel = '$_prefix · $label');
    }
    if (numberOfSelected > 1) {
      setState(
          () => _dropDownLabel = '$_prefix · $numberOfSelected selezionati');
    }
  }

  @override
  void initState() {
    super.initState();
    _updateGenreDropdownLabel();
  }

  final accent = AppColors.purple;
  final alphaAccent = AppColors.purple.withAlpha(70);

  @override
  Widget build(final context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 100),
      child: AlertDialog(
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        backgroundColor: AppColors.white,
        contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 20),
        title: Text(
          _dropDownLabel,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: 'Montserrat',
            letterSpacing: double.minPositive,
          ),
        ),
        content: Theme(
          data: ThemeData(
            unselectedWidgetColor: Colors.black,
            splashColor: alphaAccent,
            highlightColor: alphaAccent,
          ),
          child: CupertinoScrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final genre in _filterMap.values)
                    widget.type == DropdownAlertType.checkbox
                        ? CheckboxListTile(
                            activeColor: accent,
                            title: Text(
                              genre['label'] as String,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat'),
                            ),
                            value: genre['selected'] as bool,
                            onChanged: (final selected) {
                              setState(
                                  () => genre['selected'] = selected ?? false);
                              _updateGenreDropdownLabel();
                            },
                          )
                        : RadioListTile(
                            activeColor: accent,
                            title: Text(
                              genre['label'] as String,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat'),
                            ),
                            groupValue: true,
                            value: genre['selected'] as bool,
                            onChanged: (_) {
                              setState(() {
                                for (var x in _filterMap.values) {
                                  x['selected'] = false;
                                }
                                genre['selected'] = true;
                              });
                              if(widget.fun != null) widget.fun!();
                              _updateGenreDropdownLabel();
                            },
                          )
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            //highlightColor: alphaAccent,
            //splashColor: alphaAccent,
            child: const Text(
              'CLOSE',
              style: TextStyle(
                  color: Colors.black, fontSize: 14, fontFamily: 'Montserrat'),
            ),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
