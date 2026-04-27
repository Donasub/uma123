/**
 * Universe Merch Africa - Client Integration Script
 * Include this script on your frontend pages to interact with the UMA API
 * 
 * Usage:
 * <script src="/uma-client.js"></script>
 * <script>
 *   UMA.init({ apiUrl: 'https://your-api.onrender.com/api' });
 * </script>
 */

window.UMA = (function() {
  let apiUrl = '/api';
  let sessionId = null;

  // Initialize client
  function init(options) {
    if (options.apiUrl) {
      apiUrl = options.apiUrl;
    }
    sessionId = localStorage.getItem('UMA_SESSION_ID') || generateSessionId();
    localStorage.setItem('UMA_SESSION_ID', sessionId);
  }

  // Generate session ID
  function generateSessionId() {
    return `session_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  // Helper: Make API request
  async function request(method, endpoint, body = null) {
    const options = {
      method,
      headers: {
        'Content-Type': 'application/json',
        'X-Session-Id': sessionId,
      },
    };

    const token = localStorage.getItem('UMA_TOKEN');
    if (token) {
      options.headers['Authorization'] = `Bearer ${token}`;
    }

    if (body) {
      options.body = JSON.stringify(body);
    }

    const response = await fetch(`${apiUrl}${endpoint}`, options);
    const text = await response.text();

    let data;
    try {
      data = JSON.parse(text);
    } catch (_) {
      // Server returned non-JSON (e.g. Render spin-up splash page)
      if (response.status === 0 || !response.ok) {
        throw new Error('Server is starting up — please refresh in a few seconds.');
      }
      throw new Error('Unexpected server response. Please try again.');
    }

    if (!response.ok) {
      throw new Error(data.error || 'Request failed');
    }

    return data;
  }

  // Auth module
  const auth = {
    async signup(credentials) {
      const result = await request('POST', '/auth/signup', credentials);
      localStorage.setItem('UMA_TOKEN', result.token);
      localStorage.setItem('UMA_USER', JSON.stringify(result.user));
      return result.user;
    },

    async login(email, password) {
      const result = await request('POST', '/auth/login', { email, password });
      localStorage.setItem('UMA_TOKEN', result.token);
      localStorage.setItem('UMA_USER', JSON.stringify(result.user));
      return result.user;
    },

    async logout() {
      localStorage.removeItem('UMA_TOKEN');
      localStorage.removeItem('UMA_USER');
    },

    async getMe() {
      return await request('GET', '/auth/me');
    },

    async updateProfile(updates) {
      return await request('PATCH', '/auth/me', updates);
    },

    async changePassword(current_password, new_password) {
      return await request('PATCH', '/auth/password', { current_password, new_password });
    },

    getCurrentUser() {
      const user = localStorage.getItem('UMA_USER');
      return user ? JSON.parse(user) : null;
    },

    isAuthenticated() {
      return !!localStorage.getItem('UMA_TOKEN');
    },
  };

  // Schools module
  const schools = {
    async list(filters = {}) {
      let url = '/schools';
      if (filters.type) {
        url += `?type=${filters.type}`;
      }
      return await request('GET', url);
    },

    async get(codeOrId) {
      return await request('GET', `/schools/${codeOrId}`);
    },

    async products(codeOrId, filters = {}) {
      let url = `/schools/${codeOrId}/products`;
      const params = new URLSearchParams();
      if (filters.category) params.append('category', filters.category);
      if (filters.size) params.append('size', filters.size);
      if (filters.color) params.append('color', filters.color);
      if (filters.sort) params.append('sort', filters.sort);

      const queryString = params.toString();
      if (queryString) url += `?${queryString}`;

      return await request('GET', url);
    },
  };

  // Products module
  const products = {
    async list(filters = {}) {
      let url = '/products';
      const params = new URLSearchParams();
      if (filters.featured) params.append('featured', 'true');
      if (filters.new_drop) params.append('new_drop', 'true');
      if (filters.category) params.append('category', filters.category);
      if (filters.sort) params.append('sort', filters.sort);

      const queryString = params.toString();
      if (queryString) url += `?${queryString}`;

      return await request('GET', url);
    },

    async get(id) {
      return await request('GET', `/products/${id}`);
    },

    async categories() {
      return await request('GET', '/products/meta/categories');
    },
  };

  // Cart module
  const cart = {
    async get() {
      return await request('GET', '/cart');
    },

    async add(variantId, quantity) {
      return await request('POST', '/cart/items', {
        variant_id: variantId,
        quantity,
      });
    },

    async update(itemId, quantity) {
      return await request('PATCH', `/cart/items/${itemId}`, { quantity });
    },

    async remove(itemId) {
      return await request('DELETE', `/cart/items/${itemId}`);
    },

    async clear() {
      return await request('DELETE', '/cart');
    },
  };

  // Orders module
  const orders = {
    async checkout(orderData) {
      return await request('POST', '/orders', orderData);
    },

    async list() {
      return await request('GET', '/orders');
    },

    async track(orderNumber) {
      return await request('GET', `/orders/by-number/${orderNumber}`);
    },

    async paymentWebhook(orderNumber, status, reference) {
      return await request('POST', `/orders/${orderNumber}/payment-webhook`, {
        status,
        payment_reference: reference,
      });
    },
  };

  // Addresses module
  const addresses = {
    async list() {
      return await request('GET', '/addresses');
    },

    async create(addressData) {
      return await request('POST', '/addresses', addressData);
    },

    async update(id, addressData) {
      return await request('PATCH', `/addresses/${id}`, addressData);
    },

    async delete(id) {
      return await request('DELETE', `/addresses/${id}`);
    },
  };

  // Public API
  return {
    init,
    auth,
    schools,
    products,
    cart,
    orders,
    addresses,
  };
})();
