# 01 — Core Product Principles

1. **Global SaaS Quality Standard**: FitBizz is designed as a commercial, production-grade international SaaS product capable of scaling to 1,000+ gym locations. Every decision must prioritize consistency, scalability, security, performance, and long-term maintainability over quick hacks.
2. **Inspect Before Modifying**: Never guess when the codebase or documentation can provide the answer. Always inspect existing implementations, architecture, and contracts before writing code.
3. **Preserve & Reuse**: Do not break existing functionality, API contracts, database schemas, or platform compatibility. Reuse existing primitives and services rather than recreating working logic.
4. **Git Checkpoints & Change Safety**:
   - Create Git checkpoints before major features, refactorings, or database schema changes.
   - Use standard commit prefixes: `feat:`, `fix:`, `refactor:`, `ui:`, `db:`, `test:`.
   - Keep changes reversible and maintain a clear rollback strategy.
5. **No Speculative or Fake Logic**: Never write fake implementations or presentation-only mocks presented as complete when persistence is required. Avoid unrequested overengineering or complex abstractions from day one.
6. **Definition of "Done"**: A task is complete ONLY when:
   - Full-stack implementation exists (UI + local DB + API + Spring Boot + PostgreSQL where required).
   - Screen layout is verified responsive across Desktop, Tablet, and Mobile.
   - Design system tokens and component-first primitives are respected.
   - Loading, empty, and error states are fully handled.
   - `flutter analyze` returns 0 issues, Maven build succeeds (`BUILD SUCCESS`), and tests pass.
   - Documentation (`API_CONTRACT.md`, `DESIGN_SYSTEM.md`, `PROJECT_STATE.md`) is updated.
7. **Offline-First Core**: Client apps must function seamlessly offline using local storage. Internet availability enhances the product but must not block core daily operational workflows.
8. **Senior Engineer Mindset**: Act as a senior full-stack engineer: follow the workflow `INSPECT -> UNDERSTAND -> PLAN -> IMPLEMENT -> VERIFY -> CLEAN UP -> DOCUMENT -> CHECKPOINT`.
