(comment "CPSA 2.3.5")
(comment "All input read from completeness-test.scm")

(defprotocol completeness-test basic
  (defrole init
    (vars (a b name) (n text) (s skey))
    (trace (send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s))))
  (defrole resp
    (vars (a b name) (n text))
    (trace (recv (enc a n (pubk b))) (send (enc n (pubk a)))))
  (defrole probe (vars (s skey)) (trace (recv (enc "ok" s)))))

(defskeleton completeness-test
  (vars (n text) (b a name) (s s-0 skey))
  (defstrand init 3 (n n) (a a) (b b) (s s-0))
  (defstrand probe 1 (s s))
  (non-orig s (privk b))
  (uniq-orig n)
  (traces
    ((send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s-0))) ((recv (enc "ok" s))))
  (label 0)
  (unrealized (0 1) (1 0))
  (origs (n (0 0)))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton completeness-test
  (vars (n text) (b a name) (s skey))
  (defstrand init 3 (n n) (a a) (b b) (s s))
  (defstrand probe 1 (s s))
  (precedes ((0 2) (1 0)))
  (non-orig s (privk b))
  (uniq-orig n)
  (operation encryption-test (displaced 2 0 init 3) (enc "ok" s-0)
    (1 0))
  (traces
    ((send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s))) ((recv (enc "ok" s))))
  (label 1)
  (parent 0)
  (unrealized (0 1))
  (origs (n (0 0)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton completeness-test
  (vars (n n-0 text) (b a a-0 b-0 name) (s s-0 skey))
  (defstrand init 3 (n n) (a a) (b b) (s s-0))
  (defstrand probe 1 (s s))
  (defstrand init 3 (n n-0) (a a-0) (b b-0) (s s))
  (precedes ((2 2) (1 0)))
  (non-orig s (privk b))
  (uniq-orig n)
  (operation encryption-test (added-strand init 3) (enc "ok" s) (1 0))
  (traces
    ((send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s-0))) ((recv (enc "ok" s)))
    ((send (enc a-0 n-0 (pubk b-0))) (recv (enc n-0 (pubk a-0)))
      (send (enc "ok" s))))
  (label 2)
  (parent 0)
  (unrealized (0 1))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton completeness-test
  (vars (n text) (b a name) (s skey))
  (defstrand init 3 (n n) (a a) (b b) (s s))
  (defstrand probe 1 (s s))
  (defstrand resp 2 (n n) (a a) (b b))
  (precedes ((0 0) (2 0)) ((0 2) (1 0)) ((2 1) (0 1)))
  (non-orig s (privk b))
  (uniq-orig n)
  (operation nonce-test (added-strand resp 2) n (0 1)
    (enc a n (pubk b)))
  (traces
    ((send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s))) ((recv (enc "ok" s)))
    ((recv (enc a n (pubk b))) (send (enc n (pubk a)))))
  (label 3)
  (parent 1)
  (unrealized)
  (shape)
  (maps ((0 1) ((b b) (n n) (s s) (a a) (s-0 s))))
  (origs (n (0 0))))

(defskeleton completeness-test
  (vars (n n-0 text) (b a a-0 b-0 name) (s s-0 skey))
  (defstrand init 3 (n n) (a a) (b b) (s s-0))
  (defstrand probe 1 (s s))
  (defstrand init 3 (n n-0) (a a-0) (b b-0) (s s))
  (defstrand resp 2 (n n) (a a) (b b))
  (precedes ((0 0) (3 0)) ((2 2) (1 0)) ((3 1) (0 1)))
  (non-orig s (privk b))
  (uniq-orig n)
  (operation nonce-test (added-strand resp 2) n (0 1)
    (enc a n (pubk b)))
  (traces
    ((send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s-0))) ((recv (enc "ok" s)))
    ((send (enc a-0 n-0 (pubk b-0))) (recv (enc n-0 (pubk a-0)))
      (send (enc "ok" s)))
    ((recv (enc a n (pubk b))) (send (enc n (pubk a)))))
  (label 4)
  (parent 2)
  (unrealized)
  (shape)
  (maps ((0 1) ((b b) (n n) (s s) (a a) (s-0 s-0))))
  (origs (n (0 0))))

