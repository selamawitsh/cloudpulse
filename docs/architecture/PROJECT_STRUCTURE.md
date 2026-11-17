# CloudPulse Project Structure

```text
cloudpulse/
├── frontend/                 Next.js application
│   ├── src/
│   ├── public/
│   └── Dockerfile
├── backend/                  Spring Boot application (API and worker)
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/cloudpulse/
│   │   │   │   ├── auth/
│   │   │   │   ├── monitor/
│   │   │   │   ├── check/
│   │   │   │   ├── incident/
│   │   │   │   ├── notification/
│   │   │   │   ├── statuspage/
│   │   │   │   └── common/
│   │   │   └── resources/
│   │   │       └── db/migration/    Flyway SQL files
│   │   └── test/
│   ├── pom.xml
│   └── Dockerfile
├── nginx/
│   └── nginx.conf
├── deploy/
│   └── aws/
├── docs/
│   ├── product/
│   ├── requirements/
│   ├── workflows/
│   ├── architecture/
│   ├── database/
│   ├── api/
│   └── operations/
├── .github/
│   └── workflows/
├── compose.yaml
├── .env.example
├── .gitignore
└── README.md
```

Code is grouped **by feature** (auth, monitor, check...) rather than by
type, so each feature's controller, service and repository live together.
