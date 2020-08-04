(herald "Blanchet's Simple Example Protocol"
  (comment "There is a flaw in this protocol by design"))

(comment "CPSA 4.2.3")
(comment "All input read from tst/blanchet.scm")

(defprotocol blanchet basic
  (defrole init
    (vars (a b name) (s skey) (d data))
    (trace (send (enc (enc s (privk a)) (pubk b))) (recv (enc d s))))
  (defrole resp
    (vars (a b name) (s skey) (d data))
    (trace (recv (enc (enc s (privk a)) (pubk b))) (send (enc d s))))
  (defrule cakeRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (leads-to z0 i0 z1 i1)
          (leads-to z0 i0 z2 i2) (prec z1 i1 z2 i2))
        (false))))
  (defrule no-interruption
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (leads-to z0 i0 z2 i2) (trans z1 i1)
          (same-locn z0 i0 z1 i1) (prec z0 i0 z1 i1) (prec z1 i1 z2 i2))
        (false))))
  (defrule neqRl_mesg
    (forall ((x mesg)) (implies (fact neq x x) (false))))
  (defrule neqRl_strd
    (forall ((x strd)) (implies (fact neq x x) (false))))
  (defrule neqRl_indx
    (forall ((x indx)) (implies (fact neq x x) (false))))
  (defrule scissorsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (leads-to z0 i0 z2 i2))
        (and (= z1 z2) (= i1 i2)))))
  (defrule shearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (same-locn z0 i0 z2 i2)
          (prec z0 i0 z2 i2))
        (or (and (= z1 z2) (= i1 i2)) (prec z1 i1 z2 i2)))))
  (defrule invShearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (same-locn z0 i0 z1 i1)
          (leads-to z1 i1 z2 i2) (prec z0 i0 z2 i2))
        (or (and (= z0 z1) (= i0 i1)) (prec z0 i0 z1 i1)))))
  (comment "Blanchet's protocol using named asymmetric keys"))

(defskeleton blanchet
  (vars (d data) (a b name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (non-orig (privk b))
  (uniq-orig s)
  (comment "Analyze from the initiator's perspective")
  (traces ((send (enc (enc s (privk a)) (pubk b))) (recv (enc d s))))
  (label 0)
  (unrealized (0 1))
  (origs (s (0 0)))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton blanchet
  (vars (d data) (a b a-0 b-0 name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (defstrand resp 2 (d d) (a a-0) (b b-0) (s s))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (privk b))
  (uniq-orig s)
  (operation encryption-test (added-strand resp 2) (enc d s) (0 1))
  (traces ((send (enc (enc s (privk a)) (pubk b))) (recv (enc d s)))
    ((recv (enc (enc s (privk a-0)) (pubk b-0))) (send (enc d s))))
  (label 1)
  (parent 0)
  (unrealized (1 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet
  (vars (d data) (a b name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (deflistener s)
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (privk b))
  (uniq-orig s)
  (operation encryption-test (added-listener s) (enc d s) (0 1))
  (traces ((send (enc (enc s (privk a)) (pubk b))) (recv (enc d s)))
    ((recv s) (send s)))
  (label 2)
  (parent 0)
  (unrealized (1 0))
  (dead)
  (comment "empty cohort"))

(defskeleton blanchet
  (vars (d data) (a b name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (privk b))
  (uniq-orig s)
  (operation nonce-test (contracted (a-0 a) (b-0 b)) s (1 0)
    (enc (enc s (privk a)) (pubk b)))
  (traces ((send (enc (enc s (privk a)) (pubk b))) (recv (enc d s)))
    ((recv (enc (enc s (privk a)) (pubk b))) (send (enc d s))))
  (label 3)
  (parent 1)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (s s) (d d))))
  (origs (s (0 0))))

(comment "Nothing left to do")

(defprotocol blanchet basic
  (defrole init
    (vars (a b name) (s skey) (d data))
    (trace (send (enc (enc s (privk a)) (pubk b))) (recv (enc d s))))
  (defrole resp
    (vars (a b name) (s skey) (d data))
    (trace (recv (enc (enc s (privk a)) (pubk b))) (send (enc d s))))
  (defrule cakeRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (leads-to z0 i0 z1 i1)
          (leads-to z0 i0 z2 i2) (prec z1 i1 z2 i2))
        (false))))
  (defrule no-interruption
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (leads-to z0 i0 z2 i2) (trans z1 i1)
          (same-locn z0 i0 z1 i1) (prec z0 i0 z1 i1) (prec z1 i1 z2 i2))
        (false))))
  (defrule neqRl_mesg
    (forall ((x mesg)) (implies (fact neq x x) (false))))
  (defrule neqRl_strd
    (forall ((x strd)) (implies (fact neq x x) (false))))
  (defrule neqRl_indx
    (forall ((x indx)) (implies (fact neq x x) (false))))
  (defrule scissorsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (leads-to z0 i0 z2 i2))
        (and (= z1 z2) (= i1 i2)))))
  (defrule shearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (same-locn z0 i0 z2 i2)
          (prec z0 i0 z2 i2))
        (or (and (= z1 z2) (= i1 i2)) (prec z1 i1 z2 i2)))))
  (defrule invShearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (same-locn z0 i0 z1 i1)
          (leads-to z1 i1 z2 i2) (prec z0 i0 z2 i2))
        (or (and (= z0 z1) (= i0 i1)) (prec z0 i0 z1 i1)))))
  (comment "Blanchet's protocol using named asymmetric keys"))

