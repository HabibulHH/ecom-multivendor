# Product Module - Product Requirements Document (PRD)

## Overview

The Product module enables **store owners** to create, manage, and sell products within their store. Products belong to a store and are only visible when the store is active.

---

## Functional Requirements

### FR-1: Product Creation
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-1.1 | System shall allow store owners to create products within their store | High |
| FR-1.2 | System shall validate product count against subscription tier limits | High |
| FR-1.3 | System shall auto-generate URL slug from product name if not provided | Medium |
| FR-1.4 | System shall validate product slug uniqueness within the store | High |
| FR-1.5 | System shall set initial product status to `DRAFT` | Medium |
| FR-1.6 | System shall support multiple product images (up to 10) | High |

### FR-2: Product Management
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-2.1 | Store owner shall be able to update product details | High |
| FR-2.2 | Store owner shall be able to upload/reorder product images | High |
| FR-2.3 | Store owner shall be able to set product pricing and compare-at price | High |
| FR-2.4 | Store owner shall be able to manage product inventory/stock | High |
| FR-2.5 | Store owner shall be able to publish/unpublish products | High |
| FR-2.6 | Store owner shall be able to delete products (soft delete) | Medium |
| FR-2.7 | Store owner shall be able to duplicate products | Low |

### FR-3: Product Variants
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-3.1 | System shall support product variants (size, color, etc.) | High |
| FR-3.2 | Each variant shall have its own SKU, price, and inventory | High |
| FR-3.3 | System shall support up to 3 variant options per product | Medium |
| FR-3.4 | System shall auto-generate variant combinations | Medium |
| FR-3.5 | Store owner shall be able to set variant-specific images | Low |

### FR-4: Product Categories & Tags
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-4.1 | Store owner shall be able to assign products to categories | High |
| FR-4.2 | System shall support hierarchical categories (up to 3 levels) | Medium |
| FR-4.3 | Store owner shall be able to add tags to products | Medium |
| FR-4.4 | System shall support platform-wide and store-specific categories | Medium |

### FR-5: Inventory Management
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-5.1 | System shall track product/variant stock quantity | High |
| FR-5.2 | System shall automatically reduce stock on order placement | High |
| FR-5.3 | System shall restore stock on order cancellation | High |
| FR-5.4 | System shall send low stock alerts based on threshold | Medium |
| FR-5.5 | System shall support "track inventory" toggle per product | Medium |
| FR-5.6 | System shall support "allow backorders" option | Low |

### FR-6: Public Product Access
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-6.1 | Public users shall be able to view published products from active stores | High |
| FR-6.2 | Public users shall be able to search products by name/description | High |
| FR-6.3 | Public users shall be able to filter products by category, price, etc. | High |
| FR-6.4 | Public users shall be able to sort products (price, date, popularity) | Medium |
| FR-6.5 | System shall support pagination for product listings | High |

### FR-7: Admin Product Management
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-7.1 | Admin shall be able to view all products across stores | High |
| FR-7.2 | Admin shall be able to flag/unflag products | Medium |
| FR-7.3 | Admin shall be able to hide products violating policies | High |
| FR-7.4 | Admin shall be able to manage platform-wide categories | High |

---

## Non-Functional Requirements

### NFR-1: Performance
| ID | Requirement | Target |
|----|-------------|--------|
| NFR-1.1 | Product listing API response time | < 200ms (p95) |
| NFR-1.2 | Product detail API response time | < 100ms (p95) |
| NFR-1.3 | Product search response time | < 300ms (p95) |
| NFR-1.4 | Image upload processing time | < 3s per image |
| NFR-1.5 | Concurrent product listings supported | 2000 requests/sec |

### NFR-2: Scalability
| ID | Requirement | Target |
|----|-------------|--------|
| NFR-2.1 | Maximum products per store | Based on subscription tier |
| NFR-2.2 | Maximum total products supported | 10,000,000+ |
| NFR-2.3 | Maximum variants per product | 100 |
| NFR-2.4 | Maximum images per product | 10 |
| NFR-2.5 | Image storage | Cloud-based, CDN-backed |

