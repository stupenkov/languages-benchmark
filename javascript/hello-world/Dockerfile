# Минимальный Node.js образ для продакшна
FROM node:20-alpine

# Создаем пользователя для безопасности
RUN addgroup -g 1000 appuser && \
    adduser -D -u 1000 -G appuser appuser

WORKDIR /app

# Копируем файлы зависимостей и устанавливаем только продакшн-зависимости
COPY package*.json ./
RUN npm install --omit=dev

# Копируем исходный код
COPY . .

# Меняем пользователя на непривилегированного
USER appuser

# Запускаем приложение
CMD ["node", "index.js"]
