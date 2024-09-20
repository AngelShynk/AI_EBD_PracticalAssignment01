CREATE DATABASE VyshyvAI;

USE VyshyvAI;

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20)
);

CREATE TABLE Vyshyvanky (
    VyshyvankaID INT AUTO_INCREMENT PRIMARY KEY,
    VyshyvankaName VARCHAR(100),
    Price DECIMAL(10, 2)
);

CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    VyshyvankaID INT,
    OrderDate DATE,
    Quantity INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (VyshyvankaID) REFERENCES Vyshyvanky(VyshyvankaID)
);

INSERT INTO Customers (CustomerName, Email, Phone) VALUES
('Oksana Petrenko', 'oksana.petrenko@example.com', '555-0011'),
('Ivan Hrytsenko', 'ivan.hrytsenko@example.com', '555-0022'),
('Svitlana Mykhalchuk', 'svitlana.mykhalchuk@example.com', '555-0033'),
('Petro Kovalchuk', 'petro.kovalchuk@example.com', '555-0044'),
('Kateryna Kozak', 'kateryna.kozak@example.com', '555-0055');

INSERT INTO Vyshyvanky (VyshyvankaName, Price) VALUES
('Traditional Embroidery', 1200.00),
('Modern Style Vyshyvanka', 950.00),
('Children’s Vyshyvanka', 750.00),
('Custom Design Vyshyvanka', 1500.00),
('Casual Vyshyvanka', 850.00);

INSERT INTO Orders (CustomerID, VyshyvankaID, OrderDate, Quantity) VALUES
(1, 1, '2024-09-01', 1),
(1, 3, '2024-09-01', 2),
(2, 2, '2024-08-31', 1),
(3, 4, '2024-08-30', 3),
(4, 1, '2024-08-29', 1),
(4, 5, '2024-08-29', 2),
(5, 3, '2024-08-28', 1),
(5, 4, '2024-08-28', 1),
(5, 2, '2024-08-28', 1),
(3, 1, '2024-08-30', 1);

CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100)
);

CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactInfo VARCHAR(100)
);

INSERT INTO Categories (CategoryName) VALUES
('Traditional'),
('Modern'),
('Custom Design');

INSERT INTO Suppliers (SupplierName, ContactInfo) VALUES
('UkrEmbroidery Inc', 'info@ukrembroidery.com'),
('CraftMasters', 'support@craftmasters.com');

ALTER TABLE Vyshyvanky ADD CategoryID INT;
ALTER TABLE Vyshyvanky ADD SupplierID INT;
ALTER TABLE Vyshyvanky ADD FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);
ALTER TABLE Vyshyvanky ADD FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID);

SELECT
    c.CustomerName,
    v.VyshyvankaName,
    cat.CategoryName,
    s.SupplierName,
    SUM(o.Quantity) AS TotalQuantity,
    SUM(o.Quantity * v.Price) AS TotalSpent
FROM
    Orders o
LEFT JOIN
    Customers c ON o.CustomerID = c.CustomerID
LEFT JOIN
    Vyshyvanky v ON o.VyshyvankaID = v.VyshyvankaID
LEFT JOIN
    Categories cat ON v.CategoryID = cat.CategoryID
LEFT JOIN
    Suppliers s ON v.SupplierID = s.SupplierID
WHERE
    o.OrderDate >= '2024-08-28'
GROUP BY
    c.CustomerName, v.VyshyvankaName, cat.CategoryName, s.SupplierName
ORDER BY
    TotalSpent DESC;

SELECT CustomerName, TotalSpent
FROM (
    SELECT
        c.CustomerName,
        SUM(o.Quantity * v.Price) AS TotalSpent
    FROM
        Orders o
    JOIN
        Customers c ON o.CustomerID = c.CustomerID
    JOIN
        Vyshyvanky v ON o.VyshyvankaID = v.VyshyvankaID
    WHERE
        o.OrderDate >= '2024-08-28'
    GROUP BY
        c.CustomerName

    UNION ALL

    SELECT
        c.CustomerName,
        SUM(o.Quantity * v.Price) AS TotalSpent
    FROM
        Orders o
    JOIN
        Customers c ON o.CustomerID = c.CustomerID
    JOIN
        Vyshyvanky v ON o.VyshyvankaID = v.VyshyvankaID
    WHERE
        o.OrderDate < '2024-08-28'
    GROUP BY
        c.CustomerName
) AS total_spent_customers;

WITH OrderSummary AS (
    SELECT
        c.CustomerName,
        v.VyshyvankaName,
        SUM(o.Quantity) AS TotalQuantity,
        SUM(o.Quantity * v.Price) AS TotalSpent
    FROM
        Orders o
    JOIN
        Customers c ON o.CustomerID = c.CustomerID
    JOIN
        Vyshyvanky v ON o.VyshyvankaID = v.VyshyvankaID
    WHERE
        o.OrderDate >= '2024-08-28'
    GROUP BY
        c.CustomerName, v.VyshyvankaName
)
SELECT *
FROM OrderSummary
ORDER BY TotalSpent DESC;