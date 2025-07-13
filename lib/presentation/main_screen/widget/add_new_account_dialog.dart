// add_new_account_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/add_client/add_client_cubit.dart';

import '../../moc_models.dart';

class AddNewAccountDialog extends StatefulWidget {
  Function(ClientUi) onTap;
  int selectedCategoryId;

  AddNewAccountDialog(
      {super.key, required this.onTap, required this.selectedCategoryId});

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
  bool _hasSubmitted = false; // Track if already submitted successfully

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

  void _handleSubmit() {
    // Prevent multiple submissions
    if (_hasSubmitted) {
      print('🔴 [Dialog] Already submitted, ignoring tap');
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Mark as submitted immediately to prevent duplicate submissions
      setState(() {
        _hasSubmitted = true;
      });

      print('🟡 [Dialog] Submitting client: $_accountName');

      context.read<AddClientCubit>().addNewClient(
        name: _accountName,
        categoryId: widget.selectedCategoryId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddClientCubit, AddClientState>(
      listener: (context, state) {
        if (state is AddClientSuccess) {
          print('🟢 [Dialog] Client added successfully: ${state.client.name}');

          // Convert the entity to UI model
          final clientUi = ClientUi(
            id: state.client.id,
            name: state.client.name,
            categoryId: state.client.categoryId,
            transactionCount: 1,
            // Because initial balance = 1 transaction
            finalBalance:
            _isInitialBalanceAddition ? _initialAmount : -_initialAmount,
          );

          widget.onTap(clientUi); // Send client back to caller
          Navigator.of(context).pop();
          context.read<AddClientCubit>().resetState();
        } else if (state is AddClientFailure) {
          print('🔴 [Dialog] Failed to add client: ${state.message}');

          // Reset submission state on failure to allow retry
          setState(() {
            _hasSubmitted = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AddClientLoading;
        final isDisabled = isLoading || _hasSubmitted;

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
                    decoration: const InputDecoration(
                      labelText: "Account Name",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter account name'
                        : null,
                    onSaved: (value) => _accountName = value!,
                    enabled: !isDisabled,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Initial Amount",
                      prefixIcon: Icon(Icons.calculate_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter amount';
                      if (double.tryParse(value) == null) return 'Invalid amount';
                      return null;
                    },
                    onSaved: (value) => _initialAmount = double.parse(value!),
                    enabled: !isDisabled,
                  ),
                  TextFormField(
                    initialValue: _currency,
                    decoration: const InputDecoration(
                      labelText: "Currency",
                      prefixIcon: Icon(Icons.edit_outlined),
                    ),
                    onSaved: (value) => _currency = value!,
                    enabled: !isDisabled,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText:
                      "Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                    ),
                    readOnly: true,
                    onTap: isDisabled ? null : () => _selectDate(context),
                    enabled: !isDisabled,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Details",
                      prefixIcon: Icon(Icons.notes_outlined),
                    ),
                    onSaved: (value) => _details = value ?? '',
                    maxLines: null,
                    enabled: !isDisabled,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                    onSaved: (value) => _phoneNumber = value ?? '',
                    enabled: !isDisabled,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: isDisabled ? null : () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text("Save"),
              onPressed: isDisabled ? null : _handleSubmit,
            ),
          ],
        );
      },
    );
  }
}