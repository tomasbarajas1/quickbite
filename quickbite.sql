-- QuickBite database schema and seed data
-- Tested against MySQL 8.0+

CREATE DATABASE IF NOT EXISTS quickbite
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE quickbite;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Menus;
DROP TABLE IF EXISTS Restaurants;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE Restaurants (
  Restaurant_Name VARCHAR(100) NOT NULL,
  Address VARCHAR(255) NOT NULL,
  City VARCHAR(100) NOT NULL,
  FoodType VARCHAR(50) NOT NULL,
  Description TEXT,
  OpenTime TIME NOT NULL,
  ClosingTime TIME NOT NULL,
  Phone VARCHAR(25),
  CreatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (Restaurant_Name)
) ENGINE = InnoDB;

CREATE TABLE Menus (
  MenuID INT UNSIGNED NOT NULL AUTO_INCREMENT,
  Restaurant_Name VARCHAR(100) NOT NULL,
  Menu_SubCategory VARCHAR(75) NOT NULL,
  ItemName VARCHAR(100) NOT NULL,
  Description TEXT,
  Price DECIMAL(10, 2) NOT NULL,
  IsAvailable BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (MenuID),
  UNIQUE KEY uq_menu_restaurant_item (Restaurant_Name, ItemName),
  CONSTRAINT fk_menus_restaurant
    FOREIGN KEY (Restaurant_Name) REFERENCES Restaurants (Restaurant_Name)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT chk_menu_price CHECK (Price >= 0)
) ENGINE = InnoDB;

CREATE TABLE Orders (
  OrderLineID BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  OrderID BIGINT UNSIGNED NOT NULL,
  Restaurant_Name VARCHAR(100) NOT NULL,
  Qty SMALLINT UNSIGNED NOT NULL,
  ItemName VARCHAR(100) NOT NULL,
  DeliveryAddress VARCHAR(255) NOT NULL,
  EstimatedDeliveryTime DATETIME NOT NULL,
  OrderStatus ENUM('Pending', 'Preparing', 'Out for Delivery', 'Delivered', 'Cancelled')
    NOT NULL DEFAULT 'Pending',
  OrderPlacedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (OrderLineID),
  KEY idx_orders_order_id (OrderID),
  KEY idx_orders_delivery_status (OrderStatus),
  CONSTRAINT fk_orders_menu_item
    FOREIGN KEY (Restaurant_Name, ItemName)
    REFERENCES Menus (Restaurant_Name, ItemName)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_order_quantity CHECK (Qty > 0)
) ENGINE = InnoDB;

INSERT INTO Restaurants
  (Restaurant_Name, Address, City, FoodType, Description, OpenTime, ClosingTime, Phone)
VALUES
  ('Sunset Tacos', '125 Ocean Avenue', 'San Diego', 'Mexican',
    'Fresh California-style tacos and burritos.', '10:00:00', '23:00:00', '619-555-0101'),
  ('Brooklyn Pizza Co.', '48 Bedford Street', 'Brooklyn', 'Pizza',
    'Hand-tossed pizza made with locally sourced ingredients.', '11:00:00', '00:00:00', '718-555-0102'),
  ('Green Garden', '220 Market Street', 'San Francisco', 'Vegan',
    'Plant-based bowls, wraps, and fresh juices.', '09:00:00', '21:00:00', '415-555-0103'),
  ('Seoul Bowl', '77 Oak Street', 'Austin', 'Korean',
    'Korean comfort food with customizable rice bowls.', '11:30:00', '22:00:00', '512-555-0104'),
  ('Curry House', '19 King Street', 'Chicago', 'Indian',
    'Traditional Indian curries, naan, and biryani.', '11:00:00', '22:30:00', '312-555-0105'),
  ('The Burger Lab', '302 Main Street', 'Seattle', 'American',
    'Creative burgers, fries, and house-made sauces.', '10:30:00', '23:30:00', '206-555-0106'),
  ('Mediterranean Table', '91 Elm Avenue', 'Boston', 'Mediterranean',
    'Mediterranean plates featuring grilled meats and fresh salads.', '11:00:00', '21:30:00', '617-555-0107'),
  ('Sushi Harbor', '16 Pine Street', 'Portland', 'Japanese',
    'Fresh sushi, sashimi, and Japanese small plates.', '12:00:00', '22:00:00', '503-555-0108'),
  ('Southern Comfort Kitchen', '405 Broad Street', 'Atlanta', 'Southern',
    'Classic Southern dishes prepared from family recipes.', '11:00:00', '22:00:00', '404-555-0109'),
  ('Noodle Street', '63 River Road', 'New York', 'Thai',
    'Aromatic Thai noodles and stir-fried favorites.', '11:30:00', '23:00:00', '212-555-0110');

INSERT INTO Menus
  (Restaurant_Name, Menu_SubCategory, ItemName, Description, Price)