(defskeleton blanchet
  (vars (d data) (a b name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (non-orig (privk b))
  (uniq-orig d s)
  (comment "From the initiator's perspective, is the secret leaked?")
  (traces ((send (enc (enc s (privk a)) (pubk b))) (recv (enc d s)))
    ((recv d) (send d)))
  (label 4)
  (unrealized (0 1))
  (origs (s (0 0)))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton blanchet
  (vars (d data) (a b a-0 b-0 name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (defstrand resp 2 (d d) (a a-0) (b b-0) (s s))
  (precedes ((0 0) (2 0)) ((2 1) (0 1)) ((2 1) (1 0)))
  (non-orig (privk b))
  (uniq-orig d s)
  (operation encryption-test (added-strand resp 2) (enc d s) (0 1))
  (traces ((send (enc (enc s (privk a)) (pubk b))) (recv (enc d s)))
    ((recv d) (send d))
    ((recv (enc (enc s (privk a-0)) (pubk b-0))) (send (enc d s))))
  (label 5)
  (parent 4)
  (unrealized (1 0) (2 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet
  (vars (d data) (a b name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (deflistener s)
  (precedes ((0 0) (2 0)) ((2 1) (0 1)))
  (non-orig (privk b))
  (uniq-orig d s)
  (operation encryption-test (added-listener s) (enc d s) (0 1))
  (traces ((send (enc (enc s (privk a)) (pubk b))) (recv (enc d s)))
    ((recv d) (send d)) ((recv s) (send s)))
  (label 6)
  (parent 4)
  (unrealized (2 0))
  (dead)
  (comment "empty cohort"))

(defskeleton blanchet
  (vars (d data) (a b name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (precedes ((0 0) (2 0)) ((2 1) (0 1)) ((2 1) (1 0)))
  (non-orig (privk b))
  (uniq-orig d s)
  (operation nonce-test (contracted (a-0 a) (b-0 b)) s (2 0)
    (enc (enc s (privk a)) (pubk b)))
  (traces ((send (enc (enc s (privk a)) (pubk b))) (recv (enc d s)))
    ((recv d) (send d))
    ((recv (enc (enc s (privk a)) (pubk b))) (send (enc d s))))
  (label 7)
  (parent 5)
  (unrealized (1 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet
  (vars (d data) (a b name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (deflistener s)
  (precedes ((0 0) (2 0)) ((0 0) (3 0)) ((2 1) (0 1)) ((2 1) (1 0))
    ((3 1) (1 0)))
  (non-orig (privk b))
  (uniq-orig d s)
  (operation nonce-test (added-listener s) d (1 0) (enc d s))
  (traces ((send (enc (enc s (privk a)) (pubk b))) (recv (enc d s)))
    ((recv d) (send d))
    ((recv (enc (enc s (privk a)) (pubk b))) (send (enc d s)))
    ((recv s) (send s)))
  (label 8)
  (parent 7)
  (unrealized (3 0))
  (dead)
  (comment "empty cohort"))

(comment "Nothing left to do")

(defprotocol blanchet basic
  (defrole init
    (vars (a b name) (s skey) (d data))
    (trace (send (enc (enc s (privk a)) (pubk b))) (recv (enc d s))))
  (defrole resp
    (vars (a b name) (s skey) (d data))
    (trace (recv (enc (enc s (privk a)) (pubk b))) (send (enc d s))))
  (defrule cakeRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (leads-to z0 i0 z1 i1)
          (leads-to z0 i0 z2 i2) (prec z1 i1 z2 i2))
        (false))))
  (defrule no-interruption
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (leads-to z0 i0 z2 i2) (trans z1 i1)
          (same-locn z0 i0 z1 i1) (prec z0 i0 z1 i1) (prec z1 i1 z2 i2))
        (false))))
  (defrule neqRl_mesg
    (forall ((x mesg)) (implies (fact neq x x) (false))))
  (defrule neqRl_strd
    (forall ((x strd)) (implies (fact neq x x) (false))))
  (defrule neqRl_indx
    (forall ((x indx)) (implies (fact neq x x) (false))))
  (defrule scissorsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (leads-to z0 i0 z2 i2))
        (and (= z1 z2) (= i1 i2)))))
  (defrule shearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (same-locn z0 i0 z2 i2)
          (prec z0 i0 z2 i2))
        (or (and (= z1 z2) (= i1 i2)) (prec z1 i1 z2 i2)))))
  (defrule invShearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (same-locn z0 i0 z1 i1)
          (leads-to z1 i1 z2 i2) (prec z0 i0 z2 i2))
        (or (and (= z0 z1) (= i0 i1)) (prec z0 i0 z1 i1)))))
  (comment "Blanchet's protocol using named asymmetric keys"))

(defskeleton blanchet
  (vars (d data) (a b name) (s skey))
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (non-orig (privk a) (privk b))
  (uniq-orig s)
  (comment "Analyze from the responder's perspective")
  (traces ((recv (enc (enc s (privk a)) (pubk b))) (send (enc d s))))
  (label 9)
  (unrealized (0 0))
  (origs)
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet
  (vars (d data) (a b b-0 name) (s skey))
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (defstrand init 1 (a a) (b b-0) (s s))
  (precedes ((1 0) (0 0)))
  (non-orig (privk a) (privk b))
  (uniq-orig s)
  (operation encryption-test (added-strand init 1) (enc s (privk a))
    (0 0))
  (traces ((recv (enc (enc s (privk a)) (pubk b))) (send (enc d s)))
    ((send (enc (enc s (privk a)) (pubk b-0)))))
  (label 10)
  (parent 9)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (s s) (d d))))
  (origs (s (1 0))))

(comment "Nothing left to do")

