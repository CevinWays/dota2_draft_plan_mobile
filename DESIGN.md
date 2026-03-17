# Dota 2 Draft Plans — Master Plan (Take Home Assessment)

## 1) Final Tech Stack (Aligned with Your Strengths)

### Frontend (Web)

* **Next.js (App Router)**
* **Tailwind CSS**
* **TypeScript**
* **State Management: Zustand** ✅ *(recommended: easiest, lightweight, fast to implement, senior-looking if used cleanly)*
* **Form handling:** React Hook Form + Zod
* **Data fetching:** native `fetch` + simple service layer *(or TanStack Query optional, but to keep scope clean and fast, skip unless needed)*

### Backend

* **Laravel (PHP 11 / latest stable)**
* **Laravel API (RESTful)**
* **Eloquent ORM**
* **Laravel Validation + Form Request**
* **Laravel Resource / API Resource**

### Database

* **PostgreSQL**

### Infra

* **Docker Compose**
* Services:

  * `frontend` (Next.js)
  * `backend` (Laravel + PHP-FPM / artisan serve for dev)
  * `db` (PostgreSQL)

### Mobile (Optional / not primary deliverable unless requested)

* **Flutter**
* **Cubit (flutter_bloc)**
* **Clean Architecture folder structure**

> **Strategic recommendation:** For this take-home, prioritize **Web (Next.js)** as the main deliverable. It matches the requirement well, is faster to demonstrate, and easier to package with Laravel + Docker Compose.

---

# 2) Requirement Breakdown (Clarified)

## Core Functional Requirements

### A. Draft Plans List Screen

User must be able to:

* See all created draft plans
* Click one draft plan to open detail page
* Click button to create new draft plan

### B. Create Draft Plan

User must be able to:

* Input **name** (required)
* Input **description** (optional)
* Save draft plan
* After creation, open the created plan automatically or navigate to detail page

### C. Draft Plan Detail Screen

Must show:

* Draft plan name + description
* **Ban List** section
* **Preferred Picks** section
* **Enemy Threats / Counters** section
* **Item Timing Notes** section
* Link/button to **Draft Summary**
* Button to open **Hero Browser**

### D. Hero Browser (Screen or Modal)

Must:

* Load heroes from **OpenDota API** (NOT hardcoded)
* Show searchable hero list
* Allow adding selected hero into:

  * Ban List
  * Preferred Picks
  * Enemy Threats / Counters

### E. Ban List

Each entry must:

* Reference **OpenDota hero ID**
* Show hero name/icon
* Allow optional **note**
* Allow edit note
* Allow remove hero

### F. Preferred Picks

Each entry must:

* Reference **OpenDota hero ID**
* Show hero name/icon
* Allow set:

  * **Role** (free text or fixed options)
  * **Priority** = High / Medium / Low
  * **Optional note**
* Allow edit
* Allow remove

### G. Enemy Threats / Counters

Each entry must:

* Reference **OpenDota hero ID**
* Show hero name/icon
* Allow optional **threat note**
* Allow edit
* Allow remove

### H. Item Timing Notes

Each note must include:

* **Timing label** (e.g. `BKB ~18 min`)
* **Short explanation**
* Allow create/edit/delete

### I. Draft Summary View (Read-only)

Must display concise summary of:

* Draft plan info
* Ban list
* Preferred picks
* Roles
* Priorities
* Enemy threats
* Item timings

### J. Persistence

All data must persist in DB:

* Refresh browser → data remains
* Reopen app → data remains

### K. Technical Constraint

Stored hero references must use:

* **OpenDota hero ID**, not only hero name

---

# 3) Product Scope Recommendation (Senior & Realistic)

## In Scope (Recommended)

* Draft Plans CRUD *(Create, Read list, Read detail, Delete optional)*
* Ban entries CRUD
* Preferred picks CRUD
* Enemy threats CRUD
* Item timing notes CRUD
* Hero Browser modal with search
* OpenDota hero sync/cache into PostgreSQL
* Draft summary page
* Dockerized local setup
* Seed + migration + one-command init
* Clean README / DESIGN / AI_LOG / schema.dbml

## Optional but Nice

* Edit Draft Plan basic info
* Soft delete for draft plan
* Server-side search heroes
* API pagination for plans

## Explicitly Out of Scope (Good for DESIGN.md)

* Authentication (unless bonus)
* Real-time collaboration
* Offline mode
* Advanced drag-and-drop sorting
* Complex hero matchup analytics
* Full OpenDota mirror / all metadata

---

# 4) Recommended Delivery Strategy (Most Senior-Looking)

## Best Choice

Build:

* **Next.js frontend**
* **Laravel backend API**
* **PostgreSQL**
* **Docker Compose**

### Why this is strong:

* Shows real **fullstack ownership**
* Bonus points vs Supabase-only path
* Easier to explain architecture in interview
* Strong alignment with your actual skill set
* Easy to create clean commit history

---

# 5) PRD (Product Requirements Document)

## Product Name

