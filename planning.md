# Redpoint — Planning & Design Decisions

## Concept

Hybrid analog/digital training log. User writes sessions in a physical notebook, takes a photo, and a multimodal AI model converts the handwritten log into structured digital data. The analog habit stays intact; the digital layer adds trend visibility.

---

## Core Value Proposition

1. **Longitudinal visibility** — total miles, session counts, PR curves over months/years
2. **Cross-sport, all-in-one** — no app fragmentation across Strava/Hevy/etc.
3. **Qualitative data preserved** — free-text notes from the notebook become structured and searchable over time

---

## User Flow

1. Tap "+" FAB → camera screen (no sport pre-selection)
2. Take or select photo of notebook page
3. Claude Vision API parses the photo → returns structured JSON
4. Optional correction screen — user can review/edit parsed log or skip
5. Log is saved to local DB

- **Manual entry** is available but intentionally buried (multiple clicks) to keep the photo-first habit central
- **Sport is detected by the model** from the photo — no upfront selector

---

## AI / Parsing

- Model: Claude Vision API (Anthropic)
- Input: base64-encoded image + sport-aware system prompt
- Output: structured JSON (see schema below)
- One photo can span **multiple days and multiple sports** — the model handles this
- User's handwriting is readable even when messy; consistent entry layout is the only discipline required of the user

### JSON Schema (parsed output)

```json
{
  "days": [
    {
      "date": "2024-04-08",
      "sessions": [
        {
          "sport": "climbing",
          "duration_minutes": 90,
          "notes": "Not a great session. Feeling stuck.",
          "projects": [
            { "name": "Panda", "sent": true, "notes": "can do any panda" },
            { "name": "Racoon", "sent": false, "notes": "" }
          ]
        },
        {
          "sport": "yoga",
          "duration_minutes": 60,
          "style": "Stretch + Breathe",
          "notes": ""
        }
      ]
    }
  ]
}
```

---

## Tech Stack

- **Platform:** iOS (iPhone)
- **Language:** Swift
- **UI Framework:** SwiftUI
- **Persistence:** GRDB (SQLite, via GRDB.swift library)
- **AI:** Claude Vision API (Anthropic)
- **Editor:** Neovim (primary), Xcode (build/simulator/project management)

---

## UI / UX Design

### Theme

- System-dependent by default (light/dark follows iOS setting)
- User can override in More tab

### Bottom Tab Bar (4 tabs)

| Tab        | Content                                             |
| ---------- | --------------------------------------------------- |
| Date       | Training log view with Daily/Weekly/Monthly subtabs |
| Stats      | Pie chart + trend analytics                         |
| Activities | Per-sport volume summary                            |
| More       | Settings, theme, etc.                               |

### Date Tab

- **Top subtabs:** Daily | Weekly | Monthly
- **Default:** Weekly
- **Weekly view:** Mon–Sun headers, all 7 days shown (empty days show header only)
- **Session card:** SF Symbol sport icon · "Sport · key metric" · gray notes preview
- **Red "+" FAB** in bottom-right corner, visible on Date tab only
- FAB → straight to camera (no sport pre-selection)
- No sport color coding — volume-based coloring in Stats only

### Stats Tab

- Pie chart: sport breakdown by session count/volume over a selectable time period
- Colors are volume-based (most volume = red, fades for less) — no sport is tied to a specific color
- Tap a sport slice → line chart showing trend over time for that sport

### Activities Tab

- N rows, one per sport
- Each row: sport name + volume metric (e.g. "Running · 23.4 mi this month")
- Tap → full sport history and trends

---

## Data Models

### Record Granularity

**One record per sport session, not per day.**

- A day with run + climb + yoga = 3 separate Session records, all with the same date
- A second run in the evening = a 4th record
- The "day" is a display grouping concept only, not a storage unit
- A photo spanning multiple days produces multiple Session records across different dates

### Database

