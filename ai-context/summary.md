# Draft Summary — Specification

## 1. User Story
**As a** team captain during a live drafting discussion
**I want** a concise, read-only view of the draft plan
**So that** I can quickly scan and communicate the strategy without editing noise.

---

## 2. Acceptance Criteria
- [ ] **Plan Identity**: Displays plan name prominently in the header with an "Active Tactical Plan" status badge.
- [ ] **Optimized Readability**: High-contrast dark theme, large text hierarchy, minimal clutter.
- [ ] **Target Bans**: Horizontal scrollable row of ban hero avatars with names.
- [ ] **Priority Picks**: Vertical list with hero icons, names, priority badge (HIGH / FLEX / LOW), role label, and a short note.
- [ ] **Enemy Counter Threats**: Compact list with hero icon, name (uppercase), and threat explanation.
- [ ] **Key Item Timings**: Card-based grid with item icon, target time (large high-visibility text), item name, and role/timing label.
- [ ] **Read-Only**: Absolutely no edit buttons, delete icons, or "Add Hero/Threat" inputs. The page is purely presentational.
- [ ] **Live Session Indicator**: Top bar includes a pulsing red dot and "LIVE SESSION" label to signal active team use.

---

## 3. UI Components Breakdown

### A. Header & Navigation
- **Back Arrow**: Navigates back to `DraftPlanDetailPage`.
- **Screen Title**: "DRAFT SUMMARY" — uppercase, accent-colored.
- **Live Session Badge**: Right-aligned. Pulsing red circle + "LIVE SESSION" label in a small pill. Purely decorative status indicator.

### B. Active Plan Banner
- **Active Tactical Plan Chip**: Small red badge reading "ACTIVE TACTICAL PLAN".
- **Plan Title**: Bold, extra-large white text (e.g., "Anti-Push Strategy").
- **Plan Overview**: Subtitle text — muted gray, 1–2 line maximum for quick scan.

### C. Target Bans Row
- **Section Label**: "TARGET BANS" — uppercase, letter-spaced, muted color.
- **Layout**: Horizontal `ListView` (scrollable) of ban hero avatar chips.
- **Ban Chip**: 64×64 hero avatar (rounded corners) + hero abbreviation or short name below.
- **No edit controls** — tap does nothing (or optionally shows hero name tooltip).

### D. Priority Picks List
- **Section Label**: "PRIORITY PICKS" — uppercase, letter-spaced.
- **Left accent bar**: Colored vertical indicator beside each pick card.
  - HIGH → Orange/Red
  - FLEX → Blue
  - LOW → Gray
- **Pick Item**:
  - Large hero icon (left).
  - Hero name (bold, large).
  - Role label (muted, e.g., "Pos 1 CARRY").
  - Priority badge (top-right, colored pill): "HIGH", "FLEX", "LOW".
  - Short note (single line, italic, muted).
- **No edit/delete controls**.

### E. Enemy Counter Threats
- **Section Label**: "ENEMY COUNTER THREATS" — uppercase, red-tinted.
- **Threat Item**:
  - Small hero icon (left, 48×48).
  - Hero name (bold uppercase).
  - Threat note (inline, smaller muted text — may contain highlighted keyword like "Echo Slam").
- **Layout**: Compact vertical list inside a dark rounded card.
- **No edit controls**.

### F. Key Item Timings
- **Section Label**: "KEY ITEM TIMINGS" — uppercase, letter-spaced.
- **Layout**: 2-column grid of timing cards.
- **Timing Card**:
  - Item icon (top-left, small 32×32).
  - Item name (small, uppercase, muted).
  - Target time: Extra-large white text (e.g., "~18 min") — most prominent element.
  - Role/reason label: Small muted text (e.g., "TARGET CORE 1/2").
- **No edit controls**.

---

## 4. Data Requirements
Reuses the same API response as `DraftPlanDetailPage`:

```
GET /api/v1/draft-plans/{id}
```

Same JSON shape as `draft_detail.md` Section 4. No additional endpoints required.

---

## 5. Interactions & State

| State | Behavior |
|---|---|
| **Loading** | Full-screen shimmer skeleton matching the layout structure (bans row, picks list, threats list, timings grid). |
| **Loaded** | Renders all sections. If a section is empty (e.g., no bans), show a compact "None specified" inline message instead of the section. |
| **Empty Plan** | If all sections are empty, show a centered blank state: icon + "No draft data available." |
| **Error** | Full-screen error state with an icon + message + "Go Back" button (no Retry — this is read-only). |

### Interaction Rules
- **Tap on hero avatar (Bans)**: Show a `Tooltip` or `SnackBar` with the hero full name. No navigation.
- **Tap on pick item**: No action. Read-only — no navigation or edit triggered.
- **Tap on enemy threat**: No action.
- **Tap on item timing card**: No action.
- **Back button**: Pop route → return to `DraftPlanDetailPage`.
- **Live Session badge**: Purely decorative (pulsing animation only). No interaction.

---

## 6. Technical Design Notes

| Item | Detail |
|---|---|
| **Page file** | `lib/features/draft/presentation/pages/draft_summary_page.dart` |
| **State management** | Reuse `DraftPlanDetailCubit` + `DraftPlanDetailState` (no new Cubit needed). |
| **Navigation** | Pushed from `DraftPlanDetailPage` via the "Summary" `TextButton.icon` in the AppBar. |
| **BlocProvider** | Wrap `DraftSummaryPage` with existing `BlocProvider.value(value: context.read<DraftPlanDetailCubit>())` — data is already loaded, no re-fetch. |
| **Widgets** | Create read-only variants: `SummaryHeroChip`, `SummaryPickItem`, `SummaryThreatItem`, `SummaryTimingCard`. |
| **Animation** | Pulsing Live Session dot: use `AnimationController` + `CurvedAnimation` with `Curves.easeInOut` for a 1s repeating fade. |
| **AppColors** | Reuse existing tokens: `AppColors.accent`, `AppColors.banRed`, `AppColors.threatYellow`, `AppColors.surfaceVariant`. |
| **AppTextStyles** | Reuse `AppTextStyles.headingLarge`, `headingMedium`, `bodyMedium`, `bodySmall`, `badgeLabel`. |