(defprotocol blanchet basic
  (defrole init
    (vars (a b name) (s skey) (d data))
    (trace (send (enc (enc s (privk a)) (pubk b))) (recv (enc d s))))
  (defrole resp
    (vars (a b name) (s skey) (d data))
    (trace (recv (enc (enc s (privk a)) (pubk b))) (send (enc d s))))
  (defrule cakeRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (leads-to z0 i0 z1 i1)
          (leads-to z0 i0 z2 i2) (prec z1 i1 z2 i2))
        (false))))
  (defrule no-interruption
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (leads-to z0 i0 z2 i2) (trans z1 i1)
          (same-locn z0 i0 z1 i1) (prec z0 i0 z1 i1) (prec z1 i1 z2 i2))
        (false))))
  (defrule neqRl_mesg
    (forall ((x mesg)) (implies (fact neq x x) (false))))
  (defrule neqRl_strd
    (forall ((x strd)) (implies (fact neq x x) (false))))
  (defrule neqRl_indx
    (forall ((x indx)) (implies (fact neq x x) (false))))
  (defrule scissorsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (leads-to z0 i0 z2 i2))
        (and (= z1 z2) (= i1 i2)))))
  (defrule shearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (same-locn z0 i0 z2 i2)
          (prec z0 i0 z2 i2))
        (or (and (= z1 z2) (= i1 i2)) (prec z1 i1 z2 i2)))))
  (defrule invShearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (same-locn z0 i0 z1 i1)
          (leads-to z1 i1 z2 i2) (prec z0 i0 z2 i2))
        (or (and (= z0 z1) (= i0 i1)) (prec z0 i0 z1 i1)))))
  (comment "Blanchet's protocol using named asymmetric keys"))

(defskeleton blanchet
  (vars (d data) (a b name) (s skey))
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (non-orig (privk a) (privk b))
  (uniq-orig d s)
  (comment "From the responders's perspective, is the secret leaked?")
  (traces ((recv (enc (enc s (privk a)) (pubk b))) (send (enc d s)))
    ((recv d) (send d)))
  (label 11)
  (unrealized (0 0) (1 0))
  (preskeleton)
  (origs (d (0 1)))
  (comment "Not a skeleton"))

(defskeleton blanchet
  (vars (d data) (a b name) (s skey))
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (precedes ((0 1) (1 0)))
  (non-orig (privk a) (privk b))
  (uniq-orig d s)
  (traces ((recv (enc (enc s (privk a)) (pubk b))) (send (enc d s)))
    ((recv d) (send d)))
  (label 12)
  (parent 11)
  (unrealized (0 0))
  (origs (d (0 1)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet
  (vars (d data) (a b b-0 name) (s skey))
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (defstrand init 1 (a a) (b b-0) (s s))
  (precedes ((0 1) (1 0)) ((2 0) (0 0)))
  (non-orig (privk a) (privk b))
  (uniq-orig d s)
  (operation encryption-test (added-strand init 1) (enc s (privk a))
    (0 0))
  (traces ((recv (enc (enc s (privk a)) (pubk b))) (send (enc d s)))
    ((recv d) (send d)) ((send (enc (enc s (privk a)) (pubk b-0)))))
  (label 13)
  (parent 12)
  (unrealized)
  (shape)
  (maps ((0 1) ((a a) (b b) (s s) (d d))))
  (origs (s (2 0)) (d (0 1))))

(comment "Nothing left to do")

(defprotocol blanchet-akey basic
  (defrole init
    (vars (a b akey) (s skey) (d data))
    (trace (send (enc (enc s (invk a)) b)) (recv (enc d s))))
  (defrole resp
    (vars (a b akey) (s skey) (d data))
    (trace (recv (enc (enc s (invk a)) b)) (send (enc d s))))
  (defrule cakeRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (leads-to z0 i0 z1 i1)
          (leads-to z0 i0 z2 i2) (prec z1 i1 z2 i2))
        (false))))
  (defrule no-interruption
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (leads-to z0 i0 z2 i2) (trans z1 i1)
          (same-locn z0 i0 z1 i1) (prec z0 i0 z1 i1) (prec z1 i1 z2 i2))
        (false))))
  (defrule neqRl_mesg
    (forall ((x mesg)) (implies (fact neq x x) (false))))
  (defrule neqRl_strd
    (forall ((x strd)) (implies (fact neq x x) (false))))
  (defrule neqRl_indx
    (forall ((x indx)) (implies (fact neq x x) (false))))
  (defrule scissorsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (leads-to z0 i0 z2 i2))
        (and (= z1 z2) (= i1 i2)))))
  (defrule shearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (same-locn z0 i0 z2 i2)
          (prec z0 i0 z2 i2))
        (or (and (= z1 z2) (= i1 i2)) (prec z1 i1 z2 i2)))))
  (defrule invShearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (same-locn z0 i0 z1 i1)
          (leads-to z1 i1 z2 i2) (prec z0 i0 z2 i2))
        (or (and (= z0 z1) (= i0 i1)) (prec z0 i0 z1 i1)))))
  (comment "Blanchet's protocol using unnamed asymmetric keys"))

(defskeleton blanchet-akey
  (vars (d data) (s skey) (a b akey))
  (defstrand init 2 (d d) (s s) (a a) (b b))
  (non-orig (invk b))
  (uniq-orig s)
  (comment "Analyze from the initiator's perspective")
  (traces ((send (enc (enc s (invk a)) b)) (recv (enc d s))))
  (label 14)
  (unrealized (0 1))
  (origs (s (0 0)))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton blanchet-akey
  (vars (d data) (s skey) (a b a-0 b-0 akey))
  (defstrand init 2 (d d) (s s) (a a) (b b))
  (defstrand resp 2 (d d) (s s) (a a-0) (b b-0))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (invk b))
  (uniq-orig s)
  (operation encryption-test (added-strand resp 2) (enc d s) (0 1))
  (traces ((send (enc (enc s (invk a)) b)) (recv (enc d s)))
    ((recv (enc (enc s (invk a-0)) b-0)) (send (enc d s))))
  (label 15)
  (parent 14)
  (unrealized (1 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet-akey
  (vars (d data) (s skey) (a b akey))
  (defstrand init 2 (d d) (s s) (a a) (b b))
  (deflistener s)
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (invk b))
  (uniq-orig s)
  (operation encryption-test (added-listener s) (enc d s) (0 1))
  (traces ((send (enc (enc s (invk a)) b)) (recv (enc d s)))
    ((recv s) (send s)))
  (label 16)
  (parent 14)
  (unrealized (1 0))
  (dead)
  (comment "empty cohort"))

