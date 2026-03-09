# 🚀 Docker S3 Toolkit

**Simple and lightweight tools to connect Docker containers to S3-compatible storage.**

Easily upload, download, sync and manage files on any S3-compatible object storage — OVH, AWS S3, MinIO, Scaleway, Backblaze B2, and more — using a single Docker container powered by [rclone](https://rclone.org/).

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-ready-2496ED?logo=docker)](https://www.docker.com/)
[![rclone](https://img.shields.io/badge/Powered%20by-rclone-blue)](https://rclone.org/)

---

## ✨ Features

- ✅ Works with **any S3-compatible storage** (OVH, AWS, MinIO, Scaleway, Backblaze…)
- ✅ **No AWS CLI required** — uses rclone under the hood
- ✅ Simple configuration via **environment variables** (`.env` file)
- ✅ **Upload, download, sync** files and folders in one command
- ✅ Optional **bucket mount** via FUSE
- ✅ Lightweight Alpine-based Docker image

---

## 📦 Project Structure

```
docker-s3-toolkit/
├── docker/
│   └── Dockerfile          # Alpine + rclone image
├── examples/
│   └── upload-file.sh      # Example: upload a file to a bucket
├── scripts/
│   └── entrypoint.sh       # Generates rclone config from env vars
├── data/                   # Local folder mounted inside the container
├── docker-compose.yml
├── .env.example            # Configuration template
└── LICENSE
```

---

## ⚙️ Configuration

### 1. Clone the repository

```bash
git clone https://github.com/tenjyh/docker-s3-integration.git docker-s3-toolkit
cd docker-s3-toolkit
```

### 2. Set up your environment

```bash
cp .env.example .env
```

Edit `.env` with your S3 credentials:

```env
S3_ACCESS_KEY=your-access-key-id
S3_SECRET_KEY=your-secret-access-key
S3_ENDPOINT=https://s3.uk1.cloud.ovh.net
S3_REGION=uk1
S3_ACL=private
```

> **OVH users:** S3 credentials are different from your OpenStack credentials.
> Generate them from the OVH Control Panel:
> `Object Storage` → `My containers` → `S3 Users` → `Add a user`

### 3. Build the image

```bash
docker compose build
```

---

## 🚀 Usage

### List all buckets

```bash
docker compose run --rm s3 --list
```

### List bucket contents

```bash
docker compose run --rm s3 lsd s3:my-bucket
```

### Upload a file

Place your file in the `./data/` folder, then:

```bash
docker compose run --rm s3 copy /data/myfile.txt s3:my-bucket/
```

### Download a file

```bash
docker compose run --rm s3 copy s3:my-bucket/myfile.txt /data/
```

### Sync a local folder to a bucket

```bash
docker compose run --rm s3 sync /data/my-folder s3:my-bucket/my-folder
```

### Run any rclone command

```bash
# Check bucket size
docker compose run --rm s3 size s3:my-bucket

# Delete a file
docker compose run --rm s3 delete s3:my-bucket/old-file.txt

# List files with details
docker compose run --rm s3 ls s3:my-bucket
```

---

## 🗂️ Supported S3 Providers

| Provider | Endpoint example |
|---|---|
| **OVH Object Storage** | `https://s3.uk1.cloud.ovh.net` |
| **AWS S3** | `https://s3.eu-west-1.amazonaws.com` |
| **MinIO** | `http://localhost:9000` |
| **Scaleway** | `https://s3.fr-par.scw.cloud` |
| **Backblaze B2** | `https://s3.us-west-004.backblazeb2.com` |

---

## 📂 Mount a Bucket as a Filesystem (FUSE)

Uncomment the following lines in `docker-compose.yml`:

```yaml
cap_add:
  - SYS_ADMIN
devices:
  - /dev/fuse
security_opt:
  - apparmor:unconfined
```

Then run:

```bash
docker compose run --rm s3 mount s3:my-bucket /mnt/s3 --daemon
```

---

## 🔒 Security Best Practices

- Never commit your `.env` file — it is listed in `.gitignore`
- Use **dedicated S3 users** with minimal permissions (read-only, write-only, or scoped to a specific bucket)
- Prefer `ACL=private` unless public access is explicitly required
- Rotate your S3 credentials regularly

---

## 🤝 Contributing

Pull requests are welcome! Feel free to open an issue for bug reports, feature requests, or questions.

---

## 📄 License

MIT — see [LICENSE](LICENSE) for details.

## AI Assistance

Some parts of this project were assisted by AI tools (Claude) for documentation,
code suggestions and brainstorming. All code was reviewed and validated by the project maintainer.
