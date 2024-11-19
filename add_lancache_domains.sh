#!/bin/bash

# Set your Lancache IP
lancache_ip="cache.lancache.net"

# AdGuard Home API base URL
base_url="http://172.16.172.10:8888/control/rewrite/add"

#delete 
#base_url="http://172.16.172.10:8888/control/rewrite/delete"

# Session cookies (adjust these according to your session)
cookie="agh_session=747253ffba7ca899144f3bfbdd9eae54"

# Find all domain files in the cache-domains repository
find . -name "*.txt" | while read domain_file; do
  while read -r domain; do
    if [[ ! -z "$domain" && "$domain" != \#* ]]; then
      # JSON payload
      json_payload=$(printf '{"domain":"%s","answer":"%s"}' "$domain" "$lancache_ip")

      # Send the request to AdGuard Home
      curl "$base_url" \
        -H "Accept: application/json, text/plain, */*" \
        -H "Accept-Language: en-US,en;q=0.9,bn;q=0.8" \
        -H "Cache-Control: no-cache" \
        -H "Connection: keep-alive" \
        -H "Content-Type: application/json" \
        -H "Cookie: $cookie" \
        -H "Origin: http://172.16.172.10:8080" \
        -H "Pragma: no-cache" \
        -H "Referer: http://172.16.172.10:8080/" \
        -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36" \
        --data-raw "$json_payload" \
        --insecure
    fi
  done < "$domain_file"
done
