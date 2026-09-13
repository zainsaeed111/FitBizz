# 🚀 FitBizz Cloud Backend 24/7 Free Deployment Guide

This guide explains how to deploy the **FitBizz Spring Boot Backend + PostgreSQL Database** to **100% Free 24/7 Cloud Hosting** so that you and your users can access it continuously from the Flutter Mobile/Desktop app and Web Portal.

---

## 🌟 Recommended Free Hosting Platforms

| Platform | Free Tier Benefits | 24/7 Uptime | Database Included | Setup Time |
| :--- | :--- | :--- | :--- | :--- |
| **1. Render.com** *(Recommended)* | Free Web Service + Free PostgreSQL DB | ✅ Yes | ✅ Free Managed PostgreSQL | ~2 mins (1-Click) |
| **2. Koyeb.com** | 512 MB RAM Nano Service, No spin-down sleep | ✅ Yes (Continuous 24/7) | Pair with Free Neon.tech DB | ~3 mins |
| **3. Railway.app** | $5 monthly free credits | ✅ Yes | ✅ Free PostgreSQL plugin | ~2 mins |

---

## Option 1: 1-Click Deployment on Render.com (Recommended & Free)

Render provides a **free web service** and a **free managed PostgreSQL database**. Because this repository already includes [`render.yaml`](./render.yaml), Render sets up everything automatically!

### Step 1: Push your code to GitHub
Make sure your GitHub repository (`https://github.com/zainsaeed111/FitBizz`) is up to date with the latest code on the `main` branch.

### Step 2: Connect to Render
1. Go to [https://render.com](https://render.com) and create a free account (sign in with your GitHub account).
2. Click **New +** in the top right and select **Blueprint**.
3. Connect your **`FitBizz`** repository.
4. Render will automatically detect [`render.yaml`](./render.yaml) and configure:
   - **Service Name**: `fitbizz-backend` (Docker runtime)
   - **Database**: `fitbizz-postgres` (PostgreSQL 16)
5. Click **Apply**. Render will automatically build the Docker container, provision the PostgreSQL database, and deploy the live backend!

### Step 3: Get your Live URL
Once the deploy is complete (approx. 2–3 minutes), Render will give you a public URL such as:
`https://fitbizz-backend.onrender.com`

---

## Option 2: Deploying on Koyeb (Continuous 24/7 with Free Neon DB)

Koyeb provides continuous 24/7 hosting without sleep mode on its free tier.

1. Create a free PostgreSQL database at [https://neon.tech](https://neon.tech) and copy your connection string (`postgres://...`).
2. Go to [https://app.koyeb.com](https://app.koyeb.com) and sign up with GitHub.
3. Click **Create Service** -> **GitHub**.
4. Select `FitBizz` repository and choose the `fitbizz_backend` subfolder or Dockerfile.
5. In **Environment Variables**, add:
   - `PORT`: `8080`
   - `SPRING_DATASOURCE_URL`: `jdbc:postgresql://<neon-host>:5432/<db_name>?sslmode=require`
   - `SPRING_DATASOURCE_USERNAME`: `<neon-user>`
   - `SPRING_DATASOURCE_PASSWORD`: `<neon-password>`
6. Click **Deploy**. Koyeb will output your live URL: `https://<your-app>.koyeb.app`.

---

## 📱 How to Connect Flutter App & Web Portal to your Live Backend

Once your backend is live (e.g. `https://fitbizz-backend.onrender.com`):

### 1. In Flutter App (`fitbizz_app`):
1. Open the app and log in as Gym Owner or Super Admin.
2. Go to **Gym Settings** (Tab 4: **Cloud & Offline SQLite Sync**).
3. In **Cloud Gateway API Endpoint**, paste your live URL:
   `https://fitbizz-backend.onrender.com/api/v1`
4. Click **Force Full Sync**. The app will immediately handshake with your live cloud backend and sync all members, invoices, and attendance logs.

### 2. In Next.js Web Portal (`fitbizz_web`):
1. Navigate to `/settings` in the web portal.
2. Under **Cloud & Offline Sync Engine**, update the API Endpoint to your live URL.
3. Click **Save All Settings**.

---

## 💡 Keeping Free Tier Warmed Up (No Sleep)
If deploying on Render free tier, web services sleep after 15 minutes of inactivity. You can keep it active 24/7 for free:
1. Go to [https://uptimerobot.com](https://uptimerobot.com) (100% Free).
2. Create a new **HTTP(s) Monitor** pointing to `https://<your-app>.onrender.com/api/v1/auth/login` with a **5-minute interval**.
3. Your free backend will now stay awake and responsive 24 hours a day, 7 days a week!
