#!/bin/bash
# Bash script to generate self-signed SSL certificates for Elasticsearch with SAN (Subject Alternative Name)

CERT_DIR="certs"
OPENSSL_CNF="$CERT_DIR/openssl.cnf"

if [ ! -d "$CERT_DIR" ]; then
  mkdir "$CERT_DIR"
fi

# Create openssl.cnf with SAN if it doesn't exist
if [ ! -f "$OPENSSL_CNF" ]; then
  cat > "$OPENSSL_CNF" <<EOF
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = localhost

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = es01
DNS.3 = es02
IP.1 = 127.0.0.1
IP.2 = 172.29.0.3
IP.3 = 172.29.0.4
IP.4 = ::1
EOF
fi

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$CERT_DIR/server.key" -out "$CERT_DIR/server.crt" \
  -config "$OPENSSL_CNF" -extensions v3_req

echo "Self-signed certificate and key with SAN generated in the '$CERT_DIR' directory."

# Optionally trust the certificate system-wide (Linux only)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo "Copying certificate to /usr/local/share/ca-certificates/elasticsearch.crt and updating CA store..."
  sudo cp "$CERT_DIR/server.crt" /usr/local/share/ca-certificates/elasticsearch.crt
  sudo update-ca-certificates
  echo "Certificate added to system trust store. Restart your browser to apply."
fi
