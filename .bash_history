npm install firebase
npx create-next-app ecommerce-app
cd ecommerce-app
ls -la
npx create-next-app ecommerce-app
cd ecommerce-app
cd
cd ecommerce-app
npm install firebase react-firebase-hooks
cd
npm install -g firebase-tools
firebase login --no-localhost
#!/bin/bash
# Variables - Change these to fit your project
PROJECT_ID="ecommerce-app"
APP_NAME="ecommerce"
REGION="us-central1"
echo "Starting Firebase eCommerce Setup..."
# 1. Initialize Firebase Project
echo "Creating Firebase project: $PROJECT_ID"
firebase projects:create $PROJECT_ID --display-name $APP_NAME
firebase use $PROJECT_ID
# 2. Enable Firestore, Authentication, Hosting
echo "Initializing Firebase services..."
firebase init firestore
firebase init hosting
firebase init functions
firebase init storage
firebase init auth
# 3. Setup Firestore Database (Creating Collections)
echo "Setting up Firestore structure..."
firebase firestore:rules > firestore.rules <<EOL
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
EOL

echo "Deploying Firestore rules..."
firebase deploy --only firestore:rules
# 4. Create a Frontend with Next.js (React alternative)
echo "Creating Next.js frontend..."
npx create-next-app ecommerce-frontend
cd ecommerce-frontend
echo "Installing Firebase SDK..."
npm install firebase react-firebase-hooks
echo "Configuring Firebase..."
cat > firebaseConfig.js <<EOL
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "$PROJECT_ID.firebaseapp.com",
  projectId: "$PROJECT_ID",
  storageBucket: "$PROJECT_ID.appspot.com",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);

export { db, auth };
EOL

# 5. Generate Product Listing Page
echo "Generating product listing page..."
cat > pages/products.js <<EOL
import { db } from "../firebaseConfig";
import { collection, getDocs } from "firebase/firestore";
import { useState, useEffect } from "react";

export default function Products() {
  const [products, setProducts] = useState([]);

  useEffect(() => {
    const fetchProducts = async () => {
      const querySnapshot = await getDocs(collection(db, "products"));
      const productList = querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
      setProducts(productList);
    };
    fetchProducts();
  }, []);

  return (
    <div>
      <h1>Our Products</h1>
      {products.map(product => (
        <div key={product.id}>
          <img src={product.imageUrl} alt={product.name} width="150" />
          <h2>{product.name}</h2>
          <p>{product.description}</p>
          <p>${product.price}</p>
        </div>
      ))}
    </div>
  );
}
EOL

# 6. Add to Cart Function
echo "Creating add to cart function..."
cat > components/AddToCart.js <<EOL
import { db, auth } from "../firebaseConfig";
import { doc, updateDoc, arrayUnion } from "firebase/firestore";

export default function AddToCart({ product }) {
  const addToCart = async () => {
    const user = auth.currentUser;
    if (user) {
      const userRef = doc(db, "users", user.uid);
      await updateDoc(userRef, {
        cart: arrayUnion({ productId: product.id, quantity: 1 })
      });
      alert("Added to cart!");
    } else {
      alert("Please log in to add items to cart.");
    }
  };

  return <button onClick={addToCart}>Add to Cart</button>;
}
EOL

# 7. Deploy Firebase Hosting
echo "Deploying to Firebase Hosting..."
npm run build
firebase deploy --only hosting
# 8. Deploy Cloud Functions for Payments
echo "Setting up Cloud Functions for Stripe Payments..."
cd ../functions
npm install stripe
cat > index.js <<EOL
const functions = require("firebase-functions");
const stripe = require("stripe")("sk_test_YOUR_SECRET_KEY");

