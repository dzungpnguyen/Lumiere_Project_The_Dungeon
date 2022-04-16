; - PROJET D'INTELLIGENCE ARTIFICIELLE: LE DONJON -
; --------- Fait par: Phuong Dung NGUYEN ----------

; ------------------- PARTIE 2 --------------------

; base de faits
(deffacts base-de-faits
	(question)	; pour initialiser la première question de l'ordinateur
	; forme (noeud <nx> vers <ny>)
	(noeud n1 vers n2)
	(noeud n2 vers n3)
	(noeud n2 vers n7)
	(noeud n3 vers n4)
	(noeud n3 vers n5)
	(noeud n3 vers n6)
	(noeud n5 vers n4)
	(noeud n7 vers n4)
	(courant n1)		; emplacement initial
	
	; forme: (tresor <montant> lieu <noeud>)
	(tresor 1000 lieu n4)
	(tresor 200 lieu n6)
	
	; forme: (monstre <force> lieu <noeud)
	(monstre 7 lieu n5)
	(monstre 32 lieu n7)
	
	; force de l'aventurier
	(force 30)
	; magot de l'aventurier
	(magot 0)
)

; ajouter les chemins inverses
(defrule chemin-inverse
	(declare (salience 10000)) ; on excute toujours cette règle en premier
	(noeud ?ny vers ?nx)
	=>
	(assert (noeud ?nx vers ?ny))
)

(defrule demander
	?adrq <- (question)
	(courant ?nx)
	=>
	(printout t "Vous voulez allez à quelle noeud?" crlf)
	(assert (destination (read t)))
	(retract ?adrq)
)

(defrule destination-existante
	(declare (salience 10))
	?adrc <- (courant ?nx)
	?adrd <- (destination ?ny)
	(noeud ?nx vers ?ny)
	=>
	(retract ?adrc ?adrd)
	(assert (courant ?ny))
	(printout t "Vous êtes au noeud " ?ny ". ")
	(assert (question))
)

(defrule arriver-tresor
	(declare (salience 20))
	(courant ?nx)
	?adrt <- (tresor ?t lieu ?nx)
	?adrm <- (magot ?m)
	=>
	(retract ?adrm ?adrt)
	(assert (magot (+ ?m ?t)))
	(printout t "Vous avez maintenant " (+ ?m ?t) " pièces d'or." crlf)
	(assert (question))
)

(defrule arriver-monstre-inferieur
	(declare (salience 15))
	(courant ?nx)
	?adrm <- (monstre ?m lieu ?nx)
	(force ?f)
	(test (< ?m ?f))
	=>
	(printout t "Bravo! Le monstre a été vaincu!" crlf)
	(retract ?adrm)
	(assert (question))
)

(defrule arriver-monstre-superieur
	(declare (salience 15))
	?adrc <- (courant ?nx)
	(monstre ?m lieu ?nx)
	?adrm <- (magot ?mag)
	?adrf <- (force ?f)
	(test (> ?m ?f))
	=>
	(printout t "Le monstre est trop fort!" crlf)
	(printout t "Vous perdez tout le trésor et la partie!" crlf)
	(printout t "Au revoir." crlf)
	(retract ?adrm ?adrf ?adrc)
	(assert (magot 0))
)

(defrule destination-inexistante
	(declare (salience 10))
	(courant ?nx)
	?adrd <- (destination ?ny)
	(not (destination fin))
	(not (noeud ?nx vers ?ny))
	=>
	(printout t "Vous êtes au noeud " ?nx ". Le chemin vers " ?ny " n'existe pas." crlf)
	(printout t "Merci de donner un autre noeud." crlf)
	(retract ?adrd)
	(assert (destination (read t)))
)

(defrule arrêter
	(destination fin)
	(magot ?m)
	=>
	(printout t "Vous avez accumulé " ?m " pièces d'or." crlf)
	(printout t "Au revoir." crlf)
	(halt)
)