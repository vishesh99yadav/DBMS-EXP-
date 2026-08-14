# DBMS-EXP-
Experiment: ER Diagram for Indian E-Commerce Platform
1. Aim

To design an Entity-Relationship (ER) diagram for an Indian E-Commerce Platform by identifying the major entities, their attributes, primary keys, relationships, cardinalities, participation constraints, composite attributes, multi-valued attributes, and specialization of the Product entity.

2. Objectives

The objectives of this experiment are:

To identify the major entities involved in an e-commerce system.
To identify suitable attributes for each entity.
To specify primary keys for uniquely identifying entities.
To represent composite attributes such as Address.
To represent multi-valued attributes such as Customer's Mobile Number.
To identify relationships between entities.
To specify cardinality constraints such as 1:1, 1:N and M:N.
To specify participation constraints such as Total and Partial participation.
To represent specialization/generalization using ISA.
To design a conceptual database model that can later be converted into relational tables.
3. Theory

An Entity-Relationship (ER) model is a high-level conceptual model used to represent the structure of a database. It describes real-world objects as entities, their properties as attributes, and associations between entities as relationships.

Main components of an ER model
Entity

An entity is a real-world object that has an independent existence.

Examples:

Customer
Order
Product
Seller
Category
Payment
Delivery
Address
Attribute

An attribute describes a property of an entity.

For example:

Customer

Customer_ID
Name
Email
DOB
Mobile_No
Primary Key

A primary key uniquely identifies each entity instance.

Example:

Customer_ID uniquely identifies a customer.

In an ER diagram, the primary key is generally underlined.

Relationship

A relationship represents an association between two or more entities.

Examples:

Customer Places Order
Order Includes Product
Product Belongs To Category
Product Sells Seller
Cardinality

Cardinality specifies how many instances of one entity can be associated with another entity.

Common types:

1:1 — One-to-One
1:N — One-to-Many
M:N — Many-to-Many
Participation Constraint

Participation specifies whether participation in a relationship is mandatory or optional.

Total participation: Every entity instance must participate.
Partial participation: Participation is optional.
4. Entities and Attributes
4.1 Customer

Primary Key: Customer_ID

Attributes:

Customer_ID (PK)
Name
Email
DOB
Mobile_No (Multi-valued)

A customer may have more than one mobile number, so Mobile_No is represented using a double oval.

4.2 Order

Primary Key: Order_ID

Attributes:

Order_ID (PK)
Order_Date
Status
Total_Amount

An order represents a purchase made by a customer.

4.3 Product

Primary Key: Product_ID

Attributes:

Product_ID (PK)
Product_Name
Price
Brand

Product is also the superclass for product specialization.

4.4 Seller

Primary Key: Seller_ID

Attributes:

Seller_ID (PK)
Seller_Name
GST_No
Phone
Email

The seller represents a person or business that sells products through the platform.

4.5 Category

Primary Key: Category_ID

Attributes:

Category_ID (PK)
Category_Name

Examples of categories:

Electronics
Clothing
Grocery
4.6 Payment

Primary Key: Payment_ID

Attributes:

Payment_ID (PK)
Payment_Mode
Amount
Payment_Date
Payment_Status

Payment stores information about the payment associated with an order.

4.7 Delivery

Primary Key: Delivery_ID

Attributes:

Delivery_ID (PK)
Delivery_Status
Delivery_Date
Tracking_No

Delivery stores information about the shipment of an order.

4.8 Address

Primary Key: Address_ID

Attributes:

Address_ID (PK)
Address

Address is a composite attribute consisting of:

House_No
Street
City
State
PIN_Code

Therefore:

Address → {House_No, Street, City, State, PIN_Code}

5. Relationships and Cardinality
Relationship	Entities	Cardinality
Places	Customer → Order	1 : N
Has	Customer → Address	1 : N
Has	Order → Payment	1 : 1
Has	Order → Delivery	1 : 1
Includes	Order → Product	M : N
Belongs To	Product → Category	N : 1
Sells	Seller → Product	1 : N
6. Detailed Relationships
6.1 Customer — Places — Order

Relationship: Places

A customer can place multiple orders, while each order is placed by one customer.

Cardinality:

Customer 1 : N Order

Example:

Customer ─── Places ─── Order
    1                    N
Participation
Customer → Partial
Order → Total

An order cannot exist without a customer, while a customer may exist without placing an order.

6.2 Customer — Has — Address

Relationship: Has

A customer can have multiple addresses such as:

