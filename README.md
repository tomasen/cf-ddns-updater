# Cloudflare Dynamic DNS Updater

This script automatically updates a Cloudflare DNS record with your current public IP address. It's useful for maintaining a consistent domain name that points to your home network or server, even when your ISP changes your public IP address.

## Features

- Retrieves your current public IP address
- Checks if the IP has changed since the last update
- Updates the specified Cloudflare DNS record only when necessary
- Logs the last known IP to avoid unnecessary API calls

## Prerequisites

- A Cloudflare account with a domain
- A Cloudflare API token with edit access to your DNS zone
- `curl` and `jq` installed on your system
- Bash shell

## Setup

1. Clone this repository:
   ```
   git clone https://github.com/tomasen/cf-ddns-updater.git
   cd cf-ddns-updater
   ```

2. Make the script executable:
   ```
   chmod +x ddns.sh
   ```

3. Edit the script to set your Cloudflare details:
   ```bash
   ZONE_ID="YOUR_CLOUDFLARE_ZONE_ID"
   SUBDOMAIN="YOUR_FULL_DOMAIN_NAME"
   RECORD_NAME="YOUR_SUBDOMAIN_ONLY"
   API_TOKEN="YOUR_CLOUDFLARE_API_TOKEN"
   LAST_KNOWN_IP_FILE="/path/to/last_known_ip.txt"
   ```

   Replace the placeholders with your actual values:
   - `ZONE_ID`: Your Cloudflare Zone ID (found in the Cloudflare dashboard)
   - `SUBDOMAIN`: The full domain name you want to update (e.g., "subdomain.example.com")
   - `RECORD_NAME`: The subdomain part only (e.g., "subdomain" if your full domain is "subdomain.example.com")
   - `API_TOKEN`: Your Cloudflare API token with edit access to your DNS zone
   - `LAST_KNOWN_IP_FILE`: Path where you want to store the last known IP

## Usage

Run the script manually:

```
./ddns.sh
```

For automatic updates, you can set up a cron job. For example, to run the script every 15 minutes:

1. Open your crontab file:
   ```
   crontab -e
   ```

2. Add the following line:
   ```
   * * * * * /path/to/ddns.sh
   ```

## How It Works

1. The script gets your current public IP address.
2. It compares this with the last known IP address stored in a file.
3. If the IP has changed:
   - It retrieves the DNS record ID from Cloudflare.
   - It updates the DNS record with the new IP.
   - If successful, it saves the new IP to the file.
4. If the IP hasn't changed, it does nothing.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
