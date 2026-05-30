# HealthSync — Step-by-Step Render Deployment Guide 🚀

This guide provides a comprehensive walkthrough for deploying the **HealthSync** JSP/Servlet application on **Render.com** using containerized Docker environments. 

The application code is already fully production-ready: database connection configurations in all 8 Servlets and JSPs have been refactored to dynamically read database credentials from environment variables while maintaining local fallbacks.

---

## 📋 Prerequisites
1. A [GitHub Account](https://github.com/) containing your pushed `HealthSync` repository.
2. A free [Render Account](https://render.com/).

---

## 🛠️ Step 1: Provision the MySQL Database on Render

Since Render does not offer a dedicated free-tier managed MySQL instance out of the box, the most reliable and fully-integrated approach is to deploy **MySQL as a Private Service** inside a Docker container. This keeps your database completely secure (unreachable from the outside world) but fully accessible to your Web App.

1. Log in to your **Render Dashboard**.
2. Click **New +** (top right) and select **Private Service**.
3. Select the **Docker Image** option instead of Git.
4. In the **Docker Image URL** input field, type: `mysql:8.0` and click **Next**.
5. Configure the following service settings:
   * **Name**: `healthsync-db`
   * **Region**: Choose the same region for both database and web app (e.g., *Oregon (US West)*).
6. Scroll down and click **Advanced** to add the following **Environment Variables**:
   | Key | Value | Description |
   | :--- | :--- | :--- |
   | `MYSQL_ROOT_PASSWORD` | `@Amey2005` | Master root password |
   | `MYSQL_DATABASE` | `healthsync` | Database name to auto-create on start |
7. Under **Disks** (persistent storage to prevent data loss on container restarts):
   * Click **Add Disk**.
   * **Name**: `mysql-data`
   * **Mount Path**: `/var/lib/mysql`
   * **Size**: `1 GB` (minimum size, fits within free tier limits).
8. Click **Create Private Service**. 

*Render will spin up your MySQL container. It will be accessible internally to other services in your account at the address: `healthsync-db:3306`.*

---

## 🗄️ Step 2: Seed the Database Schema

To initialize tables, keys, and test data inside the new cloud MySQL service:

1. Once the `healthsync-db` Private Service status is **Live**, click on it.
2. In the left navigation pane, click on the **Shell** tab. This opens an interactive terminal inside your active cloud container.
3. Establish a connection to your MySQL service using the terminal:
   ```bash
   mysql -u root -p@Amey2005
   ```
4. Confirm you are logged in, then run the database selection query:
   ```sql
   USE healthsync;
   ```
5. Open your local [schema.sql](file:///Users/ameypatil/Desktop/HealthSync/schema.sql) file. Copy the entire contents of the SQL script.
6. Paste the copied SQL statements directly into the Render **Shell** terminal and press **Enter**.
7. Run the verification query to confirm tables are created:
   ```sql
   SHOW TABLES;
   ```
   *You should see `users`, `vitals`, `allergies`, `medical_records`, and `prescriptions` list successfully.*
8. Exit the SQL console:
   ```sql
   exit;
   ```

---

## 🌐 Step 3: Deploy the Tomcat Web App on Render

1. Return to the **Render Dashboard**.
2. Click **New +** and select **Web Service**.
3. Under **Connect a repository**, select your `HealthSync` repository (or search for `AmeyPatil3/HealthSync`).
4. Configure the following service settings:
   * **Name**: `healthsync-web`
   * **Region**: *Choose the exact same region as your database service.*
   * **Runtime**: Render will automatically detect the root `Dockerfile` and set this to **Docker**.
5. Scroll down to the **Environment Variables** section. Add the following keys to bind your web app to the database container:
   | Key | Value | Description |
   | :--- | :--- | :--- |
   | `DB_HOST` | `healthsync-db` | The internal service name of your database |
   | `DB_PORT` | `3306` | Default MySQL port |
   | `DB_NAME` | `healthsync` | Target database name |
   | `DB_USER` | `root` | Master database user |
   | `DB_PASSWORD` | `@Amey2005` | Master database password |
6. Click **Create Web Service**.

*Render will trigger a build process, pulling your Dockerfile, installing the JDK and Tomcat dependencies, packaging the JSP files and Servlets, and starting the servlet container. This process typically takes 2–4 minutes.*

---

## 🚀 Step 4: Access your Live Platform

1. Once the web service deploy status turns **Live**, look at the top left of the service dashboard for your custom sub-domain URL (e.g. `https://healthsync-web.onrender.com`).
2. Point your web browser to the context path of your deployed context:
   ```text
   https://YOUR_SUBDOMAIN.onrender.com/healthsync/index.jsp
   ```
3. **Success!** Your Personal Health Record system is now fully live on the internet! 

---

## 🔄 Dynamic Redeployments
Because your Render Web Service is hooked directly to your GitHub repository:
* Any time you edit your files and perform a **`git push`** locally, Render will automatically detect the changes, compile the project, and redeploy it with **zero downtime**!
