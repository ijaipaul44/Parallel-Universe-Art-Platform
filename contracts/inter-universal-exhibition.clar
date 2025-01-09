;; Inter-Universal Exhibition Contract

(define-data-var exhibition-count uint u0)

(define-map exhibitions
  uint
  {
    curator: principal,
    title: (string-ascii 100),
    description: (string-utf8 1000),
    start-time: uint,
    end-time: uint,
    artwork-ids: (list 100 uint),
    status: (string-ascii 20)
  }
)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u403))
(define-constant ERR_INVALID_EXHIBITION (err u404))

(define-public (create-exhibition (title (string-ascii 100)) (description (string-utf8 1000)) (start-time uint) (end-time uint) (artwork-ids (list 100 uint)))
  (let
    (
      (exhibition-id (+ (var-get exhibition-count) u1))
    )
    (map-set exhibitions
      exhibition-id
      {
        curator: tx-sender,
        title: title,
        description: description,
        start-time: start-time,
        end-time: end-time,
        artwork-ids: artwork-ids,
        status: "upcoming"
      }
    )
    (var-set exhibition-count exhibition-id)
    (ok exhibition-id)
  )
)

(define-public (update-exhibition-status (exhibition-id uint) (new-status (string-ascii 20)))
  (let
    (
      (exhibition (unwrap! (map-get? exhibitions exhibition-id) ERR_INVALID_EXHIBITION))
    )
    (asserts! (or (is-eq tx-sender CONTRACT_OWNER) (is-eq tx-sender (get curator exhibition))) ERR_NOT_AUTHORIZED)
    (ok (map-set exhibitions
      exhibition-id
      (merge exhibition { status: new-status })
    ))
  )
)

(define-read-only (get-exhibition (exhibition-id uint))
  (map-get? exhibitions exhibition-id)
)

(define-read-only (get-exhibition-count)
  (var-get exhibition-count)
)
