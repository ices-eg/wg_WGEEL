# Test the 401
# linux

# windows
$base = "https://api.mercure.eaux-et-vilaine.bzh"  
$API_password ="*********"
$tok  = Invoke-RestMethod "$base/login" -Method Post -Body @{ username = "hilaire"; password = $API_password }
$resp = Invoke-RestMethod "$base/recruitment_data" -Method Post -Headers @{ Authorization = "Bearer $(@($tok.token)[0])" }