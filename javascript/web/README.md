# JavaScript Web Server with Docker

Минимальный пример веб-сервера на JavaScript с использованием Express и Docker.

## Запуск приложения

### Сборка и запуск с помощью Docker

```bash
# Сборка образа
docker build -t js-web-server .

# Запуск контейнера
docker run -p 8080:8080 js-web-server
```

После запуска сервер будет доступен по адресу `http://localhost:8080`.

### Запуск без Docker

```bash
# Установка зависимостей
npm install

# Запуск сервера
npm start
```

Сервер будет доступен на порту 8080.