(comment "Nothing left to do")

(defprotocol completeness-test basic
  (defrole init
    (vars (a b name) (n text) (s skey))
    (trace (send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s))))
  (defrole resp
    (vars (a b name) (n text))
    (trace (recv (enc a n (pubk b))) (send (enc n (pubk a)))))
  (defrole probe (vars (s skey)) (trace (recv (enc "ok" s)))))

(defskeleton completeness-test
  (vars (n text) (b a name) (s s-0 skey))
  (defstrand probe 1 (s s))
  (defstrand init 3 (n n) (a a) (b b) (s s-0))
  (non-orig s (privk b))
  (uniq-orig n)
  (traces ((recv (enc "ok" s)))
    ((send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s-0))))
  (label 5)
  (unrealized (0 0) (1 1))
  (origs (n (1 0)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton completeness-test
  (vars (n text) (b a name) (s s-0 skey))
  (defstrand probe 1 (s s))
  (defstrand init 3 (n n) (a a) (b b) (s s-0))
  (defstrand resp 2 (n n) (a a) (b b))
  (precedes ((1 0) (2 0)) ((2 1) (1 1)))
  (non-orig s (privk b))
  (uniq-orig n)
  (operation nonce-test (added-strand resp 2) n (1 1)
    (enc a n (pubk b)))
  (traces ((recv (enc "ok" s)))
    ((send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s-0)))
    ((recv (enc a n (pubk b))) (send (enc n (pubk a)))))
  (label 6)
  (parent 5)
  (unrealized (0 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton completeness-test
  (vars (n text) (b a name) (s skey))
  (defstrand probe 1 (s s))
  (defstrand init 3 (n n) (a a) (b b) (s s))
  (defstrand resp 2 (n n) (a a) (b b))
  (precedes ((1 0) (2 0)) ((1 2) (0 0)) ((2 1) (1 1)))
  (non-orig s (privk b))
  (uniq-orig n)
  (operation encryption-test (displaced 3 1 init 3) (enc "ok" s-0)
    (0 0))
  (traces ((recv (enc "ok" s)))
    ((send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s)))
    ((recv (enc a n (pubk b))) (send (enc n (pubk a)))))
  (label 7)
  (parent 6)
  (unrealized)
  (shape)
  (maps ((0 1) ((b b) (n n) (s s) (a a) (s-0 s))))
  (origs (n (1 0))))

(defskeleton completeness-test
  (vars (n n-0 text) (b a a-0 b-0 name) (s s-0 skey))
  (defstrand probe 1 (s s))
  (defstrand init 3 (n n) (a a) (b b) (s s-0))
  (defstrand resp 2 (n n) (a a) (b b))
  (defstrand init 3 (n n-0) (a a-0) (b b-0) (s s))
  (precedes ((1 0) (2 0)) ((2 1) (1 1)) ((3 2) (0 0)))
  (non-orig s (privk b))
  (uniq-orig n)
  (operation encryption-test (added-strand init 3) (enc "ok" s) (0 0))
  (traces ((recv (enc "ok" s)))
    ((send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s-0)))
    ((recv (enc a n (pubk b))) (send (enc n (pubk a))))
    ((send (enc a-0 n-0 (pubk b-0))) (recv (enc n-0 (pubk a-0)))
      (send (enc "ok" s))))
  (label 8)
  (parent 6)
  (unrealized)
  (shape)
  (maps ((0 1) ((b b) (n n) (s s) (a a) (s-0 s-0))))
  (origs (n (1 0))))

(comment "Nothing left to do")

