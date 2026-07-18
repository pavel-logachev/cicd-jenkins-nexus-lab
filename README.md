# Jenkins + Nexus CI/CD lab

Решение практического задания Нетологии «Что такое DevOps. CI/CD» на основе форка `netology-code/sdvps-materials`.

В репозитории находятся:

- Freestyle Job для `go test` и `docker build`;
- Declarative Pipeline с отдельными стадиями теста и сборки;
- Pipeline сборки Go-бинарника и загрузки в Nexus raw-hosted;
- воспроизводимый Docker Compose стенд Jenkins + Nexus;
- [отчёт](docs/REPORT.md) и проверяемые скриншоты.

## Быстрый запуск

```bash
cp .env.example .env
docker compose up --build -d
```

Jenkins: `http://localhost:8088`. Nexus: `http://localhost:8089`.

Локальные пароли задаются в `.env` и не попадают в Git.
