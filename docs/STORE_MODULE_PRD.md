# Store Module - Product Requirements Document (PRD)

## Overview

The Store module enables **subscribed vendors** to create and manage their online store within the e-commerce platform. A vendor must have an **active subscription** before they can set up a store.

---

## Functional Requirements

### FR-1: Store Creation
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-1.1 | System shall allow vendors with ACTIVE subscription to create a store | High |
| FR-1.2 | System shall auto-generate URL slug from store name if not provided | Medium |
| FR-1.3 | System shall validate store name uniqueness (case-insensitive) | High |
| FR-1.4 | System shall validate slug uniqueness | High |
| FR-1.5 | System shall set initial store status to `PENDING_APPROVAL` | High |
| FR-1.6 | System shall prevent vendors from creating multiple stores | High |

### FR-2: Store Management
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-2.1 | Vendor shall be able to update store name, description, and contact info | High |
| FR-2.2 | Vendor shall be able to upload/update store logo (max 2MB, JPG/PNG) | Medium |
| FR-2.3 | Vendor shall be able to upload/update store banner (max 5MB, JPG/PNG) | Medium |
| FR-2.4 | Vendor shall be able to configure store settings (currency, timezone) | Low |
| FR-2.5 | Vendor shall be able to add/update social media links | Low |
| FR-2.6 | Vendor shall be able to add/update business address | Medium |

### FR-3: Store Approval Workflow
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-3.1 | Admin shall be able to view all pending store applications | High |
| FR-3.2 | Admin shall be able to approve pending stores | High |
| FR-3.3 | Admin shall be able to reject stores with mandatory reason (min 10 chars) | High |
| FR-3.4 | Admin shall be able to suspend active stores with reason | High |
| FR-3.5 | Admin shall be able to reactivate suspended stores | High |
| FR-3.6 | System shall send email notification on status changes | Medium |

### FR-4: Subscription Integration
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-4.1 | System shall automatically set store to `INACTIVE` when subscription expires | High |
| FR-4.2 | System shall automatically restore store to `ACTIVE` when subscription renews | High |
| FR-4.3 | System shall hide store products when store becomes inactive | High |
| FR-4.4 | System shall restore product visibility when store becomes active | High |

### FR-5: Public Store Access
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-5.1 | Public users shall be able to view list of active stores | High |
| FR-5.2 | Public users shall be able to view store details by slug | High |
| FR-5.3 | Public users shall be able to view store's products | High |
| FR-5.4 | System shall support pagination for store listings | Medium |
| FR-5.5 | System shall support search/filter for stores | Low |

---

## Non-Functional Requirements

### NFR-1: Performance
| ID | Requirement | Target |
|----|-------------|--------|
| NFR-1.1 | Store listing API response time | < 200ms (p95) |
| NFR-1.2 | Store detail API response time | < 100ms (p95) |
| NFR-1.3 | Store creation API response time | < 500ms (p95) |
| NFR-1.4 | Image upload processing time | < 3s |
| NFR-1.5 | Concurrent store listings supported | 1000 requests/sec |

### NFR-2: Scalability
| ID | Requirement | Target |
|----|-------------|--------|
| NFR-2.1 | Maximum stores supported | 100,000+ |
| NFR-2.2 | Maximum products per store | Based on subscription tier |
| NFR-2.3 | Image storage | Cloud-based, auto-scaling |

### NFR-3: Availability
| ID | Requirement | Target |
|----|-------------|--------|
| NFR-3.1 | Store module uptime | 99.9% |
| NFR-3.2 | Planned maintenance window | < 4 hours/month |
| NFR-3.3 | Recovery Time Objective (RTO) | < 1 hour |
| NFR-3.4 | Recovery Point Objective (RPO) | < 5 minutes |

### NFR-4: Security
| ID | Requirement | Description |
|----|-------------|-------------|
| NFR-4.1 | Authentication | JWT-based authentication required for vendor/admin endpoints |
| NFR-4.2 | Authorization | Role-based access control (VENDOR, SYSTEM_ADMIN) |
| NFR-4.3 | Data validation | Input sanitization to prevent XSS/SQL injection |
| NFR-4.4 | Image validation | File type verification, malware scanning |
| NFR-4.5 | Rate limiting | 100 requests/minute per user for write operations |
| NFR-4.6 | Audit logging | All admin actions logged with timestamp and user ID |