### NFR-3: Availability
| ID | Requirement | Target |
|----|-------------|--------|
| NFR-3.1 | Product module uptime | 99.9% |
| NFR-3.2 | Search service uptime | 99.5% |
| NFR-3.3 | Recovery Time Objective (RTO) | < 1 hour |
| NFR-3.4 | Recovery Point Objective (RPO) | < 5 minutes |

### NFR-4: Security
| ID | Requirement | Description |
|----|-------------|-------------|
| NFR-4.1 | Authentication | JWT-based authentication for store owner endpoints |
| NFR-4.2 | Authorization | Store owners can only manage their own products |
| NFR-4.3 | Data validation | Input sanitization to prevent XSS/SQL injection |
| NFR-4.4 | Image validation | File type verification, size limits, malware scanning |
| NFR-4.5 | Rate limiting | 200 requests/minute per user for write operations |

### NFR-5: Reliability
| ID | Requirement | Description |
|----|-------------|-------------|
| NFR-5.1 | Data consistency | ACID transactions for inventory updates |
| NFR-5.2 | Inventory accuracy | Real-time stock synchronization |
| NFR-5.3 | Error handling | Graceful degradation with meaningful error messages |
| NFR-5.4 | Search indexing | Near real-time index updates (< 30s delay) |

### NFR-6: Maintainability
| ID | Requirement | Description |
|----|-------------|-------------|
| NFR-6.1 | Code coverage | Minimum 80% unit test coverage |
| NFR-6.2 | Documentation | API documentation via OpenAPI/Swagger |
| NFR-6.3 | Logging | Structured logging for debugging and monitoring |

### NFR-7: Usability
| ID | Requirement | Description |
|----|-------------|-------------|
| NFR-7.1 | API consistency | RESTful conventions, consistent error format |
| NFR-7.2 | Bulk operations | Support bulk update/delete for products |
| NFR-7.3 | Pagination | Cursor-based pagination for large result sets |

---

## Business Context

### Flow
```
Store Created → Add Categories → Create Products → Publish → Customers Browse/Purchase
```

### Key Business Rules
1. Products belong to a **Store** (not directly to vendor)
2. Products are only visible when store is **ACTIVE**
3. Product count is limited by **subscription tier**
4. Products are **soft-deleted** (can be restored)
5. Inventory is tracked at **variant level** (or product level if no variants)
6. Product slug must be unique **within the store**

---

## User Stories

### US-1: Product Creation
**As a** store owner
**I want to** create a new product with details and images
**So that** I can list items for sale

**Acceptance Criteria:**
- Can enter product name, description, price
- Can upload multiple images
- Can set inventory quantity
- Product is created in DRAFT status
- Cannot exceed subscription tier product limit

### US-2: Product Variants
**As a** store owner
**I want to** create product variants (size, color)
**So that** customers can choose their preferred option

**Acceptance Criteria:**
- Can define variant options (e.g., Size: S, M, L)
- Can set different prices per variant
- Can set different inventory per variant
- Can assign specific images to variants

### US-3: Product Publishing
**As a** store owner
**I want to** publish my product when ready
**So that** customers can see and purchase it

**Acceptance Criteria:**
- Can publish products with required fields filled
- Can unpublish products anytime
- Published products appear in store and search

### US-4: Product Search
**As a** customer
**I want to** search and filter products
**So that** I can find what I'm looking for

**Acceptance Criteria:**
- Can search by product name and description
- Can filter by category, price range, store
- Can sort by price, date, relevance
- Results are paginated

### US-5: Inventory Alerts
**As a** store owner
**I want to** receive alerts when stock is low
**So that** I can restock before running out

**Acceptance Criteria:**
- Can set low stock threshold per product
- Receive email notification when stock reaches threshold
- Dashboard shows low stock products

---

## Data Model