(defprotocol completeness-test basic
  (defrole init
    (vars (a b name) (n text) (s skey))
    (trace (send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s))))
  (defrole resp
    (vars (a b name) (n text))
    (trace (recv (enc a n (pubk b))) (send (enc n (pubk a)))))
  (defrole probe (vars (s skey)) (trace (recv (enc "ok" s)))))

(defskeleton completeness-test
  (vars (n text) (b a name) (s skey))
  (defstrand init 2 (n n) (a a) (b b))
  (defstrand probe 1 (s s))
  (non-orig s (privk b))
  (uniq-orig n)
  (traces ((send (enc a n (pubk b))) (recv (enc n (pubk a))))
    ((recv (enc "ok" s))))
  (label 9)
  (unrealized (0 1) (1 0))
  (origs (n (0 0)))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton completeness-test
  (vars (n text) (a b name) (s skey))
  (defstrand probe 1 (s s))
  (defstrand init 3 (n n) (a a) (b b) (s s))
  (precedes ((1 2) (0 0)))
  (non-orig s (privk b))
  (uniq-orig n)
  (operation encryption-test (displaced 0 2 init 3) (enc "ok" s) (1 0))
  (traces ((recv (enc "ok" s)))
    ((send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s))))
  (label 10)
  (parent 9)
  (unrealized (1 1))
  (origs (n (1 0)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton completeness-test
  (vars (n n-0 text) (b a a-0 b-0 name) (s skey))
  (defstrand init 2 (n n) (a a) (b b))
  (defstrand probe 1 (s s))
  (defstrand init 3 (n n-0) (a a-0) (b b-0) (s s))
  (precedes ((2 2) (1 0)))
  (non-orig s (privk b))
  (uniq-orig n)
  (operation encryption-test (added-strand init 3) (enc "ok" s) (1 0))
  (traces ((send (enc a n (pubk b))) (recv (enc n (pubk a))))
    ((recv (enc "ok" s)))
    ((send (enc a-0 n-0 (pubk b-0))) (recv (enc n-0 (pubk a-0)))
      (send (enc "ok" s))))
  (label 11)
  (parent 9)
  (unrealized (0 1))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton completeness-test
  (vars (n text) (a b name) (s skey))
  (defstrand probe 1 (s s))
  (defstrand init 3 (n n) (a a) (b b) (s s))
  (defstrand resp 2 (n n) (a a) (b b))
  (precedes ((1 0) (2 0)) ((1 2) (0 0)) ((2 1) (1 1)))
  (non-orig s (privk b))
  (uniq-orig n)
  (operation nonce-test (added-strand resp 2) n (1 1)
    (enc a n (pubk b)))
  (traces ((recv (enc "ok" s)))
    ((send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s)))
    ((recv (enc a n (pubk b))) (send (enc n (pubk a)))))
  (label 12)
  (parent 10)
  (unrealized)
  (shape)
  (maps ((1 0) ((b b) (n n) (s s) (a a))))
  (origs (n (1 0))))

(defskeleton completeness-test
  (vars (n n-0 text) (b a a-0 b-0 name) (s skey))
  (defstrand init 2 (n n) (a a) (b b))
  (defstrand probe 1 (s s))
  (defstrand init 3 (n n-0) (a a-0) (b b-0) (s s))
  (defstrand resp 2 (n n) (a a) (b b))
  (precedes ((0 0) (3 0)) ((2 2) (1 0)) ((3 1) (0 1)))
  (non-orig s (privk b))
  (uniq-orig n)
  (operation nonce-test (added-strand resp 2) n (0 1)
    (enc a n (pubk b)))
  (traces ((send (enc a n (pubk b))) (recv (enc n (pubk a))))
    ((recv (enc "ok" s)))
    ((send (enc a-0 n-0 (pubk b-0))) (recv (enc n-0 (pubk a-0)))
      (send (enc "ok" s)))
    ((recv (enc a n (pubk b))) (send (enc n (pubk a)))))
  (label 13)
  (parent 11)
  (unrealized)
  (shape)
  (maps ((0 1) ((b b) (n n) (s s) (a a))))
  (origs (n (0 0))))