(defskeleton blanchet-akey
  (vars (d data) (s skey) (a b akey))
  (defstrand init 2 (d d) (s s) (a a) (b b))
  (defstrand resp 2 (d d) (s s) (a a) (b b))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (invk b))
  (uniq-orig s)
  (operation nonce-test (contracted (a-0 a) (b-0 b)) s (1 0)
    (enc (enc s (invk a)) b))
  (traces ((send (enc (enc s (invk a)) b)) (recv (enc d s)))
    ((recv (enc (enc s (invk a)) b)) (send (enc d s))))
  (label 17)
  (parent 15)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (s s) (d d))))
  (origs (s (0 0))))

(comment "Nothing left to do")

(defprotocol blanchet-akey basic
  (defrole init
    (vars (a b akey) (s skey) (d data))
    (trace (send (enc (enc s (invk a)) b)) (recv (enc d s))))
  (defrole resp
    (vars (a b akey) (s skey) (d data))
    (trace (recv (enc (enc s (invk a)) b)) (send (enc d s))))
  (defrule cakeRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (leads-to z0 i0 z1 i1)
          (leads-to z0 i0 z2 i2) (prec z1 i1 z2 i2))
        (false))))
  (defrule no-interruption
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (leads-to z0 i0 z2 i2) (trans z1 i1)
          (same-locn z0 i0 z1 i1) (prec z0 i0 z1 i1) (prec z1 i1 z2 i2))
        (false))))
  (defrule neqRl_mesg
    (forall ((x mesg)) (implies (fact neq x x) (false))))
  (defrule neqRl_strd
    (forall ((x strd)) (implies (fact neq x x) (false))))
  (defrule neqRl_indx
    (forall ((x indx)) (implies (fact neq x x) (false))))
  (defrule scissorsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (leads-to z0 i0 z2 i2))
        (and (= z1 z2) (= i1 i2)))))
  (defrule shearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (same-locn z0 i0 z2 i2)
          (prec z0 i0 z2 i2))
        (or (and (= z1 z2) (= i1 i2)) (prec z1 i1 z2 i2)))))
  (defrule invShearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (same-locn z0 i0 z1 i1)
          (leads-to z1 i1 z2 i2) (prec z0 i0 z2 i2))
        (or (and (= z0 z1) (= i0 i1)) (prec z0 i0 z1 i1)))))
  (comment "Blanchet's protocol using unnamed asymmetric keys"))

(defskeleton blanchet-akey
  (vars (d data) (s skey) (a b akey))
  (defstrand init 2 (d d) (s s) (a a) (b b))
  (deflistener d)
  (non-orig (invk b))
  (uniq-orig d s)
  (comment "From the initiator's perspective, is the secret leaked?")
  (traces ((send (enc (enc s (invk a)) b)) (recv (enc d s)))
    ((recv d) (send d)))
  (label 18)
  (unrealized (0 1))
  (origs (s (0 0)))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton blanchet-akey
  (vars (d data) (s skey) (a b a-0 b-0 akey))
  (defstrand init 2 (d d) (s s) (a a) (b b))
  (deflistener d)
  (defstrand resp 2 (d d) (s s) (a a-0) (b b-0))
  (precedes ((0 0) (2 0)) ((2 1) (0 1)) ((2 1) (1 0)))
  (non-orig (invk b))
  (uniq-orig d s)
  (operation encryption-test (added-strand resp 2) (enc d s) (0 1))
  (traces ((send (enc (enc s (invk a)) b)) (recv (enc d s)))
    ((recv d) (send d))
    ((recv (enc (enc s (invk a-0)) b-0)) (send (enc d s))))
  (label 19)
  (parent 18)
  (unrealized (1 0) (2 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet-akey
  (vars (d data) (s skey) (a b akey))
  (defstrand init 2 (d d) (s s) (a a) (b b))
  (deflistener d)
  (deflistener s)
  (precedes ((0 0) (2 0)) ((2 1) (0 1)))
  (non-orig (invk b))
  (uniq-orig d s)
  (operation encryption-test (added-listener s) (enc d s) (0 1))
  (traces ((send (enc (enc s (invk a)) b)) (recv (enc d s)))
    ((recv d) (send d)) ((recv s) (send s)))
  (label 20)
  (parent 18)
  (unrealized (2 0))
  (dead)
  (comment "empty cohort"))

(defskeleton blanchet-akey
  (vars (d data) (s skey) (a b akey))
  (defstrand init 2 (d d) (s s) (a a) (b b))
  (deflistener d)
  (defstrand resp 2 (d d) (s s) (a a) (b b))
  (precedes ((0 0) (2 0)) ((2 1) (0 1)) ((2 1) (1 0)))
  (non-orig (invk b))
  (uniq-orig d s)
  (operation nonce-test (contracted (a-0 a) (b-0 b)) s (2 0)
    (enc (enc s (invk a)) b))
  (traces ((send (enc (enc s (invk a)) b)) (recv (enc d s)))
    ((recv d) (send d))
    ((recv (enc (enc s (invk a)) b)) (send (enc d s))))
  (label 21)
  (parent 19)
  (unrealized (1 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet-akey
  (vars (d data) (s skey) (a b akey))
  (defstrand init 2 (d d) (s s) (a a) (b b))
  (deflistener d)
  (defstrand resp 2 (d d) (s s) (a a) (b b))
  (deflistener s)
  (precedes ((0 0) (2 0)) ((0 0) (3 0)) ((2 1) (0 1)) ((2 1) (1 0))
    ((3 1) (1 0)))
  (non-orig (invk b))
  (uniq-orig d s)
  (operation nonce-test (added-listener s) d (1 0) (enc d s))
  (traces ((send (enc (enc s (invk a)) b)) (recv (enc d s)))
    ((recv d) (send d))
    ((recv (enc (enc s (invk a)) b)) (send (enc d s)))
    ((recv s) (send s)))
  (label 22)
  (parent 21)
  (unrealized (3 0))
  (dead)
  (comment "empty cohort"))

(comment "Nothing left to do")

(defprotocol blanchet-akey basic
  (defrole init
    (vars (a b akey) (s skey) (d data))
    (trace (send (enc (enc s (invk a)) b)) (recv (enc d s))))
  (defrole resp
    (vars (a b akey) (s skey) (d data))
    (trace (recv (enc (enc s (invk a)) b)) (send (enc d s))))
  (defrule cakeRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (leads-to z0 i0 z1 i1)
          (leads-to z0 i0 z2 i2) (prec z1 i1 z2 i2))
        (false))))
  (defrule no-interruption
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (leads-to z0 i0 z2 i2) (trans z1 i1)
          (same-locn z0 i0 z1 i1) (prec z0 i0 z1 i1) (prec z1 i1 z2 i2))
        (false))))
  (defrule neqRl_mesg
    (forall ((x mesg)) (implies (fact neq x x) (false))))
  (defrule neqRl_strd
    (forall ((x strd)) (implies (fact neq x x) (false))))
  (defrule neqRl_indx
    (forall ((x indx)) (implies (fact neq x x) (false))))
  (defrule scissorsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (leads-to z0 i0 z2 i2))
        (and (= z1 z2) (= i1 i2)))))
  (defrule shearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (same-locn z0 i0 z2 i2)
          (prec z0 i0 z2 i2))
        (or (and (= z1 z2) (= i1 i2)) (prec z1 i1 z2 i2)))))
  (defrule invShearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (same-locn z0 i0 z1 i1)
          (leads-to z1 i1 z2 i2) (prec z0 i0 z2 i2))
        (or (and (= z0 z1) (= i0 i1)) (prec z0 i0 z1 i1)))))
  (comment "Blanchet's protocol using unnamed asymmetric keys"))

