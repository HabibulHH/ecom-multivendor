# Store & Product Module - Beginner's Guide

A simplified guide for understanding how stores and products work in an e-commerce platform.

---

## Overview

```
┌─────────────────────────────────────────────────────────┐
│                      PLATFORM                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   STORE A   │  │   STORE B   │  │   STORE C   │     │
│  │  ┌───────┐  │  │  ┌───────┐  │  │  ┌───────┐  │     │
│  │  │Product│  │  │  │Product│  │  │  │Product│  │     │
│  │  │Product│  │  │  │Product│  │  │  │Product│  │     │
│  │  │Product│  │  │  │Product│  │  │  │Product│  │     │
│  │  └───────┘  │  │  └───────┘  │  │  └───────┘  │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
└─────────────────────────────────────────────────────────┘
```

**Key Concept:** A Vendor owns a Store, and a Store contains Products.

---

## Basic Flow

```
1. Vendor signs up
2. Vendor purchases subscription
3. Vendor creates a store
4. Admin approves the store
5. Vendor adds products
6. Customers browse and buy
```

---

## Data Models

### Store Model

```typescript
// Store - A vendor's online shop
interface Store {
  id: string;              // Unique identifier (UUID)
  userId: string;          // Who owns this store (vendor)
  name: string;            // "John's Electronics"
  slug: string;            // "johns-electronics" (URL-friendly)
  description: string;     // About the store
  logo: string;            // Logo image URL
  status: StoreStatus;     // Current state of the store
  contactEmail: string;    // Contact email
  contactPhone: string;    // Contact phone (optional)
  createdAt: Date;         // When created
  updatedAt: Date;         // When last updated
}

// Store can be in one of these states
enum StoreStatus {
  PENDING_APPROVAL = 'PENDING_APPROVAL',  // Waiting for admin
  ACTIVE = 'ACTIVE',                       // Live and working
  INACTIVE = 'INACTIVE',                   // Subscription expired
  SUSPENDED = 'SUSPENDED',                 // Admin blocked it
  REJECTED = 'REJECTED'                    // Admin said no
}
```

### Product Model

```typescript
// Product - An item for sale in a store
interface Product {
  id: string;              // Unique identifier (UUID)
  storeId: string;         // Which store this belongs to
  name: string;            // "Wireless Headphones"
  slug: string;            // "wireless-headphones" (URL-friendly)
  description: string;     // Full product description
  price: number;           // 99.99
  compareAtPrice: number;  // Original price (for showing discount)
  sku: string;             // Stock Keeping Unit (inventory code)
  quantity: number;        // How many in stock
  status: ProductStatus;   // Current state
  images: string[];        // Array of image URLs
  createdAt: Date;         // When created
  updatedAt: Date;         // When last updated
}

// Product can be in one of these states
enum ProductStatus {
  DRAFT = 'DRAFT',         // Not visible, still editing
  PUBLISHED = 'PUBLISHED', // Live and visible to customers
  ARCHIVED = 'ARCHIVED'    // Hidden but not deleted
}
```

---

## What is a Slug?

A **slug** is a URL-friendly version of a name. It makes URLs readable and SEO-friendly.

### Examples

| Name | Slug |
|------|------|
| John's Electronics | `johns-electronics` |
| Wireless Headphones Pro | `wireless-headphones-pro` |
| 50% Off Summer Sale! | `50-off-summer-sale` |

### How to Create a Slug

```typescript
function createSlug(name: string): string {
  return name
    .toLowerCase()                    // "John's Shop" → "john's shop"
    .trim()                           // Remove extra spaces
    .replace(/[^a-z0-9\s-]/g, '')    // Remove special chars → "johns shop"
    .replace(/\s+/g, '-')            // Spaces to hyphens → "johns-shop"
    .replace(/-+/g, '-');            // Remove duplicate hyphens
}
```

### Why Use Slugs?

```
❌ Bad URL:  example.com/stores/550e8400-e29b-41d4-a716-446655440000
✅ Good URL: example.com/stores/johns-electronics
```

- Easier to read and remember
- Better for SEO (search engines)
- Users understand what page they're visiting

---

## Entity Relationships

```
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│     USER     │       │    STORE     │       │   PRODUCT    │
│──────────────│       │──────────────│       │──────────────│
│ id           │──┐    │ id           │──┐    │ id           │
│ email        │  │    │ userId    ◄──┘  │    │ storeId   ◄──┘
│ role         │  └───►│ name          │  └───►│ name         │
│ ...          │       │ slug          │       │ slug         │
└──────────────┘       │ status        │       │ price        │
                       │ ...           │       │ quantity     │
                       └──────────────┘       │ ...          │
                                              └──────────────┘

One User → One Store → Many Products
```

