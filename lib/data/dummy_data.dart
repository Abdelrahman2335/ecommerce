import 'package:uuid/uuid.dart';

import '../models/product_model.dart';

Uuid uuid = Uuid();

final List<Product> productData = [
  Product(
    category: ["Men's Fashion", "Winter Wear", "Sweaters"],
    imageUrl: [
      "https://i.pinimg.com/236x/80/87/22/8087221a9c66fdf7e69448e988949c1d.jpg",
    ],
    title: "Navy Blue Crew Neck Sweater",
    price: 299,
    size: ['S', 'M', 'L'],
    description:
        "A stylish navy blue crew neck sweater made from high-quality cotton blend, perfect for casual or semi-formal wear.",
    id: uuid.v4(),
    quantity: 10,
  ),
  Product(
    category: ["Men's Footwear", "Casual Shoes", "Sneakers"],
    imageUrl: [
      "https://i.pinimg.com/736x/ab/de/93/abde932f6612a4333ea864923bc4d08c.jpg",
    ],
    title: "Men's White Chunky Sneakers",
    price: 999,
    size: ['40-41', '42-43', '44-45'],
    description:
        "Stylish all-white chunky sneakers designed for comfort and durability. Perfect for casual and streetwear fashion.",
    id: uuid.v4(),
    quantity: 5,
  ),
  Product(
    title: "Men's Henley Shirt - Army Green",
    price: 299,
    imageUrl: [
      "https://i.pinimg.com/236x/d8/a2/cf/d8a2cf9de711089909fd806d734fe82c.jpg",
    ],
    category: ["Clothing", "Men's Fashion", "Casual Wear"],
    size: ['S', 'M', 'L', 'XL'],
    description:
        "Comfortable and stylish long-sleeve Henley shirt in army green, perfect for casual and everyday wear.",
    id: uuid.v4(),
    quantity: 6,
  ),
  Product(
    title: "Olive Green Henley Long-Sleeve Shirt",
    price: 799,
    imageUrl: [
      "https://i.pinimg.com/236x/d8/a2/cf/d8a2cf9de711089909fd806d734fe82c.jpg"
    ],
    category: ["Men's Fashion", "Casual Wear", "Shirts"],
    size: ['S', 'M', 'L', 'XL'],
    description:
        "A stylish olive green Henley long-sleeve shirt with a buttoned neckline. Made from soft, breathable fabric for all-day comfort.",
    id: uuid.v4(),
    quantity: 6,
  ),
  Product(
    title: "Men's Olive Green Corduroy Shirt",
    price: 249,
    imageUrl: [
      "https://i.pinimg.com/474x/78/c2/22/78c222b9fd9402e7ee651cf4955512f1.jpg"
    ],
    category: ["Men's Fashion", "Casual Wear", "Shirts"],
    size: ['S', 'M', 'L', 'XL'],
    description:
        "A stylish olive green corduroy shirt with a relaxed fit. Features button-up front, two chest pockets, and rolled-up sleeves for a casual look.",
    id: uuid.v4(),
    quantity: 2,
  ),
  Product(
    title: "Luxury Leather Handbag - Brown",
    price: 899,
    imageUrl: ["https://your-image-url-here.com"],
    category: ["Accessories", "Bags", "Women's Fashion"],
    size: ["One Size"],
    description:
        "Elegant brown leather handbag with gold-tone hardware. Perfect for both casual and formal occasions, offering a blend of style and functionality.",
    id: uuid.v4(),
    quantity: 3,
  ),
  Product(
    title: "Elegant Leather Handbag - Olive Green",
    price: 499,
    imageUrl: [
      "https://i.pinimg.com/236x/ee/19/22/ee192286042fa1c9d6b4e4f13a6e1ffb.jpg"
    ],
    category: ["Accessories", "Bags", "Women's Fashion"],
    description:
        "Stylish olive green leather handbag with a sleek design and ample storage. Ideal for both casual outings and formal occasions.",
    size: null,
    id: uuid.v4(),
    quantity: 14,
  ),
  Product(
    title: "Men's Henley Shirt - Olive",
    price: 349,
    imageUrl: [
      "https://i.pinimg.com/236x/6e/e9/bc/6ee9bc73e894b2218fc8b223202d6d84.jpg"
    ],
    category: ["Clothing", "Men's Fashion"],
    size: ['S', 'M', 'L', 'XL'],
    description:
        "Stylish olive-colored Henley shirt for men, featuring a buttoned neckline and a comfortable fit, perfect for casual wear.",
    id: uuid.v4(),
    quantity: 12,
  ),
  Product(
    title: "Men's Luxury Chronograph Watch - Silver & Blue",
    price: 1299,
    imageUrl: [
      "https://i.pinimg.com/236x/3a/1e/aa/3a1eaa36b1c7303905bb4dca57141009.jpg"
    ],
    category: ["Accessories", "Watches", "Men's Fashion"],
    description:
        "Elegant men's chronograph watch featuring a stainless steel band, deep blue dial, and precise timekeeping. Perfect for formal and casual wear.",
    size: null,
    id: uuid.v4(),
    quantity: 5,
  ),
  Product(
    title: "Men's Classic Black Polo Shirt",
    price: 699,
    imageUrl: [
      "https://i.pinimg.com/236x/20/e5/5e/20e55e578dde7ceea39c49e06c64327c.jpg"
    ],
    category: ["Clothing", "Men's Fashion", "Casual Wear"],
    description:
    "A stylish and comfortable black polo shirt, perfect for casual outings or semi-formal occasions. Made from high-quality breathable fabric.",
    size: ['S', 'M', 'L', 'XL'],
    id: uuid.v4(),
    quantity: 10,
  ),

  Product(
    title: "L'Oréal Paris PRO XXL Extension Mascara",
    price: 399,
    imageUrl: [
      "https://eg.jumia.is/unsafe/fit-in/500x500/filters:fill(white)/product/83/400483/1.jpg?3697"
    ],
    category: ["Personal Care", "Makeup", "Mascara"],
    description:
    "L'Oréal Paris PRO XXL Extension Mascara offers buildable volume and a lengthening effect for dramatic, extended lashes. The dual-ended brush enhances lash definition for a bold look.",
    size: ['6.9ml'],
    id: uuid.v4(),
    quantity: 6,
  ),

  Product(
    title: "Anker P25i Wireless Earbuds",
    price: 1050,
    imageUrl: [
      "https://eg.jumia.is/unsafe/fit-in/500x500/filters:fill(white)/product/56/4263611/1.jpg?6439"
    ],
    category: ["Audio & Wearables", "Electronics", "Accessories"],
    description:
    "Anker P25i True Wireless Earbuds with IPX5 water resistance and up to 30 hours of battery life. Perfect for music and calls with immersive sound quality.",
    size: null,
    id: uuid.v4(),
    quantity: 8,
  ),


  Product(
    title: "Dove Nourishing Secrets Strengthening Shampoo",
    price: 399,
    imageUrl: [
      "https://eg.jumia.is/unsafe/fit-in/500x500/filters:fill(white)/product/11/932722/1.jpg?2138"
    ],
    category: ["Personal Care", "Hair Care", "Shampoo"],
    description:
    "Dove Nourishing Secrets Strengthening Shampoo with avocado and calendula extracts. Helps strengthen and nourish hair while providing a soft, smooth feel.",
    size: ['400ml'],
    id: uuid.v4(),
    quantity: 10,
  ),

  Product(
    title: "L'Oréal Elvive Extraordinary Oil Nourishing Shampoo",
    price: 599,
    imageUrl: [
      "https://eg.jumia.is/unsafe/fit-in/500x500/filters:fill(white)/product/49/994032/1.jpg?9299"
    ],
    category: ["Personal Care", "Hair Care", "Shampoo"],
    description:
    "L'Oréal Elvive Extraordinary Oil Shampoo nourishes dry hair with its rich formula infused with precious oils. Leaves hair soft, shiny, and smooth without weighing it down.",
    size: ['400ml'],
    id: uuid.v4(),
    quantity: 7,
  ),

];
