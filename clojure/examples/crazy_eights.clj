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

;Have a player draw a card
(defn player-draw [hand deck]
	(let [[top deck] (deck-draw deck)]
		[(concat hand top) deck]))

;Split cards into cards that can be played
;and cards that cannot given the top card
(defn valid-cards [hand table]
	(let [top-card (first table)
		top-rank (card-rank top-card)
		top-suit (card-suit top-card)
		card-validity (group-by (fn [x] 
			(or (= (card-rank x) 8)
				(= (card-rank x) top-rank)
				(= (card-suit x) top-suit)))
			hand)]
		[(get card-validity true) (get card-validity false)]))

;Enumerate a list
(defn enumerate [coll]
	(map vector (range) coll))

;Display a hand
(defn hand-show [hand]
	(doseq [[i x] (enumerate hand)]
		(println (format "%d) %s" i (card-name x)))))

;Test what we have so far

(println "Choosing cards to play====")
(let [
	[hand1 hand2 table deck] (setup (deck-create))
	[valid invalid] (valid-cards hand1 table)
	valid-names (map card-name valid)
	invalid-names (map card-name invalid)
	table-names (map card-name table)]
	(println "Top card on pile:")
	(println (card-name (first table)))
	(println "Valid cards:")
	(hand-show valid)
	(println "Invalid cards:")
	(hand-show invalid))

(println "Drawing cards=====")
(let [
	[hand1 hand2 table deck] (setup (deck-create))
	[hand1 deck] (player-draw hand1 deck)]
	(println "Player 1:")
	(hand-show hand1)
	(println "Player 2:")
	(hand-show hand2))
