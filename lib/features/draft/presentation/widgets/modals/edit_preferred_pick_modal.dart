import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../domain/usecases/update_draft_item_usecases.dart';
import '../../cubit/edit_draft_item_cubit.dart';
import '../../cubit/edit_draft_item_state.dart';

class EditPreferredPickModal extends StatefulWidget {
  final String draftPlanId;
  final int itemId;
  final int heroId;
  final String heroName;
  final String heroIcon;
  final String initialPriority;
  final String? initialNote;

  const EditPreferredPickModal({
    super.key,
    required this.draftPlanId,
    required this.itemId,
    required this.heroId,
    required this.heroName,
    required this.heroIcon,
    required this.initialPriority,
    this.initialNote,
  });

  @override
  State<EditPreferredPickModal> createState() => _EditPreferredPickModalState();
}

class _EditPreferredPickModalState extends State<EditPreferredPickModal> {
  late final TextEditingController _noteController;
  late String _selectedPriority;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialNote);
    _selectedPriority = widget.initialPriority;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    // Convert String priority to int (LOW=1, MEDIUM=2, HIGH=3)
    final int priorityInt = _selectedPriority == 'HIGH' ? 3 : _selectedPriority == 'MEDIUM' ? 2 : 1;
    context.read<EditDraftItemCubit>().submitPickUpdate(
      UpdatePickParams(
        draftPlanId: widget.draftPlanId,
        itemId: widget.itemId,
        heroId: widget.heroId,
        priority: priorityInt,
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
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.banRed,
            ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
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
                  Text(
                    'Edit Preferred Pick',
                    style: AppTextStyles.headingMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Hero Info
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.heroIcon,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.surfaceVariant,
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.surfaceVariant,
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.heroName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PREFERRED PICK',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Removed Role UI since the API does not support it anymore.

              // Priority Selection
              Row(
                children: [
                  const Icon(
                    Icons.priority_high,
                    color: Colors.white70,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'PRIORITY',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _OptionChip(
                    label: 'LOW',
                    value: 'LOW',
                    groupValue: _selectedPriority,
                    onChanged: (val) => setState(() => _selectedPriority = val),
                  ),
                  const SizedBox(width: 8),
                  _OptionChip(
                    label: 'MEDIUM',
                    value: 'MEDIUM',
                    groupValue: _selectedPriority,
                    onChanged: (val) => setState(() => _selectedPriority = val),
                  ),
                  const SizedBox(width: 8),
                  _OptionChip(
                    label: 'HIGH',
                    value: 'HIGH',
                    groupValue: _selectedPriority,
                    onChanged: (val) => setState(() => _selectedPriority = val),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Strategic Note Input
              Row(
                children: [
                  const Icon(
                    Icons.description_outlined,
                    color: Colors.white70,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'STRATEGIC NOTE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g. Pick into heavy physical damage lineups.',
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Actions
              BlocBuilder<EditDraftItemCubit, EditDraftItemState>(
                builder: (context, state) {
                  final isLoading = state is EditDraftItemLoading;
                  return Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: isLoading
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
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

class _OptionChip extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _OptionChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value.toUpperCase() == groupValue.toUpperCase();
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.accent : Colors.white10,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
