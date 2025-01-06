const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
EOL

# Step 7: Create styles.css
cat <<EOL > public/admin-panel/styles.css
body {
    font-family: Arial, sans-serif;
    text-align: center;
    margin-top: 100px;
}
form {
    display: inline-block;
    margin-top: 20px;
}
input, button {
    display: block;
    margin: 10px auto;
}
button {
    padding: 10px 20px;
    background-color: #007BFF;
    color: white;
    border: none;
    cursor: pointer;
}
EOL

# Step 8: Deploy to Firebase Hosting
echo "Deploying to Firebase Hosting..."
firebase deploy --project $FIREBASE_PROJECT_ID
echo "Deployment complete! Visit your site at:"
echo "https://$FIREBASE_PROJECT_ID.web.app/admin-panel/index.html"
cd admin-panel
ls -la
cd components
ls -la
cd ..
cd public
ls -la
cd ..
cd admin-panel
npm start
firebase init
firebase deploy
ls -la
cd
ls -la
cd ecommerce-admin
ls -la
cd
cd ecommerce-app
ls -la
cd public
ls -la
cd ..
cd
#!/bin/bash
# Stop the script if any command fails
# Variables
PROJECT_NAME="allyelvis6569"
FIREBASE_PROJECT_ID="ecommerce-gu2h4u"
# Step 1: Firebase Setup
echo "Initializing Firebase Project..."
firebase init hosting --project $FIREBASE_PROJECT_ID --public public
# Step 2: Create Directory Structure
echo "Creating directory structure..."
mkdir -p public/{admin-panel}
# Step 3: Create index.html (Login & Dashboard)
cat <<EOL > public/admin-panel/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div id="login-container">
        <h1>Admin Panel</h1>
        <form id="login-form">
            <input type="email" id="email" placeholder="Email" required>
            <input type="password" id="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        <p id="error-message"></p>
    </div>

    <div id="dashboard-container" style="display: none;">
        <h1>Admin Dashboard</h1>
        <button id="logout-btn">Logout</button>
        <div>
            <h2>Manage Products</h2>
            <button onclick="window.location.href='products.html'">Go to Products</button>
        </div>
        <div>
            <h2>Manage Orders</h2>
            <button onclick="window.location.href='orders.html'">Go to Orders</button>
        </div>
    </div>

    <script type="module" src="firebase-config.js"></script>
</body>
</html>
EOL

# Step 4: Create products.html
cat <<EOL > public/admin-panel/products.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Product Management</h1>
    <form id="product-form">
        <input type="text" id="product-name" placeholder="Product Name" required>
        <input type="number" id="product-price" placeholder="Price" required>
        <button type="submit">Add Product</button>
    </form>
    <ul id="product-list"></ul>
    <script type="module" src="firebase-config.js"></script>
</body>
</html>
EOL

# Step 5: Create orders.html
cat <<EOL > public/admin-panel/orders.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Order Management</h1>
    <ul id="order-list"></ul>
    <script type="module" src="firebase-config.js"></script>
</body>
</html>
EOL

# Step 6: Create firebase-config.js
cat <<EOL > public/admin-panel/firebase-config.js
// Firebase Configuration
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-app.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-auth.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-firestore.js";

const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "$FIREBASE_PROJECT_ID.firebaseapp.com",
    projectId: "$FIREBASE_PROJECT_ID",
    storageBucket: "$FIREBASE_PROJECT_ID.appspot.com",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID"
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
EOL

# Step 7: Create styles.css
cat <<EOL > public/admin-panel/styles.css
body {
    font-family: Arial, sans-serif;
    text-align: center;
    margin-top: 100px;
}
form {
    display: inline-block;
    margin-top: 20px;
}
input, button {
    display: block;
    margin: 10px auto;
}
button {
    padding: 10px 20px;
    background-color: #007BFF;
    color: white;
    border: none;
    cursor: pointer;
}
EOL

# Step 8: Deploy to Firebase Hosting
echo "Deploying to Firebase Hosting..."
firebase deploy --project $FIREBASE_PROJECT_ID
echo "Deployment complete! Visit your site at:"
echo "https://$FIREBASE_PROJECT_ID.web.app/admin-panel/index.html"
#!/bin/bash
# Stop the script if any command fails
# Variables
PROJECT_NAME="allyelvis6569"
FIREBASE_PROJECT_ID="ecommerce-gu2h4u"
# Step 1: Firebase Setup
echo "Initializing Firebase Project..."
firebase init hosting --project $FIREBASE_PROJECT_ID public
# Step 2: Create Directory Structure
echo "Creating directory structure..."
mkdir -p public/{admin-panel}
# Step 3: Create index.html (Login & Dashboard)
cat <<EOL > public/admin-panel/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div id="login-container">
        <h1>Admin Panel</h1>
        <form id="login-form">
            <input type="email" id="email" placeholder="Email" required>
            <input type="password" id="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        <p id="error-message"></p>
    </div>

    <div id="dashboard-container" style="display: none;">
        <h1>Admin Dashboard</h1>
        <button id="logout-btn">Logout</button>
        <div>
            <h2>Manage Products</h2>
            <button onclick="window.location.href='products.html'">Go to Products</button>
        </div>
        <div>
            <h2>Manage Orders</h2>
            <button onclick="window.location.href='orders.html'">Go to Orders</button>
        </div>
    </div>

    <script type="module" src="firebase-config.js"></script>
</body>
</html>
EOL

