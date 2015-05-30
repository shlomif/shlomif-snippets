(define global-self 
  (lambda args 
    (
	(lambda (f)
      		(f 
			(
				(lambda (x) 
            			`(letrec ((local-self  
                       			(lambda () (,x ',x)))) 
               				(local-self))) 
          			
          			'(lambda (x) 
             				`(letrec ((local-self  
                        		(lambda () (,x ',x)))) 
                			(local-self))
                		)
                	)
		)
	)
     (lambda (sexpr) sexpr)
    )
  )
)

(define s-expr
			(
				(lambda (x) 
            			`(letrec ((local-self  
                       			(lambda () (,x ',x)))) 
               				(local-self))) 
          			
          			'(lambda (x) 
             				`(letrec ((local-self  
                        		(lambda () (,x ',x)))) 
                			(local-self))
                		)
                	)
	
)

(display (global-self))
(newline)
(display (eval (global-self)))
(newline)
(display (eval (eval (global-self))))
(newline)

(display s-expr)
(newline)