### Product Entity

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `id` | UUID | Primary key | Auto-generated |
| `storeId` | UUID | Parent store | FK to stores, required |
| `name` | string | Product name | Required, max 200 chars |
| `slug` | string | URL-friendly identifier | Unique per store |
| `description` | text | Full description | Optional, max 5000 chars |
| `shortDescription` | string | Brief summary | Optional, max 500 chars |
| `price` | decimal | Base price | Required, >= 0 |
| `compareAtPrice` | decimal | Original/compare price | Optional, >= price |
| `costPrice` | decimal | Cost for profit calculation | Optional |
| `sku` | string | Stock keeping unit | Optional, unique per store |
| `barcode` | string | UPC/EAN/ISBN | Optional |
| `status` | enum | Product status | See status enum |
| `trackInventory` | boolean | Track stock quantity | Default: true |
| `allowBackorders` | boolean | Allow orders when out of stock | Default: false |
| `quantity` | integer | Stock quantity | Default: 0 |
| `lowStockThreshold` | integer | Alert threshold | Default: 10 |
| `weight` | decimal | Product weight (kg) | Optional |
| `dimensions` | jsonb | Length, width, height | Optional |
| `hasVariants` | boolean | Has variant options | Default: false |
| `isFeatured` | boolean | Featured product | Default: false |
| `isDigital` | boolean | Digital product | Default: false |
| `metaTitle` | string | SEO title | Optional, max 70 chars |
| `metaDescription` | string | SEO description | Optional, max 160 chars |
| `publishedAt` | timestamp | When published | Null if draft |
| `createdAt` | timestamp | Created timestamp | Auto |
| `updatedAt` | timestamp | Updated timestamp | Auto |
| `deletedAt` | timestamp | Soft delete timestamp | Null unless deleted |

### Product Status Enum

```typescript
enum ProductStatus {
  DRAFT = 'DRAFT',           // Not yet published
  PUBLISHED = 'PUBLISHED',   // Live and visible
  ARCHIVED = 'ARCHIVED',     // Hidden but not deleted
  HIDDEN = 'HIDDEN'          // Admin hidden for policy violation
}
```

### ProductImage Entity

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `id` | UUID | Primary key | Auto-generated |
| `productId` | UUID | Parent product | FK to products |
| `url` | string | Image URL | Required |
| `altText` | string | Alt text for accessibility | Optional |
| `position` | integer | Sort order | Default: 0 |
| `isPrimary` | boolean | Primary/thumbnail image | Default: false |
| `createdAt` | timestamp | Created timestamp | Auto |

### ProductVariant Entity

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `id` | UUID | Primary key | Auto-generated |
| `productId` | UUID | Parent product | FK to products |
| `name` | string | Variant name (e.g., "Red / Large") | Auto-generated |
| `sku` | string | Variant SKU | Optional, unique per store |
| `barcode` | string | Variant barcode | Optional |
| `price` | decimal | Variant price | Required |
| `compareAtPrice` | decimal | Compare price | Optional |
| `costPrice` | decimal | Cost price | Optional |
| `quantity` | integer | Stock quantity | Default: 0 |
| `weight` | decimal | Variant weight | Optional |
| `option1` | string | First option value | e.g., "Red" |
| `option2` | string | Second option value | e.g., "Large" |
| `option3` | string | Third option value | Optional |
| `imageId` | UUID | Variant-specific image | FK to product_images |
| `position` | integer | Sort order | Default: 0 |
| `createdAt` | timestamp | Created timestamp | Auto |
| `updatedAt` | timestamp | Updated timestamp | Auto |

### ProductOption Entity

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `id` | UUID | Primary key | Auto-generated |
| `productId` | UUID | Parent product | FK to products |
| `name` | string | Option name | e.g., "Color", "Size" |
| `values` | jsonb | Option values | e.g., ["Red", "Blue", "Green"] |
| `position` | integer | Sort order | Default: 0 |