(defskeleton blanchet-akey
  (vars (d data) (s skey) (a b akey))
  (defstrand resp 2 (d d) (s s) (a a) (b b))
  (non-orig (invk a) (invk b))
  (uniq-orig s)
  (comment "Analyze from the responder's perspective")
  (traces ((recv (enc (enc s (invk a)) b)) (send (enc d s))))
  (label 23)
  (unrealized (0 0))
  (origs)
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet-akey
  (vars (d data) (s skey) (a b b-0 akey))
  (defstrand resp 2 (d d) (s s) (a a) (b b))
  (defstrand init 1 (s s) (a a) (b b-0))
  (precedes ((1 0) (0 0)))
  (non-orig (invk a) (invk b))
  (uniq-orig s)
  (operation encryption-test (added-strand init 1) (enc s (invk a))
    (0 0))
  (traces ((recv (enc (enc s (invk a)) b)) (send (enc d s)))
    ((send (enc (enc s (invk a)) b-0))))
  (label 24)
  (parent 23)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (s s) (d d))))
  (origs (s (1 0))))

(comment "Nothing left to do")

(defprotocol blanchet-akey basic
  (defrole init
    (vars (a b akey) (s skey) (d data))
    (trace (send (enc (enc s (invk a)) b)) (recv (enc d s))))
  (defrole resp
    (vars (a b akey) (s skey) (d data))
    (trace (recv (enc (enc s (invk a)) b)) (send (enc d s))))
  (defrule cakeRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (leads-to z0 i0 z1 i1)
          (leads-to z0 i0 z2 i2) (prec z1 i1 z2 i2))
        (false))))
  (defrule no-interruption
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (leads-to z0 i0 z2 i2) (trans z1 i1)
          (same-locn z0 i0 z1 i1) (prec z0 i0 z1 i1) (prec z1 i1 z2 i2))
        (false))))
  (defrule neqRl_mesg
    (forall ((x mesg)) (implies (fact neq x x) (false))))
  (defrule neqRl_strd
    (forall ((x strd)) (implies (fact neq x x) (false))))
  (defrule neqRl_indx
    (forall ((x indx)) (implies (fact neq x x) (false))))
  (defrule scissorsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (leads-to z0 i0 z2 i2))
        (and (= z1 z2) (= i1 i2)))))
  (defrule shearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (same-locn z0 i0 z2 i2)
          (prec z0 i0 z2 i2))
        (or (and (= z1 z2) (= i1 i2)) (prec z1 i1 z2 i2)))))
  (defrule invShearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (same-locn z0 i0 z1 i1)
          (leads-to z1 i1 z2 i2) (prec z0 i0 z2 i2))
        (or (and (= z0 z1) (= i0 i1)) (prec z0 i0 z1 i1)))))
  (comment "Blanchet's protocol using unnamed asymmetric keys"))

(defskeleton blanchet-akey
  (vars (d data) (s skey) (a b akey))
  (defstrand resp 2 (d d) (s s) (a a) (b b))
  (deflistener d)
  (non-orig (invk a) (invk b))
  (uniq-orig d s)
  (comment "From the responders's perspective, is the secret leaked?")
  (traces ((recv (enc (enc s (invk a)) b)) (send (enc d s)))
    ((recv d) (send d)))
  (label 25)
  (unrealized (0 0) (1 0))
  (preskeleton)
  (origs (d (0 1)))
  (comment "Not a skeleton"))

