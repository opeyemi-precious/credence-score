;; Title: Credence Score Protocol
;; Summary: Next-generation decentralized credibility scoring and reputation 
;;          management system for the Bitcoin ecosystem
;; Description: Credence revolutionizes trust assessment through blockchain-native
;;              reputation tracking. This protocol empowers communities to build
;;              transparent, verifiable credibility networks where users earn
;;              reputation through measurable contributions. Features intelligent
;;              score degradation, flexible action weighting, and immutable
;;              accountability records. Perfect for DeFi governance, P2P marketplaces,
;;              content platforms, and any ecosystem requiring trustless reputation
;;              verification. Built to scale with your community's growth while
;;              maintaining the highest security standards.

;; ERROR CONSTANTS

(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-INVALID-PARAMETERS (err u101))
(define-constant ERR-IDENTITY-EXISTS (err u102))
(define-constant ERR-IDENTITY-NOT-FOUND (err u103))
(define-constant ERR-INSUFFICIENT-REPUTATION (err u104))
(define-constant ERR-MAX-REPUTATION-REACHED (err u105))
(define-constant ERR-ACTION-EXISTS (err u106))
(define-constant ERR-ACTION-NOT-FOUND (err u107))
(define-constant ERR-NOT-ADMIN (err u108))
(define-constant ERR-NOT-ACTIVE (err u109))

;; SYSTEM CONSTANTS

(define-constant MAX-REPUTATION-SCORE u1000)
(define-constant MIN-REPUTATION-SCORE u0)
(define-constant DEFAULT-STARTING-REPUTATION u50)
(define-constant DEFAULT-DECAY-RATE u10) ;; 10% decay per period
(define-constant MINIMUM_DID_LENGTH u5)

;; STATE VARIABLES

(define-data-var contract-owner principal tx-sender)
(define-data-var contract-active bool true)
(define-data-var decay-rate uint DEFAULT-DECAY-RATE)
(define-data-var decay-period uint u10000) ;; In blocks
(define-data-var starting-reputation uint DEFAULT-STARTING-REPUTATION)

;; DATA STRUCTURES

;; Core identity registry mapping principals to their credibility profiles
(define-map identities
  { owner: principal }
  {
    did: (string-ascii 50), ;; Decentralized Identity
    reputation-score: uint,
    created-at: uint,
    last-updated: uint,
    last-decay: uint,
    total-actions: uint,
    active: bool,
  }
)

;; Configurable credibility action types and their scoring multipliers
(define-map reputation-actions
  { action-type: (string-ascii 50) }
  {
    multiplier: uint,
    description: (string-ascii 100),
    active: bool,
  }
)

;; Comprehensive audit trail for all credibility score changes
(define-map reputation-history
  {
    owner: principal,
    tx-id: uint,
  }
  {
    action-type: (string-ascii 50),
    previous-score: uint,
    new-score: uint,
    timestamp: uint,
    block-height: uint,
  }
)

;; ADMINISTRATIVE FUNCTIONS

;; Transfer contract ownership to a new principal
(define-public (set-contract-owner (new-owner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) (err ERR-NOT-ADMIN))
    ;; Validate new owner is not the same as current owner
    (asserts! (not (is-eq new-owner (var-get contract-owner)))
      (err ERR-INVALID-PARAMETERS)
    )
    ;; Validate new owner is not the zero principal
    (asserts! (not (is-eq new-owner 'ST000000000000000000002AMW42H))
      (err ERR-INVALID-PARAMETERS)
    )
    (var-set contract-owner new-owner)
    (ok true)
  )
)