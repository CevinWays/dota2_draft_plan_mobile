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

class AddEnemyThreatModal extends StatefulWidget {
  final String draftPlanId;

  const AddEnemyThreatModal({super.key, required this.draftPlanId});

  @override
  State<AddEnemyThreatModal> createState() => _AddEnemyThreatModalState();
}

class _AddEnemyThreatModalState extends State<AddEnemyThreatModal> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  HeroEntity? _selectedHero;
  int _threatLevel = 1; // 1=LOW, 2=MEDIUM, 3=HIGH

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
    context.read<EditDraftItemCubit>().submitThreatAdd(
      AddThreatParams(
        draftPlanId: widget.draftPlanId,
        heroIds: [_selectedHero!.id],
        threatLevel: _threatLevel,
        note: _noteController.text.trim(),
      ),
    );
  }

  Color _levelColor(int level) {
    if (level == 3) return AppColors.banRed;
    if (level == 2) return AppColors.threatYellow;
    return AppColors.pickGreen;
  }

  String _levelLabel(int level) {
    if (level == 3) return 'HIGH';
    if (level == 2) return 'MEDIUM';
    return 'LOW';
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
                Text('Add Enemy Threat', style: AppTextStyles.headingMedium),
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
                  color: AppColors.threatYellow.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.threatYellow.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.threatYellow, size: 18),
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
            // Threat level selector
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'THREAT LEVEL',
                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [1, 2, 3].map((level) {
                final isSelected = _threatLevel == level;
                final color = _levelColor(level);
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _threatLevel = level),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? color.withValues(alpha: 0.2) : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? color : Colors.white10),
                      ),
                      child: Center(
                        child: Text(
                          _levelLabel(level),
                          style: TextStyle(
                            color: isSelected ? color : Colors.white70,
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
                hintText: 'Why is this hero a threat? (optional)...',
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
                      backgroundColor: AppColors.threatYellow,
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
                            'Add Enemy Threat',
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
