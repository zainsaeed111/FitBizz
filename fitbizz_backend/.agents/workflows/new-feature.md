# Workflow: New Feature Implementation

Follow this actionable step-by-step workflow when adding a feature to FitBizz:

1. **Understand & Inspect**: Review requirements. Inspect existing codebase and documentation first. Do not guess.
2. **Dual-Platform Planning (Desktop + Mobile by Default)**:
   - Design layout strategies for BOTH Desktop (`>1024px`) and Mobile (`<600px`).
   - Do NOT shrink or squish desktop layouts onto mobile screens. Adapt arrangement, navigation, and overlays.
3. **Search for Component Reuse**: Search for existing reusable primitives (`AppButton`, `AppDataTable`, `AppCard`, etc.) before writing screen-specific UI.
4. **Identify Affected Layers**: Determine if the feature impacts Flutter UI, Local Database, Spring Boot Service/Controller, or PostgreSQL.
5. **Check Design & API Impact**:
   - Check `docs/DESIGN_SYSTEM.md` for UI token and adaptive component compliance.
   - Check `docs/API_CONTRACT.md` for REST API payload requirements.
6. **Full-Stack Implementation**: Implement backend models/services/controllers and client local storage/UI together. Never leave frontend and backend out of sync.
7. **Add / Update Tests**: Add unit/service/widget tests for the new feature.
8. **Static Analysis & Build Verification**:
   - Run `flutter analyze` (0 errors/warnings).
   - Run `.\mvnw test` / `.\mvnw clean package` (`BUILD SUCCESS`).
9. **Mandatory Cross-Platform UI Verification**:
   - Verify layout rendering on Desktop target (`flutter run -d windows` / `flutter build windows`).
   - Verify layout rendering on Mobile target (`flutter run -d <android-device>` / `flutter build apk`).
   - Check zero `RenderFlex` overflow, zero text clipping, touch target size (>= 48px), and overlay alignment.
10. **Update Documentation**:
    - Update `docs/API_CONTRACT.md` if APIs changed.
    - Update `docs/DESIGN_SYSTEM.md` if design tokens changed.
    - Update `PROJECT_STATE.md`.
11. **Report**: Summarize exactly what changed and report verification status for Desktop and Mobile platforms.
