# Базовый образ с Node.js для сборки
FROM node:20-alpine AS builder

# Установка последней версии pkg для создания бинарников
RUN npm install -g pkg@5.8.1

# Рабочая директория
WORKDIR /app

# Копируем файлы зависимостей
COPY package*.json ./
RUN npm install --omit=dev

# Копируем исходный код
COPY . .

# Создаем бинарник (используем правильный синтаксис для целевой платформы)
RUN pkg index.js --targets node18-alpine-x64 --output app-bin

# Финальный минимальный образ
FROM alpine:3.18

# Устанавливаем зависимости для Node.js бинарника
RUN apk add --no-cache libstdc++

# Создаем пользователя для безопасности
RUN addgroup -g 1000 appuser && \
    adduser -D -u 1000 -G appuser appuser

WORKDIR /app

# Копируем бинарник из стадии сборки
COPY --from=builder --chown=appuser:appuser /app/app-bin .

# Переключаем на непривилегированного пользователя
USER appuser

# Запускаем бинарник
CMD ["./app-bin"]