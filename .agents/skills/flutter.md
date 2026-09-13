# Skill: Flutter Development (`fitbizz_app`)

## Core Practices

### 1. Mandatory Cross-Platform UI Strategy (Desktop + Mobile)
* **Proactive Dual-Platform Ownership**: Every UI widget or screen MUST be designed for both Mobile (`<600px`) and Desktop (`>1024px`). Never treat mobile or desktop as an afterthought.
* **Layout Strategy Adaptation (No Shrinking Hacks)**:
  - **Desktop**: Side navigation, multi-column dashboard grids, dense `AppDataTable` grids, horizontal forms, keyboard/mouse shortcuts, mouse hover effects.
  - **Mobile**: Bottom navigation, single-column stacked forms, card views for data grids, bottom sheets (`AppBottomSheet`) or full-screen dialogs, touch target padding (>= 48px).
* **Adaptive Overlay Components**:
  - `SnackBar` / Toast: Positioned and constrained properly on both mobile (full-width bottom) and desktop (floating bottom-right with max width).
  - `AppDialog`: Max width constrained on desktop; full-width or bottom sheet on mobile.
  - `AppDataTable`: Renders interactive data table on desktop; converts to stacked card list or scrollable cards on mobile.

### 2. Structural Responsive Architecture
* Use `LayoutBuilder` to read constraints dynamically and switch layout sub-trees.
* Use `Expanded` / `Flexible` / `Wrap` inside responsive rows and columns to handle text wrapping and dynamic window resizing smoothly.
* Never use hardcoded pixel widths/heights, negative margins, or magic numbers to force layouts.

### 3. Reusable Component Primitives
* `AppButton` — Primary, Secondary, Text, and Danger variants with built-in loading state.
* `AppTextField` — Validated input with label, focus highlight, and error text.
* `AppCard` — Surface container with 1px border (`#E2E8F0`) and subtle elevation.
* `AppDialog` — Adaptive modal dialog (constrained desktop width / full-width mobile).
* `AppBadge` — Semantic status indicator pill.
* `AppDataTable` — Responsive data grid for desktop, converting to mobile cards.
* `AppBottomSheet` — Mobile-first action/input modal sheet.
* `AppEmptyState` — Clean empty dataset layout.
* `AppErrorState` — Standardized failure state with retry action button.
* `AppLoadingState` — Skeleton shimmers and non-blocking spinners.
* `AppStatCard` — Metric dashboard summary card.

### 4. Verification Workflow
* **Static Analysis**: `flutter analyze` must pass with 0 errors/warnings.
* **Build Targets**:
  - Windows Desktop: `flutter build windows` or `flutter run -d windows`
  - Android Mobile: `flutter build apk` or `flutter run -d <android-device>`
* **Layout Verification Checklist**: Verify zero `RenderFlex` overflows, zero clipped text, zero inaccessible buttons, and smooth layout breakpoint transitions.
