# Child Health Monitoring System (ECCD) - Installation Guide

## 📋 Quick Installation (5 Minutes!)

This guide will help you install the complete ECCD system from scratch. Don't worry - it's simple!

---

## ✅ Requirements

Before you start, make sure you have:

- **Web Server**: Apache 2.4+ or Nginx
- **PHP**: 8.0 or higher
- **Database**: MySQL 5.7+ or MariaDB 10.4+
- **Composer**: For PHP dependencies
- **phpMyAdmin** (optional but helpful)

---

## 🚀 Step-by-Step Installation

### Step 1: Download/Clone the System

```bash
# If using Git
git clone https://github.com/your-repo/Child-Health-Monitoring-System-ECCD.git
cd Child-Health-Monitoring-System-ECCD

# If you downloaded a ZIP
unzip Child-Health-Monitoring-System-ECCD.zip
cd Child-Health-Monitoring-System-ECCD
```

### Step 2: Install PHP Dependencies

```bash
composer install
```

### Step 3: Create the Database

Open your MySQL/MariaDB command line or phpMyAdmin and run:

```sql
CREATE DATABASE mswdeccddb CHARACTER SET utf8 COLLATE utf8_general_ci;
```

Or using command line:

```bash
mysql -u root -p -e "CREATE DATABASE mswdeccddb CHARACTER SET utf8 COLLATE utf8_general_ci;"
```

### Step 4: Import the Database

**Option A: Using Command Line (Recommended)**

```bash
mysql -u root -p mswdeccddb < eccd_complete_install.sql
```

When prompted, enter your MySQL root password.

**Option B: Using phpMyAdmin**

1. Open phpMyAdmin in your browser
2. Click on "Import" tab
3. Click "Choose File" and select `eccd_complete_install.sql`
4. Click "Go" button at the bottom
5. Wait for success message

### Step 5: Configure Environment

Create your `.env` file:

```bash
cp .env.example .env
```

Edit `.env` and update with your database credentials:

```env
# Database Configuration
DB_HOSTNAME=localhost
DB_USERNAME=root
DB_PASSWORD=your_mysql_password_here
DB_DATABASE=mswdeccddb
DB_PORT=3306

# Application Environment
APP_ENVIRONMENT=development

# Base URL (update with your local URL)
BASE_URL=http://localhost/Child-Health-Monitoring-System-ECCD/
```

### Step 6: Set Folder Permissions

```bash
chmod -R 755 application/cache
chmod -R 755 application/logs
chmod -R 755 assets/uploads
```

### Step 7: Configure Apache (if using Apache)

Create or edit `.htaccess` in root:

```apache
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php/$1 [L]
```

If using Apache, make sure `mod_rewrite` is enabled:

```bash
sudo a2enmod rewrite
sudo systemctl restart apache2
```

### Step 8: Test the Installation

Open your browser and navigate to:

```
http://localhost/Child-Health-Monitoring-System-ECCD/
```

or

```
http://www.mswdeccd.local/
```

You should see the login page!

---

## 🔐 First Login

Use these credentials for your first login:

- **Email**: `admin@eccd.local`
- **Password**: `Admin@2025`

⚠️ **IMPORTANT**: Change this password immediately after logging in!

To change password:
1. Log in with default credentials
2. Go to your profile or settings
3. Update password to something secure

---

## 📊 What's Included in the Database

The installation includes:

### Authentication System (aAuth)
- ✅ User management tables
- ✅ Role and permission system
- ✅ Login attempt tracking
- ✅ One super admin account

### Core Tables
- ✅ **Centers** (`ecenter`) - 31 sample daycare centers
- ✅ **Workers** (`eworkers`) - Teacher/staff management
- ✅ **Students** (`epupils`) - 82 sample student records
- ✅ **Parents** (`eparent`) - Parent/guardian information
- ✅ **School Years** (`eschoolyear`) - Academic year tracking
- ✅ **Enrollments** (`eschoolyear_by_worker_students`)

### Health Monitoring Tables
- ✅ **Weighing** (`e_weighing`) - Height/weight measurements
- ✅ **Feeding** (`e_feeding`) - Daily feeding records
- ✅ **Immunization** (`e_immunization`) - Vaccine tracking
- ✅ **Z-Score Tables** - WHO growth reference data
  - `e_zscore_wfa` (Weight-for-Age)
  - `e_zscore_hfa` (Height-for-Age)
  - `e_zscore_wfh` (Weight-for-Height)

### Assessment Tables
- ✅ **Assessments** (`assessment`) - Developmental assessments
- ✅ **Raw Scores** (`assessment_raw_score`)
- ✅ **Scaled Scores** (`assessment_sum_scaled_score`)
- ✅ **Schedules** (`assessment_schedule`, `weighing_schedule`)

### Database Views
- ✅ `center_schoolyear` - Center statistics by school year
- ✅ `center_students_schoolyear` - Student enrollments
- ✅ `center_workers` - Worker assignments
- ✅ `list_students` - Student listings with details
- ✅ `students` - Complete student information view

