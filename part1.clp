; - PROJET D'INTELLIGENCE ARTIFICIELLE: LE DONJON -
; --------- Fait par: Phuong Dung NGUYEN ----------

; ------------------- PARTIE 1 --------------------

; base de faits
(deffacts base-de-faits
	(question)
	(noeud n1 vers n2)
	(noeud n2 vers n3)
	(noeud n2 vers n7)
	(noeud n3 vers n4)
	(noeud n3 vers n5)
	(noeud n3 vers n6)
	(noeud n5 vers n4)
	(noeud n7 vers n4)
	(courant n1)		; emplacement initial
)

; ajouter les chemins inverses
(defrule chemin-inverse
	(noeud ?ny vers ?nx)
	=>
	(assert (noeud ?nx vers ?ny))
)

(defrule demander-destination
	?adrq <- (question)
	=>
	(printout t "Vous voulez allez à quelle noeud?" crlf)
	(assert (destination (read t)))
	(retract ?adrq)
)

(defrule destination-existante
	?adrc <- (courant ?nx)
	?adrd <- (destination ?ny)
	(noeud ?nx vers ?ny)
	=>
	(retract ?adrc ?adrd)
	(assert (courant ?ny))
	(printout t "Vous êtes au noeud " ?ny "." crlf)
	(assert (question))
)

(defrule destination-inexistante
	(courant ?nx)
	?adrd <- (destination ?ny)
	(not (destination stop))
	; (not (destination nil))
	(not (noeud ?nx vers ?ny))
	=>
	(printout t "Vous êtes au noeud " ?nx ". Le chemin vers " ?ny " n'existe pas." crlf)
	(printout t "Merci de donner un autre noeud." crlf)
	(retract ?adrd)
	(assert (destination (read t)))
)

;(defrule destination-inconnue
;	?adrd <- (destination nil)
;	=>
;	(printout t "Vous n'avez rien entré. Merci d'indiquer un noeud." crlf)
;	(retract ?adrd)
;	(assert (destination (read t)))
;)

(defrule arrêter
	?adrd <- (destination stop)
	=>
	;(retract ?adrd)
	(halt)
)