(defskeleton blanchet-akey
  (vars (d data) (s skey) (a b akey))
  (defstrand resp 2 (d d) (s s) (a a) (b b))
  (deflistener d)
  (precedes ((0 1) (1 0)))
  (non-orig (invk a) (invk b))
  (uniq-orig d s)
  (traces ((recv (enc (enc s (invk a)) b)) (send (enc d s)))
    ((recv d) (send d)))
  (label 26)
  (parent 25)
  (unrealized (0 0))
  (origs (d (0 1)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet-akey
  (vars (d data) (s skey) (a b b-0 akey))
  (defstrand resp 2 (d d) (s s) (a a) (b b))
  (deflistener d)
  (defstrand init 1 (s s) (a a) (b b-0))
  (precedes ((0 1) (1 0)) ((2 0) (0 0)))
  (non-orig (invk a) (invk b))
  (uniq-orig d s)
  (operation encryption-test (added-strand init 1) (enc s (invk a))
    (0 0))
  (traces ((recv (enc (enc s (invk a)) b)) (send (enc d s)))
    ((recv d) (send d)) ((send (enc (enc s (invk a)) b-0))))
  (label 27)
  (parent 26)
  (unrealized)
  (shape)
  (maps ((0 1) ((a a) (b b) (s s) (d d))))
  (origs (s (2 0)) (d (0 1))))

(comment "Nothing left to do")

(defprotocol blanchet-fixed basic
  (defrole init
    (vars (a b name) (s skey) (d data))
    (trace (send (enc (enc s b (privk a)) (pubk b))) (recv (enc d s))))
  (defrole resp
    (vars (a b name) (s skey) (d data))
    (trace (recv (enc (enc s b (privk a)) (pubk b))) (send (enc d s))))
  (defrule cakeRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (leads-to z0 i0 z1 i1)
          (leads-to z0 i0 z2 i2) (prec z1 i1 z2 i2))
        (false))))
  (defrule no-interruption
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (leads-to z0 i0 z2 i2) (trans z1 i1)
          (same-locn z0 i0 z1 i1) (prec z0 i0 z1 i1) (prec z1 i1 z2 i2))
        (false))))
  (defrule neqRl_mesg
    (forall ((x mesg)) (implies (fact neq x x) (false))))
  (defrule neqRl_strd
    (forall ((x strd)) (implies (fact neq x x) (false))))
  (defrule neqRl_indx
    (forall ((x indx)) (implies (fact neq x x) (false))))
  (defrule scissorsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (leads-to z0 i0 z2 i2))
        (and (= z1 z2) (= i1 i2)))))
  (defrule shearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (same-locn z0 i0 z2 i2)
          (prec z0 i0 z2 i2))
        (or (and (= z1 z2) (= i1 i2)) (prec z1 i1 z2 i2)))))
  (defrule invShearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (same-locn z0 i0 z1 i1)
          (leads-to z1 i1 z2 i2) (prec z0 i0 z2 i2))
        (or (and (= z0 z1) (= i0 i1)) (prec z0 i0 z1 i1)))))
  (comment "Fixed Blanchet's protocol using named asymmetric keys"))

(defskeleton blanchet-fixed
  (vars (d data) (a b name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (non-orig (privk b))
  (uniq-orig s)
  (comment "Analyze from the initiator's perspective")
  (traces ((send (enc (enc s b (privk a)) (pubk b))) (recv (enc d s))))
  (label 28)
  (unrealized (0 1))
  (origs (s (0 0)))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton blanchet-fixed
  (vars (d data) (a b a-0 b-0 name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (defstrand resp 2 (d d) (a a-0) (b b-0) (s s))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (privk b))
  (uniq-orig s)
  (operation encryption-test (added-strand resp 2) (enc d s) (0 1))
  (traces ((send (enc (enc s b (privk a)) (pubk b))) (recv (enc d s)))
    ((recv (enc (enc s b-0 (privk a-0)) (pubk b-0))) (send (enc d s))))
  (label 29)
  (parent 28)
  (unrealized (1 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet-fixed
  (vars (d data) (a b name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (deflistener s)
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (privk b))
  (uniq-orig s)
  (operation encryption-test (added-listener s) (enc d s) (0 1))
  (traces ((send (enc (enc s b (privk a)) (pubk b))) (recv (enc d s)))
    ((recv s) (send s)))
  (label 30)
  (parent 28)
  (unrealized (1 0))
  (dead)
  (comment "empty cohort"))

(defskeleton blanchet-fixed
  (vars (d data) (a b name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (precedes ((0 0) (1 0)) ((1 1) (0 1)))
  (non-orig (privk b))
  (uniq-orig s)
  (operation nonce-test (contracted (a-0 a) (b-0 b)) s (1 0)
    (enc (enc s b (privk a)) (pubk b)))
  (traces ((send (enc (enc s b (privk a)) (pubk b))) (recv (enc d s)))
    ((recv (enc (enc s b (privk a)) (pubk b))) (send (enc d s))))
  (label 31)
  (parent 29)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (s s) (d d))))
  (origs (s (0 0))))

(comment "Nothing left to do")

(defprotocol blanchet-fixed basic
  (defrole init
    (vars (a b name) (s skey) (d data))
    (trace (send (enc (enc s b (privk a)) (pubk b))) (recv (enc d s))))
  (defrole resp
    (vars (a b name) (s skey) (d data))
    (trace (recv (enc (enc s b (privk a)) (pubk b))) (send (enc d s))))
  (defrule cakeRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (leads-to z0 i0 z1 i1)
          (leads-to z0 i0 z2 i2) (prec z1 i1 z2 i2))
        (false))))
  (defrule no-interruption
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (leads-to z0 i0 z2 i2) (trans z1 i1)
          (same-locn z0 i0 z1 i1) (prec z0 i0 z1 i1) (prec z1 i1 z2 i2))
        (false))))
  (defrule neqRl_mesg
    (forall ((x mesg)) (implies (fact neq x x) (false))))
  (defrule neqRl_strd
    (forall ((x strd)) (implies (fact neq x x) (false))))
  (defrule neqRl_indx
    (forall ((x indx)) (implies (fact neq x x) (false))))
  (defrule scissorsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (leads-to z0 i0 z2 i2))
        (and (= z1 z2) (= i1 i2)))))
  (defrule shearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (same-locn z0 i0 z2 i2)
          (prec z0 i0 z2 i2))
        (or (and (= z1 z2) (= i1 i2)) (prec z1 i1 z2 i2)))))
  (defrule invShearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (same-locn z0 i0 z1 i1)
          (leads-to z1 i1 z2 i2) (prec z0 i0 z2 i2))
        (or (and (= z0 z1) (= i0 i1)) (prec z0 i0 z1 i1)))))
  (comment "Fixed Blanchet's protocol using named asymmetric keys"))