exports.createCheckoutSession = functions.https.onCall(async (data, context) => {
  const { items } = data;
  const lineItems = items.map(item => ({
    price_data: {
      currency: "usd",
      product_data: {
        name: item.name,
      },
      unit_amount: item.price * 100,
    },
    quantity: item.quantity,
  }));

  const session = await stripe.checkout.sessions.create({
    payment_method_types: ["card"],
    line_items: lineItems,
    mode: "payment",
    success_url: "https://$PROJECT_ID.web.app/success",
    cancel_url: "https://$PROJECT_ID.web.app/cancel",
  });

  return { sessionId: session.id };
});
EOL

firebase deploy --only functions
echo "eCommerce Project Setup Complete!"
cd ..
ls -la
#!/bin/bash
# Variables - Customize for your project
PROJECT_ID="ecommerce-app"
APP_NAME="ecommerce"
ADMIN_PANEL_DIR="admin-panel"
REGION="us-central1"
echo "Starting Admin Panel Setup for $APP_NAME..."
# 1. Create Admin Panel Frontend (Next.js)
echo "Creating Next.js admin panel..."
npx create-next-app $ADMIN_PANEL_DIR
cd $ADMIN_PANEL_DIR
echo "Installing Firebase SDK and Admin Tools..."
npm install firebase react-firebase-hooks
# 2. Configure Firebase in Admin Panel
cat > firebaseConfig.js <<EOL
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "$PROJECT_ID.firebaseapp.com",
  projectId: "$PROJECT_ID",
  storageBucket: "$PROJECT_ID.appspot.com",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);

export { db, auth };
EOL

# 3. Create Admin Authentication (Google Login)
cat > pages/login.js <<EOL
import { getAuth, signInWithPopup, GoogleAuthProvider } from "firebase/auth";
import { useRouter } from 'next/router';
import { useEffect } from 'react';

export default function Login() {
  const provider = new GoogleAuthProvider();
  const auth = getAuth();
  const router = useRouter();

  const signIn = async () => {
    try {
      const result = await signInWithPopup(auth, provider);
      const user = result.user;
      if (user.email.endsWith("@admin.com")) {
        router.push('/admin');
      } else {
        alert("Access Denied");
      }
    } catch (error) {
      console.error("Error signing in", error);
    }
  };

  useEffect(() => {
    signIn();
  }, []);

  return <p>Redirecting...</p>;
}
EOL

# 4. Create Admin Dashboard
mkdir pages/admin
cat > pages/admin/index.js <<EOL
import { useEffect, useState } from "react";
import { db } from "../../firebaseConfig";
import { collection, getDocs, deleteDoc, doc } from "firebase/firestore";

export default function Admin() {
  const [products, setProducts] = useState([]);

  useEffect(() => {
    const fetchProducts = async () => {
      const querySnapshot = await getDocs(collection(db, "products"));
      const productList = querySnapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data(),
      }));
      setProducts(productList);
    };
    fetchProducts();
  }, []);

  const deleteProduct = async (id) => {
    await deleteDoc(doc(db, "products", id));
    setProducts(products.filter(product => product.id !== id));
  };

  return (
    <div>
      <h1>Admin Panel</h1>
      <h2>Product List</h2>
      {products.map((product) => (
        <div key={product.id}>
          <h3>{product.name}</h3>
          <p>${product.price}</p>
          <button onClick={() => deleteProduct(product.id)}>Delete</button>
        </div>
      ))}
    </div>
  );
}
EOL

# 5. Create Product Management (Add Product)
cat > pages/admin/add-product.js <<EOL
import { useState } from "react";
import { db } from "../../firebaseConfig";
import { collection, addDoc } from "firebase/firestore";

export default function AddProduct() {
  const [productName, setProductName] = useState("");
  const [price, setPrice] = useState("");
  const [description, setDescription] = useState("");

  const addProduct = async () => {
    await addDoc(collection(db, "products"), {
      name: productName,
      price: parseFloat(price),
      description,
      imageUrl: "https://via.placeholder.com/150",
      stock: 10,
    });
    alert("Product added!");
  };

  return (
    <div>
      <h1>Add New Product</h1>
      <input
        type="text"
        placeholder="Product Name"
        value={productName}
        onChange={(e) => setProductName(e.target.value)}
      />
      <input
        type="number"
        placeholder="Price"
        value={price}
        onChange={(e) => setPrice(e.target.value)}
      />
      <textarea
        placeholder="Description"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
      ></textarea>
      <button onClick={addProduct}>Add Product</button>
    </div>
  );
}
EOL

