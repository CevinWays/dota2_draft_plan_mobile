# Draft Plan Detail — Specification

## 1. User Story
**As a** Dota 2 coach / analyst  
**I want to** open a saved draft plan  
**So that** I can review all drafting notes in one place and communicate the strategy to my team.

---

## 2. Acceptance Criteria
- [ ] **Plan Identity**: Displays the plan name clearly in the header.
- [ ] **Strategy Overview**: Shows a dedicated section for general strategy and tactical notes.
- [ ] **Ban List**: Lists heroes to be banned with associated tactical notes.
- [ ] **Preferred Picks**: Displays top-priority hero picks with Role, Priority level (High/Medium/Low), and detailed usage notes.
- [ ] **Enemy Threats**: Lists specific enemy heroes to watch out for with counter-strategy notes.
- [ ] **Item Timings**: Displays key item reach-goals (e.g., "BKB ~18 min") with explanations for their timing.
- [ ] **Visual Fidelity**: Hero references must render both the hero's **name** and **icon** (synced from OpenDota data).
- [ ] **Dynamic Loading**: All data is retrieved from the Laravel backend using a unique `plan_id` or `public_id`.

---

## 3. UI Components Breakdown

### A. Header & Navigation
- **Back Button**: Navigates back to the Draft Plans List.
- **Draft Plan Title**: High-contrast text identifying the current plan.
- **Summary Button**: Red accent button that navigates to the read-only Draft Summary view.

### B. Overview / Strategy Notes
- **Title**: "OVERVIEW / STRATEGY NOTES" (Small-caps/Uppercase).
- **Content Area**: A styled box containing the core tactical objective of the plan.
- **Action**: Edit icon (top-right) to modify the general strategy text.

### C. Ban List Section
- **Header**: "BAN LIST" with an icon and a "+ Add Hero" button.
- **Ban Item**:
    - Hero avatar (rounded corners).
    - Hero Name.
    - Note: "High priority ban to prevent call initiates".
    - Actions: Inline "EDIT NOTE" and "REMOVE" buttons.

### D. Preferred Picks Section
- **Header**: "PREFERRED PICKS" with an icon and a "+ Add Hero" button.
- **Pick Item**:
    - Large Hero Icon.
    - Hero Name with a **Priority Badge** (e.g., "HIGH" in orange).
    - Role Label: "ROLE: POSITION 1 CARRY".
    - Detailed Note: Multi-line text explaining itemization or playstyle.
    - Actions: Edit (pencil) and Delete (trash) icons.

### E. Enemy Threats Section
- **Header**: "ENEMY THREATS" with an icon and a "+ Add Threat" button.
- **Threat Item**:
    - Hero Icon.
    - Hero Name.
    - Threat Note: Explanation of why the hero is dangerous.
    - Actions: Edit and Delete icons.

### F. Item Timing Section
- **Header**: "ITEM TIMING" with an icon and a "+ Add Items" button.
- **Timing Item**:
    - **Target Window**: High-visibility orange text (e.g., "~18 min").
    - **Item Name**: Standard text.
    - **Explanation**: Why this timing is critical.
    - Actions: Edit and Delete icons.

---

## 4. Data Requirements

### Expected JSON Response (`GET /api/v1/draft-plans/{id}`)
```json
{
  "data": {
    "id": "uuid-or-id",
    "name": "Anti-Push Strategy",
    "overview": "Focus on high wave-clear and turtle potential...",
    "bans": [
      {
        "hero_id": 2,
        "hero_name": "Axe",
        "hero_icon": "https://...",
        "note": "High priority ban to prevent call initiates"
      }
    ],
    "preferred_picks": [
      {
        "hero_id": 94,
        "hero_name": "Medusa",
        "hero_icon": "https://...",
        "priority": "high",
        "role": "Position 1 Carry",
        "note": "Unrivaled wave clear and late-game insurance."
      }
    ],
    "enemy_threats": [
      {
        "hero_id": 61,
        "hero_name": "Broodmother",
        "hero_icon": "https://...",
        "note": "Can overwhelm lanes quickly."
      }
    ],
    "item_timings": [
      {
        "label": "Black King Bar",
        "target_time": "~18 min",
        "explanation": "Required to survive early push attempts."
      }
    ]
  }
}
```

---

## 5. Interactions & State
- **Loading State**: Show shimmer skeletons for each section while the backend fetches the plan.
- **Empty State**: Each section (Picks, Bans, Threats) should display a "No heroes added yet" message if the list is empty.
- **Sync Behavior**: Removing or adding a hero should update the local state immediately (Optimistic UI) and sync with the database.