(defskeleton blanchet-fixed
  (vars (d data) (a b name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (non-orig (privk b))
  (uniq-orig d s)
  (comment "From the initiator's perspective, is the secret leaked?")
  (traces ((send (enc (enc s b (privk a)) (pubk b))) (recv (enc d s)))
    ((recv d) (send d)))
  (label 32)
  (unrealized (0 1))
  (origs (s (0 0)))
  (comment "2 in cohort - 2 not yet seen"))

(defskeleton blanchet-fixed
  (vars (d data) (a b a-0 b-0 name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (defstrand resp 2 (d d) (a a-0) (b b-0) (s s))
  (precedes ((0 0) (2 0)) ((2 1) (0 1)) ((2 1) (1 0)))
  (non-orig (privk b))
  (uniq-orig d s)
  (operation encryption-test (added-strand resp 2) (enc d s) (0 1))
  (traces ((send (enc (enc s b (privk a)) (pubk b))) (recv (enc d s)))
    ((recv d) (send d))
    ((recv (enc (enc s b-0 (privk a-0)) (pubk b-0))) (send (enc d s))))
  (label 33)
  (parent 32)
  (unrealized (1 0) (2 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet-fixed
  (vars (d data) (a b name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (deflistener s)
  (precedes ((0 0) (2 0)) ((2 1) (0 1)))
  (non-orig (privk b))
  (uniq-orig d s)
  (operation encryption-test (added-listener s) (enc d s) (0 1))
  (traces ((send (enc (enc s b (privk a)) (pubk b))) (recv (enc d s)))
    ((recv d) (send d)) ((recv s) (send s)))
  (label 34)
  (parent 32)
  (unrealized (2 0))
  (dead)
  (comment "empty cohort"))

(defskeleton blanchet-fixed
  (vars (d data) (a b name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (precedes ((0 0) (2 0)) ((2 1) (0 1)) ((2 1) (1 0)))
  (non-orig (privk b))
  (uniq-orig d s)
  (operation nonce-test (contracted (a-0 a) (b-0 b)) s (2 0)
    (enc (enc s b (privk a)) (pubk b)))
  (traces ((send (enc (enc s b (privk a)) (pubk b))) (recv (enc d s)))
    ((recv d) (send d))
    ((recv (enc (enc s b (privk a)) (pubk b))) (send (enc d s))))
  (label 35)
  (parent 33)
  (unrealized (1 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet-fixed
  (vars (d data) (a b name) (s skey))
  (defstrand init 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (deflistener s)
  (precedes ((0 0) (2 0)) ((0 0) (3 0)) ((2 1) (0 1)) ((2 1) (1 0))
    ((3 1) (1 0)))
  (non-orig (privk b))
  (uniq-orig d s)
  (operation nonce-test (added-listener s) d (1 0) (enc d s))
  (traces ((send (enc (enc s b (privk a)) (pubk b))) (recv (enc d s)))
    ((recv d) (send d))
    ((recv (enc (enc s b (privk a)) (pubk b))) (send (enc d s)))
    ((recv s) (send s)))
  (label 36)
  (parent 35)
  (unrealized (3 0))
  (dead)
  (comment "empty cohort"))

(comment "Nothing left to do")

(defprotocol blanchet-fixed basic
  (defrole init
    (vars (a b name) (s skey) (d data))
    (trace (send (enc (enc s b (privk a)) (pubk b))) (recv (enc d s))))
  (defrole resp
    (vars (a b name) (s skey) (d data))
    (trace (recv (enc (enc s b (privk a)) (pubk b))) (send (enc d s))))
  (defrule cakeRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (leads-to z0 i0 z1 i1)
          (leads-to z0 i0 z2 i2) (prec z1 i1 z2 i2))
        (false))))
  (defrule no-interruption
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (leads-to z0 i0 z2 i2) (trans z1 i1)
          (same-locn z0 i0 z1 i1) (prec z0 i0 z1 i1) (prec z1 i1 z2 i2))
        (false))))
  (defrule neqRl_mesg
    (forall ((x mesg)) (implies (fact neq x x) (false))))
  (defrule neqRl_strd
    (forall ((x strd)) (implies (fact neq x x) (false))))
  (defrule neqRl_indx
    (forall ((x indx)) (implies (fact neq x x) (false))))
  (defrule scissorsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (leads-to z0 i0 z2 i2))
        (and (= z1 z2) (= i1 i2)))))
  (defrule shearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (same-locn z0 i0 z2 i2)
          (prec z0 i0 z2 i2))
        (or (and (= z1 z2) (= i1 i2)) (prec z1 i1 z2 i2)))))
  (defrule invShearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (same-locn z0 i0 z1 i1)
          (leads-to z1 i1 z2 i2) (prec z0 i0 z2 i2))
        (or (and (= z0 z1) (= i0 i1)) (prec z0 i0 z1 i1)))))
  (comment "Fixed Blanchet's protocol using named asymmetric keys"))