# 6. Add Admin Navigation
cat > components/AdminNav.js <<EOL
import Link from 'next/link';

export default function AdminNav() {
  return (
    <nav>
      <Link href="/admin">Dashboard</Link> | 
      <Link href="/admin/add-product">Add Product</Link>
    </nav>
  );
}
EOL

cat >> pages/admin/index.js <<EOL
import AdminNav from '../../components/AdminNav';
EOL

sed -i '1i import AdminNav from "../../components/AdminNav";' pages/admin/index.js
# 7. Deploy Admin Panel to Firebase Hosting
echo "Deploying Admin Panel to Firebase Hosting..."
npm run build
firebase deploy --only hosting
echo "Admin Panel Setup Complete!"
ls -la
cd
#!/bin/bash
PROJECT_ID="ecommerce-app"
APP_NAME="ecommerce"
ADMIN_PANEL_DIR="admin-panel"
REGION="us-central1"
echo "Starting Full Admin Panel Setup for $APP_NAME..."
# 1. Create Admin Panel Frontend (Next.js)
echo "Creating Next.js admin panel..."
npx create-next-app $ADMIN_PANEL_DIR
cd $ADMIN_PANEL_DIR
echo "Installing Firebase SDK and Admin Tools..."
npm install firebase react-firebase-hooks
# 2. Configure Firebase in Admin Panel
cat > firebaseConfig.js <<EOL
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "$PROJECT_ID.firebaseapp.com",
  projectId: "$PROJECT_ID",
  storageBucket: "$PROJECT_ID.appspot.com",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);

export { db, auth };
EOL

# 3. Admin Authentication (Google Login)
cat > pages/login.js <<EOL
import { getAuth, signInWithPopup, GoogleAuthProvider } from "firebase/auth";
import { useRouter } from 'next/router';
import { useEffect } from 'react';

export default function Login() {
  const provider = new GoogleAuthProvider();
  const auth = getAuth();
  const router = useRouter();

  const signIn = async () => {
    try {
      const result = await signInWithPopup(auth, provider);
      const user = result.user;
      if (user.email.endsWith("@admin.com")) {
        router.push('/admin');
      } else {
        alert("Access Denied");
      }
    } catch (error) {
      console.error("Error signing in", error);
    }
  };

  useEffect(() => {
    signIn();
  }, []);

  return <p>Redirecting...</p>;
}
EOL

# 4. Admin Navigation
mkdir components
cat > components/AdminNav.js <<EOL
import Link from 'next/link';

export default function AdminNav() {
  return (
    <nav>
      <Link href="/admin">Dashboard</Link> | 
      <Link href="/admin/add-product">Add Product</Link> | 
      <Link href="/admin/orders">Orders</Link> | 
      <Link href="/admin/users">Users</Link>
    </nav>
  );
}
EOL

# 5. Admin Dashboard
mkdir pages/admin
cat > pages/admin/index.js <<EOL
import AdminNav from '../../components/AdminNav';
export default function Admin() {
  return (
    <div>
      <AdminNav />
      <h1>Admin Dashboard</h1>
      <p>Welcome to the admin panel.</p>
    </div>
  );
}
EOL

# 6. Product Management (Add Product)
cat > pages/admin/add-product.js <<EOL
import { useState } from "react";
import { db } from "../../firebaseConfig";
import { collection, addDoc } from "firebase/firestore";

