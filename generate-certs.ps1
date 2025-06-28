# PowerShell script to generate self-signed SSL certificates for Elasticsearch
$certDir = "certs"
if (!(Test-Path $certDir)) {
    New-Item -ItemType Directory -Path $certDir | Out-Null
}

# Generate the certificate and key using OpenSSL
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $certDir/server.key -out $certDir/server.crt -subj "/CN=localhost"

Write-Host "Self-signed certificate and key generated in the 'certs' directory."
