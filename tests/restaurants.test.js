const request = require("supertest");

let mockQuery;
let mockConnect;

jest.mock("mysql2", () => {
    mockQuery = jest.fn();
    mockConnect = jest.fn((callback) => callback(null));
    return {
        createConnection: () => ({
            connect: mockConnect,
            query: mockQuery
        })
    };
});

const app = require("../app");

describe("GET /", () => {
    test("shows restaurants when there are some in the database", async () => {
        mockQuery.mockImplementation((sql, callback) => {
            callback(null, [
                { Restaurant_Name: "Sunset Tacos", FoodType: "Mexican" },
                { Restaurant_Name: "Green Garden", FoodType: "Vegan" }
            ]);
        });

        const response = await request(app).get("/");

        expect(response.status).toBe(200);
        expect(response.text).toContain("Sunset Tacos");
        expect(response.text).toContain("Green Garden");
    });

    test("shows 'No available restaurants.' when the table is empty", async () => {
        mockQuery.mockImplementation((sql, callback) => {
            callback(null, []);
        });

        const response = await request(app).get("/");

        expect(response.status).toBe(200);
        expect(response.text).toContain("No available restaurants.");
    });
});

describe("POST /ViewMenu", () => {
    test("shows the menu items for the chosen restaurant", async () => {
        mockQuery.mockImplementation((sql, params, callback) => {
            callback(null, [
                {
                    Menu_SubCategory: "Tacos",
                    ItemName: "Carne Asada Taco",
                    Description: "Grilled steak, onion, cilantro, and salsa.",
                    Price: "4.50"
                }
            ]);
        });

        const response = await request(app)
            .post("/ViewMenu")
            .send({ restaurant: "Sunset Tacos" });

        expect(response.status).toBe(200);
        expect(response.text).toContain("Carne Asada Taco");
        expect(response.text).toContain("Sunset Tacos");
    });

    test("shows 'No items available' when the restaurant has no menu items", async () => {
        mockQuery.mockImplementation((sql, params, callback) => {
            callback(null, []);
        });

        const response = await request(app)
            .post("/ViewMenu")
            .send({ restaurant: "Empty Place" });

        expect(response.status).toBe(200);
        expect(response.text).toContain("No items available");
    });
});
