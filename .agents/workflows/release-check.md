# Workflow: Release Readiness Verification

Follow this checklist before releasing or declaring a production build ready:

## 1. Flutter Client Verification (`fitbizz_app`)
- [ ] `flutter analyze` returns `No issues found!`.
- [ ] `flutter test` passes all widget and unit test suites.
- [ ] `flutter build windows` compiles clean executable without warnings.
- [ ] `flutter build apk` (or `bundle`) builds clean Android package.
- [ ] Layout verified on Mobile and Desktop resolutions.

## 2. Spring Boot Backend Verification (`fitbizz_backend`)
- [ ] `.\mvnw clean package` outputs `BUILD SUCCESS`.
- [ ] `.\mvnw test` passes 100% of test cases.
- [ ] Configuration parameters verified with no hardcoded passwords/secrets.
- [ ] Database migrations and PostgreSQL table structures verified.

## 3. Product & Data Verification
- [ ] Offline local database operations verified.
- [ ] Sync failure recovery and conflict handling verified.
- [ ] Empty states, loading spinners, and error alerts verified.
- [ ] Security validation and API payload sanitization confirmed.
