# HealthSync — 100% Free Cloud Deployment Guide 🌐

This guide details how to deploy **HealthSync** entirely on **free-tier services**, with **no credit cards or billing details required**.

We will combine two free-tier cloud platforms:
1.  **Aiven.io**: Provides a 100% free, managed MySQL database running 24/7.
2.  **Render.com**: Provides a free Web Service container that builds and hosts your Tomcat `Dockerfile` directly from GitHub.

---

## 💾 Part 1: Set Up your Free MySQL Database on Aiven.io

Aiven offers a robust, production-grade MySQL database tier that is completely free forever.

### Step 1.1: Create the Database
1. Go to [Aiven.io](https://aiven.io/) and sign up for a free account.
2. Click **Create Service**.
3. Select **MySQL** as the service type.
4. Under the plan selection, choose the **Free** tier (available in AWS regions like Virginia, Frankfurt, or Singapore).
5. Click **Create Service**.
6. Wait 2–3 minutes for the service status to change from *Rebuilding* to **Running**.

### Step 1.2: Capture Connection Details
On your Aiven console, copy the following parameters:
*   **Host**: (e.g. `mysql-26a111ba-healthsync.aivencloud.com`)
*   **Port**: (e.g. `12345`)
*   **User**: `avnadmin` (Aiven's default admin user)
*   **Password**: *(Click 'Show' to copy your unique generated password)*
*   **Database Name**: `defaultdb` (default created database)

### Step 1.3: Import the Tables
1. Download a local MySQL client (like **MySQL Workbench**, **DBeaver**, or use a VS Code database extension).
2. Connect to the database using the host, port, user, and password parameters from Step 1.2.
3. Once connected, open your local [schema.sql](file:///Users/ameypatil/Desktop/HealthSync/schema.sql) file and run it against the Aiven database (`defaultdb`) to initialize all tables and seed data.

---

## 🌐 Part 2: Deploy the Tomcat App on Render (Free Tier)

Render's Web Service free tier fully supports custom Docker deployments.

### Step 2.1: Create the Web Service
1. Log in to [Render.com](https://render.com/).
2. Click **New +** and select **Web Service**.
3. Select your connected GitHub Repository: `AmeyPatil3/HealthSync`.
4. Configure the service settings:
   * **Name**: `healthsync-web`
   * **Region**: *Select a region close to your Aiven database region to minimize lag.*
   * **Runtime**: Automatically set to **Docker** (based on your root `Dockerfile`).
   * **Instance Type**: Select **Free** (0.5 CPU, 512 MB RAM).

### Step 2.2: Add Environment Variables
Scroll down, click **Advanced**, and add your Aiven database connection variables:

| Key | Value | Description |
| :--- | :--- | :--- |
| `DB_HOST` | *(Your Aiven Host)* | e.g. `mysql-26a111ba-healthsync.aivencloud.com` |
| `DB_PORT` | *(Your Aiven Port)* | e.g. `12345` |
| `DB_NAME` | `defaultdb` | Aiven's default database name |
| `DB_USER` | `avnadmin` | Aiven's default master username |
| `DB_PASSWORD` | *(Your Aiven Password)* | Password copied from Aiven dashboard |

### Step 2.3: Build & Deploy
1. Click **Create Web Service**.
2. Render will pull your code from GitHub, read the `Dockerfile`, package the JSP pages and Tomcat server, and start the app.
3. Once the build log says **Live**, you will find your public URL at the top left of the dashboard (e.g. `https://healthsync-web.onrender.com`).
4. Point your browser to:
   ```text
   https://YOUR_SUBDOMAIN.onrender.com/healthsync/index.jsp
   ```

---

## 💡 Important Free-Tier Details to Keep in Mind:
*   **Spin-Down behavior**: Render's free Web Services will "spin down" (go to sleep) if they do not receive any traffic for 15 minutes. When someone visits your URL again, it will take about **50 seconds** to wake up and load the page. This is normal and expected on free tiers.
*   **Database Uptime**: The Aiven MySQL database runs **24/7 without sleeping**, meaning your data is always instantly responsive the moment the web app wakes up!