export default function AddProduct() {
  const [productName, setProductName] = useState("");
  const [price, setPrice] = useState("");
  const [description, setDescription] = useState("");

  const addProduct = async () => {
    await addDoc(collection(db, "products"), {
      name: productName,
      price: parseFloat(price),
      description,
      imageUrl: "https://via.placeholder.com/150",
      stock: 10,
    });
    alert("Product added!");
  };

  return (
    <div>
      <AdminNav />
      <h1>Add Product</h1>
      <input
        type="text"
        placeholder="Product Name"
        value={productName}
        onChange={(e) => setProductName(e.target.value)}
      />
      <input
        type="number"
        placeholder="Price"
        value={price}
        onChange={(e) => setPrice(e.target.value)}
      />
      <textarea
        placeholder="Description"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
      ></textarea>
      <button onClick={addProduct}>Add Product</button>
    </div>
  );
}
EOL

# 7. Order Management
cat > pages/admin/orders.js <<EOL
import { useEffect, useState } from "react";
import { db } from "../../firebaseConfig";
import { collection, getDocs, updateDoc, doc } from "firebase/firestore";

export default function Orders() {
  const [orders, setOrders] = useState([]);

  useEffect(() => {
    const fetchOrders = async () => {
      const querySnapshot = await getDocs(collection(db, "orders"));
      const orderList = querySnapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data(),
      }));
      setOrders(orderList);
    };
    fetchOrders();
  }, []);

  const markAsShipped = async (id) => {
    await updateDoc(doc(db, "orders", id), {
      status: "Shipped",
    });
    alert("Order marked as shipped.");
    setOrders(orders.map(order => order.id === id ? { ...order, status: "Shipped" } : order));
  };

  return (
    <div>
      <AdminNav />
      <h1>Orders</h1>
      {orders.map((order) => (
        <div key={order.id}>
          <p>Order ID: {order.id}</p>
          <p>{order.status}</p>
          <button onClick={() => markAsShipped(order.id)}>Mark as Shipped</button>
        </div>
      ))}
    </div>
  );
}
EOL

# 8. User Management
cat > pages/admin/users.js <<EOL
import { useEffect, useState } from "react";
import { db } from "../../firebaseConfig";
import { collection, getDocs } from "firebase/firestore";

export default function Users() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    const fetchUsers = async () => {
      const querySnapshot = await getDocs(collection(db, "users"));
      const userList = querySnapshot.docs.map(doc => doc.data());
      setUsers(userList);
    };
    fetchUsers();
  }, []);

  return (
    <div>
      <AdminNav />
      <h1>Users</h1>
      {users.map((user, index) => (
        <div key={index}>
          <p>Email: {user.email}</p>
          <p>Role: {user.role || "User"}</p>
        </div>
      ))}
    </div>
  );
}
EOL

# 9. Deploy to Firebase Hosting
npm run build
firebase deploy --only hosting
echo "Admin Panel with Product, Order, and User Management Complete!"
cd
cd admin-panel
# Deploy Firestore Security Rules
cat > firestore.rules <<EOL
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    match /orders/{orderId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && (
        request.resource.data.userId == request.auth.uid || 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin'
      );
    }
    match /users/{userId} {
      allow read: if request.auth != null && (
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin' || 
        request.auth.uid == userId
      );
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
EOL

echo "Deploying Firestore Rules..."
firebase deploy --only firestore:rules
cd
# Deploy Firestore Security Rules
cat > firestore.rules <<EOL
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    match /orders/{orderId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && (
        request.resource.data.userId == request.auth.uid || 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin'
      );
    }
    match /users/{userId} {
      allow read: if request.auth != null && (
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin' || 
        request.auth.uid == userId
      );
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
EOL

echo "Deploying Firestore Rules..."
firebase deploy --only firestore:rules
git config --global user.email"allyelvis6569@gmail.com"
git config --global user.name "allyelvis"
git add .
git commit -m "initialize"
git config --global user.email "allyelvis6569@gmail.com"
git config --global user name "allyelvis"
git config --global user.name "allyelvis"
