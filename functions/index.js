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
    success_url: "https://ecommerce-app.web.app/success",
    cancel_url: "https://ecommerce-app.web.app/cancel",
  });

  return { sessionId: session.id };
});