**Dota 2 Draft Plans**

## Background

Dota 2 drafting requires fast decision-making before and during matches. Teams often need structured preparation for hero bans, preferred picks, enemy threat handling, and key timing windows. This app helps organize draft strategy into reusable draft plans.

## Objective

Build a lightweight fullstack application where users can create reusable draft plans and quickly review strategic drafting information.

## Success Criteria

* Users can create and manage draft plans
* Users can add heroes from OpenDota into structured categories
* Users can store contextual notes for bans, picks, and threats
* Users can review a concise summary during draft discussions
* Data persists locally via PostgreSQL
* App can be run locally in minimal setup steps

## Primary User

* Competitive or semi-competitive Dota 2 player / analyst / captain

## User Stories

1. As a user, I want to create a draft plan so I can prepare a strategy for a match.
2. As a user, I want to browse heroes from OpenDota so I don’t need hardcoded data.
3. As a user, I want to assign heroes into bans and preferred picks.
4. As a user, I want to annotate why a hero should be banned.
5. As a user, I want to set role and priority for preferred picks.
6. As a user, I want to list enemy threats and why they matter.
7. As a user, I want to track item timing notes relevant to the strategy.
8. As a user, I want a read-only summary that I can scan quickly during draft.

## Functional Requirements

* FR-01: Create draft plan
* FR-02: List draft plans
* FR-03: View draft plan detail
* FR-04: Browse heroes from OpenDota-backed cache
* FR-05: Add hero to Ban List
* FR-06: Edit Ban note
* FR-07: Remove hero from Ban List
* FR-08: Add hero to Preferred Picks
* FR-09: Edit role/priority/note for preferred pick
* FR-10: Remove hero from Preferred Picks
* FR-11: Add hero to Enemy Threats
* FR-12: Edit threat note
* FR-13: Remove hero from Enemy Threats
* FR-14: Create/edit/delete item timing notes
* FR-15: View draft summary
* FR-16: Persist all data in PostgreSQL

## Non-Functional Requirements

* NFR-01: App runs locally via Docker Compose
* NFR-02: Database must be PostgreSQL
* NFR-03: Setup documented in ≤ 5 steps
* NFR-04: Data schema documented in DbML
* NFR-05: One command available for migrate + seed
* NFR-06: Clean and understandable commit history

---

# 6) End-to-End Architecture

## High-Level Flow

**Next.js UI** → **Laravel REST API** → **PostgreSQL**

### External dependency flow

**Laravel Backend** → **OpenDota API** → cache heroes into **PostgreSQL**

## Architecture Principle

* Frontend does **not** call OpenDota directly in normal app flow
* Frontend only talks to **Laravel API**
* Backend handles:

  * OpenDota fetch
  * normalization
  * caching into DB
* DB becomes the **source of truth** for hero metadata used by the app

## Why this is senior

* Avoids repeated client-side external calls
* Better reliability if OpenDota is slow/down
* Centralized validation and schema consistency
* Aligns with bonus requirement: **server-side caching in PostgreSQL only**

---

# 7) Planned Screens / Routing (Next.js)

## Routes

* `/` → Redirect to `/draft-plans`
* `/draft-plans` → Draft Plans List Page
* `/draft-plans/new` → Create Draft Plan Page *(optional; can also use modal)*
* `/draft-plans/[id]` → Draft Plan Detail Page
* `/draft-plans/[id]/summary` → Draft Summary Page

## Modal / Overlay

* Hero Browser Modal (opened from detail page)
* Form Modal for:

  * Add/Edit Ban Note
  * Add/Edit Preferred Pick metadata
  * Add/Edit Threat Note
  * Add/Edit Item Timing Note

## Recommended UX

**Fastest senior-looking approach:**

* Main pages for core navigation
* Modals for sub-actions
* Keep UI compact and practical

---

# 8) Data Model / ERD (Detailed)

## Table 1: `heroes`

Purpose: Cached hero metadata from OpenDota

Columns:

* `id` (bigserial PK)
* `opendota_hero_id` (integer, unique, required)
* `name` (varchar, required) — e.g. `npc_dota_hero_axe`
* `localized_name` (varchar, required) — e.g. `Axe`
* `primary_attr` (varchar, nullable)
* `attack_type` (varchar, nullable)
* `roles` (jsonb, nullable)
* `img` (varchar, nullable)
* `icon` (varchar, nullable)
* `base_health` (integer, nullable) *(optional if stored)*
* `base_mana` (integer, nullable) *(optional if stored)*
* `raw_payload` (jsonb, nullable) *(optional for debugging / future extensibility)*
* `last_synced_at` (timestamp, nullable)
* `created_at`
* `updated_at`

### Notes

* `opendota_hero_id` is the key used by domain records
* You can either reference internal `heroes.id` or directly store `opendota_hero_id` in child tables
* **Best recommendation:** store **`hero_id` FK to `heroes.id`**, while `heroes` table itself maps to `opendota_hero_id`
* In DESIGN.md explicitly mention: domain entries ultimately reference OpenDota identity via `heroes.opendota_hero_id`

