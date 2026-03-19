# Implementation Plan: Final API Integration

This document outlines the detailed plan for integrating the final Laravel API endpoints into the Dota 2 Draft Plan mobile application, specifically tailored to handle discrepancies between the current local/mock data models and the new API schema.

## 1. Overview
The goal is to transition from local mock data to the final backend API. This requires significant refactoring of the Data, Domain, and Presentation layers to perfectly align with the new API structure, including adding missing `id` fields to list entries for proper CRUD operations.

## 2. API Endpoints Tracking

| Feature | Endpoint | Method | Status |
| :--- | :--- | :---: | :--- |
| **Auth** | `/api/register` | POST | ⏳ Pending |
| | `/api/login` | POST | ⏳ Pending |
| **Draft Plan** | `/api/draft-plans` | POST | ⏳ Pending |
| | `/api/draft-plans/{id}` | GET | ⏳ Pending |
| **Bans** | `/api/draft-plans/{id}/bans` | POST | ⏳ Pending |
| | `/api/draft-plans/{id}/bans/{bid}` | PUT | ⏳ Pending |
| | `/api/draft-plans/{id}/bans/{bid}` | DELETE | ⏳ Pending |
| **Preferred Picks** | `/api/draft-plans/{id}/preferred-picks` | POST | ⏳ Pending |
| | `/api/draft-plans/{id}/preferred-picks/{pid}` | PUT | ⏳ Pending |
| | `/api/draft-plans/{id}/preferred-picks/{pid}` | DELETE | ⏳ Pending |
| **Enemy Threats** | `/api/draft-plans/{id}/enemy-threats` | POST | ⏳ Pending |
| | `/api/draft-plans/{id}/enemy-threats/{tid}` | PUT | ⏳ Pending |
| | `/api/draft-plans/{id}/enemy-threats/{tid}` | DELETE | ⏳ Pending |
| **Item Timings** | `/api/draft-plans/{id}/item-timings` | POST | ⏳ Pending |
| | `/api/draft-plans/{id}/item-timings/{iid}` | PUT | ⏳ Pending |
| | `/api/draft-plans/{id}/item-timings/{iid}` | DELETE | ⏳ Pending |

## 3. Entity & Model Layer Discrepancies (CRITICAL)
Currently, our Domain Entities (`DraftPlanBan`, `DraftPlanPreferredPick`, etc.) and UI Modals are missing the exact list *Entry IDs* which are required for `PUT` and `DELETE` requests. They only store `heroId`. Furthermore, field names and data types differ from the API.

### Required Domain Entity & Data Model Updates
1.  **User Model**:
    *   API returns `access_token` outside the `data` object. Model mapping must parse `access_token` from root response natively.
    *   Map `name` field exactly to `fullName`.
2.  **Hero Model**:
    *   Map `name` to `localized_name` based on API's nested `hero` object.
    *   Map image securely parsing `icon` or `image` keys instead of `img`.
3.  **DraftPlan Model**:
    *   Map `strategy_notes` correctly to `description`.
    *   Map `title` correctly to `name` or `title` fields with safe nullability fallbacks.
4.  **DraftPlanBan**:
    *   **ADD**: `int id` (Crucial for Edit/Delete endpoints).
    *   **ADD**: `int sortOrder`.
    *   Parse `heroName` and `heroIcon` securely from the nested `hero` object handling cases where `hero` object is null directly from `bans` array.
5.  **DraftPlanPreferredPick**:
    *   **ADD**: `int id`.
    *   **ADD**: `int sortOrder`.
    *   **CHANGE**: `priority` must map from API integer (e.g., 1) to UI String ('LOW', 'MEDIUM', 'HIGH') and vice-versa.
    *   **REMOVE/IGNORE**: `role`. The API does not have a `role` field for preferred picks. (Needs removal from UI or backend update).
5.  **DraftPlanEnemyThreat**:
    *   **ADD**: `int id`.
    *   **ADD**: `int threatLevel`.
    *   **ADD**: `int sortOrder`.
6.  **DraftPlanItemTiming**:
    *   **ADD**: `int id`.
    *   **MAP FIELDS**: Current UI uses `label`, `targetTime`, `explanation`. API uses `item_name`, `minute_mark` (Integer), `note`. We must update entity properties to match API semantics or map them strictly in `fromJson`/`toJson` (e.g., parse string `~18 min` to int `18`).

## 4. UI & Presentation Layer Updates (Modals)
Because we need the Entry `id` to update or delete items, the Modals and Cubit action parameters must be updated:
1.  **EditBanHeroModal** & `UpdateBanParams`:
    *   Pass `banId` to the modal and update `UpdateBanParams` to use `banId` instead of `heroId`.
2.  **EditPreferredPickModal** & `UpdatePickParams`:
    *   Pass `pickId` to the modal.
    *   Map the selected `priority` (LOW, MEDIUM, HIGH) to integer strings/numbers before submitting.
    *   Remove `Role` text field as it's not supported by the current API schema.
3.  **EditEnemyThreatModal** & `UpdateThreatParams`:
    *   Pass `threatId` to the modal.
    *   Implement UI to select/pass `threat_level` (currently missing in modal but required by backend).
4.  **EditItemTimingModal** & `UpdateTimingParams`:
    *   Pass `timingId` to the modal.
    *   Enforce numeric input for `Target Time` so it maps nicely to `minute_mark` integer on the backend.

## 5. Implementation Steps

### Phase 1: Entity & Model Corrections
1.  Update `lib/features/draft/domain/entities/draft_plan_detail.dart` to include specific entry `id`s (`int`), `sortOrder`, and proper types (`priority`, `threatLevel`, `minuteMark`).
2.  Update `lib/features/draft/data/models/draft_plan_detail_model.dart` `fromJson` mappings to parse nested `hero` object for names/icons.

### Phase 2: Data Source & Repositories
1.  Create/Update remote data source (`DraftRemoteDataSource`) endpoints matching the URLs strictly using **Dio** (as mandated by Rule 4) for all API communication.
2.  Pass bearer token explicitly to requests.

### Phase 3: Update Use Cases & Cubit params
1.  Update `update_draft_item_usecases.dart` params to consume `itemId` (e.g., `banId`) instead of `heroId` for updates/deletes.
2.  Adjust `DraftPlanCubit` and `EditDraftItemCubit` to accept these new params.

### Phase 4: Refactor UI Modals
1.  Update the four modals (`edit_ban_hero_modal`, `edit_preferred_pick_modal`, `edit_enemy_threat_modal`, `edit_item_timing_modal`) to accept and pass the specific pivot entry `id`.
2.  Adapt text fields and dropdowns in modals to match exact backend data types (e.g. numeric minute mark, integers for priority/threat levels).

## 6. Technical Notes & Project Rules Compliance
*   **Base URL**: `http://127.0.0.1:8000/api` (Remember to configure for Android emulator `10.0.2.2`).
*   **Auth**: Remember to extract `access_token` from outer root node from `login`/`register` responses.
*   **Networking**: Always use `Dio` for requests (Rule 4).
*   **State Management**: Use `Cubit`/`Bloc` for all Presentation logic mapping (Rule 2).
*   **Architecture**: Follow strict Clean Architecture principles crossing Presentation, Domain, and Data limits (Rule 3).
*   **Image Loading**: Remote hero icons fetched from the API must be rendered with `CachedNetworkImage` (Rule 5).
*   **Framework**: Execute all implementations aligned with Flutter Stable 3.38.9 environments (Rule 6).
