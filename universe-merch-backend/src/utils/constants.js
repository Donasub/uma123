export const SHIPPING_COSTS = {
  campus_pickup: 0,
  doorstep: 2500,
  express: 5000,
};

export const VAT_RATE = 0.075; // 7.5%

export const CATEGORIES = [
  't-shirts',
  'hoodies',
  'jackets',
  'polo',
  'caps',
  'beanies',
  'pants',
  'shorts',
  'tracksuits',
  'accessories',
];

export const SIZES = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'One Size'];

export const COLORS = [
  'White',
  'Black',
  'Navy Blue',
  'Red',
  'Green',
  'Blue',
  'Yellow',
  'Gray',
  'Orange',
  'Pink',
  'Purple',
  'Gold',
];

export const ORDER_STATUSES = ['pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled'];
export const PAYMENT_STATUSES = ['pending', 'paid', 'failed'];
export const DELIVERY_METHODS = ['campus_pickup', 'doorstep', 'express'];
export const PAYMENT_METHODS = ['card', 'transfer', 'ussd'];