---

## Table 2: `draft_plans`

Purpose: Main entity

Columns:

* `id` (uuid PK recommended, or bigserial if you want speed)
* `name` (varchar, required)
* `description` (text, nullable)
* `created_at`
* `updated_at`

### Recommendation

* Use **UUID** if you want more “senior” feel
* But **bigint autoincrement** is faster to implement and totally acceptable
* For take-home speed: **bigint** is fine

---

## Table 3: `draft_plan_bans`

Purpose: Ban list entries per draft plan

Columns:

* `id` (bigserial PK)
* `draft_plan_id` (FK → draft_plans.id, required)
* `hero_id` (FK → heroes.id, required)
* `note` (text, nullable)
* `created_at`
* `updated_at`

Constraints:

* Unique: (`draft_plan_id`, `hero_id`) to prevent duplicate ban hero in same plan

---

## Table 4: `draft_plan_preferred_picks`

Purpose: Preferred picks entries per draft plan

Columns:

* `id` (bigserial PK)
* `draft_plan_id` (FK → draft_plans.id, required)
* `hero_id` (FK → heroes.id, required)
* `role` (varchar, nullable) — e.g. `Mid`, `Carry`, `Offlane`, etc.
* `priority` (varchar, required default `medium`) — enum-like: `high`, `medium`, `low`
* `note` (text, nullable)
* `created_at`
* `updated_at`

Constraints:

* Unique: (`draft_plan_id`, `hero_id`)
* Check constraint for priority if desired

---

## Table 5: `draft_plan_enemy_threats`

Purpose: Enemy threats / counters to respond to

Columns:

* `id` (bigserial PK)
* `draft_plan_id` (FK → draft_plans.id, required)
* `hero_id` (FK → heroes.id, required)
* `note` (text, nullable)
* `created_at`
* `updated_at`

Constraints:

* Unique: (`draft_plan_id`, `hero_id`)

---

## Table 6: `draft_plan_item_timings`

Purpose: Item timing strategic notes

Columns:

* `id` (bigserial PK)
* `draft_plan_id` (FK → draft_plans.id, required)
* `timing_label` (varchar, required) — e.g. `BKB ~18 min`
* `explanation` (text, required)
* `sort_order` (integer, default 0)
* `created_at`
* `updated_at`

---

# 9) ERD Relationships

* `draft_plans` 1 → N `draft_plan_bans`
* `draft_plans` 1 → N `draft_plan_preferred_picks`
* `draft_plans` 1 → N `draft_plan_enemy_threats`
* `draft_plans` 1 → N `draft_plan_item_timings`
* `heroes` 1 → N `draft_plan_bans`
* `heroes` 1 → N `draft_plan_preferred_picks`
* `heroes` 1 → N `draft_plan_enemy_threats`

---

# 10) DBML Draft (schema.dbml)

```dbml
Table heroes {
  id bigserial [pk]
  opendota_hero_id int [not null, unique]
  name varchar [not null]
  localized_name varchar [not null]
  primary_attr varchar
  attack_type varchar
  roles jsonb
  img varchar
  icon varchar
  raw_payload jsonb
  last_synced_at timestamp
  created_at timestamp
  updated_at timestamp
}

Table draft_plans {
  id bigserial [pk]
  name varchar [not null]
  description text
  created_at timestamp
  updated_at timestamp
}

Table draft_plan_bans {
  id bigserial [pk]
  draft_plan_id bigint [not null]
  hero_id bigint [not null]
  note text
  created_at timestamp
  updated_at timestamp

  indexes {
    (draft_plan_id, hero_id) [unique]
  }
}

Table draft_plan_preferred_picks {
  id bigserial [pk]
  draft_plan_id bigint [not null]
  hero_id bigint [not null]
  role varchar
  priority varchar [not null, default: 'medium']
  note text
  created_at timestamp
  updated_at timestamp

  indexes {
    (draft_plan_id, hero_id) [unique]
  }
}

Table draft_plan_enemy_threats {
  id bigserial [pk]
  draft_plan_id bigint [not null]
  hero_id bigint [not null]
  note text
  created_at timestamp
  updated_at timestamp

  indexes {
    (draft_plan_id, hero_id) [unique]
  }
}

Table draft_plan_item_timings {
  id bigserial [pk]
  draft_plan_id bigint [not null]
  timing_label varchar [not null]
  explanation text [not null]
  sort_order int [not null, default: 0]
  created_at timestamp
  updated_at timestamp
}

Ref: draft_plan_bans.draft_plan_id > draft_plans.id
Ref: draft_plan_bans.hero_id > heroes.id

Ref: draft_plan_preferred_picks.draft_plan_id > draft_plans.id
Ref: draft_plan_preferred_picks.hero_id > heroes.id

Ref: draft_plan_enemy_threats.draft_plan_id > draft_plans.id
Ref: draft_plan_enemy_threats.hero_id > heroes.id

Ref: draft_plan_item_timings.draft_plan_id > draft_plans.id
```

