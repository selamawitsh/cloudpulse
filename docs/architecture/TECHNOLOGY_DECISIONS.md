# CloudPulse Technology Decisions

| # | Area | Decision | Why | Not chosen |
|---|---|---|---|---|
| 1 | Backend language | Java 21 with Spring Boot 3 | Strong job market, mature ecosystem | Node.js, Go |
| 2 | Build tool | Maven | Simple and widely used | Gradle |
| 3 | Backend design | Modular monolith, run as API and worker | Simple to build, test, containerize | Many microservices |
| 4 | Database | PostgreSQL | Reliable, relational data fits our model | MongoDB |
| 5 | Migrations | Flyway (versioned SQL files) | Database changes are tracked in Git | Manual SQL |
| 6 | Job queue and locks | Redis | Fast, simple, in our stack | RabbitMQ, Kafka |
| 7 | Authentication | Spring Security with JWT in a secure HTTP-only cookie | Standard, protects the token from page scripts | Plain sessions in memory |
| 8 | Frontend | Next.js with TypeScript | Popular, good routing, good for status pages | Plain React |
| 9 | Charts | Recharts | Easy with React | Hand-drawn charts |
| 10 | API style | REST with JSON | Easy to learn, test and document | GraphQL |
| 11 | Browser to server | Same origin through Nginx | Avoids CORS problems | Separate domains |
| 12 | Email (local) | Mailpit | Catches test emails safely | Real SMTP in development |
| 13 | Email (cloud) | AWS SES or SMTP, decided in Phase 15 | Cheap and reliable | - |
| 14 | Backend tests | JUnit 5 and Testcontainers | Real PostgreSQL in tests | Mocking the database |
| 15 | Local orchestration | Docker Compose | One command starts everything | Manual containers |
| 16 | CI/CD | GitHub Actions, GitHub Container Registry | Free, close to the code | Jenkins |
| 17 | Cloud | AWS, service choice in Phase 15 | Industry standard | - |
| 18 | Kubernetes | Not used | Too much for this project | - |

## Decisions we will revisit

- Exact AWS services (Phase 15)
- Email provider in the cloud (Phase 15)
- Failure rule numbers: 3 failures, 2 successes (Phase 8)
