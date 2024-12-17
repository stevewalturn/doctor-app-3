import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_app/ui/widgets/custom_button.dart';

class FiltersSheet extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const FiltersSheet({
    super.key,
    required this.request,
    required this.completer,
  });

  @override
  State<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<FiltersSheet> {
  late Map<String, dynamic> filters;
  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  @override
  void initState() {
    super.initState();
    filters = Map<String, dynamic>.from(widget.request.data ?? {});
    filters['ageRange'] ??= const RangeValues(0, 100);
    filters['gender'] ??= null;
    filters['bloodGroup'] ??= null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Patients',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () =>
                    widget.completer(SheetResponse(confirmed: false)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Age Range',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          RangeSlider(
            values: filters['ageRange'] as RangeValues,
            min: 0,
            max: 100,
            divisions: 100,
            labels: RangeLabels(
              '${(filters['ageRange'] as RangeValues).start.round()}',
              '${(filters['ageRange'] as RangeValues).end.round()}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                filters['ageRange'] = values;
              });
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Gender',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: filters['gender'] == null,
                onSelected: (selected) {
                  setState(() {
                    filters['gender'] = selected ? null : filters['gender'];
                  });
                },
              ),
              ChoiceChip(
                label: const Text('Male'),
                selected: filters['gender'] == 'Male',
                onSelected: (selected) {
                  setState(() {
                    filters['gender'] = selected ? 'Male' : null;
                  });
                },
              ),
              ChoiceChip(
                label: const Text('Female'),
                selected: filters['gender'] == 'Female',
                onSelected: (selected) {
                  setState(() {
                    filters['gender'] = selected ? 'Female' : null;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Blood Group',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: filters['bloodGroup'] == null,
                onSelected: (selected) {
                  setState(() {
                    filters['bloodGroup'] =
                        selected ? null : filters['bloodGroup'];
                  });
                },
              ),
              ...bloodGroups.map((group) => ChoiceChip(
                    label: Text(group),
                    selected: filters['bloodGroup'] == group,
                    onSelected: (selected) {
                      setState(() {
                        filters['bloodGroup'] = selected ? group : null;
                      });
                    },
                  )),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Reset',
                  onPressed: () {
                    setState(() {
                      filters = {
                        'ageRange': const RangeValues(0, 100),
                        'gender': null,
                        'bloodGroup': null,
                      };
                    });
                  },
                  type: ButtonType.outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: 'Apply',
                  onPressed: () {
                    widget.completer(SheetResponse(
                      confirmed: true,
                      data: filters,
                    ));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