---

# 11) API Contract (Laravel REST)

## Base URL

`/api/v1`

---

## Hero Endpoints

### GET `/heroes`

Purpose:

* List cached heroes from PostgreSQL
* Supports search

Query params:

* `search` (optional)
* `limit` (optional, default 30)

Response:

```json
{
  "data": [
    {
      "id": 1,
      "opendota_hero_id": 2,
      "localized_name": "Axe",
      "name": "npc_dota_hero_axe",
      "primary_attr": "str",
      "attack_type": "Melee",
      "roles": ["Initiator", "Durable"],
      "img": "/apps/dota2/images/heroes/axe_full.png?",
      "icon": "/apps/dota2/images/heroes/axe_icon.png?"
    }
  ]
}
```

### POST `/heroes/sync`

Purpose:

* Fetch heroes from OpenDota and upsert into PostgreSQL
* Usually used by seed or admin/dev utility

Response:

```json
{
  "message": "Heroes synced successfully",
  "count": 126
}
```

> In production-like design, this endpoint can be protected or only used internally.

---

## Draft Plans Endpoints

### GET `/draft-plans`

Response:

```json
{
  "data": [
    {
      "id": 1,
      "name": "Anti Push Draft",
      "description": "Plan against zoo lineups",
      "counts": {
        "bans": 3,
        "preferred_picks": 4,
        "enemy_threats": 2,
        "item_timings": 2
      },
      "created_at": "..."
    }
  ]
}
```

### POST `/draft-plans`

Request:

```json
{
  "name": "Anti Push Draft",
  "description": "Plan against zoo lineups"
}
```

Response:

```json
{
  "data": {
    "id": 1,
    "name": "Anti Push Draft",
    "description": "Plan against zoo lineups"
  }
}
```

### GET `/draft-plans/{id}`

Purpose:

* Full detail with all sections

Response:

```json
{
  "data": {
    "id": 1,
    "name": "Anti Push Draft",
    "description": "Plan against zoo lineups",
    "bans": [...],
    "preferred_picks": [...],
    "enemy_threats": [...],
    "item_timings": [...]
  }
}
```

### PATCH `/draft-plans/{id}` *(optional but recommended)*

### DELETE `/draft-plans/{id}` *(optional but useful)*

---

## Ban Endpoints

### POST `/draft-plans/{id}/bans`

Request:

```json
{
  "hero_id": 12,
  "note": "Strong lane dominator"
}
```

### PATCH `/draft-plans/{id}/bans/{banId}`

Request:

```json
{
  "note": "Punishes greedy supports"
}
```

### DELETE `/draft-plans/{id}/bans/{banId}`

---

## Preferred Picks Endpoints

### POST `/draft-plans/{id}/preferred-picks`

Request:

```json
{
  "hero_id": 20,
  "role": "Mid",
  "priority": "high",
  "note": "Comfort pick for player 2"
}
```

### PATCH `/draft-plans/{id}/preferred-picks/{pickId}`

### DELETE `/draft-plans/{id}/preferred-picks/{pickId}`

---

## Enemy Threats Endpoints

### POST `/draft-plans/{id}/enemy-threats`

Request:

```json
{
  "hero_id": 34,
  "note": "Must answer illusion pressure"
}
```

### PATCH `/draft-plans/{id}/enemy-threats/{threatId}`

### DELETE `/draft-plans/{id}/enemy-threats/{threatId}`

---

## Item Timings Endpoints

### POST `/draft-plans/{id}/item-timings`

Request:

```json
{
  "timing_label": "BKB ~18 min",
  "explanation": "Critical timing before enemy control spikes"
}
```

### PATCH `/draft-plans/{id}/item-timings/{timingId}`

### DELETE `/draft-plans/{id}/item-timings/{timingId}`

---

## Draft Summary Endpoint

### GET `/draft-plans/{id}/summary`

Purpose:

* Returns read-only aggregated structure optimized for UI

Response:

```json
{
  "data": {
    "plan": {
      "id": 1,
      "name": "Anti Push Draft",
      "description": "Plan against zoo lineups"
    },
    "bans": [...],
    "preferred_picks": [...],
    "enemy_threats": [...],
    "item_timings": [...],
    "summary_meta": {
      "total_bans": 3,
      "total_preferred_picks": 4,
      "high_priority_count": 2
    }
  }
}
```

---

# 12) Frontend State Management (Recommended: Zustand)

## Why Zustand

For your take-home:

* Faster than Redux
* Less boilerplate
* Easy to explain in interview
* Looks modern and practical
* Good enough for medium complexity

## Recommended state split

### `useDraftPlansStore`

Handles:

* draft plans list
* selected draft plan detail
* loading states
* create/delete/update actions

### `useHeroBrowserStore`

Handles:

* hero search query
* hero list results
* modal open/close
* target mode (`ban` | `preferred_pick` | `enemy_threat`)

### `useUiStore`

