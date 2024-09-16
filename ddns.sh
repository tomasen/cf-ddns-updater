#!/bin/bash

# Cloudflare API credentials
API_TOKEN="<YOUR_CLOUDFLARE_API_TOKEN>"
# Your Cloudflare Zone ID (found in the Cloudflare dashboard)
ZONE_ID="CLOUDFLARE_DOMAIN_ZONE_ID"
# The full domain name you want to update (e.g., "subdomain.example.com")
SUBDOMAIN="<FULL_DOMAIN_NAME>"
# The subdomain part only (e.g., "subdomain" if your full domain is "subdomain.example.com")
RECORD_NAME="<SUBDOMAIN_ONLY>"
# Path to the file where the last known IP address will be stored
LAST_KNOWN_IP_FILE="/etc/last_known_ip"

# Get the current public IP address
IP=$(curl -s https://ipv4.icanhazip.com)

# Get the last known IP address from a local file
LAST_KNOWN_IP=$(cat "$LAST_KNOWN_IP_FILE" 2>/dev/null)

# If the IP has changed, update Cloudflare
if [ "$IP" != "$LAST_KNOWN_IP" ]; then
    echo "IP has changed from $LAST_KNOWN_IP to $IP. Updating Cloudflare..."

    # Get the DNS Record ID for the specified subdomain
    RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$SUBDOMAIN" \
            -H "Authorization: Bearer $API_TOKEN" \
            -H "Content-Type: application/json" | jq -r '.result[0].id')

    echo "$RECORD_ID"

    # Update the DNS record with the current IP
    RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
            -H "Authorization: Bearer $API_TOKEN" \
            -H "Content-Type: application/json" \
            --data "{\"type\":\"A\",\"name\":\"$RECORD_NAME\",\"content\":\"$IP\",\"ttl\":120,\"proxied\":false}")

    # Check if the update was successful
    if [[ "$RESPONSE" == *"\"success\":true"* ]]; then
        echo "DNS record updated successfully to $IP."
        # Save the new IP to the file
        echo "$IP" > "$LAST_KNOWN_IP_FILE"
    else
            echo "Failed to update DNS record. $RESPONSE"
    fi

else
    echo "IP has not changed. No update needed."
fi
