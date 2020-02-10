import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';

class FilterScreen extends StatefulWidget {
  static const routeName = '/filters';
  final Function saveFilters;
  final Map<String, bool> currentFilters;
  FilterScreen({@required this.currentFilters, @required this.saveFilters});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _glutenFree = false;
  var _vegetarian = false;
  var _vegan = false;
  var _lactoseFree = false;
  @override
  initState() {
    _glutenFree = widget.currentFilters['gluten'];
    _vegetarian = widget.currentFilters['vegetarian'];
    _vegan = widget.currentFilters['vegan'];
    _lactoseFree = widget.currentFilters['lactose'];
    super.initState();
  }

  Widget _buildSwitchListTitle(String text, var value, Function updateValue) {
    return SwitchListTile(
      title: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Only include $text meals'),
      value: value,
      onChanged: updateValue,
    );
  }

  void _showInSnackBar() {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        duration: Duration(seconds: 1),
        shape: StadiumBorder(
          side: BorderSide(
            style: BorderStyle.solid,
            color: Colors.white,
            width: 1,
          ),
        ),
        content: Text(
          'Saved',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Filters'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                final selectedFilters = {
                  'gluten': _glutenFree,
                  'vegetarian': _vegetarian,
                  'vegan': _vegan,
                  'lactose': _lactoseFree,
                };
                widget.saveFilters(selectedFilters);
                _showInSnackBar();
              })
        ],
      ),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                'Adjust your meal selection.',
                style: Theme.of(context).textTheme.title,
              ),
              padding: EdgeInsets.all(20),
            ),
            _buildSwitchListTitle(
              'Gluten-free',
              _glutenFree,
              (newValue) {
                setState(
                  () {
                    _glutenFree = newValue;
                  },
                );
              },
            ),
            _buildSwitchListTitle(
              'Vegetarian-free',
              _vegetarian,
              (newValue) {
                setState(
                  () {
                    _vegetarian = newValue;
                  },
                );
              },
            ),
            _buildSwitchListTitle(
              'Vegan-free',
              _vegan,
              (newValue) {
                setState(
                  () {
                    _vegan = newValue;
                  },
                );
              },
            ),
            _buildSwitchListTitle(
              'Lactose-free',
              _lactoseFree,
              (newValue) {
                setState(
                  () {
                    _lactoseFree = newValue;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
