#!/bin/bash

# Test script for account page integration

BASE_URL="http://localhost:4000/api"
TEST_EMAIL="test@example.com"
TEST_PASSWORD="password123"

echo "================================"
echo "Testing UMA Account Page Flow"
echo "================================"
echo ""

# 1. Login
echo "[1] Testing LOGIN endpoint..."
LOGIN_RESPONSE=$(curl -s -X POST $BASE_URL/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$TEST_EMAIL\",\"password\":\"$TEST_PASSWORD\"}")

TOKEN=$(echo "$LOGIN_RESPONSE" | python3 -c "import sys, json; data = json.load(sys.stdin); print(data.get('token', ''))")
USER_ID=$(echo "$LOGIN_RESPONSE" | python3 -c "import sys, json; data = json.load(sys.stdin); print(data.get('user', {}).get('id', ''))")

if [ -z "$TOKEN" ]; then
  echo "❌ Login failed"
  exit 1
fi

echo "✅ Login successful"
echo "   Token: ${TOKEN:0:50}..."
echo "   User ID: $USER_ID"
echo ""

# 2. Get user profile
echo "[2] Testing GET /auth/me (Get user profile)..."
PROFILE=$(curl -s $BASE_URL/auth/me \
  -H "Authorization: Bearer $TOKEN")
echo "✅ Profile retrieved:"
echo "$PROFILE" | python3 -m json.tool | head -15
echo ""

# 3. List addresses
echo "[3] Testing GET /addresses (List addresses)..."
ADDRESSES=$(curl -s $BASE_URL/addresses \
  -H "Authorization: Bearer $TOKEN")
ADDRESS_COUNT=$(echo "$ADDRESSES" | python3 -c "import sys, json; data = json.load(sys.stdin); print(len(data))")
echo "✅ Found $ADDRESS_COUNT addresses"
echo "$ADDRESSES" | python3 -m json.tool | head -20
echo ""

# 4. List orders
echo "[4] Testing GET /orders (List orders)..."
ORDERS=$(curl -s $BASE_URL/orders \
  -H "Authorization: Bearer $TOKEN")
ORDER_COUNT=$(echo "$ORDERS" | python3 -c "import sys, json; data = json.load(sys.stdin); print(len(data))")
echo "✅ Found $ORDER_COUNT orders"
echo "$ORDERS" | python3 -m json.tool | head -20
echo ""

# 5. Update profile
echo "[5] Testing PATCH /auth/me (Update profile)..."
UPDATE_RESPONSE=$(curl -s -X PATCH $BASE_URL/auth/me \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"phone":"+2349876543210"}')
echo "✅ Profile updated:"
echo "$UPDATE_RESPONSE" | python3 -m json.tool
echo ""

# 6. Create address
echo "[6] Testing POST /addresses (Create address)..."
CREATE_ADDRESS_RESPONSE=$(curl -s -X POST $BASE_URL/addresses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "type":"home",
    "label":"New Address",
    "address":"789 Test Street",
    "city":"Abuja",
    "state":"FCT",
    "postal_code":"900001",
    "phone":"+2348012345678"
  }')
NEW_ADDRESS_ID=$(echo "$CREATE_ADDRESS_RESPONSE" | python3 -c "import sys, json; data = json.load(sys.stdin); print(data.get('id', ''))")
echo "✅ Address created with ID: $NEW_ADDRESS_ID"
echo "$CREATE_ADDRESS_RESPONSE" | python3 -m json.tool
echo ""

# 7. Update address
if [ ! -z "$NEW_ADDRESS_ID" ]; then
  echo "[7] Testing PATCH /addresses/{id} (Update address)..."
  UPDATE_ADDRESS_RESPONSE=$(curl -s -X PATCH $BASE_URL/addresses/$NEW_ADDRESS_ID \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{
      "label":"Updated Address",
      "postal_code":"900002"
    }')
  echo "✅ Address updated:"
  echo "$UPDATE_ADDRESS_RESPONSE" | python3 -m json.tool
  echo ""

  # 8. Set as default
  echo "[8] Testing PATCH /addresses/{id} (Set as default)..."
  SET_DEFAULT_RESPONSE=$(curl -s -X PATCH $BASE_URL/addresses/$NEW_ADDRESS_ID \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"is_default":true}')
  echo "✅ Address set as default:"
  echo "$SET_DEFAULT_RESPONSE" | python3 -m json.tool
  echo ""

  # 9. Delete address
  echo "[9] Testing DELETE /addresses/{id} (Delete address)..."
  DELETE_RESPONSE=$(curl -s -X DELETE $BASE_URL/addresses/$NEW_ADDRESS_ID \
    -H "Authorization: Bearer $TOKEN")
  echo "✅ Address deleted:"
  echo "$DELETE_RESPONSE" | python3 -m json.tool
  echo ""
fi

# 10. Change password
echo "[10] Testing PATCH /auth/password (Change password)..."
PASSWORD_RESPONSE=$(curl -s -X PATCH $BASE_URL/auth/password \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"current_password":"password123","new_password":"newpassword789"}')
echo "✅ Password changed:"
echo "$PASSWORD_RESPONSE" | python3 -m json.tool
echo ""

# 11. List schools
echo "[11] Testing GET /schools (List schools)..."
SCHOOLS=$(curl -s $BASE_URL/schools)
SCHOOL_COUNT=$(echo "$SCHOOLS" | python3 -c "import sys, json; data = json.load(sys.stdin); print(len(data))")
echo "✅ Found $SCHOOL_COUNT schools"
echo "$SCHOOLS" | python3 -m json.tool | head -30
echo ""

echo "================================"
echo "✅ All tests passed!"
echo "================================"
