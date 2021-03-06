(herald "Woo-Lam Protocol")

(defprotocol woolam basic
  (defrole init (vars (a s name) (n text))
    (trace
     (send a)
     (recv n)
     (send (enc n (ltk a s))))
    (non-orig (ltk a s)))
  (defrole resp (vars (a s b name) (n text))
    (trace
     (recv a)
     (send n)
     (recv (enc n (ltk a s)))
     (send (enc a (enc n (ltk a s)) (ltk b s)))
     (recv (enc a n (ltk b s))))
    (non-orig (ltk b s))
    (uniq-orig n))
  (defrole serv (vars (a s b name) (n text))
    (trace
     (recv (enc a (enc n (ltk a s)) (ltk b s)))
     (send (enc a n (ltk b s))))))

(defskeleton woolam (vars (n text) (a s name))
  (defstrand resp 5 (a a) (s s))
  (non-orig (ltk a s)))

(defprotocol woolam-msg basic
  (defrole init (vars (a s name) (n text))
    (trace
     (send a)
     (recv n)
     (send (enc n (ltk a s))))
    (non-orig (ltk a s)))
  (defrole resp (vars (a s b name) (n text) (m mesg))
    (trace
     (recv a)
     (send n)
     (recv m)
     (send (enc a m (ltk b s)))
     (recv (enc n (ltk b s))))
    (non-orig (ltk b s))
    (uniq-orig n))
  (defrole serv (vars (a s b name) (n text))
    (trace
     (recv (enc a (enc n (ltk a s)) (ltk b s)))
     (send (enc n (ltk b s))))))

(defskeleton woolam-msg (vars (a s name))
  (defstrand resp 5 (a a) (s s))
  (non-orig (ltk a s)))

(defprotocol woolam-msg1 basic
  (defrole init (vars (a s name) (n text))
    (trace
     (send a)
     (recv n)
     (send (enc n (ltk a s))))
    (non-orig (ltk a s)))
  (defrole resp (vars (a s b name) (n text) (m mesg))
    (trace
     (recv a)
     (send n)
     (recv m)
     (send (cat a b (enc m (ltk b s))))
     (recv (enc a n (ltk b s))))
    (non-orig (ltk b s))
    (uniq-orig n))
  (defrole serv (vars (a s b name) (n text))
    (trace
     (recv (cat a b (enc (enc n (ltk a s)) (ltk b s))))
     (send (enc a n (ltk b s))))))

(defskeleton woolam-msg1 (vars (a s name))
  (defstrand resp 5 (a a) (s s))
  (non-orig (ltk a s)))
