#!/bin/bash

IMAGE_NAME="helloworld"
CONTAINER_NAME="test-run"

docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1

echo "=== Запуск контейнера $IMAGE_NAME ==="

start_time=$(date +%s%3N)

# Запуск контейнера в фоне
docker run --rm --name "$CONTAINER_NAME" "$IMAGE_NAME" &
container_pid=$!

max_cpu=0
max_mem_kb=0

# Мониторинг пока контейнер жив
while docker ps --filter "name=$CONTAINER_NAME" --format '{{.Names}}' | grep -q "$CONTAINER_NAME"; do
    stats=$(docker stats "$CONTAINER_NAME" --no-stream --format "{{.CPUPerc}},{{.MemUsage}}")
    cpu=$(echo "$stats" | cut -d',' -f1 | tr -d '%' )
    mem=$(echo "$stats" | cut -d',' -f2 | awk '{print $1}' | tr -d 'MiB' )

    # Переводим MiB в KiB
    mem_kb=$(echo "$mem * 1024" | bc | awk '{print int($1)}')

    # Обновляем пики
    (( $(echo "$cpu > $max_cpu" | bc -l) )) && max_cpu=$cpu
    (( $mem_kb > $max_mem_kb )) && max_mem_kb=$mem_kb

    sleep 0.1
done

wait $container_pid
end_time=$(date +%s%3N)

elapsed_ms=$((end_time - start_time))
elapsed_s=$(echo "scale=3; $elapsed_ms / 1000" | bc)

echo
echo "=== РЕЗУЛЬТАТ ==="
echo "Время выполнения: ${elapsed_s} сек"
echo "Пик CPU: ${max_cpu}%"
echo "Пик RAM: ${max_mem_kb} KiB ($((max_mem_kb/1024)) MiB)"

echo
echo "=== Детальная статистика (time) ==="
/usr/bin/time -v docker run --rm "$IMAGE_NAME" 2>&1 | grep -E "Elapsed|User time|System time|Maximum resident"
