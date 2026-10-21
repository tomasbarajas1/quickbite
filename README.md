# QuickBite
Online ordering and pickup platform for restaurants

## Stack
- [Node.js](https://nodejs.org/) with [Express](https://expressjs.com/) 
- [EJS](https://ejs.co/) 
- [MySQL](https://dev.mysql.com/downloads/) with the [mysql2](https://www.npmjs.com/package/mysql2) driver
- Plain CSS
- [Jest](https://jestjs.io/) and [Supertest](https://www.npmjs.com/package/supertest) (automated tests)

## Project Structure

```
quickbite/
├── app.js                    
├── Restaurants.ejs           # Home page: list of restaurants
├── Menu.ejs                  # Menu page for the selected restaurant
├── style.css                 # Styles for all pages
├── sql/
│   └── quickbite.sql         # Database schema and sample data
├── tests/
│   └── restaurants.test.js   # Tests
├── package.json              # Dependencies 
├── .gitignore                
└── README.md
```


## Local Setup & Installation

### Prerequisites
- [Node.js](https://nodejs.org/) 
- [Git](https://git-scm.com/)
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

### Initialize the MySQL database

Run the schema and seed script from the repository root:

```bash
mysql -u <username> -p < sql/quickbite.sql
```

The script creates the `quickbite` database, its `Restaurants`, `Menus`, and
`Orders` tables, and inserts sample data for local development.

### Check the database connection settings

The connection is configured near the top of `app.js`:

```js
const db = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "quickbite",
})
```

### Run the Application

Start the server using Node.js:

```bash
node app.js
```

The application should be available at: http://localhost:3000
