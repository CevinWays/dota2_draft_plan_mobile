import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/hero_entity.dart';
import '../../../domain/usecases/update_draft_item_usecases.dart';
import '../../cubit/edit_draft_item_cubit.dart';
import '../../cubit/edit_draft_item_state.dart';
import '../../cubit/heroes_cubit.dart';
import '../../cubit/heroes_state.dart';

class AddPreferredPickModal extends StatefulWidget {
  final String draftPlanId;

  const AddPreferredPickModal({super.key, required this.draftPlanId});

  @override
  State<AddPreferredPickModal> createState() => _AddPreferredPickModalState();
}

class _AddPreferredPickModalState extends State<AddPreferredPickModal> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  HeroEntity? _selectedHero;
  String _selectedPriority = 'LOW';

  @override
  void initState() {
    super.initState();
    context.read<HeroesCubit>().loadHeroes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    context.read<HeroesCubit>().loadHeroes(query: q.isEmpty ? null : q);
  }

  void _submit() {
    if (_selectedHero == null) return;
    final int priorityInt = _selectedPriority == 'HIGH' ? 3 : _selectedPriority == 'MEDIUM' ? 2 : 1;
    context.read<EditDraftItemCubit>().submitPickAdd(
      AddPickParams(
        draftPlanId: widget.draftPlanId,
        heroIds: [_selectedHero!.id],
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
                Text('Add Preferred Pick', style: AppTextStyles.headingMedium),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Selected hero chip
            if (_selectedHero != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.pickGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.pickGreen.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: AppColors.pickGreen, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      _selectedHero!.localizedName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _selectedHero = null),
                      child: const Icon(Icons.close, color: Colors.white54, size: 18),
                    ),
                  ],
                ),
              ),
            // Search field
            TextField(
              controller: _searchController,
              onChanged: _onSearch,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search hero...',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Hero list
            SizedBox(
              height: 160,
              child: BlocBuilder<HeroesCubit, HeroesState>(
                builder: (context, state) {
                  if (state is HeroesLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.accent));
                  }
                  if (state is HeroesLoaded) {
                    final heroes = state.heroes;
                    if (heroes.isEmpty) {
                      return const Center(
                        child: Text('No heroes found', style: TextStyle(color: Colors.white54)),
                      );
                    }
                    return ListView.builder(
                      itemCount: heroes.length,
                      itemBuilder: (context, index) {
                        final hero = heroes[index];
                        final isSelected = _selectedHero?.id == hero.id;
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: hero.imgUrl.isNotEmpty
                                ? Image.network(
                                    hero.imgUrl,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, url, error) => Container(
                                      width: 40,
                                      height: 40,
                                      color: AppColors.surfaceVariant,
                                      child: const Icon(Icons.person, color: Colors.white54, size: 20),
                                    ),
                                  )
                                : Container(
                                    width: 40,
                                    height: 40,
                                    color: AppColors.surfaceVariant,
                                    child: const Icon(Icons.person, color: Colors.white54, size: 20),
                                  ),
                          ),
                          title: Text(
                            hero.localizedName,
                            style: TextStyle(
                              color: isSelected ? AppColors.accent : Colors.white,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            hero.primaryAttr.toUpperCase(),
                            style: const TextStyle(color: Colors.white54, fontSize: 11),
                          ),
                          selected: isSelected,
                          selectedTileColor: AppColors.accent.withValues(alpha: 0.1),
                          onTap: () => setState(() => _selectedHero = hero),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(height: 12),
            // Priority selector
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'PRIORITY',
                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: ['LOW', 'MEDIUM', 'HIGH'].map((priority) {
                final isSelected = _selectedPriority == priority;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedPriority = priority),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.accent : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? AppColors.accent : Colors.white10),
                      ),
                      child: Center(
                        child: Text(
                          priority,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            // Note field
            TextField(
              controller: _noteController,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Strategic note (optional)...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Submit
            BlocBuilder<EditDraftItemCubit, EditDraftItemState>(
              builder: (context, state) {
                final isLoading = state is EditDraftItemLoading;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_selectedHero == null || isLoading) ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pickGreen,
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
                            'Add Preferred Pick',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