Handles:

* modal states
* toast/snackbar
* temporary selected entity for edit

## Alternative

If you want even simpler:

* Use **server state via fetch in page components**
* Use local `useState` + `useReducer`
* But **Zustand + service layer** is more polished

---

# 13) Frontend Folder Structure (Next.js)

```bash
frontend/
├── app/
│   ├── layout.tsx
│   ├── page.tsx
│   ├── draft-plans/
│   │   ├── page.tsx
│   │   ├── new/
│   │   │   └── page.tsx
│   │   └── [id]/
│   │       ├── page.tsx
│   │       └── summary/
│   │           └── page.tsx
│   ├── globals.css
│   └── providers.tsx
├── components/
│   ├── common/
│   │   ├── Button.tsx
│   │   ├── Input.tsx
│   │   ├── Modal.tsx
│   │   ├── EmptyState.tsx
│   │   └── LoadingSpinner.tsx
│   ├── draft-plans/
│   │   ├── DraftPlanCard.tsx
│   │   ├── DraftPlanForm.tsx
│   │   ├── DraftPlanHeader.tsx
│   │   ├── DraftSectionCard.tsx
│   │   ├── BanListSection.tsx
│   │   ├── PreferredPicksSection.tsx
│   │   ├── EnemyThreatsSection.tsx
│   │   ├── ItemTimingSection.tsx
│   │   └── DraftSummaryView.tsx
│   └── heroes/
│       ├── HeroBrowserModal.tsx
│       ├── HeroList.tsx
│       └── HeroRow.tsx
├── lib/
│   ├── api/
│   │   ├── client.ts
│   │   ├── draftPlans.ts
│   │   ├── heroes.ts
│   │   └── mappers.ts
│   ├── constants/
│   │   └── priorities.ts
│   ├── schemas/
│   │   ├── draftPlan.ts
│   │   ├── ban.ts
│   │   ├── preferredPick.ts
│   │   ├── enemyThreat.ts
│   │   └── itemTiming.ts
│   └── utils/
│       └── format.ts
├── stores/
│   ├── useDraftPlansStore.ts
│   ├── useHeroBrowserStore.ts
│   └── useUiStore.ts
├── types/
│   ├── api.ts
│   ├── draft-plan.ts
│   └── hero.ts
├── package.json
└── tsconfig.json
```

---

# 14) Backend Folder Structure (Laravel)

```bash
backend/
├── app/
│   ├── Http/
│   │   ├── Controllers/Api/V1/
│   │   │   ├── DraftPlanController.php
│   │   │   ├── DraftPlanBanController.php
│   │   │   ├── DraftPlanPreferredPickController.php
│   │   │   ├── DraftPlanEnemyThreatController.php
│   │   │   ├── DraftPlanItemTimingController.php
│   │   │   ├── DraftPlanSummaryController.php
│   │   │   └── HeroController.php
│   │   ├── Requests/
│   │   │   ├── StoreDraftPlanRequest.php
│   │   │   ├── UpdateDraftPlanRequest.php
│   │   │   ├── StoreBanRequest.php
│   │   │   ├── UpdateBanRequest.php
│   │   │   ├── StorePreferredPickRequest.php
│   │   │   ├── UpdatePreferredPickRequest.php
│   │   │   ├── StoreEnemyThreatRequest.php
│   │   │   ├── UpdateEnemyThreatRequest.php
│   │   │   ├── StoreItemTimingRequest.php
│   │   │   └── UpdateItemTimingRequest.php
│   │   └── Resources/
│   │       ├── DraftPlanResource.php
│   │       ├── DraftPlanDetailResource.php
│   │       ├── DraftSummaryResource.php
│   │       └── HeroResource.php
│   ├── Models/
│   │   ├── DraftPlan.php
│   │   ├── DraftPlanBan.php
│   │   ├── DraftPlanPreferredPick.php
│   │   ├── DraftPlanEnemyThreat.php
│   │   ├── DraftPlanItemTiming.php
│   │   └── Hero.php
│   ├── Services/
│   │   ├── HeroSyncService.php
│   │   └── DraftPlanSummaryService.php
│   └── Console/Commands/
│       └── SyncHeroesCommand.php
├── database/
│   ├── migrations/
│   ├── seeders/
│   │   ├── DatabaseSeeder.php
│   │   ├── HeroSeeder.php
│   │   └── DraftPlanDemoSeeder.php
│   └── factories/
├── routes/
│   └── api.php
└── composer.json
```

---

# 15) Migration Strategy

## Order of migrations

1. `create_heroes_table`
2. `create_draft_plans_table`
3. `create_draft_plan_bans_table`
4. `create_draft_plan_preferred_picks_table`
5. `create_draft_plan_enemy_threats_table`
6. `create_draft_plan_item_timings_table`

## Important migration rules

* Add foreign keys with `cascadeOnDelete()` for all child tables
* Add unique composite indexes to prevent duplicates
* Add `priority` default = `medium`
* Use `jsonb` for `roles` and `raw_payload`

