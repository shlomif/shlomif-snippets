(define zero (lambda (f) (lambda (x) x)))

(define (church->int church)
        ((church (lambda (a) (+ a 1))) 0)
)

(define succ
(lambda (n)
        (lambda (f)
                (lambda (x)
                        (f ((n f) x))
                )
        )
))

(define (int->church n)
        (if (= n 0)
                zero
                (succ (int->church (- n 1)))
        )
)
(define lc_true  (lambda (x) (lambda (y) x)))
(define lc_false (lambda (x) (lambda (y) y)))
(define add
    (lambda (n)
        (lambda (m)
            ((n succ) m)
        )
    )
)

(define lc_cons
    (lambda (mycar)
        (lambda (mycdr)
            ; we return this lambda-expression:
            (lambda (which)
                ((which mycar) mycdr)
            )
        )
    )
)

(define lc_car
    (lambda (tuple)
        (tuple lc_true)
    )
)

(define lc_cdr
    (lambda (tuple)
        (tuple lc_false)
    )
)
; We can evaluate it into:
(define add
    (lambda (m)
        (lambda (n)
            (lambda (f)
                (lambda (x)
                    ((m f)
                        ((n f) x)
                    )
                )
            )
        )
    )
)

; Now let's try multiplication. Since a church numeral is basically about
; repeating something n times, we can repeat the other multiplicand N times.

(define mult
    (lambda (m)
        (lambda (n)
            (lambda (f)
                (m (n f))
            )
        )
    )
)

; Power: we can repeat the LC's mult m times

(define power
    (lambda (m)
        (lambda (n)
            ((n (mult m)) (succ zero))
        )
    )
)

; This, in turn can be simplified into:

(define power
    (lambda (m)
        (lambda (n)
            (n m)
        )
    )
)

; Predecessor
; -----------

; Getting the predecessor in Church numerals is quite tricky.
; Let's consider the following method:
;
; Create a pair [0,0] and convert it into the pair [0,1]. (what
; we do is take the cdr and put it in the car and set the cdr to it plus
; 1).
;
; Then into [1,2], [2,3], etc. Repeat this process N times and
; we'll get [N-1, N].
;
; Then we can return the first element of the final pair which is N-1.

(define pred_next_tuple
    (lambda (tuple)
        ((lc_cons
            (lc_cdr tuple))
            (succ (lc_cdr tuple)))
    )
)
; Note that we base the next tuple on the second item of the original tuple.

(define pred
    (lambda (n)
        (lc_car
            ((n pred_next_tuple)
                ; A tuple with two zeros.
                ((lc_cons zero) zero)
            )
        )
    )
)

; Note that the pred of zero is zero, because there isn't -1 in church numerals

; Subtraction is simply repeating pred m times

(define subtract
    (lambda (n)
        (lambda (m)
            ((m pred) n)
        )
    )
)


; Now, how do we compare two Church numerals? We can subtract the
; first one from the second one. If the result is equal to zero, then the
; second one is greater or equal to the first.

(define is-zero?
    (lambda (n)
            ((n (lambda (x) lc_false)) lc_true)
    )
)

(define less-or-equal
    (lambda (x)
            (lambda (y)
                    (is-zero? ((subtract x) y))
            )
    )
)

; The Y combinator is defined as follows:

(define Y
    (lambda (f)
        (
            (lambda (x)
                    (f (lambda (y) ((x x) y)))
            )
            (lambda (x)
                    (f (lambda (y) ((x x) y)))
            )
        )
    )
)

(define zero (lambda (f) (lambda (x) x)))
(define one  (lambda (f) (lambda (x) (f x))))
(define factorial (Y (lambda (f) (lambda (x) ((((is-zero? x) (lambda (no_use) one)) (lambda (no_use) ((mult x) (f (pred x))))) zero)))))
; In a similar way and by using not we can define all other comparison
; operators.

(display (church->int (factorial (int->church 4))))
(newline)

; Division and modulo? For this we need the Y combinator.
; Stay tuned...