### Category Entity

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `id` | UUID | Primary key | Auto-generated |
| `parentId` | UUID | Parent category | FK to categories, nullable |
| `storeId` | UUID | Store-specific category | FK to stores, nullable |
| `name` | string | Category name | Required |
| `slug` | string | URL-friendly identifier | Unique |
| `description` | text | Category description | Optional |
| `image` | string | Category image URL | Optional |
| `position` | integer | Sort order | Default: 0 |
| `isActive` | boolean | Active status | Default: true |
| `createdAt` | timestamp | Created timestamp | Auto |
| `updatedAt` | timestamp | Updated timestamp | Auto |

### ProductCategory (Junction Table)

| Field | Type | Description |
|-------|------|-------------|
| `productId` | UUID | FK to products |
| `categoryId` | UUID | FK to categories |

### ProductTag Entity

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `id` | UUID | Primary key | Auto-generated |
| `storeId` | UUID | Parent store | FK to stores |
| `name` | string | Tag name | Required, unique per store |
| `slug` | string | URL-friendly identifier | Unique per store |

### ProductTagAssignment (Junction Table)

| Field | Type | Description |
|-------|------|-------------|
| `productId` | UUID | FK to products |
| `tagId` | UUID | FK to product_tags |

---

## API Endpoints

### Store Owner Endpoints (requires VENDOR role + store ownership)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/stores/my-store/products` | Create new product |
| `GET` | `/stores/my-store/products` | List own products |
| `GET` | `/stores/my-store/products/:id` | Get product details |
| `PATCH` | `/stores/my-store/products/:id` | Update product |
| `DELETE` | `/stores/my-store/products/:id` | Soft delete product |
| `POST` | `/stores/my-store/products/:id/duplicate` | Duplicate product |
| `PATCH` | `/stores/my-store/products/:id/publish` | Publish product |
| `PATCH` | `/stores/my-store/products/:id/unpublish` | Unpublish product |
| `POST` | `/stores/my-store/products/:id/images` | Upload images |
| `DELETE` | `/stores/my-store/products/:id/images/:imageId` | Delete image |
| `PATCH` | `/stores/my-store/products/:id/images/reorder` | Reorder images |
| `POST` | `/stores/my-store/products/:id/variants` | Create variant |
| `PATCH` | `/stores/my-store/products/:id/variants/:variantId` | Update variant |
| `DELETE` | `/stores/my-store/products/:id/variants/:variantId` | Delete variant |
| `PATCH` | `/stores/my-store/products/:id/inventory` | Update inventory |
| `POST` | `/stores/my-store/products/bulk-update` | Bulk update products |
| `POST` | `/stores/my-store/products/bulk-delete` | Bulk delete products |

### Public Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/products` | List all published products (paginated) |
| `GET` | `/products/search` | Search products |
| `GET` | `/products/:slug` | Get product by slug |
| `GET` | `/stores/:storeSlug/products` | Get store's products |
| `GET` | `/categories` | List all categories |
| `GET` | `/categories/:slug/products` | Get products in category |

### Admin Endpoints (requires SYSTEM_ADMIN role)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/admin/products` | List all products (any status) |
| `GET` | `/admin/products/:id` | Get product details |
| `PATCH` | `/admin/products/:id/hide` | Hide product (policy violation) |
| `PATCH` | `/admin/products/:id/unhide` | Unhide product |
| `GET` | `/admin/categories` | List all categories |
| `POST` | `/admin/categories` | Create platform category |
| `PATCH` | `/admin/categories/:id` | Update category |
| `DELETE` | `/admin/categories/:id` | Delete category |

---

## DTOs

### CreateProductDto

```typescript
{
  name: string;              // Required, 3-200 chars
  slug?: string;             // Optional (auto-generated from name)
  description?: string;      // Optional, max 5000 chars
  shortDescription?: string; // Optional, max 500 chars
  price: number;             // Required, >= 0
  compareAtPrice?: number;   // Optional, >= price
  costPrice?: number;        // Optional
  sku?: string;              // Optional
  barcode?: string;          // Optional
  trackInventory?: boolean;  // Default: true
  allowBackorders?: boolean; // Default: false
  quantity?: number;         // Default: 0
  lowStockThreshold?: number;// Default: 10
  weight?: number;           // Optional (kg)
  dimensions?: {
    length: number;
    width: number;
    height: number;
    unit: 'cm' | 'in';
  };
  isDigital?: boolean;       // Default: false
  categoryIds?: string[];    // Optional
  tags?: string[];           // Optional
  metaTitle?: string;        // Optional
  metaDescription?: string;  // Optional
}
```