---

# 16) Seed Strategy

## Required deliverable says:

* Must have **database seed script**
* Must have **one command to initialize and populate DB**

## Recommended seed content

### A. `HeroSeeder`

* Calls `HeroSyncService`
* Fetches from OpenDota `/api/heroes`
* Upserts into `heroes`

### B. `DraftPlanDemoSeeder`

* Creates 1–2 sample draft plans
* Adds:

  * 2–3 bans
  * 2–3 preferred picks
  * 1–2 enemy threats
  * 1–2 item timings

### C. `DatabaseSeeder`

* Runs `HeroSeeder`
* Then `DraftPlanDemoSeeder`

## One-command init (important)

Recommended command:

```bash
php artisan migrate:fresh --seed
```

If using Docker:

```bash
docker compose exec backend php artisan migrate:fresh --seed
```

### Even better

Create custom command or Makefile alias:

```bash
php artisan app:init
```

that internally runs:

* migrate
* seed
* optional hero sync

But to keep scope simple:

* **Document `php artisan migrate:fresh --seed` as the one command**

---

# 17) OpenDota Caching in PostgreSQL (Bonus-Friendly)

## Goal

Reduce repeated external API calls without Redis/Memcached or client localStorage.

## Recommended design

### Option A (Best for take-home)

**Preload all heroes into PostgreSQL once**

* On seed or manual sync
* Since hero list is mostly static
* Frontend always reads from local DB

This is the cleanest and most stable solution.

## Flow

1. Backend requests OpenDota `/api/heroes`
2. Backend transforms response
3. Upsert into `heroes` table using `opendota_hero_id`
4. Save `last_synced_at`
5. UI only calls local API `/api/v1/heroes`

## Why this satisfies bonus

* External calls are minimized
* Cache lives in PostgreSQL only
* No Redis needed

## Upsert logic

Match on:

* `opendota_hero_id`

Update fields:

* `name`
* `localized_name`
* `primary_attr`
* `attack_type`
* `roles`
* `img`
* `icon`
* `raw_payload`
* `last_synced_at`

## Interview talking point

> “I intentionally centralized OpenDota access in the backend and cached hero metadata in PostgreSQL, so the frontend remains stable, repeated external calls are reduced, and all draft plan references stay consistent through a normalized local heroes table keyed by OpenDota identity.”

---

# 18) Long-Running Task with PostgreSQL Only (Bonus, Optional)

If you want bonus mention without overbuilding:

## Simple approach

* Create a `hero_sync_jobs` table *(optional)*
* User triggers sync
* Backend inserts a job row with status `pending`
* Laravel command/cron polls and processes pending jobs
* Update status to `running`, then `completed` / `failed`

But honestly for time efficiency:

* **Skip implementation**
* Mention in DESIGN.md under “What was intentionally not built and why?”

This is senior because:

* You understand the concept
* You intentionally avoid overengineering due to timebox

---

# 19) Error Handling Strategy

## Frontend

* Show loading state for API calls
* Show empty state when no data
* Show inline form validation errors
* Show toast for failed network requests
* Disable submit buttons while pending
* Gracefully handle duplicate hero addition (409 or validation message)

## Backend

* Use Laravel Form Requests for validation
* Return consistent JSON errors
* Use proper HTTP codes:

  * `200 OK`
  * `201 Created`
  * `204 No Content`
  * `422 Validation Error`
  * `404 Not Found`
  * `409 Conflict` (duplicate hero in same section, if desired)
  * `500 Internal Server Error`

## OpenDota failure fallback

* If sync fails:

  * Return meaningful error
  * Existing cached heroes remain usable
* This is a very strong interview point

---

# 20) Data Flow Overview (For DESIGN.md)

## Example 1: Add Ban Hero

1. User opens Draft Plan Detail page
2. User clicks “Add to Ban List”
3. Hero Browser modal opens
4. Frontend fetches cached heroes from backend `/api/v1/heroes`
5. User selects hero
6. Frontend sends `POST /api/v1/draft-plans/{id}/bans`
7. Backend validates:

   * draft plan exists
   * hero exists
   * no duplicate in same plan ban list
8. Backend writes to `draft_plan_bans`
9. Backend returns created record
10. Frontend refreshes selected draft plan state

## Example 2: View Summary

1. User opens `/draft-plans/{id}/summary`
2. Frontend calls `/api/v1/draft-plans/{id}/summary`
3. Backend aggregates related data
4. Backend returns read-only structure
5. Frontend renders concise sections for quick scan

---

# 21) DESIGN.md Structure (Recommended)

Create a `DESIGN.md` with these sections:

## 1. Overview

* Brief summary of architecture

## 2. Planned Pages / Screens

* Draft Plans List
* Draft Plan Detail
* Hero Browser Modal
* Draft Summary

## 3. Routing Structure

* `/draft-plans`
* `/draft-plans/[id]`
* `/draft-plans/[id]/summary`

## 4. State Management Approach

