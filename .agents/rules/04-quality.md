# 04 — Engineering Quality, Safety & Performance

1. **Pre-Push & Commit Safety Check**:
   - Before committing or pushing significant work, verify:
     1. `git status` — Check modified, untracked, and staged files.
     2. Secrets Audit — Ensure NO passwords, API keys, private tokens, or `.env` secrets are present.
     3. Static Analysis — Run `flutter analyze` (0 errors/warnings).
     4. Build & Tests — Run `.\mvnw test` and build target executables/packages.
     5. Generated Files — Verify no temporary debugging artifacts or build clutter are committed.

2. **Rollback Strategy & Git Checkpoints**:
   - Create a Git checkpoint before risky refactorings, major feature branches, or database schema migrations.
   - If an implementation attempt breaks existing functionality, decide immediately whether to fix forward, revert, or restore from the Git checkpoint. Never stack unverified hacks on top of a broken state.

3. **Performance Standards**:
   - **Flutter**: Avoid unnecessary widget rebuilds; use `ListView.builder` / `CustomScrollView` for lazy-loaded list data; dispose all `TextEditingController`s and `AnimationController`s properly.
   - **Spring Boot**: Avoid N+1 database query problems; use paginated database queries (`Pageable`); index foreign keys and lookup columns in PostgreSQL.

4. **No Unnecessary Rework or Overengineering**:
   - If existing code or components work correctly, do not rewrite them simply for stylistic preference.
   - Do not invent complex speculative frameworks, event buses, or microservices on day one. Design code so it is *easy to extend*, not *overcomplicated today*.
