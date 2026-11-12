# EduNexora - Course Management System

EduNexora is a complete, enterprise-grade Course Management System (CMS) engineered with **Java 21**, **Spring Boot 3.3.5**, and server-rendered **JSP** pages. Designed around robust role-based architecture, EduNexora streamlines course administration, student enrollment workflows, and instructor course management.

---

## 🛠️ Technology Stack

- **Backend**: Java 21 LTS, Spring Boot 3.3.5 (Spring MVC, Spring Security 6, Spring Data JPA, Hibernate ORM)
- **Frontend**: Server-rendered JSP (Jakarta JSTL 3.0, Spring Form Tags, Spring Security Taglibs), Bootstrap 5.3.3, Bootstrap Icons 1.11.3, Chart.js 4.4.4
- **Database**: MySQL Server 8.0+ (`course_management_system`)
- **Security**: BCrypt password hashing, Role-Based Access Control (RBAC), CSRF protection on all mutating forms, session fixation protection, HttpOnly/SameSite cookies, 14-day Remember Me token
- **Build Tool**: Apache Maven (WAR packaging with embedded Tomcat Jasper)

---

## 📋 Prerequisites

Before running the application, ensure the following are installed:
1. **JDK 17 or Java 21+** (`java -version`)
2. **Apache Maven 3.8+** (or use the provided Maven wrapper `mvnw.cmd` / `mvnw`)
3. **MySQL Server 8.0+** running locally on port `3306`

---

## 🗄️ Database Setup

1. **Log in to MySQL**:
   ```bash
   mysql -u root -p
   ```

2. **Create the Database**:
   ```sql
   CREATE DATABASE IF NOT EXISTS course_management_system;
   USE course_management_system;
   ```

3. **Execute Schema & Sample Data**:
   ```bash
   mysql -u root -p course_management_system < database/schema.sql
   mysql -u root -p course_management_system < database/sample-data.sql
   ```
   *(Or run them from MySQL Workbench / CLI using `source database/schema.sql;` and `source database/sample-data.sql;`)*

---

## ⚙️ Configuration & Environment Variables

Application settings are located in `src/main/resources/application.properties`. You can override them via environment variables:

| Setting | Default Value | Environment Variable | Description |
| :--- | :--- | :--- | :--- |
| Database URL | `jdbc:mysql://localhost:3306/course_management_system` | `DB_URL` | JDBC Connection URL |
| Database User | `root` | `DB_USERNAME` | MySQL Username |
| Database Password | `gnims` | `DB_PASSWORD` | MySQL Password |
| Admin Username | `admin` | `CMS_ADMIN_USERNAME` | Default Administrator Username |
| Admin Email | `admin@edunexora.com` | `CMS_ADMIN_EMAIL` | Default Administrator Email |
| Admin Password | `Admin@123` | `CMS_ADMIN_PASSWORD` | Default Administrator Initial Password |

---

## 👥 Sample Login Accounts

All passwords in sample data and initial admin setup are strictly BCrypt-hashed:

| Role | Username / Email | Plaintext Test Password | Role Description |
| :--- | :--- | :--- | :--- |
| **Admin** | `admin` or `admin@edunexora.com` | `Admin@123` | System Administrator (Full Access) |
| **Teacher** | `alan.turing@edunexora.com` | `Password@123` | CS Faculty (Assigned to CS101, CS102) |
| **Teacher** | `ada.lovelace@edunexora.com` | `Password@123` | SE Faculty (Assigned to SE201, SE202) |
| **Teacher** | `grace.hopper@edunexora.com` | `Password@123` | IS Faculty (Assigned to IS301) |
| **Student** | `alice.smith@student.com` | `Password@123` | Registered Student |
| **Student** | `bob.johnson@student.com` | `Password@123` | Registered Student |

*(New students can also register instantly via the `/register` page).*

---

## 🚀 How to Run the Application

### Option 1: Terminal (Maven Wrapper)
From the project root directory (`d:\EduNexora\EduNexora`):
```powershell
.\mvnw.cmd spring-boot:run
```
*(On Linux/macOS: `./mvnw spring-boot:run`)*

### Option 2: IntelliJ IDEA
1. Open IntelliJ IDEA and select **Open** -> choose `d:\EduNexora\EduNexora`.
2. Allow Maven to import dependencies.
3. Locate `src/main/java/com/cms/Application.java`.
4. Right-click and choose **Run 'Application.main()'**.

### Option 3: Visual Studio Code
1. Open the project folder in VS Code.
2. Install the **Extension Pack for Java** and **Spring Boot Extension Pack**.
3. Press `F5` or click **Run Java** on `Application.java`.

---

## 🌐 Accessing the Application

Once started, open your web browser and navigate to:
```
http://localhost:8080/login
```

- **Student Portal**: Select `Student`, enter student email and password -> lands on `/student/dashboard`.
- **Faculty Portal**: Select `Teacher`, enter faculty email and password -> lands on `/teacher/dashboard`.
- **Admin Portal**: Select `Admin`, enter `admin` (or `admin@edunexora.com`) and `Admin@123` -> lands on `/admin/dashboard`.

---

## 🧪 Running Automated Tests

Run the full automated test suite (Repository, Authentication, Enrollment, Security, Role Isolation):
```powershell
.\mvnw.cmd test
```

---

## 🔧 Troubleshooting Guide

### 1. JSP Page Not Rendering / 404 on Views
- **Cause**: In Spring Boot WAR projects with embedded Tomcat, `tomcat-embed-jasper` and Jakarta JSTL API + implementation must be available on the classpath.
- **Solution**: Ensure dependencies `tomcat-embed-jasper`, `jakarta.servlet.jsp.jstl-api`, and `org.glassfish.web:jakarta.servlet.jsp.jstl` are present in `pom.xml`. Always run the project using `.\mvnw.cmd spring-boot:run` from the root project folder so Tomcat resolves the `src/main/webapp/WEB-INF/views/` directory.

### 2. MySQL Connection Refused (`CommunicationsException` or `10013`)
- **Cause**: MySQL server service is stopped or port `3306` is inaccessible.
- **Solution**:
  - Check service status: `Get-Service *mysql*`
  - Start the service if needed: `Start-Service MySQL80`
  - Verify credentials in `application.properties` or set `DB_PASSWORD`.

### 3. Hibernate Schema Validation Error (`SchemaManagementException`)
- **Cause**: Database tables do not match entity definitions when `spring.jpa.hibernate.ddl-auto=validate`.
- **Solution**: Run `database/schema.sql` to synchronize database tables.

