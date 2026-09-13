# Project State — FitBizz

## Current Phase
Foundation & Cross-Platform Guidance Established

## Completed
- Created root workspace structure (`FitBizz/`, `fitbizz_backend/`, `fitbizz_app/`)
- Initialized Spring Boot 3.3.5 backend with Java 21, Maven wrapper, Validation, JPA, PostgreSQL driver
- Verified backend build (`BUILD SUCCESS`), tests, and application startup on port `8080`
- Initialized single cross-platform Flutter project supporting Android and Windows Desktop
- Verified Flutter environment (`flutter analyze` with 0 issues, Windows desktop app built and executed successfully)
- Established AI-assisted guidance system (`.agents/rules/`, `.agents/skills/`, `.agents/workflows/`, `docs/`)
- Integrated **FitBizz Premium Product Quality & Long-Term Design/Engineering Standards**
- Integrated **Mandatory Cross-Platform UI Verification Rules** (Proactive Dual-Platform Ownership for Desktop + Mobile by default, layout adaptation over shrinking hacks, adaptive overlay/dialog/toast components, zero overflow guarantee, and completion checklist).

## In Progress
- Setup phase complete

## Next
- Local database architecture & offline-first foundation setup
- Core business entity planning

## Important Decisions
- **Cross-Platform Rule**: Every UI change is designed and verified for BOTH Desktop and Mobile by default.
- **Quality Standard**: Enterprise international SaaS product standards (no local-gym hacks or bodybuilding clichés).
- **Architecture**: Single Flutter project (Android + Windows); Spring Boot 3.x REST API + PostgreSQL backend. Modular feature directory structure (`presentation/`, `domain/`, `data/`).
- **Design System**: Centralized design tokens and reusable UI primitives (`AppButton`, `AppTextField`, `AppCard`, `AppDataTable`, `AppDialog`, `AppBadge`, `AppBottomSheet`, `AppEmptyState`, `AppErrorState`, `AppLoadingState`, `AppStatCard`).
- **Offline-First**: Local database as primary UI data source; isolated background sync engine.
