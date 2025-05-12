# 🧑‍💼 HR Management System

A full-stack Human Resource Management System designed to simplify and automate HR processes such as employee management, leave tracking, and visual reporting. Built using React.js, Express.js, MySQL, and styled with TailwindCSS.

## 📚 Table of Contents

- [🚀 Features](#-features)  
- [🛠️ Tech Stack](#️-tech-stack)  
- [🗃️ Database Schema Overview](#️-database-schema-overview)  
- [⚙️ SQL Triggers](#️-sql-triggers)  
- [📦 Installation & Setup](#-installation--setup)  
- [📊 Dashboard Preview](#-dashboard-preview)  
- [🧠 Future Enhancements](#-future-enhancements)  
- [🤝 Contributing](#-contributing)  
- [📄 License](#-license)


## 🚀 Features

- 👥 **Employee Management** – Add, update, or remove employee records  
- 📅 **Leave Management** – Apply for leave, approve/reject requests  
- 🔢 **Leave Balances** – Auto-adjust leave balances with SQL triggers  
- 🧾 **Department & Role Assignment**  
- 📊 **Analytics Dashboard** – Visual summaries using Chart.js  
- 🔐 **Role-Based Access** – Admins, HR managers, and employee roles  
- 📧 **Optional**: Email notifications for leave requests (future feature)

---

## 🛠️ Tech Stack

### 🖥️ Frontend
- [React.js](https://reactjs.org/)
- [Chart.js](https://www.chartjs.org/) via `react-chartjs-2`
- [TailwindCSS](https://tailwindcss.com/)

### ⚙️ Backend
- [Node.js](https://nodejs.org/) with [Express.js](https://expressjs.com/)
- [MySQL](https://www.mysql.com/) for relational data storage

### 📦 Tools
- [Axios](https://axios-http.com/) for HTTP requests  
- [Postman](https://www.postman.com/) for API testing  
- [Dotenv](https://www.npmjs.com/package/dotenv) for environment management

---

## 🗃️ Database Schema Overview

- `employees` – Personal and role info  
- `departments` – Departmental structure  
- `roles` – Admin, HR, Employee  
- `leave_types` – Sick, Annual, Maternity, etc.  
- `leaves` – Leave applications and approval status  
- `employee_leave_balances` – Track available leave per type

---

## ⚙️ SQL Triggers

### 1. Auto Deduct Leave Balance on Approval

```sql
AFTER UPDATE ON leaves
FOR EACH ROW
BEGIN
  IF NEW.status = 'approved' AND OLD.status != 'approved' THEN
    UPDATE employee_leave_balances
    SET balance = balance - (DATEDIFF(NEW.end_date, NEW.start_date) + 1)
    WHERE employee_id = NEW.employee_id
    AND leave_type_id = NEW.leave_type_id;
  END IF;
END
```

### 2. Create Leave Balances on Employee Insert

```sql
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
  INSERT INTO employee_leave_balances (employee_id, leave_type_id, balance)
  SELECT NEW.id, lt.id, lt.max_days
  FROM leave_types lt;
END
```

---

## 📦 Installation & Setup

### 🔧 Backend (Express + MySQL)
```bash
cd backend
npm install
cp .env.example .env  # Set DB credentials
npm start
```

### 🖥️ Frontend (React + Tailwind + Chart.js)
```bash
cd frontend
npm install
npm run dev  # or npm start
```

---

## 📊 Dashboard Preview

- Employee Summary  
- Leave Utilization  
- Leave Balance Trends  
- Approval Rates  

*(Charts powered by Chart.js)*

---

## 🧠 Future Enhancements

- Attendance & Payroll Integration  
- JWT Authentication  
- Admin Logs & Auditing  
- PWA Support (for mobile use)  
- AI-driven HR insights  

---

## 🤝 Contributors

- Karen Mumbi
- Charles Muthui
- Felix

Pull requests are welcome! Please open an issue to discuss proposed changes.

---

## 📄 License

MIT License — Feel free to use and adapt with attribution.