---

## API Endpoints

### Store APIs

| Method | Endpoint | Description | Who Can Use |
|--------|----------|-------------|-------------|
| `POST` | `/stores` | Create a new store | Vendor |
| `GET` | `/stores` | List all active stores | Anyone |
| `GET` | `/stores/:slug` | Get store by slug | Anyone |
| `GET` | `/stores/my-store` | Get my own store | Vendor |
| `PATCH` | `/stores/my-store` | Update my store | Vendor |

### Product APIs

| Method | Endpoint | Description | Who Can Use |
|--------|----------|-------------|-------------|
| `POST` | `/stores/my-store/products` | Create product | Vendor |
| `GET` | `/stores/my-store/products` | List my products | Vendor |
| `GET` | `/stores/:slug/products` | List store's products | Anyone |
| `GET` | `/products/:slug` | Get product details | Anyone |
| `PATCH` | `/stores/my-store/products/:id` | Update product | Vendor |
| `DELETE` | `/stores/my-store/products/:id` | Delete product | Vendor |

### Admin APIs

| Method | Endpoint | Description | Who Can Use |
|--------|----------|-------------|-------------|
| `GET` | `/admin/stores` | List all stores | Admin |
| `PATCH` | `/admin/stores/:id/approve` | Approve store | Admin |
| `PATCH` | `/admin/stores/:id/reject` | Reject store | Admin |

---

## Request & Response Examples

### Create Store

**Request:**
```http
POST /stores
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "John's Electronics",
  "description": "Best electronics in town",
  "contactEmail": "john@example.com"
}
```

**Response:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "John's Electronics",
  "slug": "johns-electronics",
  "description": "Best electronics in town",
  "status": "PENDING_APPROVAL",
  "contactEmail": "john@example.com",
  "createdAt": "2026-01-22T10:00:00Z"
}
```

### Create Product

**Request:**
```http
POST /stores/my-store/products
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "Wireless Headphones",
  "description": "High-quality wireless headphones with noise cancellation",
  "price": 99.99,
  "quantity": 50
}
```

**Response:**
```json
{
  "id": "660e8400-e29b-41d4-a716-446655440001",
  "storeId": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Wireless Headphones",
  "slug": "wireless-headphones",
  "description": "High-quality wireless headphones with noise cancellation",
  "price": 99.99,
  "quantity": 50,
  "status": "DRAFT",
  "createdAt": "2026-01-22T10:30:00Z"
}
```

### Get Store Products (Public)

**Request:**
```http
GET /stores/johns-electronics/products
```

**Response:**
```json
{
  "data": [
    {
      "id": "660e8400-e29b-41d4-a716-446655440001",
      "name": "Wireless Headphones",
      "slug": "wireless-headphones",
      "price": 99.99,
      "images": ["https://cdn.example.com/headphones.jpg"]
    },
    {
      "id": "660e8400-e29b-41d4-a716-446655440002",
      "name": "Bluetooth Speaker",
      "slug": "bluetooth-speaker",
      "price": 49.99,
      "images": ["https://cdn.example.com/speaker.jpg"]
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 2
  }
}
```

---

## DTOs (Data Transfer Objects)

DTOs define the shape of data for API requests.

### CreateStoreDto

```typescript
// What you send when creating a store
class CreateStoreDto {
  name: string;           // Required, 3-100 characters
  slug?: string;          // Optional (auto-generated if not provided)
  description?: string;   // Optional
  contactEmail: string;   // Required, valid email
  contactPhone?: string;  // Optional
}
```

### CreateProductDto

```typescript
// What you send when creating a product
class CreateProductDto {
  name: string;           // Required, 3-200 characters
  slug?: string;          // Optional (auto-generated)
  description?: string;   // Optional
  price: number;          // Required, must be >= 0
  compareAtPrice?: number;// Optional (original price)
  sku?: string;           // Optional (inventory code)
  quantity?: number;      // Optional, default: 0
}
```

### UpdateProductDto

```typescript
// What you send when updating a product (all fields optional)
class UpdateProductDto {
  name?: string;
  description?: string;
  price?: number;
  compareAtPrice?: number;
  sku?: string;
  quantity?: number;
  status?: ProductStatus;
}
```

---

## Business Rules (Simple Version)

### Store Rules
1. One vendor can have only ONE store
2. Store must be approved by admin before going live
3. Store needs active subscription to remain active

### Product Rules
1. Products belong to a store (not directly to vendor)
2. Products start as DRAFT (not visible to customers)
3. Must publish product to make it visible
4. Products are hidden when store becomes inactive

### Slug Rules
1. Store slug must be unique across the platform
2. Product slug must be unique within the store
3. Slugs are auto-generated if not provided

---

## Status Flow Diagrams

### Store Status Flow

```
                    ┌─────────────────┐
                    │  Store Created  │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
         ┌─────────│ PENDING_APPROVAL│─────────┐
         │         └─────────────────┘         │
         │                                     │
    Admin Approves                        Admin Rejects
         │                                     │
         ▼                                     ▼
    ┌─────────┐                          ┌──────────┐
    │ ACTIVE  │◄─────────────────────────│ REJECTED │
    └────┬────┘     (Vendor reapplies)   └──────────┘
         │
         │ Subscription Expires
         ▼
    ┌──────────┐
    │ INACTIVE │
    └────┬─────┘
         │
         │ Subscription Renewed
         ▼
    ┌─────────┐
    │ ACTIVE  │
    └─────────┘
```

### Product Status Flow

```
    ┌─────────────────┐
    │ Product Created │
    └────────┬────────┘
             │
             ▼
        ┌─────────┐
        │  DRAFT  │◄──────────────┐
        └────┬────┘               │
             │                    │
        Vendor Publishes     Vendor Unpublishes
             │                    │
             ▼                    │
       ┌───────────┐              │
       │ PUBLISHED │──────────────┘
       └─────┬─────┘
             │
        Vendor Archives
             │
             ▼
       ┌──────────┐
       │ ARCHIVED │
       └──────────┘
```

---

## Database Schema (SQL)

```sql
-- Stores table
CREATE TABLE stores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  logo VARCHAR(500),
  status VARCHAR(20) NOT NULL DEFAULT 'PENDING_APPROVAL',
  contact_email VARCHAR(255) NOT NULL,
  contact_phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  store_id UUID NOT NULL REFERENCES stores(id),
  name VARCHAR(200) NOT NULL,
  slug VARCHAR(200) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  compare_at_price DECIMAL(10, 2),
  sku VARCHAR(100),
  quantity INTEGER DEFAULT 0,
  status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  -- Product slug must be unique within each store
  UNIQUE(store_id, slug)
);

