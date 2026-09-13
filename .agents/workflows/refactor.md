# Workflow: Code Refactoring

Follow this workflow when improving existing code structure in FitBizz:

1. **Justify Refactoring**: Ensure there is a clear engineering objective (e.g., eliminating confirmed code duplication, improving readability, fixing performance bottlenecks).
2. **Preserve External Behavior**: Existing API contracts, UI behaviors, database schemas, and public method signatures must remain intact.
3. **Keep Changes Incremental**: Apply refactoring in small, verifiable steps rather than massive global rewrites.
4. **Isolate Scope**: Never mix major feature development or bug fixes with unrelated structural refactoring.
5. **Verification Pipeline**:
   - Run `flutter analyze` and `flutter test`.
   - Run `.\mvnw test` and `.\mvnw clean package`.
   - Verify UI rendering across Mobile and Desktop views.
