#!/usr/bin/clojure
(load-file "../byte_cards.clj")

;Create a deck of cards from 0 to 63
(defn deck-create []
	(shuffle (range 0 64)))

;Draw a card or multiple cards
(defn deck-draw 
	([deck] (split-at 1 deck))
	([deck n] (split-at n deck)))

;Deal 5 cards to every player, then draw a
;card and place it on the table.
(defn setup [deck]
	(let [[hand1 deck] (deck-draw deck 5)
		[hand2 deck] (deck-draw deck 5)
		[table deck] (deck-draw deck)]
		[hand1 hand2 table deck]))

;Test setup
(println (setup (deck-create)))
