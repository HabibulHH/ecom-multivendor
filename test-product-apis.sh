#!/bin/bash

# ============================================================
# Product Module API Test Script
# Base URL: http://localhost:3000
# ============================================================

BASE_URL="http://localhost:3000"

echo "============================================"
echo "  Product Module API Tests"
echo "============================================"
echo ""

# ─── SETUP: Create Vendor User ───
echo ">>> [SETUP] Creating vendor user..."
VENDOR_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/users" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "testvendor@product-test.com",
    "password": "password123",
    "firstName": "Test",
    "lastName": "Vendor",
    "role": "VENDOR"
  }')
VENDOR_HTTP_CODE=$(echo "$VENDOR_RESPONSE" | tail -1)
VENDOR_BODY=$(echo "$VENDOR_RESPONSE" | sed '$d')
VENDOR_ID=$(echo "$VENDOR_BODY" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
echo "Status: $VENDOR_HTTP_CODE"
echo "Vendor ID: $VENDOR_ID"
echo ""

# ─── SETUP: Create Store for Vendor ───
echo ">>> [SETUP] Creating store for vendor..."
STORE_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/stores" \
  -H "Content-Type: application/json" \
  -d "{
    \"userId\": \"$VENDOR_ID\",
    \"name\": \"Test Product Store\",
    \"description\": \"A store for testing product APIs\",
    \"contactEmail\": \"store@product-test.com\"
  }")
STORE_HTTP_CODE=$(echo "$STORE_RESPONSE" | tail -1)
STORE_BODY=$(echo "$STORE_RESPONSE" | sed '$d')
STORE_ID=$(echo "$STORE_BODY" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
STORE_SLUG=$(echo "$STORE_BODY" | grep -o '"slug":"[^"]*"' | head -1 | cut -d'"' -f4)
echo "Status: $STORE_HTTP_CODE"
echo "Store ID: $STORE_ID"
echo "Store Slug: $STORE_SLUG"
echo ""

# ─── SETUP: Approve Store (Admin) ───
echo ">>> [SETUP] Approving store (admin)..."
APPROVE_RESPONSE=$(curl -s -w "\n%{http_code}" -X PATCH "$BASE_URL/admin/stores/$STORE_ID/approve")
APPROVE_HTTP_CODE=$(echo "$APPROVE_RESPONSE" | tail -1)
echo "Status: $APPROVE_HTTP_CODE"
echo ""

echo "============================================"
echo "  CATEGORY APIs (Admin)"
echo "============================================"
echo ""

# ─── 1. Create Category ───
echo ">>> 1. POST /admin/categories - Create category"
CAT1_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/admin/categories" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Electronics",
    "description": "Electronic gadgets and devices"
  }')
CAT1_HTTP_CODE=$(echo "$CAT1_RESPONSE" | tail -1)
CAT1_BODY=$(echo "$CAT1_RESPONSE" | sed '$d')
CATEGORY_ID=$(echo "$CAT1_BODY" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
CATEGORY_SLUG=$(echo "$CAT1_BODY" | grep -o '"slug":"[^"]*"' | head -1 | cut -d'"' -f4)
echo "Status: $CAT1_HTTP_CODE"
echo "Category ID: $CATEGORY_ID"
echo "Response: $CAT1_BODY"
echo ""

# ─── 2. Create Second Category ───
echo ">>> 2. POST /admin/categories - Create second category"
CAT2_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/admin/categories" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Clothing",
    "description": "Apparel and accessories"
  }')
CAT2_HTTP_CODE=$(echo "$CAT2_RESPONSE" | tail -1)
CAT2_BODY=$(echo "$CAT2_RESPONSE" | sed '$d')
CATEGORY2_ID=$(echo "$CAT2_BODY" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
echo "Status: $CAT2_HTTP_CODE"
echo "Category 2 ID: $CATEGORY2_ID"
echo ""

# ─── 3. List Categories (Public) ───
echo ">>> 3. GET /categories - List active categories (public)"
curl -s -w "\nStatus: %{http_code}\n" "$BASE_URL/categories"
echo ""

# ─── 4. Update Category (Admin) ───
echo ">>> 4. PATCH /admin/categories/:id - Update category"
curl -s -w "\nStatus: %{http_code}\n" -X PATCH "$BASE_URL/admin/categories/$CATEGORY_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Electronics & Gadgets",
    "description": "Updated description"
  }'
echo ""

echo "============================================"
echo "  STORE OWNER Product APIs"
echo "============================================"
echo ""

# ─── 5. Create Product ───
echo ">>> 5. POST /stores/my-store/products - Create product"
PRODUCT_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/stores/my-store/products" \
  -H "Content-Type: application/json" \
  -d "{
    \"userId\": \"$VENDOR_ID\",
    \"name\": \"Wireless Headphones\",
    \"description\": \"Premium noise-cancelling wireless headphones\",
    \"price\": 99.99,
    \"compareAtPrice\": 149.99,
    \"sku\": \"WH-001\",
    \"quantity\": 50,
    \"categoryIds\": [\"$CATEGORY_ID\"]
  }")
PRODUCT_HTTP_CODE=$(echo "$PRODUCT_RESPONSE" | tail -1)
PRODUCT_BODY=$(echo "$PRODUCT_RESPONSE" | sed '$d')
PRODUCT_ID=$(echo "$PRODUCT_BODY" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
echo "Status: $PRODUCT_HTTP_CODE"
echo "Product ID: $PRODUCT_ID"
echo "Response: $PRODUCT_BODY"
echo ""

# ─── 6. Create Second Product ───
echo ">>> 6. POST /stores/my-store/products - Create second product"
PRODUCT2_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/stores/my-store/products" \
  -H "Content-Type: application/json" \
  -d "{
    \"userId\": \"$VENDOR_ID\",
    \"name\": \"USB-C Cable\",
    \"description\": \"Fast charging USB-C cable 2m\",
    \"price\": 12.50,
    \"sku\": \"USB-C-002\",
    \"quantity\": 200,
    \"categoryIds\": [\"$CATEGORY_ID\", \"$CATEGORY2_ID\"]
  }")
PRODUCT2_HTTP_CODE=$(echo "$PRODUCT2_RESPONSE" | tail -1)
PRODUCT2_BODY=$(echo "$PRODUCT2_RESPONSE" | sed '$d')
PRODUCT2_ID=$(echo "$PRODUCT2_BODY" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
echo "Status: $PRODUCT2_HTTP_CODE"
echo "Product 2 ID: $PRODUCT2_ID"
echo ""

# ─── 7. List Own Products ───
echo ">>> 7. GET /stores/my-store/products - List own products"
curl -s -w "\nStatus: %{http_code}\n" "$BASE_URL/stores/my-store/products" \
  -H "Content-Type: application/json" \
  -d "{\"userId\": \"$VENDOR_ID\"}"
echo ""

# ─── 8. Get Single Product ───
echo ">>> 8. GET /stores/my-store/products/:id - Get product by ID"
curl -s -w "\nStatus: %{http_code}\n" "$BASE_URL/stores/my-store/products/$PRODUCT_ID"
echo ""

# ─── 9. Update Product ───
echo ">>> 9. PATCH /stores/my-store/products/:id - Update product"
curl -s -w "\nStatus: %{http_code}\n" -X PATCH "$BASE_URL/stores/my-store/products/$PRODUCT_ID" \
  -H "Content-Type: application/json" \
  -d "{
    \"userId\": \"$VENDOR_ID\",
    \"name\": \"Wireless Headphones Pro\",
    \"price\": 119.99,
    \"isFeatured\": true
  }"
echo ""

# ─── 10. Add Image to Product ───
echo ">>> 10. POST /stores/my-store/products/:id/images - Add image 1"
IMG_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/stores/my-store/products/$PRODUCT_ID/images" \
  -H "Content-Type: application/json" \
  -d "{
    \"userId\": \"$VENDOR_ID\",
    \"url\": \"https://example.com/images/headphones-front.jpg\",
    \"altText\": \"Headphones front view\",
    \"isPrimary\": true
  }")
IMG_HTTP_CODE=$(echo "$IMG_RESPONSE" | tail -1)
IMG_BODY=$(echo "$IMG_RESPONSE" | sed '$d')
IMAGE_ID=$(echo "$IMG_BODY" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
echo "Status: $IMG_HTTP_CODE"
echo "Response: $IMG_BODY"
echo ""

# ─── 11. Add Second Image ───
echo ">>> 11. POST /stores/my-store/products/:id/images - Add image 2"
IMG2_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/stores/my-store/products/$PRODUCT_ID/images" \
  -H "Content-Type: application/json" \
  -d "{
    \"userId\": \"$VENDOR_ID\",
    \"url\": \"https://example.com/images/headphones-side.jpg\",
    \"altText\": \"Headphones side view\"
  }")
IMG2_HTTP_CODE=$(echo "$IMG2_RESPONSE" | tail -1)
IMG2_BODY=$(echo "$IMG2_RESPONSE" | sed '$d')
IMAGE2_ID=$(echo "$IMG2_BODY" | grep -o '"images":\[{[^}]*"id":"[^"]*"' | grep -o '"id":"[^"]*"' | tail -1 | cut -d'"' -f4)
echo "Status: $IMG2_HTTP_CODE"
echo ""

# ─── 12. Publish Product (should succeed - has name, price, image) ───
echo ">>> 12. PATCH /stores/my-store/products/:id/publish - Publish product"
curl -s -w "\nStatus: %{http_code}\n" -X PATCH "$BASE_URL/stores/my-store/products/$PRODUCT_ID/publish" \
  -H "Content-Type: application/json" \
  -d "{\"userId\": \"$VENDOR_ID\"}"
echo ""

# ─── 13. Publish Product 2 (should FAIL - no images) ───
echo ">>> 13. PATCH /stores/my-store/products/:id/publish - Publish product without image (expect 400)"
curl -s -w "\nStatus: %{http_code}\n" -X PATCH "$BASE_URL/stores/my-store/products/$PRODUCT2_ID/publish" \
  -H "Content-Type: application/json" \
  -d "{\"userId\": \"$VENDOR_ID\"}"
echo ""

# ─── 14. Unpublish Product ───
echo ">>> 14. PATCH /stores/my-store/products/:id/unpublish - Unpublish product"
curl -s -w "\nStatus: %{http_code}\n" -X PATCH "$BASE_URL/stores/my-store/products/$PRODUCT_ID/unpublish" \
  -H "Content-Type: application/json" \
  -d "{\"userId\": \"$VENDOR_ID\"}"
echo ""

# ─── 15. Re-publish for public endpoint testing ───
echo ">>> 15. Re-publishing product for public tests..."
curl -s -w "\nStatus: %{http_code}\n" -X PATCH "$BASE_URL/stores/my-store/products/$PRODUCT_ID/publish" \
  -H "Content-Type: application/json" \
  -d "{\"userId\": \"$VENDOR_ID\"}"
echo ""

# ─── 16. Remove Image ───
echo ">>> 16. DELETE /stores/my-store/products/:id/images/:imageId - Remove image"
curl -s -w "\nStatus: %{http_code}\n" -X DELETE "$BASE_URL/stores/my-store/products/$PRODUCT_ID/images/$IMAGE2_ID" \
  -H "Content-Type: application/json" \
  -d "{\"userId\": \"$VENDOR_ID\"}"
echo ""

echo "============================================"
echo "  PUBLIC Product APIs"
echo "============================================"
echo ""

# ─── 17. List Published Products ───
echo ">>> 17. GET /products - List published products"
curl -s -w "\nStatus: %{http_code}\n" "$BASE_URL/products"
echo ""

# ─── 18. Search Products ───
echo ">>> 18. GET /products/search?q=headphones - Search products"
curl -s -w "\nStatus: %{http_code}\n" "$BASE_URL/products/search?q=headphones"
echo ""

# ─── 19. Search with Price Filter ───
echo ">>> 19. GET /products/search - Search with price filter"
curl -s -w "\nStatus: %{http_code}\n" "$BASE_URL/products/search?minPrice=50&maxPrice=200&sortBy=price_asc"
echo ""

# ─── 20. Search with Category Filter ───
echo ">>> 20. GET /products/search - Search with category filter"
curl -s -w "\nStatus: %{http_code}\n" "$BASE_URL/products/search?categoryId=$CATEGORY_ID"
echo ""

# ─── 21. Store Public Products ───
echo ">>> 21. GET /stores/:storeSlug/products - Store's published products"
curl -s -w "\nStatus: %{http_code}\n" "$BASE_URL/stores/$STORE_SLUG/products"
echo ""

# ─── 22. Category Products ───
echo ">>> 22. GET /categories/:slug/products - Products in category"
curl -s -w "\nStatus: %{http_code}\n" "$BASE_URL/categories/$CATEGORY_SLUG/products"
echo ""

# ─── 23. Pagination ───
echo ">>> 23. GET /products?page=1&limit=1 - Pagination test"
curl -s -w "\nStatus: %{http_code}\n" "$BASE_URL/products?page=1&limit=1"
echo ""

echo "============================================"
echo "  ADMIN Product APIs"
echo "============================================"
echo ""

# ─── 24. Admin List All Products ───
echo ">>> 24. GET /admin/products - Admin list all products"
curl -s -w "\nStatus: %{http_code}\n" "$BASE_URL/admin/products"
echo ""

# ─── 25. Admin Get Product ───
echo ">>> 25. GET /admin/products/:id - Admin get product"
curl -s -w "\nStatus: %{http_code}\n" "$BASE_URL/admin/products/$PRODUCT_ID"
echo ""

# ─── 26. Admin Hide Product ───
echo ">>> 26. PATCH /admin/products/:id/hide - Admin hide product"
curl -s -w "\nStatus: %{http_code}\n" -X PATCH "$BASE_URL/admin/products/$PRODUCT_ID/hide"
echo ""

# ─── 27. Admin Unhide Product ───
echo ">>> 27. PATCH /admin/products/:id/unhide - Admin unhide product"
curl -s -w "\nStatus: %{http_code}\n" -X PATCH "$BASE_URL/admin/products/$PRODUCT_ID/unhide"
echo ""

echo "============================================"
echo "  SOFT DELETE & EDGE CASES"
echo "============================================"
echo ""

# ─── 28. Soft Delete Product ───
echo ">>> 28. DELETE /stores/my-store/products/:id - Soft delete product 2"
curl -s -w "\nStatus: %{http_code}\n" -X DELETE "$BASE_URL/stores/my-store/products/$PRODUCT2_ID" \
  -H "Content-Type: application/json" \
  -d "{\"userId\": \"$VENDOR_ID\"}"
echo ""

# ─── 29. Try to get deleted product (should 404) ───
echo ">>> 29. GET /stores/my-store/products/:id - Get soft-deleted product (expect 404)"
curl -s -w "\nStatus: %{http_code}\n" "$BASE_URL/stores/my-store/products/$PRODUCT2_ID"
echo ""

# ─── 30. Delete Category (Admin) ───
echo ">>> 30. DELETE /admin/categories/:id - Delete category"
curl -s -w "\nStatus: %{http_code}\n" -X DELETE "$BASE_URL/admin/categories/$CATEGORY2_ID"
echo ""

echo "============================================"
echo "  DONE - All tests completed!"
echo "============================================"
echo ""
echo "IDs used in this test run:"
echo "  Vendor ID:    $VENDOR_ID"
echo "  Store ID:     $STORE_ID"
echo "  Store Slug:   $STORE_SLUG"
echo "  Product ID:   $PRODUCT_ID"
echo "  Product 2 ID: $PRODUCT2_ID"
echo "  Category ID:  $CATEGORY_ID"
echo "  Category Slug: $CATEGORY_SLUG"
echo "  Image ID:     $IMAGE_ID"