---

## 🎯 Post-Installation Steps

### 1. Change Admin Password
- Log in with default credentials
- Update to a strong password
- Password should have: 8+ characters, uppercase, lowercase, number, special character

### 2. Create Your First Center
1. Navigate to **Centers** menu
2. Click "Add New Center"
3. Fill in center details
4. Save

### 3. Add Workers/Teachers
1. Navigate to **Workers** menu
2. Click "Add New Worker"
3. Fill in worker information
4. Assign to a center
5. System will generate a random secure password
6. Copy and provide to the worker

### 4. Add Students
1. Navigate to **Students** menu
2. Click "Add New Student"
3. Fill in student and parent information
4. Enroll in a cycle
5. Assign to a teacher

### 5. Set Up School Year/Cycle
1. Navigate to **Settings** → **School Years**
2. Create a new school year
3. Create cycles within the school year
4. Assign teachers to cycles

---

## 🔧 Troubleshooting

### Issue: "Database connection error"

**Solution:**
- Check `.env` file has correct database credentials
- Verify MySQL/MariaDB is running: `sudo systemctl status mysql`
- Test connection: `mysql -u root -p -e "USE mswdeccddb;"`

### Issue: "404 Page Not Found" or routing errors

**Solution:**
- Ensure `.htaccess` file exists in root directory
- Enable `mod_rewrite` in Apache
- Check `application/config/config.php` → `$config['index_page'] = '';`

### Issue: "Permission denied" errors

**Solution:**
```bash
chmod -R 755 application/cache
chmod -R 755 application/logs
chmod -R 777 assets/uploads  # For file uploads
chown -R www-data:www-data .  # If using Apache
```

### Issue: "CSRF token mismatch"

**Solution:**
- Clear browser cookies
- Check `application/config/config.php` → `$config['csrf_protection'] = TRUE;`
- Ensure forms include CSRF token

### Issue: Blank page or white screen

**Solution:**
- Check PHP error logs: `tail -f /var/log/apache2/error.log`
- Enable error display in `index.php`:
  ```php
  define('ENVIRONMENT', 'development');
  ```
- Check `application/logs/` folder for CI errors

### Issue: "Cannot login" or "Invalid credentials"

**Solution:**
- Use exact credentials: `admin@eccd.local` / `Admin@2025`
- Check if database was imported correctly
- Verify `aauth_users` table has data:
  ```sql
  SELECT * FROM aauth_users WHERE id = 1;
  ```

---

## 📁 Directory Structure

```
Child-Health-Monitoring-System-ECCD/
├── application/           # CodeIgniter application
│   ├── config/           # Configuration files
│   ├── controllers/      # Base controllers
│   ├── models/          # Base models
│   ├── modules/         # HMVC modules (22 modules)
│   └── sql/             # Database backup files
├── assets/              # CSS, JS, images
├── system/              # CodeIgniter core
├── .env.example         # Environment template
├── .gitignore          # Git ignore rules
├── composer.json       # PHP dependencies
├── index.php           # Entry point
├── eccd_complete_install.sql  # 👈 ONE-FILE DATABASE INSTALLER
├── INSTALLATION_GUIDE.md      # 👈 THIS FILE
└── SECURITY_FIXES.md         # Security documentation
```

---

## 🔒 Security Reminders

After installation:

1. ✅ **Change default admin password**
2. ✅ **Update .env with strong database password**
3. ✅ **Never commit .env to version control**
4. ✅ **Set production environment** when deploying:
   ```php
   // In index.php
   define('ENVIRONMENT', 'production');
   ```
5. ✅ **Enable HTTPS** in production
6. ✅ **Regular backups** of database
7. ✅ **Update dependencies** regularly

---

## 📚 Additional Resources

- **Security Fixes**: See `SECURITY_FIXES.md` for applied security patches
- **Laravel Migration Guide**: See `LARAVEL_DEVELOPMENT_PROMPT.md` for version 2
- **CodeIgniter Docs**: https://codeigniter.com/userguide3/
- **System Documentation**: Coming soon

---

## 🐛 Still Having Issues?

1. Check application logs: `application/logs/`
2. Check web server logs: `/var/log/apache2/` or `/var/log/nginx/`
3. Enable CodeIgniter debugging:
   ```php
   // In index.php
   define('ENVIRONMENT', 'development');
   ```
4. Contact support: roivanrita@gmail.com

---

## ✨ Success!

If everything is working:
- ✅ You can log in to the system
- ✅ You can see the dashboard
- ✅ You can navigate to Centers, Workers, Students
- ✅ No error messages

**Congratulations! Your ECCD system is ready to use! 🎉**

Start by:
1. Changing admin password
2. Creating your centers
3. Adding workers/teachers
4. Enrolling students
5. Recording measurements and assessments

---

**Installation Date**: November 24, 2025
**System Version**: 1.0
**Database**: mswdeccddb
**Framework**: CodeIgniter 3.1.13
