# Bench

docker build -t webslim . --no-cache

docker run -p 5000:5000 \
  --cpus=0.001 \
  --memory=16m \
  webslim


docker build -t cr.yandex/crpavr6rnkbg3vvn9t7o/web-runtime-self-contained:latest -f Dockerfile.self-contained .

  docker run -p 8080:8080 \
  cr.yandex/crpavr6rnkbg3vvn9t7o/web-runtime-self-contained:latest

docker push cr.yandex/crpavr6rnkbg3vvn9t7o/web-runtime-self-contained:latest
---
