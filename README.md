# Elasticsearch Compose Stack

This project provides a ready-to-use Docker Compose stack for running a secure, multi-node Elasticsearch cluster (v9.0.3) with Kibana, PostgreSQL, Redis, and supporting tools for local development and testing.

## Features
- **Elasticsearch 9.0.3**: Two-node cluster with SSL/TLS enabled and security features.
- **Kibana 9.0.3**: Visualize and manage your Elasticsearch data securely.
- **PostgreSQL & pgAdmin**: For relational data and database management.
- **Redis & Redis Commander**: For caching, messaging, and key-value storage.
- **Automated certificate generation** for secure inter-node and client communication.
- **User and role management scripts** for Elasticsearch and Kibana.

## Usage

### 1. Generate SSL Certificates
Run the script to generate self-signed certificates for Elasticsearch and Kibana:
```bash
./generate-certs.sh
```
This will create the `certs/` directory with the necessary files and add the CA to your Linux trust store.

### 2. Build and Start the Stack
Build the custom Elasticsearch image and start all services:
```bash
./elastic-setup.sh
```
This script will:
- Build the custom Elasticsearch image if needed
- Start all services with Docker Compose
- Wait for Elasticsearch to be ready
- Create built-in users (`es_owner`, `es_reader`)

### 3. Set Up Kibana User and Privileges
Create a dedicated user for Kibana and grant all required privileges:
```bash
./kibana-setup.sh
```
This will create the `es_kibana` user and assign all necessary roles for Kibana operation.

### 4. Access Services
- **Kibana**: https://localhost:5601/ (login with `es_kibana` / `Qwerty123!`)
- **Elasticsearch**: https://localhost:9200/ (login with `es_owner` or `es_kibana`)
- **pgAdmin**: http://localhost:5050/
- **Redis Commander**: http://localhost:8081/

### 5. Git Version Control
A local git repository is initialized. To push to GitHub:
```bash
git add .
git commit -m "Initial commit"
git push -u origin main
```

## Notes
- For production, use CA-signed certificates and strong passwords.
- You can customize users, roles, and passwords in the scripts as needed.
- If you change the Kibana user or password, update both the script and `docker-compose.yml`.

---

**Enjoy a secure, multi-service local development environment!**