# Step 4: Create products.html
cat <<EOL > public/admin-panel/products.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Product Management</h1>
    <form id="product-form">
        <input type="text" id="product-name" placeholder="Product Name" required>
        <input type="number" id="product-price" placeholder="Price" required>
        <button type="submit">Add Product</button>
    </form>
    <ul id="product-list"></ul>
    <script type="module" src="firebase-config.js"></script>
</body>
</html>
EOL

# Step 5: Create orders.html
cat <<EOL > public/admin-panel/orders.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Order Management</h1>
    <ul id="order-list"></ul>
    <script type="module" src="firebase-config.js"></script>
</body>
</html>
EOL

# Step 6: Create firebase-config.js
cat <<EOL > public/admin-panel/firebase-config.js
// Firebase Configuration
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-app.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-auth.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-firestore.js";

const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "$FIREBASE_PROJECT_ID.firebaseapp.com",
    projectId: "$FIREBASE_PROJECT_ID",
    storageBucket: "$FIREBASE_PROJECT_ID.appspot.com",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID"
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
EOL

# Step 7: Create styles.css
cat <<EOL > public/admin-panel/styles.css
body {
    font-family: Arial, sans-serif;
    text-align: center;
    margin-top: 100px;
}
form {
    display: inline-block;
    margin-top: 20px;
}
input, button {
    display: block;
    margin: 10px auto;
}
button {
    padding: 10px 20px;
    background-color: #007BFF;
    color: white;
    border: none;
    cursor: pointer;
}
EOL

# Step 8: Deploy to Firebase Hosting
echo "Deploying to Firebase Hosting..."
firebase deploy --project $FIREBASE_PROJECT_ID
echo "Deployment complete! Visit your site at:"
echo "https://$FIREBASE_PROJECT_ID.web.app/admin-panel/index.html"
ls -la
cd functions
ls -la
npm run build
cd
cd public
ls -la
cd
cd public
cd {admin-panel}
ls -la
cd
firebase init
firebase deploy
npm run start
npm run build
#!/bin/bash
# Stop the script if any command fails
# Variables
PROJECT_NAME="ecommerce-admin"
FIREBASE_PROJECT_ID="ecommerce-gu2h4u"
# Step 1: Firebase Setup
echo "Initializing Firebase Project..."
firebase init hosting --project $FIREBASE_PROJECT_ID --public public
# Step 2: Create Directory Structure
echo "Creating directory structure..."
mkdir -p public/{admin-panel}
# Step 3: Create index.html (Login & Dashboard)
cat <<EOL > public/admin-panel/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div id="login-container">
        <h1>Admin Panel</h1>
        <form id="login-form">
            <input type="email" id="email" placeholder="Email" required>
            <input type="password" id="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        <p id="error-message"></p>
    </div>

    <div id="dashboard-container" style="display: none;">
        <h1>Admin Dashboard</h1>
        <button id="logout-btn">Logout</button>
        <div>
            <h2>Manage Products</h2>
            <button onclick="window.location.href='products.html'">Go to Products</button>
        </div>
        <div>
            <h2>Manage Orders</h2>
            <button onclick="window.location.href='orders.html'">Go to Orders</button>
        </div>
    </div>

    <script type="module" src="firebase-config.js"></script>
</body>
</html>
EOL

# Step 4: Create products.html
cat <<EOL > public/admin-panel/products.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Product Management</h1>
    <form id="product-form">
        <input type="text" id="product-name" placeholder="Product Name" required>
        <input type="number" id="product-price" placeholder="Price" required>
        <button type="submit">Add Product</button>
    </form>
    <ul id="product-list"></ul>
    <script type="module" src="firebase-config.js"></script>
</body>
</html>
EOL

# Step 5: Create orders.html
cat <<EOL > public/admin-panel/orders.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Order Management</h1>
    <ul id="order-list"></ul>
    <script type="module" src="firebase-config.js"></script>
</body>
</html>
EOL

# Step 6: Create firebase-config.js
cat <<EOL > public/admin-panel/firebase-config.js
// Firebase Configuration
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-app.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-auth.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/10.8.1/firebase-firestore.js";

const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "$FIREBASE_PROJECT_ID.firebaseapp.com",
    projectId: "$FIREBASE_PROJECT_ID",
    storageBucket: "$FIREBASE_PROJECT_ID.appspot.com",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    appId: "YOUR_APP_ID"
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
EOL

# Step 7: Create styles.css
cat <<EOL > public/admin-panel/styles.css
body {
    font-family: Arial, sans-serif;
    text-align: center;
    margin-top: 100px;
}
form {
    display: inline-block;
    margin-top: 20px;
}
input, button {
    display: block;
    margin: 10px auto;
}
button {
    padding: 10px 20px;
    background-color: #007BFF;
    color: white;
    border: none;
    cursor: pointer;
}
EOL

# Step 8: Deploy to Firebase Hosting
echo "Deploying to Firebase Hosting..."
firebase deploy --project $FIREBASE_PROJECT_ID
echo "Deployment complete! Visit your site at:"
echo "https://$FIREBASE_PROJECT_ID.web.app/admin-panel/index.html"docker pull     gcr.io/sic-container-repo/todo-api-postgres:latest
gcloud auth configure-docker gcr.io
docker pull     gcr.io/sic-container-repo/todo-api-postgres:latest
docker pull     gcr.io/sic-container-repo/todo-api-postgres@sha256:da7715bb369f199b3b8a8631371264e27854aff92295d451b4e941d0ad313c69
cd 