Home
Hostel
Office

Each address belongs to one customer.

Cardinality:

Customer 1 : N Address

Participation
Customer → Partial
Address → Total

Every address must belong to a customer.

6.3 Order — Has — Payment

Relationship: Has

An order is associated with a payment.

For the simplified ER model:

Order 1 : 1 Payment

Participation
Order → Total
Payment → Total/Partial depending on whether unpaid orders are allowed.

For a model where payment is mandatory after order confirmation:

Order → Total

6.4 Order — Has — Delivery

Relationship: Has

An order is associated with its delivery.

Cardinality:

Order 1 : 1 Delivery

Participation
Order → Total
Delivery → Partial

An order may be created before delivery information is generated.

7. Order — Includes — Product

Relationship: Includes

An order can contain multiple products, and the same product can appear in many different orders.

Therefore:

Order M : N Product

Example:

Order ─── Includes ─── Product
  M                       N

This is an important many-to-many relationship.

In the relational database, this relationship would normally be converted into an intermediate entity/table such as:

Order_Item

with attributes such as:

Order_ID
Product_ID
Quantity
Unit_Price

The combination (Order_ID, Product_ID) can be used as a composite key if one product occurs only once per order.

8. Product — Belongs To — Category

Relationship: Belongs To

A product belongs to one category, while a category can contain many products.

Therefore:

Category 1 : N Product

or equivalently:

Product N : 1 Category

Product ─── Belongs To ─── Category
   N                         1
Participation
Product → Total
Category → Partial

Every product must belong to a category, but a category may exist without currently having products.

9. Seller — Sells — Product

Relationship: Sells

A seller can sell multiple products.

In the simplified model:

Seller 1 : N Product

Seller ─── Sells ─── Product
   1                   N
Participation
Seller → Partial
Product → Total

Every product is associated with a seller, while a seller may not currently have any products listed.

10. Specialization of Product

The Product entity is specialized using an ISA relationship.

The superclass is:

Product

It has three subclasses:

Electronics
Clothing
Grocery
                 Product
                    |
                   ISA
          __________|__________
         /          |          \
 Electronics     Clothing     Grocery

Each subclass has specialized attributes.

Electronics

Attribute:

Warranty_Period
Clothing

Attributes:

Size
Color
Grocery

Attribute:

Expiry_Date

Therefore:

Product
   |
   ISA
   |
   ├── Electronics
   │      └── Warranty_Period
   │
   ├── Clothing
   │      ├── Size
   │      └── Color
   │
   └── Grocery
          └── Expiry_Date

The Product_ID of Product is inherited by each subtype.

11. Special Attributes Used
Primary Key

Primary keys uniquely identify entities.

Examples:

Customer_ID
Order_ID
Product_ID
Seller_ID
Category_ID
Payment_ID
Delivery_ID
Address_ID

They are underlined in the ER diagram.

Multi-Valued Attribute

Mobile_No of Customer is multi-valued.

A customer can have:

Mobile_No = {9876543210, 9123456780}

In an ER diagram, a multi-valued attribute is represented using a double oval.

Composite Attribute

Address is a composite attribute.

Address
   |
   ├── House_No
   ├── Street
   ├── City
   ├── State
   └── PIN_Code

A composite attribute can be divided into smaller meaningful attributes.

12. Participation Constraints
Entity	Relationship	Participation
Customer	Places	Partial
Order	Places	Total
Customer	Has Address	Partial
Address	Has Customer	Total
Order	Has Payment	Total
Payment	Has Order	Partial/Total
Order	Has Delivery	Total
Delivery	Has Order	Partial
Order	Includes Product	Total
Product	Includes Order	Partial
Product	Belongs To Category	Total
Category	Belongs To Product	Partial
Seller	Sells Product	Partial
Product	Sells Seller	Total

Note: Participation can be adjusted depending on the exact business rules assumed by your teacher. For a college ER-model experiment, clearly stating the assumption is sufficient.

13. ER Diagram Notation
Symbol	Meaning
Rectangle	Entity
Oval	Attribute
Double Oval	Multi-valued attribute
Underlined Attribute	Primary Key
Diamond	Relationship
Double Rectangle	Weak Entity
Double Diamond	Identifying Relationship
Triangle / ISA	Specialization/Generalization
Lines	Connections between entities and attributes
<img width="7228" height="4264" alt="image" src="https://github.com/user-attachments/assets/0ef1d29a-983d-482b-ad37-98495663e210" />

