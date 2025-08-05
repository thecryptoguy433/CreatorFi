;; CreatorFi Subscription Pass Contract
;; Clarity v2
;; Implements tiered non-transferable NFT subscription logic

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-INVALID-TIER u101)
(define-constant ERR-NOT-OWNER u102)
(define-constant ERR-EXPIRED u103)
(define-constant ERR-NOT-FOUND u104)
(define-constant ERR-NOT-RENEWABLE u105)

(define-data-var admin principal tx-sender)
(define-data-var pass-counter uint u0)

(define-map subscriptions uint
  {
    owner: principal,
    tier: uint,         ;; 1 = Basic, 2 = Premium, 3 = VIP
    expires-at: uint    ;; block height of expiration
  }
)

(define-map user-subscriptions principal uint)

;; Constants
(define-constant TIER-BASIC u1)
(define-constant TIER-PREMIUM u2)
(define-constant TIER-VIP u3)

(define-constant DURATION-BLOCKS u52500) ;; ~1 month assuming 10min blocks

;; Helpers
(define-private (is-admin)
  (is-eq tx-sender (var-get admin))
)

(define-private (valid-tier? (tier uint))
  (or (is-eq tier TIER-BASIC)
      (or (is-eq tier TIER-PREMIUM)
          (is-eq tier TIER-VIP)))
)

;; Admin: Transfer control
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (var-set admin new-admin)
    (ok true)
  )
)

;; Mint a new subscription pass
(define-public (mint-pass (recipient principal) (tier uint))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (valid-tier? tier) (err ERR-INVALID-TIER))
    (let (
      (next-id (+ u1 (var-get pass-counter)))
      (expires (+ block-height DURATION-BLOCKS))
    )
      (map-set subscriptions next-id { owner: recipient, tier: tier, expires-at: expires })
      (map-set user-subscriptions recipient next-id)
      (var-set pass-counter next-id)
      (ok next-id)
    )
  )
)

;; Renew pass (extends expiration)
(define-public (renew-pass)
  (let (
    (sub-id (default-to u0 (map-get? user-subscriptions tx-sender)))
    (subscription (map-get? subscriptions sub-id))
  )
    (match subscription
      subscription-data
        (begin
          (asserts! (is-eq tx-sender (get owner subscription-data)) (err ERR-NOT-OWNER))
          (let (
            (current-expiry (get expires-at subscription-data))
            (new-expiry (+ current-expiry DURATION-BLOCKS))
          )
            (map-set subscriptions sub-id
              { owner: tx-sender, tier: (get tier subscription-data), expires-at: new-expiry })
            (ok new-expiry)
          )
        )
      (err ERR-NOT-FOUND)
    )
  )
)

;; Redeem pass (only if not expired)
(define-public (redeem-benefit)
  (let (
    (sub-id (default-to u0 (map-get? user-subscriptions tx-sender)))
    (subscription (map-get? subscriptions sub-id))
  )
    (match subscription
      subscription-data
        (begin
          (asserts! (is-eq tx-sender (get owner subscription-data)) (err ERR-NOT-OWNER))
          (asserts! (> (get expires-at subscription-data) block-height) (err ERR-EXPIRED))
          (ok { tier: (get tier subscription-data), expires-at: (get expires-at subscription-data) })
        )
      (err ERR-NOT-FOUND)
    )
  )
)

;; Read-onlys
(define-read-only (get-subscription-id (user principal))
  (ok (default-to u0 (map-get? user-subscriptions user)))
)

(define-read-only (get-subscription (sub-id uint))
  (match (map-get? subscriptions sub-id)
    sub (ok sub)
    (err ERR-NOT-FOUND)
  )
)

(define-read-only (get-admin)
  (ok (var-get admin))
)

(define-read-only (get-counter)
  (ok (var-get pass-counter))
)
