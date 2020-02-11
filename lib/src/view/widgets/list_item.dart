import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function(bool) onTap;

  ListItem({this.title, this.subtitle, this.onTap});

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: CheckboxListTile(
        title: Text(widget.title),
        subtitle: Text(widget.subtitle),
        value: _isChecked,
        activeColor: Colors.teal,
        onChanged: (bool value) {
          setState(() {
            if (_isChecked) {
              _isChecked = false;
            } else {
              _isChecked = true;
            }
          });
          widget.onTap(_isChecked);
        },
      ),
    );
  }
}
