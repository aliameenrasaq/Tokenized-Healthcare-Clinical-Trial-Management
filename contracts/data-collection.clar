;; Data Collection Contract
;; Securely stores trial results

;; Map to store data entries
(define-map data-entries
  { protocol-id: uint, patient-id: (buff 32), entry-id: uint }
  {
    timestamp: uint,
    data-hash: (buff 32), ;; Hash of the encrypted data
    collector: principal,
    verified: bool
  }
)

;; Map to track entry counts per patient in a protocol
(define-map patient-entry-counts
  { protocol-id: uint, patient-id: (buff 32) }
  uint
)

;; Public function to add a data entry
(define-public (add-data-entry
    (protocol-id uint)
    (patient-id (buff 32))
    (data-hash (buff 32)))
  (let ((patient-key { protocol-id: protocol-id, patient-id: patient-id })
        (current-count (default-to u0 (map-get? patient-entry-counts patient-key)))
        (new-entry-id (+ current-count u1))
        (entry-key { protocol-id: protocol-id, patient-id: patient-id, entry-id: new-entry-id }))
    (begin
      ;; Check if patient is enrolled (would call the enrollment contract in a real implementation)
      ;; For simplicity, we're not making the contract call here

      ;; Record data entry
      (map-set data-entries entry-key
        {
          timestamp: block-height,
          data-hash: data-hash,
          collector: tx-sender,
          verified: false
        }
      )

      ;; Update entry count
      (map-set patient-entry-counts patient-key new-entry-id)

      (ok new-entry-id)
    )
  )
)

;; Public function to verify a data entry
(define-public (verify-data-entry
    (protocol-id uint)
    (patient-id (buff 32))
    (entry-id uint))
  (let ((entry-key { protocol-id: protocol-id, patient-id: patient-id, entry-id: entry-id }))
    (begin
      (asserts! (is-some (map-get? data-entries entry-key)) (err u1)) ;; Entry must exist

      (ok (map-set data-entries entry-key
        (merge (unwrap-panic (map-get? data-entries entry-key))
          { verified: true }
        )
      ))
    )
  )
)

;; Read-only function to get data entry
(define-read-only (get-data-entry (protocol-id uint) (patient-id (buff 32)) (entry-id uint))
  (map-get? data-entries { protocol-id: protocol-id, patient-id: patient-id, entry-id: entry-id })
)

;; Read-only function to get entry count for a patient
(define-read-only (get-patient-entry-count (protocol-id uint) (patient-id (buff 32)))
  (default-to u0 (map-get? patient-entry-counts { protocol-id: protocol-id, patient-id: patient-id }))
)