VALUES
  ('Sunset Tacos', 'Tacos', 'Carne Asada Taco', 'Grilled steak, onion, cilantro, and salsa.', 4.50),
  ('Sunset Tacos', 'Burritos', 'Chicken Burrito', 'Grilled chicken, rice, beans, cheese, and salsa.', 12.00),
  ('Brooklyn Pizza Co.', 'Pizza', 'Margherita Pizza', 'Tomato, fresh mozzarella, basil, and olive oil.', 16.00),
  ('Brooklyn Pizza Co.', 'Pizza', 'Pepperoni Pizza', 'Classic tomato pizza with mozzarella and pepperoni.', 18.00),
  ('Green Garden', 'Bowls', 'Crispy Tofu Bowl', 'Tofu, brown rice, greens, avocado, and tahini.', 14.50),
  ('Green Garden', 'Drinks', 'Green Detox Juice', 'Kale, apple, cucumber, lemon, and ginger.', 7.00),
  ('Seoul Bowl', 'Rice Bowls', 'Bulgogi Beef Bowl', 'Marinated beef, rice, vegetables, and gochujang.', 15.50),
  ('Seoul Bowl', 'Rice Bowls', 'Spicy Tofu Bowl', 'Spicy tofu, rice, vegetables, and sesame sauce.', 13.50),
  ('Curry House', 'Curries', 'Butter Chicken', 'Tandoori chicken in a creamy tomato sauce.', 16.00),
  ('Curry House', 'Breads', 'Garlic Naan', 'Tandoor-baked naan with garlic and butter.', 4.00),
  ('The Burger Lab', 'Burgers', 'Classic Lab Burger', 'Beef patty, cheddar, lettuce, tomato, and sauce.', 14.00),
  ('The Burger Lab', 'Sides', 'Truffle Fries', 'Crispy fries with truffle oil and parmesan.', 8.00);

INSERT INTO Orders
  (OrderID, Restaurant_Name, Qty, ItemName, DeliveryAddress,
   EstimatedDeliveryTime, OrderStatus, OrderPlacedAt)
VALUES
  (10001, 'Sunset Tacos', 2, 'Carne Asada Taco', '10 Maple Street, San Diego, CA',
    '2026-10-18 12:35:00', 'Delivered', '2026-10-18 12:00:00'),
  (10002, 'Sunset Tacos', 1, 'Chicken Burrito', '82 Harbor Drive, San Diego, CA',
    '2026-10-18 13:10:00', 'Out for Delivery', '2026-10-18 12:35:00'),
  (10003, 'Brooklyn Pizza Co.', 1, 'Margherita Pizza', '15 Clinton Street, Brooklyn, NY',
    '2026-10-18 18:45:00', 'Preparing', '2026-10-18 18:05:00'),
  (10004, 'Brooklyn Pizza Co.', 2, 'Pepperoni Pizza', '201 Kent Avenue, Brooklyn, NY',
    '2026-10-18 19:15:00', 'Pending', '2026-10-18 18:35:00'),
  (10005, 'Green Garden', 1, 'Crispy Tofu Bowl', '44 Hayes Street, San Francisco, CA',
    '2026-10-18 12:50:00', 'Delivered', '2026-10-18 12:15:00'),
  (10006, 'Green Garden', 2, 'Green Detox Juice', '9 Mission Street, San Francisco, CA',
    '2026-10-18 13:00:00', 'Delivered', '2026-10-18 12:25:00'),
  (10007, 'Seoul Bowl', 1, 'Bulgogi Beef Bowl', '330 Congress Avenue, Austin, TX',
    '2026-10-18 19:20:00', 'Preparing', '2026-10-18 18:40:00'),
  (10008, 'Seoul Bowl', 1, 'Spicy Tofu Bowl', '715 Lamar Boulevard, Austin, TX',
    '2026-10-18 20:00:00', 'Pending', '2026-10-18 19:20:00'),
  (10009, 'Curry House', 2, 'Butter Chicken', '605 Lake Shore Drive, Chicago, IL',
    '2026-10-18 18:55:00', 'Out for Delivery', '2026-10-18 18:10:00'),
  (10010, 'Curry House', 3, 'Garlic Naan', '155 Wacker Drive, Chicago, IL',
    '2026-10-18 19:05:00', 'Delivered', '2026-10-18 18:20:00'),
  (10011, 'The Burger Lab', 1, 'Classic Lab Burger', '120 Pine Street, Seattle, WA',
    '2026-10-18 20:10:00', 'Pending', '2026-10-18 19:30:00'),
  (10012, 'The Burger Lab', 1, 'Truffle Fries', '801 Queen Anne Avenue, Seattle, WA',
    '2026-10-18 20:15:00', 'Cancelled', '2026-10-18 19:35:00');
