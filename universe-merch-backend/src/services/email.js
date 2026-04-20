import nodemailer from 'nodemailer';
import dotenv from 'dotenv';

dotenv.config();

const transporter = nodemailer.createTransport({
  host: process.env.EMAIL_HOST,
  port: parseInt(process.env.EMAIL_PORT),
  secure: process.env.EMAIL_PORT == 465, // true for 465, false for other ports
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

export const sendWelcomeEmail = async (user) => {
  try {
    const mailOptions = {
      from: process.env.EMAIL_FROM || `"Universe Merch" <${process.env.EMAIL_USER}>`,
      to: user.email,
      subject: 'Welcome to Universe Merch Africa! 🎉',
      html: `
        <h1>Welcome, ${user.first_name}!</h1>
        <p>Your Universe Merch account has been created successfully.</p>
        <p>You can now browse and shop from your school's storefront.</p>
        <p>
          <a href="${process.env.FRONTEND_URL}" style="background-color: #003380; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;">
            Start Shopping
          </a>
        </p>
        <p>Best regards,<br>The Universe Merch Team</p>
      `,
    };

    await transporter.sendMail(mailOptions);
    console.log(`Welcome email sent to ${user.email}`);
  } catch (error) {
    console.error('Failed to send welcome email:', error);
    // Don't throw - email delivery failure shouldn't block signup
  }
};

export const sendOrderConfirmationEmail = async (order, items) => {
  try {
    const itemsHtml = items
      .map(
        (item) => `
        <tr>
          <td>${item.name} (${item.size}/${item.color})</td>
          <td align="center">${item.quantity}</td>
          <td align="right">₦${item.price.toLocaleString()}</td>
          <td align="right">₦${(item.price * item.quantity).toLocaleString()}</td>
        </tr>
      `
      )
      .join('');

    const mailOptions = {
      from: process.env.EMAIL_FROM || `"Universe Merch" <${process.env.EMAIL_USER}>`,
      to: order.email,
      subject: `Order Confirmation - ${order.order_number} ✓`,
      html: `
        <h1>Order Confirmed!</h1>
        <p>Thank you for your order, ${order.first_name}!</p>
        
        <h2>Order Details</h2>
        <p><strong>Order Number:</strong> ${order.order_number}</p>
        <p><strong>Date:</strong> ${new Date(order.created_at).toLocaleDateString()}</p>
        
        <h2>Items</h2>
        <table border="1" cellpadding="10" style="border-collapse: collapse; width: 100%;">
          <thead>
            <tr style="background-color: #f0f0f0;">
              <th align="left">Product</th>
              <th align="center">Qty</th>
              <th align="right">Price</th>
              <th align="right">Total</th>
            </tr>
          </thead>
          <tbody>
            ${itemsHtml}
          </tbody>
        </table>
        
        <h2>Order Summary</h2>
        <p><strong>Subtotal:</strong> ₦${order.subtotal.toLocaleString()}</p>
        <p><strong>Shipping (${order.delivery_method}):</strong> ₦${order.shipping_cost.toLocaleString()}</p>
        <p><strong>VAT (7.5%):</strong> ₦${order.vat.toLocaleString()}</p>
        ${order.discount_amount > 0 ? `<p><strong>Discount:</strong> -₦${order.discount_amount.toLocaleString()}</p>` : ''}
        <h3 style="border-top: 2px solid #ddd; padding-top: 10px;">
          <strong>Total: ₦${order.total_amount.toLocaleString()}</strong>
        </h3>
        
        <h2>Delivery Information</h2>
        <p><strong>Method:</strong> ${order.delivery_method.replace('_', ' ').toUpperCase()}</p>
        ${order.delivery_address ? `<p><strong>Address:</strong> ${order.delivery_address}, ${order.delivery_city}, ${order.delivery_state}</p>` : ''}
        ${order.delivery_notes ? `<p><strong>Notes:</strong> ${order.delivery_notes}</p>` : ''}
        
        <h2>Next Steps</h2>
        <p>We're processing your order. You'll receive a shipment update within 24 hours.</p>
        <p><strong>Payment Status:</strong> ${order.payment_status.toUpperCase()}</p>
        
        <p style="margin-top: 30px; color: #666; font-size: 12px;">
          Questions? Contact us at support@universemerch.africa
        </p>
      `,
    };

    await transporter.sendMail(mailOptions);
    console.log(`Order confirmation email sent to ${order.email}`);
  } catch (error) {
    console.error('Failed to send order confirmation email:', error);
    // Don't throw - email delivery failure shouldn't block order
  }
};

export const verifyEmailConfig = async () => {
  try {
    await transporter.verify();
    console.log('✓ Email service is ready');
    return true;
  } catch (error) {
    console.error('✗ Email service verification failed:', error.message);
    return false;
  }
};
