import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return FilterOptions();
              },
            );
          },
          child: Text('Show Bottom Sheet'),
        ),
      ),
    );
  }
}

class FilterOptions extends StatefulWidget {
  @override
  _FilterOptionsState createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  bool _year2020Selected = false;
  bool _year2021Selected = false;
  bool _year2022Selected = false;
  bool _year2023Selected = false;
  bool _firstFloorSelected = false;
  bool _secondFloorSelected = false;
  bool _thirdFloorSelected = false;
  bool _fourthFloorSelected = false;
  bool _maleSelected = false;
  bool _femaleSelected = false;

  void _toggleSelected(int index) {
    setState(() {
      switch (index) {
        case 0:
          _year2020Selected = !_year2020Selected;
          break;
        case 1:
          _year2021Selected = !_year2021Selected;
          break;
        case 2:
          _year2022Selected = !_year2022Selected;
          break;
        case 3:
          _year2023Selected = !_year2023Selected;
          break;
        case 4:
          _firstFloorSelected = !_firstFloorSelected;
          break;
        case 5:
          _secondFloorSelected = !_secondFloorSelected;
          break;
        case 6:
          _thirdFloorSelected = !_thirdFloorSelected;
          break;
        case 7:
          _fourthFloorSelected = !_fourthFloorSelected;
          break;
        case 8:
          _maleSelected = !_maleSelected;
          break;
        case 9:
          _femaleSelected = !_femaleSelected;
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Filter By Year",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(width: 70),
              Text(
                "Filter By Floor",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              _buildButton(0, "2020"),
              SizedBox(width: 10),
              _buildButton(1, "2021"),
              SizedBox(width: 80),
              _buildButton(4, "1st Floor"),
              SizedBox(width: 10),
              _buildButton(5, "2nd Floor"),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _buildButton(2, "2022"),
              SizedBox(width: 10),
              _buildButton(3, "2023"),
              SizedBox(width: 80),
              _buildButton(6, "3rd Floor"),
              SizedBox(width: 10),
              _buildButton(7, "4th Floor"),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                "              Filter By Gender",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 85,
              ),
              SizedBox(width: 20),
              _buildButton(8, "Male"),
              SizedBox(width: 20),
              _buildButton(9, "Female"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildButton(int index, String text) {
    return ElevatedButton(
      onPressed: () {
        _toggleSelected(index);
      },
      child: Text(text),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 8),
        primary: _getButtonColor(index),
      ),
    );
  }

  Color? _getButtonColor(int index) {
    switch (index) {
      case 0:
        return _year2020Selected ? Colors.grey : null;
      case 1:
        return _year2021Selected ? Colors.grey : null;
      case 2:
        return _year2022Selected ? Colors.grey : null;
      case 3:
        return _year2023Selected ? Colors.grey : null;
      case 4:
        return _firstFloorSelected ? Colors.grey : null;
      case 5:
        return _secondFloorSelected ? Colors.grey : null;
      case 6:
        return _thirdFloorSelected ? Colors.grey : null;
      case 7:
        return _fourthFloorSelected ? Colors.grey : null;
      case 8:
        return _maleSelected ? Colors.grey : null;
      case 9:
        return _femaleSelected ? Colors.grey : null;
      default:
        return null;
    }
  }
}
