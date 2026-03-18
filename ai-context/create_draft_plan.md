# Instruction: Implementation Guide - Create Draft Plan

This document defines the requirements and UI/UX flow for implementing the **Create Draft Plan** feature in the Dota 2 Draft Plan mobile application, based on the provided design screenshots and user stories.

## 1. Feature Overview
The goal is to provide a multi-step form (Wizard) that allows Dota 2 players, captains, or coaches to create a reusable strategy. This strategy includes a plan name, descriptive notes, a list of banned heroes, preferred picks, and enemy threats.

---

## 2. Integrated User Stories

### US-01: Create Draft Plan
- **Requirement**: Open a "Create Draft Plan" form.
- **Fields**: Plan Name (Required), Description/Strategy Notes (Optional).
- **Persistence**: Data must be stored in PostgreSQL.
- **Success Criteria**: User receives a success response and the plan is available after page refresh.

### US-04: Add Ban Heroes
- **Requirement**: Search/browse heroes and add them to a "Ban List".
- **Data**: Stored references must use **OpenDota hero ID**.
- **Validation**: Prevent duplicate heroes in the same ban list.

### US-05: Add Preferred Picks
- **Requirement**: Search/browse heroes and add them to "Preferred Picks".
- **Data**: Stored references must use **OpenDota hero ID**.
- **Validation**: Prevent duplicate entries.

### US-06: Add Enemy Threats
- **Requirement**: Add heroes as "Enemy Threats" with optional context notes.
- **Example Notes**: "Must ban if enemy has last pick", "Avoid greedy offlane matchup".
- **Data**: Stored references must use **OpenDota hero ID**.

---

## 3. UI/UX Flow (Wizard/Stepper)

### Step 1: Details (Image 1)
- **Header**: "CREATE DRAFT PLAN" with a back button.
- **Progress**: A horizontal stepper showing "1 DETAILS", "2 BANS", "3 PICKS", etc.
- **Title**: "NEW STRATEGY"
- **Subtitle**: "Define your objective and tactical approach for the next series."
- **Inputs**:
    - **PLAN NAME (REQUIRED)**: Text input with placeholder "e.g. Anti-Deathball Defense".
    - **DESCRIPTION / STRATEGY NOTES (OPTIONAL)**: Multiline text area.
- **Action**: "NEXT: CHOOSE BANS" (Primary Action), "CANCEL" (Secondary Action).

### Step 2: Hero Selection - Bans (Image 2)
- **Progress**: Stepper "2 BANS" is highlighted.
- **Title**: "BAN A HERO"
- **Footer Action**: "NEXT: CHOOSE PREFERRED PICKS →"

### Step 3: Hero Selection - Preferred Picks (Image 3)
- **Progress**: Stepper "3 PICKS" is highlighted.
- **Title**: "PICK A HERO"
- **Footer Action**: "NEXT: CHOOSE THREATS →"

### Step 4: Hero Selection - Enemy Threats (Image 4)
- **Progress**: Stepper "4 THREATS" is highlighted.
- **Title**: "PICK A THREATS"
- **Footer Action**: "FINISH →"

### Hero Browser UI (Shared for Steps 2-4)
- **Search Bar**: "Search bans..." or "Search heroes...".
- **Attribute Tabs**: "STRENGTH", "AGILITY", "INTELLIGENCE" for attribute filtering.
- **Hero Grid**:
    - High-quality hero portrait.
    - Hero ID label (e.g., "ID: 2").
    - Hero Name (e.g., "Axe").
    - Primary Attribute text/icon.
    - **Selection State**: A red checkmark icon in the top right corner when selected.
- **Footer Implementation**:
    - **Selection Count**: "X Heroes selected" (e.g., "2 Heroes").
    - **Clear All**: Reset selection button.

### Step 5: Success Screen (Image 5)
- **Message**: "STRATEGY CREATED!"
- **Description**: "Your '[Plan Name]' has been saved to your plans."
- **Icon**: Shield icon with a central checkmark.
- **Actions**:
    - "VIEW PLAN DETAILS" (Primary - takes user to the detail view of the new plan).
    - "BACK TO DASHBOARD" (Secondary - takes user back to the main list).

---

## 4. Technical Specifications

### Data Mapping (OpenDota)
- Fetch hero data from OpenDota (`/heroes` endpoint).
- Use `id` mapping:
    - `id`: 2 -> Axe
    - `id`: 14 -> Pudge
    - `id`: 129 -> Mars
    - `id`: 28 -> Slardar
    - `id`: 18 -> Sven
    - `id`: 19 -> Tiny
- Store `localized_name`, `primary_attr`, and `img` for display.

### Database Persistence (PostgreSQL)
1. **Draft Plan Table**: `id`, `name`, `description`, `created_at`.
2. **Draft Plan Bans Table**: `id`, `plan_id`, `hero_id` (FK to hero ID).
3. **Draft Plan Picks Table**: `id`, `plan_id`, `hero_id`.
4. **Draft Plan Threats Table**: `id`, `plan_id`, `hero_id`, `note`.

### Constraints
- **Unique Constraint**: Ensure `(plan_id, hero_id)` is unique in the Ban, Pick, and Threat tables to prevent duplicates.
- **Required Fields**: `plan_name` must not be null.

---

## 5. Visual Guidelines
- **Theme**: Premium dark mode.
- **Colors**:
    - Primary Button: Red/Coral (`#FD4F4F` or similar).
    - Background: Deep charcoal / Black.
    - Accents: Orange for success icons, White/Grey for text.
- **Typography**: Bold sans-serif for headers (e.g., Inter, Montserrat).
- **Interactions**: Smooth transitions between stepper steps. Long-press or modal popup for adding notes to specific heroes in the Threats step.