### NFR-5: Reliability
| ID | Requirement | Description |
|----|-------------|-------------|
| NFR-5.1 | Data consistency | ACID transactions for store status changes |
| NFR-5.2 | Idempotency | Store creation API must be idempotent |
| NFR-5.3 | Error handling | Graceful degradation with meaningful error messages |
| NFR-5.4 | Retry mechanism | Automatic retry for failed email notifications |

### NFR-6: Maintainability
| ID | Requirement | Description |
|----|-------------|-------------|
| NFR-6.1 | Code coverage | Minimum 80% unit test coverage |
| NFR-6.2 | Documentation | API documentation via OpenAPI/Swagger |
| NFR-6.3 | Logging | Structured logging for debugging and monitoring |
| NFR-6.4 | Monitoring | Health check endpoints, metrics exposure |

### NFR-7: Usability
| ID | Requirement | Description |
|----|-------------|-------------|
| NFR-7.1 | API consistency | RESTful conventions, consistent error format |
| NFR-7.2 | Validation feedback | Clear, actionable validation error messages |
| NFR-7.3 | Pagination | Cursor-based pagination for large result sets |

---

## Business Context

### Flow
```
Vendor Signs Up → Purchases Subscription → Creates Store → Lists Products
```

### Key Business Rules
1. Only users with role `VENDOR` can create a store
2. Vendor must have an **ACTIVE** subscription to create/manage a store
3. Each vendor can have **ONE store only**
4. Store becomes **inactive** if subscription expires/cancels
5. Products belong to a Store (not directly to vendor)

---

## User Stories

### US-1: Store Creation
**As a** subscribed vendor
**I want to** create my store with basic information
**So that** I can start listing and selling products

**Acceptance Criteria:**
- Vendor must have active subscription
- Store name must be unique across platform
- Store URL/slug must be unique and URL-friendly
- Store is created with `PENDING_APPROVAL` status initially

### US-2: Store Profile Setup
**As a** store owner
**I want to** complete my store profile
**So that** customers can learn about my business

**Acceptance Criteria:**
- Can add store logo and banner image
- Can add store description
- Can add contact information
- Can add business address
- Can add social media links

### US-3: Store Status Management
**As a** platform admin
**I want to** approve/reject/suspend stores
**So that** I can maintain platform quality

**Acceptance Criteria:**
- Admin can approve pending stores
- Admin can reject stores with reason
- Admin can suspend active stores
- Admin can reactivate suspended stores

### US-4: Subscription-Store Binding
**As a** platform
**I want to** automatically handle store status based on subscription
**So that** only paying vendors have active stores

**Acceptance Criteria:**
- Store becomes `INACTIVE` when subscription expires
- Store becomes `ACTIVE` when subscription renews
- Products become hidden when store is inactive

---

## Data Model

### Store Entity

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `id` | UUID | Primary key | Auto-generated |
| `userId` | UUID | Owner (vendor) | FK to users, unique |
| `userSubscriptionId` | UUID | Active subscription | FK to user_subscriptions |
| `name` | string | Store display name | Required, max 100 chars |
| `slug` | string | URL-friendly identifier | Unique, lowercase, no spaces |
| `description` | text | Store description | Optional, max 2000 chars |
| `logo` | string | Logo image URL | Optional |
| `banner` | string | Banner image URL | Optional |
| `status` | enum | Store status | See status enum |
| `contactEmail` | string | Contact email | Required, valid email |
| `contactPhone` | string | Contact phone | Optional |
| `address` | jsonb | Business address | Optional, structured |
| `socialLinks` | jsonb | Social media links | Optional |
| `settings` | jsonb | Store settings | Default {} |
| `approvedAt` | timestamp | When approved | Null until approved |
| `approvedBy` | UUID | Admin who approved | FK to users |
| `rejectionReason` | string | Why rejected | Null unless rejected |
| `suspendedAt` | timestamp | When suspended | Null unless suspended |
| `suspendedBy` | UUID | Admin who suspended | FK to users |
| `suspensionReason` | string | Why suspended | Null unless suspended |
| `createdAt` | timestamp | Created timestamp | Auto |
| `updatedAt` | timestamp | Updated timestamp | Auto |

