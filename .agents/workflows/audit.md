# Workflow: System Audit

Follow this workflow when conducting a system or codebase health check for FitBizz:

1. **Read-Only Inspection**: Inspect target codebase without modifying files during audit execution.
2. **Audit Dimensions**:
   - **Architecture**: Adherence to layer separation and boundaries.
   - **UI & Responsiveness**: Design system compliance, breakpoint handling, Mobile vs Desktop parity.
   - **Backend & APIs**: Thin controller enforcement, DTO usage, API contract synchronization.
   - **Database & Offline**: Local storage integrity, sync safety, transaction boundaries.
   - **Quality & Dependencies**: `flutter analyze`, compiler warnings, package bloat, test coverage.
   - **Security**: Hardcoded credentials, input validation, SQL injection safety.
3. **Structured Audit Report**:
   - **Critical Issues** (Immediate risk to security, data integrity, or builds)
   - **High Priority** (Architectural violations, layout overflows, missing validation)
   - **Medium Priority** (Code duplication, missing test coverage)
   - **Low Priority** (Minor code formatting, doc polish)
   - **Recommended Next Actions** (Prioritized action items)
