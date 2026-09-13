# Workflow: Bug Fixing

Follow this workflow when resolving bugs or unexpected behavior in FitBizz:

1. **Inspect & Reproduce**: Inspect stack traces, logs, or error reports to understand the failure context.
2. **Diagnose Root Cause**: Trace the exact data flow across Flutter UI -> Local DB -> HTTP -> Spring Boot Controller -> Service -> PostgreSQL. Identify the root cause before editing code.
3. **Determine Minimal Fix**: Plan the smallest, safest, most targeted change. Avoid unrelated code refactoring.
4. **Implement & Test**: Apply the targeted fix and add a regression test whenever practical.
5. **Execute Static Analysis & Build**:
   - Run `flutter analyze`.
   - Run `.\mvnw test`.
6. **Verify Resolution**: Confirm that the original bug scenario is resolved and no side-effects were introduced on Mobile or Desktop platforms.
7. **Update State**: Update `PROJECT_STATE.md` if the bug fix represents a material architectural change or resolved a tracked known issue.
