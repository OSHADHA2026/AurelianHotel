# Aurelian Hotel – Hotel Management Web

Spring Boot 3 + JSP/JSTL + MySQL hotel management system (rooms, reservations, billing, reviews,
notifications, employee/admin dashboards).

## Requirements
- Java 17
- MySQL 8 (the schema is created automatically: `spring.jpa.hibernate.ddl-auto=update`)

## Run
```bash
./mvnw spring-boot:run          # Windows: mvnw.cmd spring-boot:run
./mvnw test                     # unit tests
```
Open http://localhost:8080

## Configuration
Settings live in `src/main/resources/application.properties`. Any value can be overridden with an
environment variable without editing the file, for example:

| Setting | Environment variable |
|---|---|
| Database URL / user / password | `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME`, `SPRING_DATASOURCE_PASSWORD` |
| Mail user / password | `SPRING_MAIL_USERNAME`, `SPRING_MAIL_PASSWORD` |

> **Before publishing the repository:** remove the real database/mail passwords from
> `application.properties` (use the variables above or an untracked `application-local.properties`)
> and rotate the mail app-password.

## Project structure
```
.
├── pom.xml
├── src
│   ├── main
│   │   ├── java/com/example/hotelmanagementweb
│   │   │   ├── config/          Session + static-resource configuration
│   │   │   ├── controller/      MVC + REST controllers, GlobalExceptionHandler
│   │   │   ├── dto/  exception/  model/  repository/  service/
│   │   ├── resources
│   │   │   ├── application.properties
│   │   │   └── static                      (served as-is at /)
│   │   │       ├── css
│   │   │       │   ├── theme.css           global tokens, light/dark mode, navbar/hero look
│   │   │       │   ├── components/         navbar, footer, shared page-hero
│   │   │       │   └── pages/              one stylesheet per JSP (mirrors WEB-INF/jsp)
│   │   │       ├── js
│   │   │       │   ├── theme.js            light/dark toggle
│   │   │       │   └── currency.js         USD/LKR display switcher (rate defined at top)
│   │   │       ├── images/{flags,scenes,rooms}
│   │   │       ├── vendor/phosphor         icon font (MIT)
│   │   │       └── favicon.png             brand logo
│   │   └── webapp/WEB-INF/jsp
│   │       ├── fragments/       head-assets, navbar, footer (shared includes)
│   │       ├── admin/  booking/ page folders
│   │       └── *.jsp            public / guest pages
│   └── test/java                unit tests
├── uploads/  room-images/       runtime uploads (not source – git-ignored, back up separately)
└── .mvn/ mvnw mvnw.cmd          Maven wrapper
```

## Front-end conventions
- Every page starts with `<%@ include file="…/fragments/head-assets.jsp" %>` in `<head>`; this is the
  single place that loads the theme, icon font and shared scripts. Bump its `?v=` after changing
  those files.
- Page-specific styles go in `static/css/pages/<page>.css`; shared pieces in `static/css/components/`.
- Colours, surfaces and borders use CSS variables (`--au-*`, defined in `theme.css`); the dark theme
  only overrides those variables under `html[data-theme="dark"]`.
- Icons: Phosphor (`<i class="ph ph-house"></i>`).
- Currency: prices are written in USD everywhere; `currency.js` converts them for display only.
  Change the LKR rate in the `CURRENCIES` object at the top of that file.