-- Product images table
CREATE TABLE product_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES products(id),
  url VARCHAR(500) NOT NULL,
  position INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for faster queries
CREATE INDEX idx_stores_user_id ON stores(user_id);
CREATE INDEX idx_stores_status ON stores(status);
CREATE INDEX idx_products_store_id ON products(store_id);
CREATE INDEX idx_products_status ON products(status);
```

---

## NestJS Implementation Examples

### Store Entity (TypeORM)

```typescript
import { Entity, PrimaryGeneratedColumn, Column, OneToMany, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Product } from './product.entity';

@Entity('stores')
export class Store {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id' })
  userId: string;

  @Column({ length: 100 })
  name: string;

  @Column({ length: 100, unique: true })
  slug: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ nullable: true })
  logo: string;

  @Column({ default: 'PENDING_APPROVAL' })
  status: string;

  @Column({ name: 'contact_email' })
  contactEmail: string;

  @Column({ name: 'contact_phone', nullable: true })
  contactPhone: string;

  @OneToMany(() => Product, (product) => product.store)
  products: Product[];

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
```

### Product Entity (TypeORM)

```typescript
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Store } from './store.entity';

@Entity('products')
export class Product {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'store_id' })
  storeId: string;

  @ManyToOne(() => Store, (store) => store.products)
  @JoinColumn({ name: 'store_id' })
  store: Store;

  @Column({ length: 200 })
  name: string;

  @Column({ length: 200 })
  slug: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  price: number;

  @Column({ name: 'compare_at_price', type: 'decimal', precision: 10, scale: 2, nullable: true })
  compareAtPrice: number;

  @Column({ nullable: true })
  sku: string;

  @Column({ default: 0 })
  quantity: number;

  @Column({ default: 'DRAFT' })
  status: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
```

### Simple Store Service

```typescript
import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Store } from './store.entity';
import { CreateStoreDto } from './dto/create-store.dto';

@Injectable()
export class StoreService {
  constructor(
    @InjectRepository(Store)
    private storeRepository: Repository<Store>,
  ) {}

