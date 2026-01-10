# ManyToOne Relationship Explained

## The Relationship

**Many** users can subscribe to **One** plan, and **One** user can have **Many** subscriptions over time.

## Example Data

### `subscriptions` table (the plans)
| id | name | price | plan |
|----|------|-------|------|
| `plan-001` | Basic Monthly | 9.99 | BASIC |
| `plan-002` | Standard Monthly | 19.99 | STANDARD |
| `plan-003` | Premium Monthly | 49.99 | PREMIUM |

### `users` table
| id | email | firstName |
|----|-------|-----------|
| `user-001` | ali@gmail.com | Ali |
| `user-002` | sara@gmail.com | Sara |
| `user-003` | ahmed@gmail.com | Ahmed |

### `user_subscriptions` table
| id | userId | subscriptionId | startDate | endDate | status |
|----|--------|----------------|-----------|---------|--------|
| `sub-001` | `user-001` | `plan-002` | 2024-01-01 | 2024-02-01 | EXPIRED |
| `sub-002` | `user-001` | `plan-003` | 2024-02-01 | 2024-03-01 | ACTIVE |
| `sub-003` | `user-002` | `plan-001` | 2024-01-15 | 2024-02-15 | ACTIVE |
| `sub-004` | `user-003` | `plan-002` | 2024-01-10 | 2024-02-10 | CANCELLED |

## Visual Explanation

```
Many UserSubscriptions ──────────► One User
     (sub-001, sub-002)                (user-001 Ali)

Many UserSubscriptions ──────────► One Subscription Plan
     (sub-002, sub-004)                (plan-002 Standard)
```

## What This Means

| Scenario | Explanation |
|----------|-------------|
| Ali (`user-001`) | Had Basic, then upgraded to Premium (2 subscriptions) |
| Sara (`user-002`) | Has Basic plan (1 subscription) |
| Standard plan (`plan-002`) | Used by both Ali and Ahmed (many users) |

## Code → Database Mapping

```typescript
@ManyToOne(() => User)
@JoinColumn({ name: 'userId' })
user: User;
```

This means:
- `userId` column stores the foreign key
- Many `user_subscriptions` rows can point to ONE `user`
- When you fetch a UserSubscription, you can also load the full User object

## Query Example

```typescript
// Get subscription with user details
const result = await userSubscriptionRepo.findOne({
  where: { id: 'sub-001' },
  relations: ['user', 'subscription'],
});

// Result:
{
  id: 'sub-001',
  userId: 'user-001',
  subscriptionId: 'plan-002',
  status: 'EXPIRED',
  user: {
    id: 'user-001',
    email: 'ali@gmail.com',
    firstName: 'Ali'
  },
  subscription: {
    id: 'plan-002',
    name: 'Standard Monthly',
    price: 19.99
  }
}
```
