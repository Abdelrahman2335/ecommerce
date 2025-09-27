import 'package:ecommerce/core/models/address_model.dart';
import 'package:ecommerce/features/auth/presentation/manager/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Example usage of AddressProvider in a UI widget
class AddressExampleUsage extends StatefulWidget {
  const AddressExampleUsage({super.key});

  @override
  State<AddressExampleUsage> createState() => _AddressExampleUsageState();
}

class _AddressExampleUsageState extends State<AddressExampleUsage> {
  final _cityController = TextEditingController();
  final _areaController = TextEditingController();
  final _streetController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load existing address when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().loadAddress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Address Management')),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          // Handle error display
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (addressProvider.hasError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(addressProvider.errMessage!)),
              );
              addressProvider.clearError();
            }
          });

          // Pre-fill form with existing address
          if (addressProvider.currentAddress != null &&
              _cityController.text.isEmpty) {
            final address = addressProvider.currentAddress!;
            _cityController.text = address.city ?? '';
            _areaController.text = address.area ?? '';
            _streetController.text = address.street ?? '';
            _countryController.text = address.country ?? '';
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Display current address
                if (addressProvider.hasAddress) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Current Address:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(addressProvider.getFormattedAddress()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Address form
                TextField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _areaController,
                  decoration: const InputDecoration(
                    labelText: 'Area',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _streetController,
                  decoration: const InputDecoration(
                    labelText: 'Street',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Save button
                ElevatedButton(
                  onPressed: addressProvider.loading
                      ? null
                      : () => _saveAddress(context),
                  child: addressProvider.loading
                      ? const CircularProgressIndicator()
                      : const Text('Save Address'),
                ),

                const SizedBox(height: 16),

                // Delete button (only show if address exists)
                if (addressProvider.hasAddress)
                  ElevatedButton(
                    onPressed: addressProvider.loading
                        ? null
                        : () => _deleteAddress(context),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: addressProvider.loading
                        ? const CircularProgressIndicator()
                        : const Text('Delete Address'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveAddress(BuildContext context) {
    final address = AddressModel(
      country: _countryController.text.trim(),
      city: _cityController.text.trim(),
      area: _areaController.text.trim(),
      street: _streetController.text.trim(),
    );

    final addressProvider = context.read<AddressProvider>();

    if (!addressProvider.isAddressComplete(address)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    addressProvider.saveAddress(address);
  }

  void _deleteAddress(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete your address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AddressProvider>().deleteAddress();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    _areaController.dispose();
    _streetController.dispose();
    _countryController.dispose();
    super.dispose();
  }
}
