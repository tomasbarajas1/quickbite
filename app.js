const express = require("express");
const path = require("path");
const mysql = require("mysql2");

const app = express();

app.use(express.static(__dirname));

const port = 3000;

app.use(express.urlencoded({ extended: false}))
app.use(express.json());

const db = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "quickbite",
})

app.set("view engine", "ejs");
app.set("views", path.join(__dirname));

app.get("/", (req, res) =>  {
    db.connect((error) =>   {
        if (error) {
            console.log("Could not connect to database.")
        }
        else    {
            console.log("Connected to database.")
        }
        query = "SELECT * FROM restaurants";
        db.query(query, (err, results) =>   {
            if (err)    {
                return console.log(err);
            }
            if (results.length > 0) {
                res.render("Restaurants", {sample: results});
            } else  {
                res.send("No available restaurants.");
            }
        })
    })
})

app.post("/ViewMenu", (req, res) => {
    db.query("SELECT * FROM menus WHERE Restaurant_Name = ?", [req.body.restaurant], (err, result) =>  {
        if (err)
            res.send("Error loading menu.")
        else    {
            res.render("Menu.ejs", {sample: result, name: req.body.restaurant})
        }
    })
})

if (require.main === module) {
    app.listen(port, () =>  {
        console.log("Server: https://localhost:3000")
    })
}

module.exports = app;