(defskeleton blanchet-fixed
  (vars (d data) (a b name) (s skey))
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (non-orig (privk a) (privk b))
  (uniq-orig s)
  (comment "Analyze from the responder's perspective")
  (traces ((recv (enc (enc s b (privk a)) (pubk b))) (send (enc d s))))
  (label 37)
  (unrealized (0 0))
  (origs)
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet-fixed
  (vars (d data) (a b name) (s skey))
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (defstrand init 1 (a a) (b b) (s s))
  (precedes ((1 0) (0 0)))
  (non-orig (privk a) (privk b))
  (uniq-orig s)
  (operation encryption-test (added-strand init 1) (enc s b (privk a))
    (0 0))
  (traces ((recv (enc (enc s b (privk a)) (pubk b))) (send (enc d s)))
    ((send (enc (enc s b (privk a)) (pubk b)))))
  (label 38)
  (parent 37)
  (unrealized)
  (shape)
  (maps ((0) ((a a) (b b) (s s) (d d))))
  (origs (s (1 0))))

(comment "Nothing left to do")

(defprotocol blanchet-fixed basic
  (defrole init
    (vars (a b name) (s skey) (d data))
    (trace (send (enc (enc s b (privk a)) (pubk b))) (recv (enc d s))))
  (defrole resp
    (vars (a b name) (s skey) (d data))
    (trace (recv (enc (enc s b (privk a)) (pubk b))) (send (enc d s))))
  (defrule cakeRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (leads-to z0 i0 z1 i1)
          (leads-to z0 i0 z2 i2) (prec z1 i1 z2 i2))
        (false))))
  (defrule no-interruption
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (leads-to z0 i0 z2 i2) (trans z1 i1)
          (same-locn z0 i0 z1 i1) (prec z0 i0 z1 i1) (prec z1 i1 z2 i2))
        (false))))
  (defrule neqRl_mesg
    (forall ((x mesg)) (implies (fact neq x x) (false))))
  (defrule neqRl_strd
    (forall ((x strd)) (implies (fact neq x x) (false))))
  (defrule neqRl_indx
    (forall ((x indx)) (implies (fact neq x x) (false))))
  (defrule scissorsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (leads-to z0 i0 z2 i2))
        (and (= z1 z2) (= i1 i2)))))
  (defrule shearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (trans z2 i2)
          (leads-to z0 i0 z1 i1) (same-locn z0 i0 z2 i2)
          (prec z0 i0 z2 i2))
        (or (and (= z1 z2) (= i1 i2)) (prec z1 i1 z2 i2)))))
  (defrule invShearsRule
    (forall ((z0 z1 z2 strd) (i0 i1 i2 indx))
      (implies
        (and (trans z0 i0) (trans z1 i1) (same-locn z0 i0 z1 i1)
          (leads-to z1 i1 z2 i2) (prec z0 i0 z2 i2))
        (or (and (= z0 z1) (= i0 i1)) (prec z0 i0 z1 i1)))))
  (comment "Fixed Blanchet's protocol using named asymmetric keys"))

(defskeleton blanchet-fixed
  (vars (d data) (a b name) (s skey))
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (non-orig (privk a) (privk b))
  (uniq-orig d s)
  (comment "From the responders's perspective, is the secret leaked?")
  (traces ((recv (enc (enc s b (privk a)) (pubk b))) (send (enc d s)))
    ((recv d) (send d)))
  (label 39)
  (unrealized (0 0) (1 0))
  (preskeleton)
  (origs (d (0 1)))
  (comment "Not a skeleton"))

(defskeleton blanchet-fixed
  (vars (d data) (a b name) (s skey))
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (precedes ((0 1) (1 0)))
  (non-orig (privk a) (privk b))
  (uniq-orig d s)
  (traces ((recv (enc (enc s b (privk a)) (pubk b))) (send (enc d s)))
    ((recv d) (send d)))
  (label 40)
  (parent 39)
  (unrealized (0 0))
  (origs (d (0 1)))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet-fixed
  (vars (d data) (a b name) (s skey))
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (defstrand init 1 (a a) (b b) (s s))
  (precedes ((0 1) (1 0)) ((2 0) (0 0)))
  (non-orig (privk a) (privk b))
  (uniq-orig d s)
  (operation encryption-test (added-strand init 1) (enc s b (privk a))
    (0 0))
  (traces ((recv (enc (enc s b (privk a)) (pubk b))) (send (enc d s)))
    ((recv d) (send d)) ((send (enc (enc s b (privk a)) (pubk b)))))
  (label 41)
  (parent 40)
  (unrealized (1 0))
  (comment "1 in cohort - 1 not yet seen"))

(defskeleton blanchet-fixed
  (vars (d data) (a b name) (s skey))
  (defstrand resp 2 (d d) (a a) (b b) (s s))
  (deflistener d)
  (defstrand init 1 (a a) (b b) (s s))
  (deflistener s)
  (precedes ((0 1) (1 0)) ((2 0) (0 0)) ((2 0) (3 0)) ((3 1) (1 0)))
  (non-orig (privk a) (privk b))
  (uniq-orig d s)
  (operation nonce-test (added-listener s) d (1 0) (enc d s))
  (traces ((recv (enc (enc s b (privk a)) (pubk b))) (send (enc d s)))
    ((recv d) (send d)) ((send (enc (enc s b (privk a)) (pubk b))))
    ((recv s) (send s)))
  (label 42)
  (parent 41)
  (unrealized (3 0))
  (dead)
  (comment "empty cohort"))

(comment "Nothing left to do")
