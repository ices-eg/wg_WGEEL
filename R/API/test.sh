# Test the 401
# linux
curl -i -X POST http://localhost:8082/recruitment_data
curl -i -X POST -H "Authorization: Bearer garbage" http://localhost:8082/recruitment_data
# windows
curl.exe -i -X POST http://127.0.0.1:8082/recruitment_data
curl.exe -i -X POST -H "Authorization: Bearer garbage" http://localhost:8082/recruitment_data
curl.exe -X POST -H "Content-Type: application/json" -d "{\"user\":\"cedric\",\"password\":\"cedric0\"}" http://localhost:8082/login