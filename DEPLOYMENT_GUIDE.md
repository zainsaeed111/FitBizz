# 🚀 FitBizz Backend — 100% Free Cloud Deployment (No Credit Card Required)

This guide provides the **most optimized, completely free zero-card methods** to deploy your **FitBizz Spring Boot 3 Java 21 Backend + PostgreSQL Database** to the cloud.

---

## 🏆 Top 3 Free "No Card Needed" Deployment Options

| Platform | Free Tier Specs | Credit Card Needed? | Sleep Mode? | Best Use Case |
| :--- | :--- | :--- | :--- | :--- |
| **1. Render.com + Neon.tech** *(Recommended)* | 512 MB RAM Web Service + 0.5 GB Serverless Postgres | ❌ **NO Card** | Sleeps after 15m (Kept awake 24/7 with GitHub Cron) | **Fastest & Easiest** (1-Click Blueprint or Web Service) |
| **2. Hugging Face Spaces (Docker)** | 2 vCPU, 16 GB RAM Container, Unlimited | ❌ **NO Card** | ❌ **Never Sleeps (Continuous 24/7)** | Heavy workloads & continuous zero-sleep |
| **3. Koyeb.com + Neon.tech** | 512 MB RAM Nano instance | ❌ **NO Card** | ❌ **Active 24/7** | Direct Docker / GitHub deployment |

---

## 🥇 Method 1: Render.com + Neon PostgreSQL (Recommended & Fastest)

### Step 1: Create a Permanent Free Database on Neon.tech (1 min)
1. Go to [https://neon.tech](https://neon.tech) and click **Sign Up** with GitHub (No credit card required).
2. Create a new project named `fitbizz-db`.
3. Under **Dashboard**, copy your **Connection String**. Select the `Java / JDBC` or standard `postgres://` format:
   ```text
   jdbc:postgresql://ep-xxxx.us-east-2.aws.neon.tech/neondb?sslmode=require
   ```
4. Note your:
   - Host & DB Name: `ep-xxxx.us-east-2.aws.neon.tech/neondb`
   - User: `neondb_owner` (or your user)
   - Password: `<your-neon-password>`

---

### Step 2: Deploy Backend to Render.com (2 mins)
1. Go to [https://dashboard.render.com](https://dashboard.render.com) and click **Sign in with GitHub** (No credit card required).
2. Click **New +** (top right) ➔ **Web Service**.
3. Select **Build and deploy from a Git repository** ➔ Click **Next**.
4. Connect your **FitBizz** repository (`zainsaeed111/FitBizz`).
5. Configure the deployment settings:
   - **Name**: `fitbizz-backend`
   - **Region**: Choose closest to you (e.g., *Oregon (US West)* or *Frankfurt (EU)*)
   - **Branch**: `main`
   - **Root Directory**: `fitbizz_backend`
   - **Runtime**: **Docker** (Render will automatically detect `fitbizz_backend/Dockerfile`)
   - **Instance Type**: **Free** (512 MB RAM, 0.1 CPU)
6. Scroll down to **Environment Variables** and add:
   | Key | Value |
   | :--- | :--- |
   | `PORT` | `8080` |
   | `SPRING_DATASOURCE_URL` | `jdbc:postgresql://<neon-host>/<db-name>?sslmode=require` |
   | `SPRING_DATASOURCE_USERNAME` | `<neon-username>` |
   | `SPRING_DATASOURCE_PASSWORD` | `<neon-password>` |
   | `JWT_SECRET` | `c2VjdXJlX2ZpdGJpenpfand0X3NlY3JldF9rZXlfZm9yX2F1dGhlbnRpY2F0aW9uXzIwMjY=` |
7. Click **Create Web Service**.

Render will build the Docker container and start your Spring Boot application!
Once finished, your live URL will be ready (e.g., `https://fitbizz-backend.onrender.com`).

---

## 🥈 Method 2: Hugging Face Spaces (Docker — 16 GB RAM Free 24/7)

Hugging Face provides **free 16GB RAM Docker instances** with **no sleep mode** and **no credit card**:

1. Go to [https://huggingface.co](https://huggingface.co) and sign up.
2. Click **Spaces** ➔ **Create new Space**.
3. Set **Space Name**: `fitbizz-backend`, **License**: `MIT`, **SDK**: `Docker` (Blank).
4. Set Space to **Public**.
5. In **Settings** ➔ **Variables and secrets**, add:
   - `SPRING_DATASOURCE_URL`: your Neon JDBC URL
   - `SPRING_DATASOURCE_USERNAME`: your Neon username
   - `SPRING_DATASOURCE_PASSWORD`: your Neon password
   - `PORT`: `7860`
6. Push the `fitbizz_backend` files to the Space repo or link your GitHub repo.
7. Your backend will run 24/7 with zero downtime!

---

## ⚡ Step 3: Keep Free Render Instance Awake 24/7 (Prevent Sleep)

Render Free web services go into sleep mode after 15 minutes of inactivity. We have already built an automated keep-alive system into this repository:

### Option A: GitHub Actions (Already in your repo!)
1. Go to your GitHub repository: `https://github.com/zainsaeed111/FitBizz/settings/secrets/actions`
2. Add a new repository secret:
   - **Name**: `RENDER_BACKEND_URL`
   - **Value**: `https://fitbizz-backend.onrender.com` (your live Render URL)
3. The GitHub Actions workflow in [`.github/workflows/keep-alive-cron.yml`](file:///d:/Flutter%20Projects/FitBizz/.github/workflows/keep-alive-cron.yml) will automatically ping `/api/v1/health` every 10 minutes to keep the backend warm 24/7.

### Option B: Free External Pingers (Cron-job.org / UptimeRobot)
1. Go to [https://cron-job.org](https://cron-job.org) (100% Free, no card).
2. Create a cron job pointing to:
   `https://<your-render-url>/api/v1/health`
3. Set execution interval to **Every 10 minutes**.

---

## 📱 Connect Flutter Mobile/Desktop App & Web App to Live Cloud

Once your backend is live:

### 1. In Flutter App (`fitbizz_app`):
1. Open the app and log in.
2. Go to **Gym Settings** (Tab: **Cloud & Offline Sync**).
3. Set **Cloud Gateway API Endpoint** to:
   `https://fitbizz-backend.onrender.com/api/v1`
4. Tap **Force Full Sync**.

### 2. In Next.js Web Portal (`fitbizz_web`):
1. Navigate to `/settings`.
2. Under **Cloud & Offline Sync Engine**, update the API Endpoint to your live URL.
3. Click **Save All Settings**.