### UpdateProductDto

```typescript
{
  name?: string;
  description?: string;
  shortDescription?: string;
  price?: number;
  compareAtPrice?: number;
  costPrice?: number;
  sku?: string;
  barcode?: string;
  trackInventory?: boolean;
  allowBackorders?: boolean;
  quantity?: number;
  lowStockThreshold?: number;
  weight?: number;
  dimensions?: ProductDimensions;
  isFeatured?: boolean;
  categoryIds?: string[];
  tags?: string[];
  metaTitle?: string;
  metaDescription?: string;
}
```

### CreateVariantDto

```typescript
{
  sku?: string;
  barcode?: string;
  price: number;
  compareAtPrice?: number;
  costPrice?: number;
  quantity?: number;
  weight?: number;
  option1: string;           // Required
  option2?: string;
  option3?: string;
  imageId?: string;
}
```

### ProductSearchQueryDto

```typescript
{
  q?: string;                // Search query
  categoryId?: string;       // Filter by category
  storeId?: string;          // Filter by store
  minPrice?: number;         // Minimum price
  maxPrice?: number;         // Maximum price
  inStock?: boolean;         // Only in-stock products
  sortBy?: 'price_asc' | 'price_desc' | 'created_at' | 'name' | 'popularity';
  page?: number;             // Page number
  limit?: number;            // Items per page (max 50)
}
```

### BulkUpdateProductsDto

```typescript
{
  productIds: string[];      // Product IDs to update
  updates: {
    status?: ProductStatus;
    categoryIds?: string[];
    tags?: string[];
    isFeatured?: boolean;
  };
}
```

---

## Business Logic

### Product Creation Flow

```
1. Validate user owns the store
2. Check store is ACTIVE
3. Check product count against subscription tier limit
4. Generate slug from name (if not provided)
5. Validate slug is unique within store
6. Create product with status = DRAFT
7. Process and upload images (if provided)
8. Return created product
```

### Product Publishing Flow

```
1. Validate required fields are filled:
   - Name
   - Price
   - At least one image
2. Validate store is ACTIVE
3. Set status = PUBLISHED
4. Set publishedAt = now
5. Index product for search
6. Return updated product
```

### Inventory Update Flow

```
On Order Placed:
1. Lock product/variant row
2. Check available quantity
3. If insufficient and !allowBackorders, reject order
4. Reduce quantity
5. Release lock
6. If quantity <= lowStockThreshold, queue alert

On Order Cancelled:
1. Restore quantity
2. Log inventory change
```

### Store Deactivation Impact

```
When store becomes INACTIVE:
1. All published products become hidden from public listings
2. Products remain in PUBLISHED status (not changed to DRAFT)
3. Search index excludes these products

When store becomes ACTIVE again:
1. Published products become visible again
2. Search index includes these products
```

---

## Product Slug

A **slug** is a URL-friendly identifier derived from the product name. It creates clean, readable URLs.

### What Makes a Slug

| Original Text | Slug |
|---------------|------|
| iPhone 15 Pro Max | `iphone-15-pro-max` |
| Men's Running Shoes (Black) | `mens-running-shoes-black` |
| 50% Off Sale Items! | `50-off-sale-items` |

**Transformation rules:**
- Convert to lowercase
- Remove special characters (`'`, `&`, `@`, `!`, etc.)
- Replace spaces with hyphens
- Remove accents/diacritics
- Trim leading/trailing hyphens
- Collapse multiple hyphens into one

### Slug Uniqueness

Product slugs must be unique **within the store**, not globally. This allows:
```
store-a.com/products/blue-shirt  ✅
store-b.com/products/blue-shirt  ✅ (different store)
store-a.com/products/blue-shirt  ❌ (duplicate in same store)
```

