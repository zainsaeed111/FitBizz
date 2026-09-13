# Design System — FitBizz

The canonical source of truth for FitBizz visual design across Mobile, Desktop, and Web.

## 1. Aesthetic Direction & Brand Identity
* **Brand Name**: FitBizz
* **Product Category**: Enterprise Gym & Fitness Business Management SaaS.
* **Visual Persona**: *Professional, Premium, Modern, Trustworthy, Fast, Business-Focused, Clean*.
* **Forbidden Visual Patterns**:
  - NO dumbbell imagery or bodybuilding clichés.
  - NO neon colors, heavy glassmorphism, or noisy gradients.
  - NO arbitrary, hardcoded screen-specific colors (e.g. `Color(0xFF2563EB)`).

---

## 2. Color Palette Tokens

### Primary Brand Palette
* **Primary / Heading Text**: `#0F172A` (Slate 900)
* **Primary Action**: `#2563EB` (Blue 600)
* **Secondary Blue**: `#3B82F6` (Blue 500)
* **Background**: `#F8FAFC` (Slate 50)
* **Surface**: `#FFFFFF` (Pure White)
* **Secondary Text**: `#64748B` (Slate 500)
* **Border / Divider**: `#E2E8F0` (Slate 200)

### Feedback & Status Tokens
* **Success**: `#16A34A` (Green 600)
* **Warning**: `#F59E0B` (Amber 500)
* **Error / Danger**: `#DC2626` (Red 600)

### Dark Theme Tokens
* **Dark Background**: `#0B1120` (Deep Slate Dark)
* **Dark Surface**: `#111827` (Slate 900 Dark)

---

## 3. Typography & Spacing Foundations

* **Typography**: `Inter` / `Manrope` (Clean, highly readable international typography).
* **Spacing Scale**:
  - `xs`: 4px | `sm`: 8px | `md`: 16px | `lg`: 24px | `xl`: 32px | `2xl`: 48px
* **Corner Radius**:
  - Controls / Badges / Buttons: `8px`
  - Cards / Modals / Sheets: `12px` - `16px`

---

## 4. Reusable Component Foundations & Adaptive Rules

All UI components must be consistent in visual identity while adapting layout strategy by platform:

1. `AppButton` — Primary, Secondary, Text, Danger variants (min 48px touch padding on Mobile).
2. `AppTextField` — Form input fields (horizontal layout on Desktop, stacked on Mobile).
3. `AppCard` — Surface container (multi-column grid on Desktop, full-width stacked on Mobile).
4. `AppDialog` — Modal overlay (max width `520px` centered on Desktop, full-width or bottom sheet on Mobile).
5. `AppBadge` — Status pill indicator (`Active`, `Expired`, `Pending`).
6. `AppDataTable` — Multi-column data grid on Desktop/Tablet; transforms into stacked card views on Mobile.
7. `AppBottomSheet` — Mobile-first bottom sheet for actions/inputs; transforms into modal side drawer/dialog on Desktop.
8. `AppEmptyState` — Clean empty-data presentation with graphic, title, description, and primary action.
9. `AppErrorState` — Standardized failure state with retry button.
10. `AppLoadingState` — Skeleton shimmers and non-blocking progress indicators.
11. `AppStatCard` — Metric dashboard summary card (multi-column on Desktop, scrollable/grid on Mobile).
12. `AppSnackBar` / Toast — Bottom-right floating card (`max-width: 400px`) on Desktop; full-width bottom toast on Mobile.

---

## 5. Responsive Breakpoint Matrix

* **Mobile (`<600px`)**: Single column, compact header, bottom navigation, bottom sheets, progressive disclosure, touch targets >= 48px.
* **Tablet (`600px - 1024px`)**: 2-column adaptive layout, collapsible navigation drawer/rail.
* **Desktop (`>1024px`)**: Permanent side navigation, multi-column dashboard grid, dense data tables, keyboard/mouse interaction.
