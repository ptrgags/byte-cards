#!/usr/bin/clojure
(load-file "../byte_cards.clj")

;Create a deck of cards from 0 to 63
(defn deck-create []
	(seq (shuffle (range 0 64))))

;Draw a card or multiple cards
(defn deck-draw 
	([deck] (split-at 1 deck))
	([deck n] (split-at n deck)))

;Deal 7 cards for a single player
(defn deal-hand [deck]
	(deck-draw deck 7))

;Deal the first card to the pile.
;If the first card is an 8, reshuffle
;and try again.
(defn deal-pile [deck]
	(let [top (first deck)]
		(if (= (card-rank top) 8)
			(deal-pile (shuffle deck))
			(deck-draw deck))))

(defn setup []
	(let [
		deck (deck-create)
		[hand1 deck] (deal-hand deck)
		[hand2 deck] (deal-hand deck)
		[pile deck] (deal-pile deck)]
		[1 hand1 hand2 pile deck]))


;Move a card from a hand to the pile
(defn play-card [hand card pile]
	(let [rm-card (fn [x] (= card x))]
		[(remove rm-card hand) (cons card pile)]))

;Check if a card is playable given the top card
;in the pile
(defn playable [card pile]
	(let [top (first pile)]
		(or
			(= (card-rank card) 8)
			(= (card-rank card) (card-rank top))
			(= (card-suit card) (card-suit top)))))

;Draw cards from the deck until one can be played on the pile
;TODO: Fix infinite loop caused by empty deck
(defn draw-until-playable [hand pile deck]
	(let [
		split-fn (fn [x] (not (playable x pile)))
		[bad-cards deck] (split-with split-fn  deck)
		[pile-card deck] (deck-draw deck)
		hand (concat hand bad-cards)
		pile (concat pile-card pile)]
		[hand pile deck]))

;Get a list of cards that are playable in the hand
(defn valid-cards [hand pile]
	(filter (fn [x] (playable x pile)) hand))

;Pick a random card from the hand.
(defn random-card [hand]
	(rand-nth hand))

;Play a random card from a list of valid card
(defn play-random [hand valids pile deck]
	(let [
		card (random-card valids)
		[hand pile] (play-card hand card pile)]
		[hand pile deck]))

;Simulate a single player's turn
(defn player-turn [hand pile deck]
	(let [valids (valid-cards hand pile)]
		(if (empty? valids)
			(draw-until-playable hand pile deck)
			(play-random hand valids pile deck))))

;Take a turn based on the turn state
(defn game-turn [turn hand1 hand2 pile deck]
	(if (= turn 1)
		(let [[hand1 pile deck] (player-turn hand1 pile deck)]
			[2 hand1 hand2 pile deck])
		(let [[hand2 pile deck] (player-turn hand2 pile deck)]
			[1 hand1 hand2 pile deck])))

;Main game loop
(defn game-loop []
	(loop [[player hand1 hand2 pile deck] (setup)
			turn 1]
		(println (format "Turn %s - Player %s's turn=====" turn player))
		(print "Player 1's cards: ")
		(println hand1)
		(print "Player 2's cards: ")
		(println hand2)
		(print "Cards on the pile: ")
		(println pile)
		(print "Deck: ")
		(println deck)
		(cond 
			(empty? hand1) (do (println "Player 1 wins!") 1)
			(empty? hand2) (do (println "Player 2 wins!") 2)
			:else (let [
				state
				(game-turn player hand1 hand2 pile deck)]
				(recur state (inc turn))))))
(game-loop)


;Enumerate a list
(defn enumerate [coll]
	(map vector (range) coll))

;Display a hand
(defn hand-show [hand]
	(doseq [[i x] (enumerate hand)]
		(println (format "%d) %s" i (card-name x)))))

;Wait for the user to press enter
(defn wait-enter []
	(do 
		(print "Press Enter to continue ")
		(flush)
		(read-line)))

;Print \e[2J to clear the screen
(defn clear-screen []
	(do 
		(print "\u001B[2J")
		(flush)))

(comment
;Print a welcome message
(defn game-welcome []
	(do
		(println "Welcome to Crazy Eights!")
		(println "Today we have 2 players, Player 1 and Player 2!")
		(wait-enter)
		(clear-screen)))

;Setup the game
(defn game-setup []
	(let [[hand1 hand2 table deck] (setup (deck-create))
		top-card (first table)]
		(println "Deck was created with 64 cards and then shuffled")
		(println "Dealt 5 cards to each player")
		(println "Creating the center pile")
		(println (format "The top card is the %s" (card-name top-card)))
		[hand1 hand2 table deck]))

;Read an integer and return -1 on exceptions.
(defn read-int []
	(try
		(Integer/parseInt (read-line))
		(catch Exception e -1)))

;pick a card, any card...
(defn choose-card [hand]
	(do
		(println "Choose a card:")
		(hand-show hand)
		(read-int)))

;Test what we have so far
;(game-welcome)
;(println (game-setup))
;(println (choose-card '(1 34 6 32 54)))

;Desired API:
;(game-welcome)
;(game-loop (game-setup))

;(wait-enter)
;(clear-screen)
;(println "Choosing cards to play====")
;(let [
;	[hand1 hand2 table deck] (setup (deck-create))
;	[valid invalid] (valid-cards hand1 table)
;	valid-names (map card-name valid)
;	invalid-names (map card-name invalid)
;	table-names (map card-name table)]
;	(println "Top card on pile:")
;	(println (card-name (first table)))
;	(println "Valid cards:")
;	(hand-show valid)
;	(println "Invalid cards:")
;	(hand-show invalid))

;(wait-enter)
;(clear-screen)

;(println "Drawing cards=====")
;(let [
;	[hand1 hand2 table deck] (setup (deck-create))
;	[hand1 deck] (player-draw hand1 deck)]
;	(println "Player 1:")
;	(hand-show hand1)
;	(println "Player 2:")
;	(hand-show hand2))
)