### URL Structure

```
GET /stores/:storeSlug/products/:productSlug
GET /stores/johns-electronics/products/wireless-headphones
```

---

## Validation Rules

### Product Name
- Required
- 3-200 characters
- Cannot be only special characters

### Product Price
- Required
- Must be >= 0
- Decimal with up to 2 decimal places
- Compare-at price must be >= price (if provided)

### Product SKU
- Optional
- Max 100 characters
- Must be unique within the store
- Alphanumeric, hyphens, underscores only

### Product Images
- Max 10 images per product
- Accepted formats: JPG, PNG, WebP
- Max file size: 5MB per image
- Recommended dimensions: 1000x1000px minimum

### Product Slug
- Auto-generated from name if not provided
- Lowercase letters, numbers, hyphens only
- 3-100 characters
- Must be unique within the store

---

## Feature Flags by Subscription Tier

| Feature | BASIC | STANDARD | PREMIUM |
|---------|-------|----------|---------|
| Max Products | 50 | 200 | Unlimited |
| Max Images per Product | 5 | 10 | 10 |
| Product Variants | No | Yes | Yes |
| Bulk Operations | No | Yes | Yes |
| Digital Products | No | Yes | Yes |
| Featured Products | No | 5 | Unlimited |
| Custom SEO Fields | No | Yes | Yes |
| Export/Import | No | CSV | CSV + API |

---

## Database Indexes

```sql
-- Products
CREATE INDEX idx_products_store_id ON products(store_id);
CREATE UNIQUE INDEX idx_products_store_slug ON products(store_id, slug);
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_products_created_at ON products(created_at);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_sku ON products(store_id, sku) WHERE sku IS NOT NULL;

-- Full-text search
CREATE INDEX idx_products_search ON products USING gin(to_tsvector('english', name || ' ' || COALESCE(description, '')));

-- Variants
CREATE INDEX idx_variants_product_id ON product_variants(product_id);
CREATE INDEX idx_variants_sku ON product_variants(sku) WHERE sku IS NOT NULL;

-- Categories
CREATE INDEX idx_categories_parent_id ON categories(parent_id);
CREATE INDEX idx_categories_store_id ON categories(store_id);
CREATE UNIQUE INDEX idx_categories_slug ON categories(slug);

-- Product-Category junction
CREATE INDEX idx_product_categories_product ON product_categories(product_id);
CREATE INDEX idx_product_categories_category ON product_categories(category_id);

-- Images
CREATE INDEX idx_product_images_product ON product_images(product_id);
```

---

## Future Considerations

### Phase 2 Enhancements
- Product reviews and ratings
- Product Q&A
- Related products / recommendations
- Product bundles
- Wishlist functionality
- Recently viewed products

### Phase 3 Enhancements
- Multi-currency pricing
- Scheduled publishing
- Product subscriptions (recurring)
- Advanced inventory (multi-location)
- Product import/export (CSV, API)
- AI-powered product descriptions

---

## Dependencies

### Requires
- Store module (products belong to store)
- User module (vendor authentication)
- UserSubscription module (tier limits)

### Enables
- Order module (order items reference products)
- Cart module (cart items reference products)
- Review module (reviews on products)
- Wishlist module (saved products)

---

## Success Metrics

- Average products per store
- Product publishing rate (draft to published)
- Product search usage and success rate
- Average time to first product listing
- Inventory accuracy rate
- Low stock alert effectiveness

---

## Open Questions

1. **Product Moderation**: Should products require approval before publishing?
   - Recommendation: No approval needed, but admin can hide violating products

2. **Cross-store Products**: Can vendors list same product in multiple stores?
   - Recommendation: Not in Phase 1, each store has independent catalog

3. **Product Templates**: Should we provide product templates by category?
   - Recommendation: Consider for Phase 2

4. **Inventory Sync**: Should we support external inventory system integration?
   - Recommendation: Phase 3, via API

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-22 | Claude | Initial PRD |
