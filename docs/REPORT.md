# Отчёт по практическому заданию «Что такое DevOps. CI/CD»

## Стенд

- исходный учебный репозиторий форкнут в `pavel-logachev/cicd-jenkins-nexus-lab`;
- Jenkins развёрнут локально в Docker и доступен на `http://localhost:8088`;
- Nexus Repository развёрнут локально в Docker и доступен на `http://localhost:8089`;
- Jenkins-агент содержит Go, Git, Docker CLI и плагины Pipeline/Job DSL/JCasC;
- конфигурация Jenkins и три задания создаются автоматически из `jenkins/casc.yaml`;
- учётные данные Nexus хранятся только в локальном `.env`, который исключён из Git.

## Задание 1. Freestyle

Job `sdvps-freestyle` клонирует публичный форк и выполняет:

```bash
go test .
docker build -t sdvps-materials:${BUILD_NUMBER} .
```

Результат и ссылка на скриншот будут добавлены после выполнения стенда.

## Задание 2. Declarative Pipeline

Job `sdvps-declarative` использует `Jenkinsfile`. Отдельные стадии выполняют тест Go и сборку Docker-образа с номером сборки Jenkins.

Результат и ссылка на скриншот будут добавлены после выполнения стенда.

## Задание 3. Nexus

Одноразовый контейнер `nexus-bootstrap` создаёт raw-hosted репозиторий `sdvps-releases`. Job `sdvps-nexus-upload` использует `Jenkinsfile.nexus`, собирает версионированный бинарник и загружает его по пути:

```text
sdvps-materials/<BUILD_NUMBER>/sdvps-materials-<BUILD_NUMBER>
```

Результат и ссылка на скриншот будут добавлены после выполнения стенда.

## Запуск

```bash
cp .env.example .env
docker compose up --build -d
```

После старта запустить три job из интерфейса Jenkins. Для остановки:

```bash
docker compose down
```

