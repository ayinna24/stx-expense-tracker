;; stx-expense-tracker.clar
;; A simple STX expense tracker contract

(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-FAILED-TRANSFER (err u101))

;; Contract deployer (owner / manager of expense tracker)
(define-constant contract-admin tx-sender)

;; Expense record structure
;; Each expense has: spender, amount, note, timestamp
(define-map expenses { id: uint }
  { spender: principal, amount: uint, note: (string-ascii 50), block: uint })

;; Track total expenses
(define-data-var total-expenses uint u0)

;; Track next expense ID
(define-data-var next-id uint u0)

;; -----------------------------
;; FUNCTIONS
;; -----------------------------

;; Record an expense (with STX transfer)
;; Record an expense (with STX transfer)
(define-public (record-expense (amount uint) (note (string-ascii 50)))
    (if (<= amount u0)
        (err u200) ;; must attach STX
        (begin
          ;; transfer into contract
          (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))

          ;; assign ID
          (let ((id (var-get next-id)))
            (map-set expenses { id: id }
              { spender: tx-sender, amount: amount, note: note, block: u0 })
            (var-set next-id (+ id u1))
            (var-set total-expenses (+ (var-get total-expenses) amount))
            (ok id) ;; return expense ID
          )
        )
    )
)

;; Admin can withdraw collected funds to reimburse expenses
(define-public (withdraw (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-admin) ERR-NOT-AUTHORIZED)
    (try! (stx-transfer? amount (as-contract tx-sender) recipient))
    (ok true)
  )
)

;; -----------------------------
;; READ-ONLYS
;; -----------------------------

;; Get a single expense by ID
(define-read-only (get-expense (id uint))
  (map-get? expenses { id: id })
)

;; Get total expenses recorded
(define-read-only (get-total-expenses)
  (ok (var-get total-expenses))
)

;; Get number of expenses (next ID = count)
(define-read-only (get-count)
  (ok (var-get next-id))
)
