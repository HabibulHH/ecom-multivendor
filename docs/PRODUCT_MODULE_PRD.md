# Product Module PRD (Bare Minimum)

## Overview

Store owners can create and manage products. Products belong to a store and are only visible when the store is **ACTIVE** and the product is **PUBLISHED**.

---

## Scope

| Included | NOT Included |
|----------|--------------|
| Product CRUD (create, read, update, soft-delete) | Tags |
| Product images (URL-based, max 5) | Bulk operations |
| Flat categories (no hierarchy) | Product variants |
| Publish / Unpublish | Subscription tier limits |
| Basic search & filter | SEO fields (metaTitle, metaDescription) |
| Pagination | Image file upload |
| Admin hide/unhide | Low stock alerts |
| | Digital products |
| | Import/Export |

---

## Data Model

### Product

| Field | Type | Constraints |
|-------|------|-------------|
| `id` | UUID | PK, auto-generated |
| `storeId` | UUID | FK to stores, required |
| `name` | string(200) | Required, min 3 chars |
| `slug` | string(200) | Unique per store, auto-generated |
| `description` | text | Optional |
| `price` | decimal(10,2) | Required, >= 0 |
| `compareAtPrice` | decimal(10,2) | Optional |
| `sku` | string(100) | Optional |
| `status` | enum | DRAFT, PUBLISHED, ARCHIVED, HIDDEN |
| `quantity` | integer | Default: 0 |
| `isFeatured` | boolean | Default: false |
| `publishedAt` | timestamp | Set when published |
| `createdAt` | timestamp | Auto |
| `updatedAt` | timestamp | Auto |
| `deletedAt` | timestamp | Soft delete |

### ProductImage

| Field | Type | Constraints |
|-------|------|-------------|
| `id` | UUID | PK |
| `productId` | UUID | FK to products |
| `url` | string(500) | Required |
| `altText` | string(200) | Optional |
| `position` | integer | Default: 0 |
| `isPrimary` | boolean | Default: false |
| `createdAt` | timestamp | Auto |

### Category (flat, no hierarchy)

| Field | Type | Constraints |
|-------|------|-------------|
| `id` | UUID | PK |
| `name` | string(200) | Required |
| `slug` | string(200) | Unique |
| `description` | text | Optional |
| `isActive` | boolean | Default: true |
| `createdAt` | timestamp | Auto |
| `updatedAt` | timestamp | Auto |

### ProductCategory (junction table)

| Field | Type |
|-------|------|
| `productId` | UUID FK |
| `categoryId` | UUID FK |

---

## API Endpoints

### Store Owner (`/stores/my-store/products`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/stores/my-store/products` | Create product |
| GET | `/stores/my-store/products` | List own products |
| GET | `/stores/my-store/products/:id` | Get product |
| PATCH | `/stores/my-store/products/:id` | Update product |
| DELETE | `/stores/my-store/products/:id` | Soft delete |
| PATCH | `/stores/my-store/products/:id/publish` | Publish |
| PATCH | `/stores/my-store/products/:id/unpublish` | Unpublish |
| POST | `/stores/my-store/products/:id/images` | Add image |
| DELETE | `/stores/my-store/products/:id/images/:imageId` | Remove image |

### Public

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/products` | List published products (paginated) |
| GET | `/products/search` | Search products |
| GET | `/stores/:storeSlug/products` | Store's published products |
| GET | `/categories` | List categories |
| GET | `/categories/:slug/products` | Products in category |

### Admin (`/admin/products`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/admin/products` | List all products |
| GET | `/admin/products/:id` | Get any product |
| PATCH | `/admin/products/:id/hide` | Hide product |
| PATCH | `/admin/products/:id/unhide` | Unhide product |
| POST | `/admin/categories` | Create category |
| PATCH | `/admin/categories/:id` | Update category |
| DELETE | `/admin/categories/:id` | Delete category |

---

## Business Rules

1. Products belong to a **Store**, not directly to a user
2. Product slug is auto-generated from name, must be **unique within the store**
3. New products start in **DRAFT** status
4. To publish: product must have a name, price, and at least one image
5. Only **PUBLISHED** products from **ACTIVE** stores are visible publicly
6. Delete is **soft delete** (sets `deletedAt`, can be restored)
7. Max **5 images** per product

---

## Product Creation Flow

```
1. Receive product data + userId
2. Find user's store
3. Generate slug from product name
4. Check slug is unique in store
5. Create product with status = DRAFT
6. Return created product
```

## Product Publishing Flow

```
1. Find the product
2. Check: has name, price, at least 1 image
3. Set status = PUBLISHED, publishedAt = now
4. Return updated product
```

---

## Search & Filter (GET /products/search)

| Query Param | Type | Description |
|-------------|------|-------------|
| `q` | string | Search by name |
| `categoryId` | UUID | Filter by category |
| `storeId` | UUID | Filter by store |
| `minPrice` | number | Min price |
| `maxPrice` | number | Max price |
| `sortBy` | enum | `price_asc`, `price_desc`, `created_at`, `name` |
| `page` | number | Page number (default: 1) |
| `limit` | number | Per page (default: 20, max: 50) |

---

## Dependencies

- **Store module** - products belong to a store
- **User module** - store owner identification
