import 'package:flutter/material.dart';

class FilterOptionsDialog extends StatefulWidget {
  final List<bool> selections;
  final Function(List<bool>) onSelectionChanged;

  const FilterOptionsDialog(
      {super.key, required this.selections, required this.onSelectionChanged});

  @override
  State<FilterOptionsDialog> createState() => _FilterOptionsDialogState();
}

class _FilterOptionsDialogState extends State<FilterOptionsDialog> {
  late final List<bool> _selections = widget.selections;
  final _filterOptions = {
    'Year of joining': ["2021", "2022", "2023", "2024"],
    'Floor number': ["1st Floor", "2nd Floor", "3rd Floor"],
    'Gender': ["Male", "Female"]
  };

  @override
  Widget build(BuildContext context) {
    final clr = Theme.of(context).colorScheme;
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 10,
          child: Center(
            child: Container(
              width: 35,
              height: 5,
              decoration: const BoxDecoration(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Icon(Icons.filter_alt_outlined, size: 35),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Filter Students',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const Text('Select the filters you want to apply'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Year of Joining
                Text(_filterOptions.keys.elementAt(0),
                    style: TextStyle(
                        color: clr.primary, fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: _filterOptions.values.elementAt(0).map((e) {
                    int index = _filterOptions.values.elementAt(0).indexOf(e);
                    return FilterChip(
                      label: Text(e),
                      showCheckmark: true,
                      selected: _selections[index],
                      onSelected: (selected) {
                        setState(() {
                          _selections[index] = selected;
                          widget.onSelectionChanged(_selections);
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Floor Number
                Text(_filterOptions.keys.elementAt(1),
                    style: TextStyle(
                        color: clr.primary, fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: _filterOptions.values.elementAt(1).map((e) {
                    int index = _filterOptions.values.elementAt(1).indexOf(e) +
                        _filterOptions.values.elementAt(0).length;
                    return FilterChip(
                      label: Text(e),
                      showCheckmark: true,
                      selected: _selections[index],
                      onSelected: (selected) {
                        setState(() {
                          _selections[index] = selected;
                          widget.onSelectionChanged(_selections);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Gender
                Text(_filterOptions.keys.elementAt(2),
                    style: TextStyle(
                        color: clr.primary, fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: _filterOptions.values.elementAt(2).map((e) {
                    int index = _filterOptions.values.elementAt(2).indexOf(e) +
                        _filterOptions.values.elementAt(0).length +
                        _filterOptions.values.elementAt(1).length;
                    return FilterChip(
                      label: Text(e),
                      showCheckmark: true,
                      selected: _selections[index],
                      onSelected: (selected) {
                        setState(() {
                          _selections[index] = selected;
                          widget.onSelectionChanged(_selections);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Clear All btn
                Align(
                  alignment: Alignment.bottomRight,
                  child: ActionChip(
                    avatar: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _selections.fillRange(0, _selections.length, false);
                        widget.onSelectionChanged(_selections);
                      });
                    },
                    label: const Text('Clear All'),
                    backgroundColor: clr.tertiaryContainer,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