* Zustand for client UI/domain state
* Service layer for API calls
* Why not Redux: avoid boilerplate for timeboxed scope

## 5. Data Flow

* UI → Laravel API → PostgreSQL
* OpenDota only accessed via backend for caching

## 6. Error Handling

* Frontend + backend strategy

## 7. Tradeoffs / What Was Not Built

Suggested content:

* Authentication omitted due to timeboxing
* Reordering/sorting UX omitted
* Advanced analytics omitted
* Background sync scheduler omitted

---

# 22) AI_LOG.md Structure (Required)

Even if AI is used, be transparent and professional.

## Recommended format

```md
# AI_LOG.md

## AI Tools Used
- ChatGPT

## Prompt Record 1
- Purpose: project planning and architecture scaffolding
- First Prompt: "Help me break down a Dota 2 Draft Plans fullstack take-home assessment..."
- Iterations: 4
- Final Prompt / Accepted Output: Finalized architecture, ERD, API contract, folder structure
- Notes: Used for planning and scoping

## Prompt Record 2
- Purpose: DBML drafting
- First Prompt: "Generate DbML schema for draft plans, heroes, bans, preferred picks, threats, item timings"
- Iterations: 2
- Final Prompt / Accepted Output: schema.dbml draft used as base
- Notes: Used for ERD and schema validation

## Prompt Record 3
- Purpose: README and deliverable checklist
- First Prompt: "Create a 5-step README for local docker setup"
- Iterations: 2
- Final Prompt / Accepted Output: concise setup instructions
- Notes: Used for documentation polishing

## Prompt Record 4
- Purpose: refactoring / edge-case review
- First Prompt: "Review this API design for duplicate hero prevention and caching strategy"
- Iterations: 3
- Final Prompt / Accepted Output: improved validation and caching notes
- Notes: Used for refinement and review

## Custom AI Instructions / Agent Files
- None
```

> If you create `agents.md` or `skills.md`, list them here.

---

# 23) README.md (Maximum 5 Steps)

## Recommended 5-Step README

```md
# Dota 2 Draft Plans

## Requirements
- Docker + Docker Compose

## Setup (5 Steps)
1. Copy environment files
   - `cp backend/.env.example backend/.env`
   - `cp frontend/.env.example frontend/.env.local`

2. Start all services
   - `docker compose up --build -d`

3. Install backend app key (first time only)
   - `docker compose exec backend php artisan key:generate`

4. Initialize database (migrate + seed)
   - `docker compose exec backend php artisan migrate:fresh --seed`

5. Open the app
   - Frontend: `http://localhost:3000`
   - Backend API: `http://localhost:8000/api/v1`
