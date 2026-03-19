import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../domain/usecases/update_draft_item_usecases.dart';
import '../../cubit/edit_draft_item_cubit.dart';
import '../../cubit/edit_draft_item_state.dart';

class AddItemTimingModal extends StatefulWidget {
  final String draftPlanId;

  const AddItemTimingModal({super.key, required this.draftPlanId});

  @override
  State<AddItemTimingModal> createState() => _AddItemTimingModalState();
}

class _AddItemTimingModalState extends State<AddItemTimingModal> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _minuteMarkController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _itemNameController.dispose();
    _minuteMarkController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final itemName = _itemNameController.text.trim();
    final minuteMark = int.tryParse(_minuteMarkController.text.trim()) ?? 0;
    if (itemName.isEmpty) return;
    context.read<EditDraftItemCubit>().submitTimingAdd(
      AddItemTimingParams(
        draftPlanId: widget.draftPlanId,
        itemName: itemName,
        minuteMark: minuteMark,
        note: _noteController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditDraftItemCubit, EditDraftItemState>(
      listener: (context, state) {
        if (state is EditDraftItemSuccess) {
          Navigator.of(context).pop(true);
        } else if (state is EditDraftItemError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.banRed),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add Item Timing', style: AppTextStyles.headingMedium),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Item Name field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ITEM NAME',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _itemNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g. Black King Bar, Blink Dagger...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.shopping_bag_outlined, color: Colors.white54, size: 20),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Minute mark field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'MINUTE MARK',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _minuteMarkController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.threatYellow, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'e.g. 18',
                  hintStyle: const TextStyle(color: Colors.white38),
                  suffixIcon: const Icon(Icons.access_time, color: Colors.white54, size: 20),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Note / explanation field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'EXPLANATION',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g. Essential for mid-game teamfights...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Submit
              BlocBuilder<EditDraftItemCubit, EditDraftItemState>(
                builder: (context, state) {
                  final isLoading = state is EditDraftItemLoading;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(
                              'Add Item Timing',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
