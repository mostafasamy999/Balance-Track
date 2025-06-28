
// add_new_account_dialog
import 'package:flutter/material.dart';

import '../../bloc/main_screen_cubit/main_screen_cubit.dart';
import '../../moc_models.dart';
class AddNewAccountDialog extends StatefulWidget {
  Function(ClientUi) onTap;
  int selectedCategoryId;
  AddNewAccountDialog({super.key,required this.onTap,required this.selectedCategoryId});

  @override
  State<AddNewAccountDialog> createState() => _AddNewAccountDialogState();
}

class _AddNewAccountDialogState extends State<AddNewAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  String _accountName = '';
  double _initialAmount = 0.0;
  String _currency = 'Local'; // Default or from settings
  DateTime _selectedDate = DateTime.now();
  String _details = '';
  String _phoneNumber = '';
  bool _isInitialBalanceAddition = true; // true for Credit, false for Debit

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.person_add_alt_1_outlined, color: Colors.blue),
          SizedBox(width: 10),
          Text("Add New Account"),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: "Account Name", prefixIcon: Icon(Icons.person_outline)),
                validator: (value) => value == null || value.isEmpty ? 'Please enter account name' : null,
                onSaved: (value) => _accountName = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Initial Amount", prefixIcon: Icon(Icons.calculate_outlined)),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter amount';
                  if (double.tryParse(value) == null) return 'Invalid amount';
                  return null;
                },
                onSaved: (value) => _initialAmount = double.parse(value!),
              ),
              // In a real app, currency might be a dropdown or based on global settings
              TextFormField(
                initialValue: _currency,
                decoration: const InputDecoration(labelText: "Currency", prefixIcon: Icon(Icons.edit_outlined)),
                // readOnly: true, // If currency is fixed
                onSaved: (value) => _currency = value!,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Details", prefixIcon: Icon(Icons.notes_outlined)),
                onSaved: (value) => _details = value ?? '',
                maxLines: null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Phone Number", prefixIcon: Icon(Icons.phone_outlined)),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _phoneNumber = value ?? '',
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text("Save"),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                // Create the client object
                final newClient = ClientUi(
                  id: 0, // Assuming the backend or DB will assign an ID
                  name: _accountName,
                  categoryId: widget.selectedCategoryId, // You'll want to pass categoryId into the dialog later
                  transactionCount: 1, // Because initial balance = 1 transaction
                  finalBalance: _isInitialBalanceAddition ? _initialAmount : -_initialAmount,
                );

                widget.onTap(newClient); // Send client back to caller
                Navigator.of(context).pop();
              }
            }

        ),
      ],
    );
  }
}
