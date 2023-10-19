echo "Build...."
docker build -t fastapi-py38-async-mem-leak-test py3.8-async >/dev/null 2>&1
docker build -t fastapi-py39-async-mem-leak-test py3.9-async >/dev/null 2>&1
docker build -t fastapi-py310-async-mem-leak-test py3.10-async >/dev/null 2>&1
docker build -t fastapi-py39-hypercorn-mem-leak-test py3.9-hypercorn >/dev/null 2>&1
echo "Start Server...."
docker run --name fastapi-py38-async -d fastapi-py38-async-mem-leak-test >/dev/null 2>&1
docker run --name fastapi-py39-async -d fastapi-py39-async-mem-leak-test >/dev/null 2>&1
docker run --name fastapi-py310-async -d fastapi-py310-async-mem-leak-test >/dev/null 2>&1
docker run --name fastapi-py39-hypercorn -d fastapi-py39-hypercorn-mem-leak-test >/dev/null 2>&1
echo "Initial Mem Usage"
echo "=========================================="
docker stats fastapi-py38-async fastapi-py39-async fastapi-py310-async fastapi-py39-hypercorn --no-stream --format "{{.Name}}: {{.MemUsage}}"
echo "=========================================="
echo "Run 1000 Requests...."
echo "Run fastapi-py38-async"
docker exec -it fastapi-py38-async bash -c "export TIMEFORMAT='real: %3lR; user %3lU; system %3lS' && time (for run in {1..1000}; do curl 127.0.0.1>/dev/null 2>&1; done)"
echo "Run fastapi-py39-async"
docker exec -it fastapi-py39-async bash -c "export TIMEFORMAT='real: %3lR; user %3lU; system %3lS' && time (for run in {1..1000}; do curl 127.0.0.1>/dev/null 2>&1; done)"
echo "Run fastapi-py310-async"
docker exec -it fastapi-py310-async bash -c "export TIMEFORMAT='real: %3lR; user %3lU; system %3lS' && time (for run in {1..1000}; do curl 127.0.0.1>/dev/null 2>&1; done)"
echo "Run fastapi-py39-hypercorn"
docker exec -it fastapi-py39-hypercorn bash -c "export TIMEFORMAT='real: %3lR; user %3lU; system %3lS' && time (for run in {1..1000}; do curl 127.0.0.1>/dev/null 2>&1; done)"
echo "After 1000 Requests Mem Usage"
echo "=========================================="
docker stats fastapi-py38-async fastapi-py39-async fastapi-py310-async fastapi-py39-hypercorn --no-stream --format "{{.Name}}: {{.MemUsage}}"
echo "=========================================="
sleep 10
echo "After 10 seconds sleep"
echo "=========================================="
docker stats fastapi-py38-async fastapi-py39-async fastapi-py310-async fastapi-py39-hypercorn --no-stream --format "{{.Name}}: {{.MemUsage}}"
echo "=========================================="
echo "Cleanup...."
docker stop fastapi-py38-async fastapi-py39-async fastapi-py310-async fastapi-py39-hypercorn >/dev/null 2>&1
docker rm fastapi-py38-async fastapi-py39-async fastapi-py310-async fastapi-py39-hypercorn >/dev/null 2>&1