```

## Optional Notes

* If hero sync fails due to OpenDota temporary issue, rerun:

```bash
docker compose exec backend php artisan db:seed --class=HeroSeeder
```

---

# 24) Docker Compose Strategy

## Services

### `db`

* image: postgres:16
* env:

  * POSTGRES_DB=dota_draft
  * POSTGRES_USER=postgres
  * POSTGRES_PASSWORD=postgres
* port: `5432:5432`

### `backend`

* build from `./backend`
* depends_on `db`
* port: `8000:8000`
* command can be simplified for dev

### `frontend`

* build from `./frontend`
* depends_on `backend`
* port: `3000:3000`

## Recommendation

For take-home:

* Keep docker simple and dev-friendly
* Don’t overengineer Nginx unless needed

---

# 25) Submission Checklist (Very Important)

## Required Deliverables Checklist

* [ ] Full source code included
* [ ] **`.git` directory included** inside ZIP ⚠️
* [ ] `README.md` (≤ 5 setup steps)
* [ ] `DESIGN.md`
* [ ] `AI_LOG.md`
* [ ] `schema.dbml`
* [ ] Database migration files
* [ ] Database seed files
* [ ] One command for init + populate DB documented
* [ ] Docker Compose file included
* [ ] Backend + frontend env example files included
* [ ] App runs locally end-to-end

## Strongly Recommended Extras

* [ ] Sample seeded data for instant demo
* [ ] Clean commit history (meaningful commits)
* [ ] Consistent API response shape
* [ ] Good loading / empty / error states
* [ ] Duplicate prevention for hero entries
* [ ] Short architecture explanation ready for interview

---

# 26) Most Realistic Senior-Looking Timeline

## If deadline is tight (1.5–2.5 days focused work)

### Day 1 — Foundation (6–8 hours)

* [ ] Initialize repo with `frontend/` + `backend/`
* [ ] Setup Docker Compose
* [ ] Setup Laravel + PostgreSQL connection
* [ ] Create migrations + models + relations
* [ ] Implement hero sync service + seeder
* [ ] Seed DB with heroes + sample plan
* [ ] Test API base works

### Day 2 — Core Feature Delivery (6–10 hours)

* [ ] Build Draft Plans list page
* [ ] Build create draft plan flow
* [ ] Build draft plan detail page
* [ ] Build hero browser modal
* [ ] Implement add/remove bans
* [ ] Implement add/remove preferred picks
* [ ] Implement add/remove enemy threats
* [ ] Implement add/edit/delete item timings

### Day 3 — Polish & Submission (4–8 hours)

* [ ] Build summary page
* [ ] Improve validation & error handling
* [ ] UI cleanup (Tailwind polish)
* [ ] Write README.md
* [ ] Write DESIGN.md
* [ ] Write AI_LOG.md
* [ ] Create `schema.dbml`
* [ ] Verify one-command init works
* [ ] Final ZIP check with `.git`

## If you only have ~1 day

**Prioritize in this order:**

1. Docker + DB + migrations
2. Hero sync/cache
3. Draft plans list + create
4. Detail page
5. Ban / Preferred / Threat CRUD
6. Item timings
7. Summary page
8. Docs polish

---

# 27) Recommended State & UI Implementation Scope (Best Balance)

## Minimal but strong UI features

* Search hero by name in modal
* Section cards with count badges
* Empty states for each section
* Priority badge colors (High/Medium/Low)
* Summary page as printable clean card layout

## Don’t waste time on

* Fancy animations
* Drag-and-drop sorting
* Complex tables
* Overly custom design system

**Goal:** functional, clean, stable, explainable.

---

# 28) Suggested Commit History (Looks Senior)

Example commit sequence:

1. `chore: initialize monorepo with frontend and backend structure`
2. `chore: add docker compose for frontend backend and postgres`
3. `feat: add database schema for draft plans and hero references`
4. `feat: implement OpenDota hero sync and seed caching`
5. `feat: add draft plans CRUD endpoints`
6. `feat: add ban list and preferred picks endpoints`
7. `feat: add enemy threats and item timing endpoints`
8. `feat: build draft plans list and detail pages`
9. `feat: add hero browser modal and section management UI`
10. `feat: implement draft summary page`
11. `docs: add README DESIGN AI_LOG and schema.dbml`
12. `refactor: improve validation and error handling`

---

# 29) Interview Talking Points (Important for Stage After Submission)

## Why Laravel + Next.js?

> “I chose a dedicated Laravel API with PostgreSQL and a Next.js frontend because it best demonstrates fullstack ownership while keeping the architecture production-like and easy to reason about under a take-home timebox.”

## Why cache OpenDota in PostgreSQL?

> “The hero dataset is relatively stable, so I cached it server-side in PostgreSQL to reduce external API dependency, avoid repeated calls, and keep all draft plan references normalized through a local heroes table.”

## Why Zustand?

> “I used Zustand because it offers enough structure for this medium-sized UI without Redux-level boilerplate, which kept the implementation efficient while still maintaining clear state boundaries.”

## What did you intentionally not build?

> “I intentionally did not add authentication or background job orchestration because they were outside the core product objective, and I prioritized correctness, clarity, and complete required deliverables first.”

---

# 30) Final Recommendation (My Strongest Advice for You)

## Build this exact version:

* **Next.js + Tailwind + Zustand**
* **Laravel REST API**
* **PostgreSQL**
* **Docker Compose**
* **Hero cache in DB via backend sync**
* **Clean docs + sample seeded data**

## Why this is the best for you

Because it:

* Matches your real-world fullstack capability
* Is feasible within timebox
* Looks more senior than Supabase-only
* Gives strong interview storytelling
* Lets you control architecture decisions clearly

---

# 31) Next Recommended Execution Order (When Continuing in New Chat)

When you continue in a new chat, do this order:

1. **Generate project folder scaffolding (frontend + backend + docker)**
2. **Create Laravel migrations & models**
3. **Create Laravel API routes + controllers**
4. **Create HeroSyncService + seeder**
5. **Create Next.js page structure**
6. **Create Zustand stores + service layer**
7. **Implement UI page by page**
8. **Write README / DESIGN / AI_LOG / schema.dbml**
9. **Review submission checklist**

---

# 32) Copy-Paste Prompt for Next Chat (Use This)

```md
Continue from my Dota 2 Draft Plans take-home plan.
Tech stack is fixed:
- Frontend: Next.js App Router, Tailwind CSS, TypeScript, Zustand, React Hook Form, Zod
- Backend: Laravel API
- DB: PostgreSQL
- Infra: Docker Compose

Please continue step by step in this exact order:
1. Generate full project folder scaffolding
2. Create docker-compose.yml
3. Create Laravel migrations and models
4. Create API routes and controllers
5. Create HeroSyncService and seeders
6. Create Next.js page structure and components
7. Create Zustand stores and API service layer
8. Create README.md, DESIGN.md, AI_LOG.md, and schema.dbml

Use the architecture and ERD from the previous master plan.
```

---

# 33) Closing Note

This plan is intentionally optimized for:

* **Speed of execution**
* **Senior-looking architecture**
* **Interview explainability**
* **High completion probability**

If you follow this exactly, your submission will look:

* structured,
* complete,
* practical,
* and much more senior than a rushed “just make it work” take-home.
