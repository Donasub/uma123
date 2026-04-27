/**
 * Universe Merch Africa — Shared Navbar Auth Utilities
 * Include after uma-client.js on every page.
 * Usage: UMANav.init({ cartId: 'cartCount', userId: 'userMenu' });
 */
(function () {
  // Inject shared styles once
  const style = document.createElement('style');
  style.textContent = `
    .uma-signin-btn {
      display: inline-flex; align-items: center; gap: 6px;
      background: var(--mustard, #F0A500); color: var(--ink, #17140F) !important;
      padding: 8px 18px; border-radius: 3px; font-size: .72rem;
      font-weight: 600; letter-spacing: .12em; text-transform: uppercase;
      text-decoration: none; cursor: pointer; transition: opacity .2s;
      white-space: nowrap;
    }
    .uma-signin-btn:hover { opacity: .85; }

    .uma-user-wrap { position: relative; }

    .uma-user-btn {
      display: inline-flex; align-items: center; gap: 7px; cursor: pointer;
      padding: 6px 12px; border-radius: 3px; transition: background .2s;
      font-size: .75rem; font-weight: 600; letter-spacing: .08em;
      text-transform: uppercase; color: inherit;
      background: rgba(255,255,255,.12);
    }
    .uma-user-btn:hover { background: rgba(255,255,255,.22); }

    .uma-user-avatar {
      width: 26px; height: 26px; border-radius: 50%;
      background: var(--oxblood, #7A1C1C); color: #fff;
      display: inline-flex; align-items: center; justify-content: center;
      font-size: .75rem; font-weight: 700; flex-shrink: 0;
    }

    .uma-dropdown {
      position: absolute; top: calc(100% + 8px); right: 0; min-width: 180px;
      background: #fff; border: 1px solid #e8e0d4; border-radius: 6px;
      box-shadow: 0 8px 24px rgba(0,0,0,.13); z-index: 9999;
      overflow: hidden; animation: umaFadeIn .15s ease;
    }
    @keyframes umaFadeIn { from { opacity:0; transform:translateY(-4px); } to { opacity:1; transform:translateY(0); } }
    .uma-dropdown a {
      display: block; padding: 11px 18px; font-size: .8rem; font-weight: 500;
      color: #17140F; text-decoration: none; transition: background .15s;
      letter-spacing: .04em;
    }
    .uma-dropdown a:hover { background: #f7f2ea; }
    .uma-dropdown hr { border: none; border-top: 1px solid #e8e0d4; margin: 4px 0; }
    .uma-dropdown .uma-signout { color: #c0392b !important; }
    .uma-dropdown .uma-signout:hover { background: #fdf0f0 !important; }

    .uma-cart-wrap { position: relative; display: inline-flex; cursor: pointer; }
    .uma-cart-badge {
      position: absolute; top: -6px; right: -8px;
      background: var(--oxblood, #7A1C1C); color: #fff;
      border-radius: 50%; width: 18px; height: 18px;
      font-size: .65rem; font-weight: 700;
      display: none; align-items: center; justify-content: center;
    }
  `;
  document.head.appendChild(style);

  window.UMANav = {
    _cartId: null,
    _userId: null,

    init({ cartId, userId } = {}) {
      this._cartId = cartId || null;
      this._userId = userId || null;
      this.update();
      // Close dropdown on outside click
      document.addEventListener('click', (e) => {
        if (!e.target.closest('.uma-user-wrap')) {
          document.querySelectorAll('.uma-dropdown').forEach(d => d.style.display = 'none');
        }
      });
    },

    update() {
      if (this._cartId) this._renderCart(this._cartId);
      if (this._userId) this._renderUser(this._userId);
    },

    getCartCount() {
      const cart = JSON.parse(localStorage.getItem('UMA_CART') || '{}');
      return Object.values(cart).reduce((sum, item) => sum + (Number(item.quantity) || 1), 0);
    },

    getUser() {
      try { return JSON.parse(localStorage.getItem('UMA_USER') || 'null'); } catch { return null; }
    },

    logout() {
      localStorage.removeItem('UMA_TOKEN');
      localStorage.removeItem('UMA_USER');
      window.location.href = 'index.html';
    },

    toggleDropdown(wrapperId) {
      const dd = document.getElementById(wrapperId + '-dd');
      if (!dd) return;
      dd.style.display = dd.style.display === 'none' ? 'block' : 'none';
    },

    _renderCart(id) {
      const el = document.getElementById(id);
      if (!el) return;
      const count = this.getCartCount();
      // If it's already a badge span, just update it
      if (el.classList.contains('uma-cart-badge') || el.classList.contains('navbar-cart-count') || el.classList.contains('storefront-cart-count') || el.classList.contains('detail-cart-count')) {
        el.textContent = count;
        el.style.display = count > 0 ? 'grid' : 'none';
      }
    },

    _renderUser(id) {
      const el = document.getElementById(id);
      if (!el) return;
      const token = localStorage.getItem('UMA_TOKEN');
      const user = this.getUser();
      const redirect = encodeURIComponent(window.location.pathname + window.location.search);

      el.classList.add('uma-user-wrap');

      if (token && user) {
        const initial = (user.first_name || 'U')[0].toUpperCase();
        const name = user.first_name || 'Account';
        el.innerHTML = `
          <div class="uma-user-btn" onclick="UMANav.toggleDropdown('${id}')">
            <span class="uma-user-avatar">${initial}</span>
            <span>${name}</span>
            <svg width="10" height="10" viewBox="0 0 10 10" fill="currentColor"><path d="M5 7L0 2h10z"/></svg>
          </div>
          <div class="uma-dropdown" id="${id}-dd" style="display:none;">
            <a href="account.html">👤 My Account</a>
            <a href="schools-browse.html">🏫 Browse Schools</a>
            <a href="cart.html">🛒 My Cart</a>
            <hr/>
            <a class="uma-signout" onclick="UMANav.logout()">Sign Out</a>
          </div>
        `;
      } else {
        el.innerHTML = `<a class="uma-signin-btn" href="login.html?redirect=${redirect}">Sign In</a>`;
      }
    }
  };
})();
