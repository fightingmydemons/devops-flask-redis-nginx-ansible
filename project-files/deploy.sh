#!/bin/bash

# Наш скрипт автоматического обновления деплоя
echo "=== [1/4] Перезапускаем контейнеры с принудительной пересборкой... ==="
docker compose down
docker compose up -d --build

echo "=== [2/4] Ждем 3 секунды, чтобы Flask успел стартовать... ==="
sleep 3

echo "=== [3/4] Проверяем статус контейнеров... ==="
docker compose ps

echo "=== [4/4] Тестируем доступность сайта локально... ==="
HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" http://localhost)

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "УСПЕХ: Сайт ответил кодом 200. Деплой прошел успешно!"
else
    echo "ОШИБКА: Что-то пошло не так, код ответа сервера: $HTTP_STATUS"
    docker compose logs web
fi
