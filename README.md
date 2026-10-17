# QuickBite
Online ordering and pickup platform for restaurants

## Stack
- Node.js
- MySQL


## Local Setup & Installation

### Prerequisites
- [Node.js](https://nodejs.org/) installed
- Git installed
- [MySQL](https://dev.mysql.com/downloads/) installed and running

### Clone the Repository

```bash
git clone https://github.com/tomasbarajas1/quickbite.git
cd quickbite
```

### Install Dependencies

```bash
npm install
```

### Run the Application

Start the server using Node.js:

```bash
node app.js
```

The application should be available at: http://localhost:3000

### Initialize the MySQL database

Run the schema and seed script from the repository root:

```bash
mysql -u <username> -p < sql/quickbite.sql
```

The script creates the `quickbite` database, its `Restaurants`, `Menus`, and
`Orders` tables, and inserts sample data for local development.
