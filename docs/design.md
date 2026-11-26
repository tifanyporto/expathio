# Design

Visual identity and interface rules for Expathio. They apply to every part of
the project, not only to mail.

## 1. Direction

Expathio should feel clean and intimate: a quiet place of one's own. Warmth
comes from colour, space and wording, never from decoration.

- **Less, but warm.** Warm paper instead of white, a single violet, and no
  element that does not do a job.
- **Room to breathe.** Generous spacing and a narrow reading column. Nothing
  competes with the content.
- **Plain, kind words.** The interface speaks like a person and is honest
  about what does not work yet.

## 2. Colour

### 2.1 Light theme

| Token | Value | Use |
|---|---|---|
| `paper` | `#FAF6F0` | Page background, everywhere |
| `sheet` | `#FFFFFF` | Reading and writing surfaces, main panels |
| `linen` | `#F1EBE3` | Fields, secondary buttons, side areas, hover |
| `lilac` | `#ECE5F6` | Selected item, soft fills |
| `violet` | `#6B47A8` | Primary colour: main action, links, focus, unread mark |
| `on-violet` | `#FFFFFF` | Text on `violet` |
| `ink` | `#2B2630` | Text |
| `ink-reading` | `#3A3340` | Long-form text, such as a message body |
| `ink-secondary` | `#6A6170` | Metadata, captions, field labels |
| `ink-muted` | `#746B7A` | Small technical detail |
| `line` | `#EAE2D8` | Dividers on `paper` |
| `line-soft` | `#F1EBE3` | Dividers on `sheet` |
| `positive` | `#2F6B45` | "Working" state, as text |
| `pending` | `#8A5400` | "Not yet" state, as text |
| `notice-bg` | `#F8EDDA` | Background of an inline notice |
| `notice-ink` | `#4F3300` | Text of an inline notice |
| `disabled-bg` | `#D9CEEB` | Disabled primary button |
| `disabled-ink` | `#5A4A7A` | Text of a disabled primary button |

### 2.2 Dark theme

| Token | Value |
|---|---|
| `paper` | `#1D1920` |
| `sheet` | `#262129` |
| `linen` | `#2C2630` |
| `lilac` | `#322A3B` |
| `violet` | `#B29BE0` |
| `on-violet` | `#1D1920` |
| `ink` | `#F2ECE6` |
| `ink-reading` | `#E4DCD8` |
| `ink-secondary` | `#B5ABB8` |

In the dark theme, surfaces carry no shadow.

### 2.3 Rules

- `violet` is the only accent. It marks the one main action of a view, links,
  focus and unread items. It is never used as a background wash.
- `lilac` marks the selected item and nothing else of importance.
- `paper` is the background of every view. `sheet` is reserved for the surface
  the person reads or writes on.
- State is written in words ("Working", "Not yet") and coloured as text. Colour
  alone never carries meaning.
- Text contrast is at least 4.5:1. Reference pairs: `on-violet` on `violet`
  6.8:1, `ink-secondary` on `paper` 5.5:1, `ink-muted` on `paper` 4.7:1.

## 3. Typography

| Role | Family | Size / line height | Weight |
|---|---|---|---|
| View title | Newsreader | 30/38 to 44/52 | 400 |
| Content title (a message subject) | Newsreader | 36/44 | 400 |
| Long-form text (a message body) | Newsreader | 18/31 | 400 |
| Interface text | Hanken Grotesk | 15/22 | 400; 600 for emphasis and unread |
| Secondary text | Hanken Grotesk | 13–14/20 | 400 |
| Buttons | Hanken Grotesk | 15 | 600 |
| Wordmark | Hanken Grotesk | 17 | 600, lowercase `expathio` |

- Newsreader is used for titles and for what people write. Hanken Grotesk is
  used for everything around it.
- Titles use a letter spacing of -0.015em to -0.02em. No italics, no uppercase
  labels, no letter-spaced captions.
- Numbers that line up (counts, ports, sizes) use tabular figures.
- No decorative, display or handwriting typefaces.

## 4. Space and shape

- **Spacing.** Multiples of 4 px. Common steps: 8, 12, 16, 20, 24, 32, 40, 56.
- **Reading column.** Long-form text is at most 620 px wide and centred on its
  sheet.
- **Controls.** 44 px high for main actions, 40 px for list rows and fields,
  with a corner radius of 10 to 12 px.
- **Sheets.** Corner radius of 20 px and a very light shadow:
  `0 1px 2px rgba(43,38,48,0.04), 0 12px 32px -16px rgba(43,38,48,0.10)`.
- **Lines.** Used sparingly. Space separates groups before a divider does.
  No borders around panels, no dashed lines.
- **No rotation, texture or imitation of physical objects.**

## 5. Components

| Component | Specification |
|---|---|
| Primary button | `violet` background, `on-violet` text, 44 px high, radius 12. One per view. |
| Secondary button | `linen` background, `ink` text, same size. |
| Quiet button | No background, `ink-secondary` text. For less frequent actions such as "Delete". |
| Field | `linen` background without a border on `paper`; on `sheet`, a white field with a 1 px inner line. A visible label above it or beside it. |
| List row | No divider. Radius 12. Selected: `lilac` background. Unread: a 7 px `violet` dot before the row and weight 600 on sender and subject. |
| Navigation item | Text only, 40 px high, radius 10. Current: `lilac` background and weight 600. |
| Inline notice | `notice-bg` background, `notice-ink` text, radius 12, placed next to what it is about. States the problem and the way out in one or two sentences. |
| Token (a recipient, an attachment) | `lilac` or `linen` background, radius 10 to 12, with a remove button of at least 28 px. |

Actions are labelled with words ("Reply", "Forward", "Delete"). Icons are the
exception: used only where a word does not fit, and always with an accessible
name.

## 6. Voice

Interface text is in English, short, and written the way a person would say it.

| Instead of | Write |
|---|---|
| No messages in this folder. | Nothing here. |
| Error: relay host not configured. | Mail to other domains isn't connected yet. |
| Create account | Add an address |
| 3 unread messages | 3 unread |

- Things keep their standard names (Inbox, Drafts, Sent, Junk, Trash). No
  metaphors and no renaming for charm.
- When something is not available, say what and why, and what the person can
  do now. Technical detail may follow in small secondary text.
- No exclamation marks in interface text, no jargon in the first sentence.

## 7. Accessibility

- Interactive elements are real controls (`button`, `a`, `input` with a
  `label`) and are reachable by keyboard.
- Targets are at least 40 px high; remove buttons inside tokens at least 28 px.
- Focus is always visible, drawn in `violet`.
- Both themes meet the contrast rule in section 2.3.

## 8. Layout

Desktop-first. A view is made of a quiet side column for navigation on
`paper`, a list on `paper`, and one `sheet` for the content in focus. At narrow
widths the columns stack in that order.
