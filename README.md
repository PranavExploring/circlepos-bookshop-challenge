# CirclePOS Bookshop Inventory & POS API

A Ruby on Rails API demonstration built for Circle Software, featuring indexed bookshop inventory search, transactional POS checkout with pessimistic locking, and RSpec test coverage.

## Key Highlights
- **Clean Architecture:** Thin controllers delegating business logic to `PosCheckoutService`.
- **SQL Performance:** Indexed `isbn` (unique) and `author_id` foreign keys, plus `.includes(:author)` eager loading to prevent N+1 queries.
- **Concurrency Safety:** Uses `with_lock` during stock decrements to prevent overselling.
- **Automated Testing:** Service and edge-case specs built with RSpec.