### Store Status Enum

```typescript
enum StoreStatus {
  PENDING_APPROVAL = 'PENDING_APPROVAL',  // Newly created, awaiting admin review
  ACTIVE = 'ACTIVE',                       // Approved and subscription active
  INACTIVE = 'INACTIVE',                   // Subscription expired/cancelled
  SUSPENDED = 'SUSPENDED',                 // Admin suspended
  REJECTED = 'REJECTED'                    // Admin rejected application
}
```

### Address Structure (JSONB)

```typescript
interface StoreAddress {
  street: string;
  city: string;
  state: string;
  postalCode: string;
  country: string;
}
```

### Social Links Structure (JSONB)

```typescript
interface StoreSocialLinks {
  website?: string;
  facebook?: string;
  instagram?: string;
  twitter?: string;
  linkedin?: string;
  youtube?: string;
}
```

### Store Settings Structure (JSONB)

```typescript
interface StoreSettings {
  currency?: string;           // Default: 'USD'
  timezone?: string;           // Default: 'UTC'
  orderNotifications?: boolean; // Default: true
  lowStockThreshold?: number;  // Default: 10
}
```

---

## API Endpoints

### Vendor Endpoints (requires VENDOR role + active subscription)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/stores` | Create new store |
| `GET` | `/stores/my-store` | Get own store details |
| `PATCH` | `/stores/my-store` | Update own store |
| `PATCH` | `/stores/my-store/logo` | Upload/update logo |
| `PATCH` | `/stores/my-store/banner` | Upload/update banner |

### Public Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/stores` | List all active stores (paginated) |
| `GET` | `/stores/:slug` | Get store by slug (public view) |
| `GET` | `/stores/:slug/products` | Get store's products (future) |

### Admin Endpoints (requires SYSTEM_ADMIN role)

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/admin/stores` | List all stores (any status) |
| `GET` | `/admin/stores/:id` | Get store details |
| `PATCH` | `/admin/stores/:id/approve` | Approve pending store |
| `PATCH` | `/admin/stores/:id/reject` | Reject store with reason |
| `PATCH` | `/admin/stores/:id/suspend` | Suspend store with reason |
| `PATCH` | `/admin/stores/:id/reactivate` | Reactivate suspended store |

---

## DTOs

### CreateStoreDto

```typescript
{
  name: string;          // Required, 3-100 chars
  slug?: string;         // Optional (auto-generated from name if not provided)
  description?: string;  // Optional, max 2000 chars
  contactEmail: string;  // Required, valid email
  contactPhone?: string; // Optional
  address?: StoreAddress;
  socialLinks?: StoreSocialLinks;
}
```

### UpdateStoreDto

```typescript
{
  name?: string;
  description?: string;
  contactEmail?: string;
  contactPhone?: string;
  address?: StoreAddress;
  socialLinks?: StoreSocialLinks;
  settings?: StoreSettings;
}
```

### AdminRejectStoreDto

```typescript
{
  reason: string;  // Required, min 10 chars
}
```

### AdminSuspendStoreDto

```typescript
{
  reason: string;  // Required, min 10 chars
}
```

---

## Business Logic

### Store Creation Flow

```
1. Validate user is VENDOR role
2. Check user has ACTIVE subscription
3. Check user doesn't already have a store
4. Generate slug from name (if not provided)
5. Validate slug is unique
6. Create store with status = PENDING_APPROVAL
7. Send notification to admins for review
8. Return created store
```

### Subscription Expiry Handling

```
When subscription status changes to EXPIRED or CANCELLED:
1. Find associated store
2. Change store status to INACTIVE
3. Hide all store products from public listings
4. Notify vendor via email

When subscription is renewed/reactivated:
1. Find associated store
2. If store was INACTIVE (due to subscription), change to ACTIVE
3. Restore products to public listings
4. Notify vendor via email
```

### Store Approval Flow

```
Admin Approve:
1. Validate store is in PENDING_APPROVAL status
2. Set status = ACTIVE
3. Set approvedAt = now
4. Set approvedBy = admin user id
5. Notify vendor via email