(comment "Nothing left to do")

(defprotocol completeness-test basic
  (defrole init
    (vars (a b name) (n text) (s skey))
    (trace (send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s))))
  (defrole resp
    (vars (a b name) (n text))
    (trace (recv (enc a n (pubk b))) (send (enc n (pubk a)))))
  (defrole probe (vars (s skey)) (trace (recv (enc "ok" s)))))

(defskeleton completeness-test
  (vars (n text) (b a name) (s skey))
  (defstrand probe 1 (s s))
  (defstrand init 2 (n n) (a a) (b b))
  (non-orig s (privk b))
  (uniq-orig n)
  (traces ((recv (enc "ok" s)))
    ((send (enc a n (pubk b))) (recv (enc n (pubk a)))))
  (label 14)
  (unrealized (0 0) (1 1))
  (origs (n (1 0)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton completeness-test
  (vars (n text) (b a name) (s skey))
  (defstrand probe 1 (s s))
  (defstrand init 2 (n n) (a a) (b b))
  (defstrand resp 2 (n n) (a a) (b b))
  (precedes ((1 0) (2 0)) ((2 1) (1 1)))
  (non-orig s (privk b))
  (uniq-orig n)
  (operation nonce-test (added-strand resp 2) n (1 1)
    (enc a n (pubk b)))
  (traces ((recv (enc "ok" s)))
    ((send (enc a n (pubk b))) (recv (enc n (pubk a))))
    ((recv (enc a n (pubk b))) (send (enc n (pubk a)))))
  (label 15)
  (parent 14)
  (unrealized (0 0))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton completeness-test
  (vars (n text) (a b name) (s skey))
  (defstrand probe 1 (s s))
  (defstrand resp 2 (n n) (a a) (b b))
  (defstrand init 3 (n n) (a a) (b b) (s s))
  (precedes ((1 1) (2 1)) ((2 0) (1 0)) ((2 2) (0 0)))
  (non-orig s (privk b))
  (uniq-orig n)
  (operation encryption-test (displaced 1 3 init 3) (enc "ok" s) (0 0))
  (traces ((recv (enc "ok" s)))
    ((recv (enc a n (pubk b))) (send (enc n (pubk a))))
    ((send (enc a n (pubk b))) (recv (enc n (pubk a)))
      (send (enc "ok" s))))
  (label 16)
  (parent 15)
  (unrealized)
  (shape)
  (maps ((0 2) ((b b) (n n) (s s) (a a))))
  (origs (n (2 0))))

(defskeleton completeness-test
  (vars (n n-0 text) (b a a-0 b-0 name) (s skey))
  (defstrand probe 1 (s s))
  (defstrand init 2 (n n) (a a) (b b))
  (defstrand resp 2 (n n) (a a) (b b))
  (defstrand init 3 (n n-0) (a a-0) (b b-0) (s s))
  (precedes ((1 0) (2 0)) ((2 1) (1 1)) ((3 2) (0 0)))
  (non-orig s (privk b))
  (uniq-orig n)
  (operation encryption-test (added-strand init 3) (enc "ok" s) (0 0))
  (traces ((recv (enc "ok" s)))
    ((send (enc a n (pubk b))) (recv (enc n (pubk a))))
    ((recv (enc a n (pubk b))) (send (enc n (pubk a))))
    ((send (enc a-0 n-0 (pubk b-0))) (recv (enc n-0 (pubk a-0)))
      (send (enc "ok" s))))
  (label 17)
  (parent 15)
  (unrealized)
  (shape)
  (maps ((0 1) ((b b) (n n) (s s) (a a))))
  (origs (n (1 0))))

(comment "Nothing left to do")
