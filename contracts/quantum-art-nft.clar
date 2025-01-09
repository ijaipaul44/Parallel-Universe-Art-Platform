;; Quantum Art NFT Contract

(define-non-fungible-token quantum-art-nft uint)

(define-data-var last-token-id uint u0)

(define-map token-metadata
  uint
  {
    name: (string-ascii 100),
    description: (string-utf8 1000),
    artist: principal,
    artwork-id: uint,
    image-url: (string-ascii 256),
    quantum-entropy: (buff 32),
    universe-id: uint
  }
)

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u403))

(define-public (mint (name (string-ascii 100)) (description (string-utf8 1000)) (artwork-id uint) (image-url (string-ascii 256)) (quantum-entropy (buff 32)) (universe-id uint))
  (let
    (
      (token-id (+ (var-get last-token-id) u1))
      (artwork (unwrap! (contract-call? .artwork-management get-artwork artwork-id) ERR_NOT_AUTHORIZED))
    )
    (asserts! (is-eq tx-sender (get artist artwork)) ERR_NOT_AUTHORIZED)
    (try! (nft-mint? quantum-art-nft token-id tx-sender))
    (map-set token-metadata
      token-id
      {
        name: name,
        description: description,
        artist: tx-sender,
        artwork-id: artwork-id,
        image-url: image-url,
        quantum-entropy: quantum-entropy,
        universe-id: universe-id
      }
    )
    (var-set last-token-id token-id)
    (ok token-id)
  )
)

(define-public (transfer (token-id uint) (recipient principal))
  (nft-transfer? quantum-art-nft token-id tx-sender recipient)
)

(define-read-only (get-token-metadata (token-id uint))
  (map-get? token-metadata token-id)
)

(define-read-only (get-last-token-id)
  (var-get last-token-id)
)
