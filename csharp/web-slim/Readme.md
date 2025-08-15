# Bench

docker build -t webslim . --no-cache

docker run -p 5000:5000 \
  --cpus=0.001 \
  --memory=16m \
  webslim

---
