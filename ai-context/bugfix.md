# Bugfix and API Synchronization Plan

This document outlines the plan to synchronize the mobile application with the latest changes in the backend API for both the draft plan list and detail endpoints.

## 1. Overview of Changes

The backend API has updated several fields and structures to provide more descriptive data and reduce client-side processing.

### A. Draft Plan List API (`/draft-plans`)
New count fields have been added to the response objects:
- `count_ban_hero`: Number of banned heroes in the plan.
- `count_prefered_pick_hero`: Number of preferred pick heroes in the plan.
- `count_enemy_threat_hero`: Number of enemy threat heroes in the plan.

### B. Draft Plan Detail API (`/draft-plans/{id}`)
Related hero data is now nested within the `bans`, `preferredPicks`, and `enemyThreats` objects as a `hero` object, instead of providing only the `hero_id`.

## 2. Implementation Steps

### Step 1: Update Data Models

#### Update `DraftPlanModel`
Modify `lib/features/draft/data/models/draft_plan_model.dart` to parse the new count fields.
- Map `count_ban_hero` → `bans`
- Map `count_prefered_pick_hero` → `picks`
- Map `count_enemy_threat_hero` → `threats`

#### Update `DraftPlanDetailModel`
Modify `lib/features/draft/data/models/draft_plan_detail_model.dart` and its sub-models to robustly parse the nested `hero` object.
- **DraftPlanBanModel**: Extract `localized_name` and `icon` from the `hero` object if available.
- **DraftPlanPreferredPickModel**: Extract `localized_name` and `icon` from the `hero` object if available.
- **DraftPlanEnemyThreatModel**: Extract `localized_name` and `icon` from the `hero` object if available.

### Step 2: Update UI Components

#### Draft Plan List (`DraftPlanListPage`)
- Ensure the `DraftPlanCard` correctly displays the counts using the updated model fields.
- Verify that the `StatBadge` components are receiving the correct data.

#### Draft Plan Detail (`DraftPlanDetailPage`)
- Verify that hero names and icons are correctly displayed in the Ban, Preferred Pick, and Enemy Threat sections by utilizing the nested `hero` object data.

## 3. Detailed File Changes

### `lib/features/draft/data/models/draft_plan_model.dart`
```dart
// Update factory DraftPlanModel.fromJson
picks: (json['count_prefered_pick_hero'] as num?)?.toInt() ?? (json['picks'] as num?)?.toInt() ?? 0,
bans: (json['count_ban_hero'] as num?)?.toInt() ?? (json['bans'] as num?)?.toInt() ?? 0,
threats: (json['count_enemy_threat_hero'] as num?)?.toInt() ?? (json['threats'] as num?)?.toInt() ?? 0,
```

### `lib/features/draft/data/models/draft_plan_detail_model.dart`
Ensure the `fromJson` methods for `DraftPlanBanModel`, `DraftPlanPreferredPickModel`, and `DraftPlanEnemyThreatModel` correctly handle the optional `hero` object:
```dart
final heroObj = json['hero'] as Map<String, dynamic>?;
// ... use heroObj?['localized_name'] and heroObj?['icon']
```

## 4. Verification Plan

1. **List View Verification**: Open the app and navigate to the Draft Plan List. Confirm that each card shows the correct counts for Bans, Picks, and Threats.
2. **Detail View Verification**: Tap on a Draft Plan. Confirm that:
   - Banned heroes show their names and icons.
   - Preferred picks show their names and icons.
   - Enemy threats show their names and icons.
3. **Data Integrity**: Verify that if the `hero` object is missing (fallback scenario), it still shows a placeholder or the `hero_id`.
