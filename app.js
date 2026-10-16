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
    database: "restaurants",
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
        query = "";
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

app.listen(port, () =>  {
    console.log("Server: https://localhost:3000")
})