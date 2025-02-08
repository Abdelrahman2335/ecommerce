import '../models/product_model.dart';

final List<Product> productData = [
  Product(
    category: "Clothing",
    imageUrl: [
      "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/img_2.png?alt=media&token=99b47ab6-54a9-4250-b5c5-16578d7c0304",
      "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/img_3.png?alt=media&token=69e76f6a-cee0-4bf9-82b7-cf30c7c4324c",
      "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/img_4.png?alt=media&token=094a0661-e36f-4747-ae08-d1c26b2ca3c1",
    ],
    title:
        "Kady Windowpane Pattern Buttons Down Closure Shirt - Navy Blue & Dark Green",
    price: 299,
    size: ['S', 'M', 'L'],
    description:
        "A stylish and comfortable shirt with a windowpane pattern, perfect for casual and formal occasions.",
  ),
  Product(
    category: "Footwear",
    imageUrl: [
      "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/img_1.png?alt=media&token=443a3367-f2b9-418b-8a08-fff1e71f5106",
    ],
    title: "Nike Shoes",
    price: 999,
    size: ['40-41', '42-43', '44-45'],
    description:
        "High-performance Nike shoes designed for comfort and durability, ideal for sports and everyday wear.",
  ),
  Product(
    title: "Elegant Women's Printed Kurta",
    price: 400,
    imageUrl: [
      "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/dress.png?alt=media&token=d8611349-946a-42a0-8038-9a6e10e86e57",
    ],
    category: "Clothing",
    size: ['S', 'M', 'L'],
    description:
        "Elegant printed kurta with vibrant colors, perfect for traditional and festive occasions.",
  ),
  Product(
    title: "Marwa Platform Moccasin - Green",
    price: 799,
    imageUrl: [
      "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/classic%20shoes.jpg?alt=media&token=7de8cdda-4635-4e88-83e7-9bcece3a43bb"
    ],
    category: "Footwear",
    size: ['40-41', '42-43', '44-45'],
    description:
        "Stylish platform moccasins with a classic design, adding elegance and comfort to your steps.",
  ),
  Product(
    title: "Men's Casual Shirt",
    price: 249,
    imageUrl: [
      "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/T-shert.png?alt=media&token=691bb8ac-cc7f-4df2-b312-e1995dfcf198"
    ],
    category: "Clothing",
    size: ['S', 'M', 'L'],
    description:
        "Casual shirt for men, crafted with breathable fabric for everyday comfort and style.",
  ),
  Product(
    title: "Running Shoes - Blue",
    price: 140,
    imageUrl: [
      "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/shoes.png.jpg?alt=media&token=26188e93-ac61-4911-b1fe-77da33cbdcdd"
    ],
    category: "Footwear",
    size: ['40-41', '42-43', '44-45'],
    description:
        "Lightweight running shoes designed for optimal performance, with a stylish blue finish.",
  ),
  Product(
    title: "Leather Handbag - Brown",
    price: 499,
    imageUrl: [
      "https://getdore.com/cdn/shop/files/DDohVrouwen-Zachte-Pu-Lederen-Schoudertas-Toevallige-Vintage-Grote-Handtassen-Mode-Nieuwe-Eenvoudige-Onderarm-Tassen-Luxe-Designer.jpg?v=1726060840&width=713"
    ],
    category: "Accessories",
    description:
        "Elegant brown leather handbag with ample storage, perfect for both formal and casual settings.",
    size: null,
  ),
  Product(
    category: "Clothing",
    imageUrl: [
      "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/jacket.png?alt=media&token=6171661b-b828-42ae-b6dd-730b696a4e15"
    ],
    title: "Men's Jacket - Black",
    size: ['S', 'M', 'L'],
    price: 499,
    description:
        "Classic black jacket for men, designed to provide warmth and style during colder days.",
  ),
  Product(
      title: "Men's Classic Watch",
      price: 999,
      imageUrl: [
        "https://ng.jumia.is/unsafe/fit-in/680x680/filters:fill(white)/product/91/4377262/1.jpg?3687"
      ],
      category: "Accessories",
      description:
          "Sophisticated classic watch, ideal for formal wear and everyday elegance.",
      size: null),
  Product(
      title: "Shirt - Black",
      price: 699,
      imageUrl: [
        "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/pexels-gustavo-11576960.jpg?alt=media&token=07c57d92-e30d-4acc-88df-974a8c6e17af"
      ],
      category: "Accessories",
      description:
          "Versatile black shirt that pairs well with any outfit for a sleek, modern look.",
      size: null),
  Product(
    title: "Women High Heels - Red",
    price: 399,
    imageUrl: [
      "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/Women%20High%20Heels.png?alt=media&token=1affb620-bc58-45eb-a32e-f7b4f84294b6"
    ],
    category: "Footwear",
    size: ['38-39', '40-41', '42-43'],
    description:
        "Elegant high heels in a striking red color, designed to make a statement.",
  ),
  Product(
      title: "Bluetooth Headphone",
      price: 699,
      imageUrl: [
        "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/Headphones.png?alt=media&token=9faa4534-6962-4876-afb2-f7a455533d13"
      ],
      category: "Electronics",
      description:
          "Wireless Bluetooth headphones with high-quality sound and comfortable design for long wear.",
      size: null),
  Product(
    title: "Men's Formal Trousers",
    price: 399,
    imageUrl: [
      "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/img.png?alt=media&token=de4073b5-5571-4af2-a88e-bc11da1efe3b"
    ],
    category: "Clothing",
    size: ['40-41', '42-43', '44-45'],
    description:
        "Smart formal trousers for men, offering a tailored fit suitable for business and formal events.",
  ),
  Product(
    title: "Men's Watch - Classic",
    price: 599,
    imageUrl: [
      "https://firebasestorage.googleapis.com/v0/b/e-commerce-app-669f8.appspot.com/o/watch.png?alt=media&token=a2a0fe2e-79af-43b7-9767-1a4ca9d23628"
    ],
    category: "Accessories",
    description:
        "Elegant men's watch with classic styling, perfect for daily wear or special occasions.",
    size: null,
  ),
];