- **GRDB.swift** — direct SQLite control, no ORM magic
- One detail table per sport — `sessions` stays lean with common fields only
- No users table — single-user on-device app, no need
- Images saved to app documents directory (`session_images/<uuid>.jpg`); path stored in sessions table
- `ON DELETE CASCADE` on all sport tables — deleting a session cleans up everything linked to it

### Schema

**`sessions`**
| Field | Type | Notes |
|-------|------|-------|
| `id` | INTEGER PK | |
| `date` | TEXT | "2026-04-25" |
| `sport` | TEXT | "running" \| "lifting" \| "climbing" \| "yoga" |
| `duration_minutes` | INTEGER | optional |
| `notes` | TEXT | always present, default '' |
| `feel` | INTEGER | 1–5, optional |
| `source` | TEXT | "photo" \| "manual" |
| `image_path` | TEXT | relative path to image file, null for manual entries |
| `created_at` | TEXT | |

**`run_sessions`**
| Field | Type | Notes |
|-------|------|-------|
| `id` | INTEGER PK | |
| `session_id` | INTEGER FK → sessions | CASCADE |
| `distance_miles` | REAL | |
| `pace` | TEXT | optional, e.g. "8:45/mi" |

**`lift_sessions`**
| Field | Type | Notes |
|-------|------|-------|
| `id` | INTEGER PK | |
| `session_id` | INTEGER FK → sessions | CASCADE |
| `day_type` | TEXT | optional, e.g. "Push", "Legs + Pull" |

**`exercises`**
| Field | Type | Notes |
|-------|------|-------|
| `id` | INTEGER PK | |
| `lift_session_id` | INTEGER FK → lift_sessions | CASCADE |
| `name` | TEXT | |
| `sets` | INTEGER | |
| `reps` | INTEGER | |
| `weight` | REAL | optional |
| `weight_unit` | TEXT | optional, "lb" \| "kg" \| "kb" |
| `notes` | TEXT | optional |

**`climb_sessions`**
| Field | Type | Notes |
|-------|------|-------|
| `id` | INTEGER PK | |
| `session_id` | INTEGER FK → sessions | CASCADE |

**`climbing_projects`**
| Field | Type | Notes |
|-------|------|-------|
| `id` | INTEGER PK | |
| `climb_session_id` | INTEGER FK → climb_sessions | CASCADE |
| `name` | TEXT | project name e.g. "Panda" |
| `sent` | INTEGER | 0/1 boolean |
| `attempts` | INTEGER | default 1 |
| `grade` | TEXT | optional |
| `notes` | TEXT | optional |

**`yoga_sessions`**
| Field | Type | Notes |
|-------|------|-------|
| `id` | INTEGER PK | |
| `session_id` | INTEGER FK → sessions | CASCADE |
| `style` | TEXT | optional, e.g. "Vinyasa 2" |
| `poses` | TEXT | optional, comma-separated |

### Supported Sports (v1)

- Running
- Lifting
- Climbing
- Yoga

---

## Handwriting / Notation Conventions

- Climbing: tracked by **project name**, not grade (grade is optional)
- Lifting: weight in brackets e.g. `[35kb]`, `[10lb]`; reps x sets format varies
- Multiple sports per page/day is the norm — model handles splitting
- Insertions marked with `^` and word written above are handled by model
- "f" in reps = to failure (e.g. "3 x f")

---

## Analytics (Strava-simple)

- Graph per time interval (weekly/monthly)
- Best efforts per sport
- Volume counts (total miles, total sessions, total reps/mileage)
- Build after core logging flow is complete

---

## Build Sequence

1. App structure — TabView root, Weekly log view, FAB
2. GRDB schema + migrations — create all tables
3. Swift model structs — one per table, Codable + FetchableRecord
4. Camera + Claude API service — photo → JSON
5. Correction screen — review/edit parsed log
6. Save to DB + display in weekly view
7. Stats tab — pie chart
8. Activities tab — per-sport volume rows
9. More tab — settings, theme picker