Admin Reject:
1. Validate store is in PENDING_APPROVAL status
2. Set status = REJECTED
3. Set rejectionReason
4. Notify vendor via email with reason
```

---

## Validation Rules

### Store Name
- Required
- 3-100 characters
- Cannot contain special characters except: `& - ' .`
- Must be unique (case-insensitive)

### Store Slug

A **slug** is a URL-friendly identifier derived from a human-readable string. It creates clean, readable URLs instead of using numeric IDs or random strings.

#### What Makes a Slug

| Original Text | Slug |
|---------------|------|
| John's Electronics & More | `johns-electronics-more` |
| The Best Coffee Shop | `the-best-coffee-shop` |
| Café Müller 2024 | `cafe-muller-2024` |

**Transformation rules:**
- Convert to lowercase
- Remove special characters (`'`, `&`, `@`, etc.)
- Replace spaces with hyphens
- Remove accents/diacritics
- Trim leading/trailing hyphens

#### Why Use Slugs Instead of IDs?

| Aspect | ID-based URL | Slug-based URL |
|--------|--------------|----------------|
| Readability | `/store/a1f3-9c2b` | `/store/bobs-bakery` |
| SEO | Poor | Better ranking |
| Memorability | Impossible | Easy to remember |
| Shareability | Confusing | Clear intent |

#### Use Cases

1. **SEO-Friendly URLs**
   ```
   ❌ example.com/stores/123e4567-e89b-12d3-a456
   ✅ example.com/stores/johns-electronics
   ```

2. **E-commerce Stores & Products**
   ```
   /stores/nike-official
   /products/wireless-bluetooth-headphones
   ```

3. **Blog Posts & Articles**
   ```
   /blog/how-to-build-a-rest-api
   ```

4. **Store Module Usage**
   ```
   GET /stores/:slug → GET /stores/johns-electronics
   ```
   Vendors can share: `yourplatform.com/stores/johns-electronics`

#### Validation Rules
- Auto-generated from name if not provided
- Lowercase letters, numbers, hyphens only
- 3-50 characters
- Must be unique
- Cannot use reserved words: `admin`, `api`, `store`, `stores`, `vendor`, `login`, `signup`

### Contact Email
- Required
- Valid email format
- Will receive order notifications

---

## Feature Flags by Subscription Tier

| Feature | BASIC | STANDARD | PREMIUM |
|---------|-------|----------|---------|
| Max Products | 50 | 200 | Unlimited |
| Store Customization | Basic | Advanced | Full |
| Analytics | Basic | Detailed | Advanced |
| Priority Support | No | Email | 24/7 |
| Featured Placement | No | No | Yes |
| Custom Domain | No | No | Yes |

---

## Database Indexes

```sql
CREATE UNIQUE INDEX idx_stores_user_id ON stores(user_id);
CREATE UNIQUE INDEX idx_stores_slug ON stores(slug);
CREATE INDEX idx_stores_status ON stores(status);
CREATE INDEX idx_stores_user_subscription_id ON stores(user_subscription_id);
```

---

## Future Considerations

### Phase 2 Enhancements
- Store analytics dashboard
- Store reviews/ratings
- Store followers
- Store categories/tags
- Store verification badge

### Phase 3 Enhancements
- Custom store themes
- Custom domain mapping
- Store-level promotions
- Multi-location support
- Store staff accounts

---

## Dependencies

### Requires
- User module (VENDOR role)
- UserSubscription module (active subscription check)

### Enables
- Product module (products belong to store)
- Order module (orders placed to stores)
- Review module (store reviews)

---

## Success Metrics

- Store creation completion rate
- Time from subscription purchase to store setup
- Store approval rate
- Average time to approval
- Store activation rate after subscription renewal

---

## Open Questions

1. **Approval Process**: Should stores be auto-approved or require manual review?
   - Recommendation: Auto-approve for PREMIUM, manual for BASIC/STANDARD

2. **Grace Period**: How long should a store remain accessible after subscription expires?
   - Recommendation: 7-day grace period with warning banners

3. **Store Transfer**: Can a store be transferred to another vendor?
   - Recommendation: Not in Phase 1, consider for future

4. **Multiple Stores**: Should PREMIUM vendors be allowed multiple stores?
   - Recommendation: Consider for Phase 2

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-22 | Claude | Initial PRD |
