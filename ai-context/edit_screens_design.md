# Edit Screens Design Specification — Dota 2 Draft Plan

This document outlines the design and functional requirements for the edit screens within the Dota 2 Draft Plan mobile application. These screens allow users to refine their strategies by updating bans, preferred picks, enemy threats, and item timings.

## Design Principles
- **Atmosphere**: Dark, premium, and tactical.
- **Color Palette**: 
  - Background: Deep Charcoal / Dark Brown (`#1A1A1A`, `#221A16`)
  - Accent: Vibrant Orange (`#FF6600`) for primary actions.
  - Secondary: Muted Blue/Grey for cancel/background elements.
- **Typography**: Modern sans-serif (e.g., Inter or Roboto) with clear hierarchy.
- **Interactions**: Bottom sheet or Full-screen overlay with a clear "Save/Update" vs "Cancel" distinction.

---

## 1. Edit Ban Hero
*Purpose: Updates the strategic reasoning for banning a specific hero.*

### UI Components
- **Header**: Hero name followed by "BAN LIST ENTRY" subtitle.
- **Hero Image**: Hero portrait with a visible "Ban" icon overlay (crossed circle).
- **Section: Strategic Note**:
    - **Icon**: 📄 (Document/Note icon)
    - **Label**: "Strategic Note"
    - **Control**: Multi-line Text Input.
    - **Placeholder**: "Enter reasoning for banning this hero... e.g. Scales too hard against our support picks in the late game."
- **Action Buttons**:
    - **Save Changes**: Primary Orange Button.
    - **Cancel**: Text or Muted Button.

### Acceptance Criteria
- User can update the strategic note/reason for banning.
- Changes persist after saving.
- Prevents duplicate hero entries in the same ban list (handled at the data/service layer).

---

## 2. Edit Preferred Pick Hero
*Purpose: Adjusts role assignments, priority levels, and strategic notes for a comfort pick.*

### UI Components
- **Header**: "Edit Preferred Pick" with a close (X) icon.
- **Hero Image**: Prominent landscape hero artwork.
- **Badge**: Attribute badge (e.g., "STRENGTH HERO", "AGILITY HERO", "INTELLIGENCE HERO").
- **Section: Role**:
    - **Icon**: ⚔️ (Crossed Swords icon)
    - **Label**: "ROLE"
    - **Control**: Single-line Text Input (e.g., "Mid Laner", "Hard Support").
- **Section: Priority**:
    - **Icon**: ❗ (Exclamation icon)
    - **Label**: "PRIORITY"
    - **Control**: Segmented Control / Toggle (Low, Medium, High).
- **Section: Strategic Note**:
    - **Icon**: 📄 (Document icon)
    - **Label**: "STRATEGIC NOTE"
    - **Control**: Multi-line Text Input.
- **Action Buttons**:
    - **Save Changes**: Primary Orange Button.
    - **Cancel**: Muted Secondary Button.

### Acceptance Criteria
- User can update: **role**, **priority**, and **strategic note**.
- Role and Priority selections are clearly visible.
- Successfully persists changes to the repository.

---

## 3. Edit Enemy Threat
*Purpose: Updates the analysis and neutralization strategy for a specific enemy threat.*

### UI Components
- **Header**: "Edit Enemy Threat" with a close (X) icon.
- **Hero Image**: Circular or Rounded square hero portrait.
- **Metadata**: Hero name, Level (optional indicator), and Roles (e.g., "LEVEL 25 • Carry / Assassin").
- **Section: Threat Explanation**:
    - **Icon**: ⚠️ (Warning icon)
    - **Label**: "Threat Explanation"
    - **Control**: Multi-line Text Input within a bordered container.
- **Action Buttons**:
    - **Update Threat**: Primary Orange Button.
    - **Cancel**: Muted Secondary Button.

### Acceptance Criteria
- User can update the threat explanation/note.
- (Optional) User can update threat level if enabled in the data model.
- Deletion option should be accessible (as per US-12).

---

## 4. Edit Item Timing
*Purpose: Keeps the itemization roadmap updated with labels and explanations.*

### UI Components
- **Header**: "Edit Item Timing" with a close (X) icon.
- **Current Target**: 
    - Hero icon (if specific to a hero) or just the Item Icon.
    - Item Name (e.g., "Black King Bar").
- **Section: Timing Label**:
    - **Label**: "TIMING LABEL"
    - **Control**: Text Input with a 🕒 (Clock icon) suffix.
    - **Example**: "BKB ~18 min"
    - **Hint Text**: "RECOMMENDED: 16:00 - 20:00" (Dynamic based on item context if available).
- **Section: Explanation**:
    - **Label**: "EXPLANATION"
    - **Control**: Multi-line Text Input.
- **Action Buttons**:
    - **Save Timing Note**: Primary Orange Button.

### Acceptance Criteria
- User can update the timing label (e.g., "BKB ~18 min").
- User can update the explanation/strategic context.
- Changes must persist and be reflected in the Draft Summary.

---

## Technical Considerations
- **Data Model**: All entries must reference the **OpenDota hero ID**.
- **State Management**: Use **Cubit** (flutter_bloc) to manage the edit states and form validation.
- **Persistence**: Ensure `Repository` methods are called to save changes to the local/remote database (PostgreSQL/Local Storage).
- **Validation**: Prevent duplicate hero entries in the same category within a single draft plan.