  // Create a new store
  async create(userId: string, dto: CreateStoreDto): Promise<Store> {
    // Check if user already has a store
    const existingStore = await this.storeRepository.findOne({ where: { userId } });
    if (existingStore) {
      throw new ConflictException('You already have a store');
    }

    // Generate slug if not provided
    const slug = dto.slug || this.createSlug(dto.name);

    // Check if slug is unique
    const slugExists = await this.storeRepository.findOne({ where: { slug } });
    if (slugExists) {
      throw new ConflictException('Store slug already exists');
    }

    // Create and save store
    const store = this.storeRepository.create({
      ...dto,
      userId,
      slug,
      status: 'PENDING_APPROVAL',
    });

    return this.storeRepository.save(store);
  }

  // Get store by slug (public)
  async findBySlug(slug: string): Promise<Store> {
    const store = await this.storeRepository.findOne({
      where: { slug, status: 'ACTIVE' },
    });

    if (!store) {
      throw new NotFoundException('Store not found');
    }

    return store;
  }

  // Get all active stores
  async findAllActive(page = 1, limit = 10): Promise<{ data: Store[]; total: number }> {
    const [data, total] = await this.storeRepository.findAndCount({
      where: { status: 'ACTIVE' },
      skip: (page - 1) * limit,
      take: limit,
      order: { createdAt: 'DESC' },
    });

    return { data, total };
  }

  // Helper: Create slug from name
  private createSlug(name: string): string {
    return name
      .toLowerCase()
      .trim()
      .replace(/[^a-z0-9\s-]/g, '')
      .replace(/\s+/g, '-')
      .replace(/-+/g, '-');
  }
}
```

### Simple Product Service

```typescript
import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from './product.entity';
import { CreateProductDto } from './dto/create-product.dto';

@Injectable()
export class ProductService {
  constructor(
    @InjectRepository(Product)
    private productRepository: Repository<Product>,
  ) {}

  // Create a new product
  async create(storeId: string, dto: CreateProductDto): Promise<Product> {
    const slug = dto.slug || this.createSlug(dto.name);

    // Check if slug is unique within the store
    const slugExists = await this.productRepository.findOne({
      where: { storeId, slug },
    });
    if (slugExists) {
      throw new ConflictException('Product slug already exists in this store');
    }

    const product = this.productRepository.create({
      ...dto,
      storeId,
      slug,
      status: 'DRAFT',
    });

    return this.productRepository.save(product);
  }

  // Get store's products (public - only published)
  async findByStore(storeId: string, page = 1, limit = 10) {
    const [data, total] = await this.productRepository.findAndCount({
      where: { storeId, status: 'PUBLISHED' },
      skip: (page - 1) * limit,
      take: limit,
      order: { createdAt: 'DESC' },
    });

    return { data, total };
  }

  // Publish a product
  async publish(productId: string, storeId: string): Promise<Product> {
    const product = await this.productRepository.findOne({
      where: { id: productId, storeId },
    });

    if (!product) {
      throw new NotFoundException('Product not found');
    }

    product.status = 'PUBLISHED';
    return this.productRepository.save(product);
  }

  // Helper: Create slug from name
  private createSlug(name: string): string {
    return name
      .toLowerCase()
      .trim()
      .replace(/[^a-z0-9\s-]/g, '')
      .replace(/\s+/g, '-')
      .replace(/-+/g, '-');
  }
}
```

---

## Quick Reference

### HTTP Methods
| Method | Purpose | Example |
|--------|---------|---------|
| `GET` | Read data | Get store details |
| `POST` | Create new | Create a product |
| `PATCH` | Update partial | Update product price |
| `PUT` | Replace entire | Replace all product data |
| `DELETE` | Remove | Delete a product |

### HTTP Status Codes
| Code | Meaning | When to Use |
|------|---------|-------------|
| `200` | OK | Successful GET/PATCH |
| `201` | Created | Successful POST |
| `400` | Bad Request | Validation failed |
| `401` | Unauthorized | Not logged in |
| `403` | Forbidden | Not allowed |
| `404` | Not Found | Resource doesn't exist |
| `409` | Conflict | Duplicate (e.g., slug exists) |

---

## Summary

1. **Store** = Vendor's online shop (one per vendor)
2. **Product** = Item for sale (belongs to a store)
3. **Slug** = URL-friendly name (`johns-electronics`)
4. **Status** = Current state (DRAFT → PUBLISHED)
5. **DTO** = Shape of request data

### Key Relationships
```
User (Vendor) ──── 1:1 ──── Store ──── 1:Many ──── Products
```

### Key APIs
- Create store: `POST /stores`
- Create product: `POST /stores/my-store/products`
- View store: `GET /stores/:slug`
- View products: `GET /stores/:slug/products`

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-22 | Claude | Initial guide |
