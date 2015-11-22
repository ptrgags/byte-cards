#!/usr/bin/clojure
(load-file "../byte_cards.clj")

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

;Print a welcome message
(defn game-welcome []
  (do
	(println "Welcome to Crazy Eights!")
	(println "Today we have 2 players, Player 1 and Player 2!")
	(wait-enter)
	(clear-screen)))

;Enumerate a list
(defn enumerate [coll]
  (map vector (range) coll))

;Display a hand
(defn hand-show [hand]
  (doseq [[i x] (enumerate hand)]
	(println (format "%d) %s" i (card-name x)))))

;Read an integer and return -1 on exceptions.
(defn read-int []
  (try
   (print ">")
   (flush)
   (Integer/parseInt (read-line))
   (catch Exception e -1)))

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

;Set up the initial game state
(defn setup []
  (let [deck (deck-create)
	    [hand1 deck] (deal-hand deck)
		[hand2 deck] (deal-hand deck)
		[pile deck] (deal-pile deck)]
    (game-welcome)
    (println "Deck was created and shuffled with 64 cards")
    (println "Dealt 5 cards to each player")
    (println "Created the center pile")
    (wait-enter)
    (clear-screen)
	[1 hand1 hand2 pile deck]))

;Move a card from a hand to the pile
(defn play-card [hand card pile]
  (do
   (println (format "Played the %s" (card-name card)))
   [(remove #(= card %) hand) (cons card pile)]))

;Check if a card is playable given the top card
;in the pile
(defn playable? [card pile]
  (let [top (first pile)]
	(or
	 (= (card-rank card) 8)
	 (= (card-rank card) (card-rank top))
	 (= (card-suit card) (card-suit top)))))

;Draw cards from the deck until one can be played on the pile
(defn draw-until-playable [hand pile deck]
  (loop [hand hand 
         pile pile 
         deck deck]
	(let [[top-pile rest-pile] (split-at 1 pile)
		  [top-deck rest-deck] (split-at 1 deck)]
	  (cond
        ;When the deck is empty, shuffle the pile into the deck
		(empty? top-deck) 
        (recur hand top-pile (seq (shuffle rest-pile)))
        ;If the first card in the deck is playable, play it directly
        ;to the pile
        (playable? (first top-deck) pile) 
        (do 
         (println (format "Played the %s" (card-name (first top-deck))))
         (wait-enter)
         (clear-screen)
         [hand (concat top-deck pile) rest-deck])
        ;Otherwise, put the top card in the player's hand and try again
		:else 
        (recur (concat hand top-deck) pile rest-deck)))))
		  
;Get a list of cards that are playable in the hand
(defn valid-cards [hand pile]
  (filter #(playable? % pile) hand))

;Pick a random card from the hand.
(defn random-card [hand]
  (rand-nth hand))

;Play a random card from a list of valid card
(defn play-random [hand valids pile deck]
  (let [card (random-card valids)
	    [hand pile] (play-card hand card pile)]
    (wait-enter)
    (clear-screen)
	[hand pile deck]))

;Simulate a single player's turn
(defn ai-turn [hand pile deck]
  (let [valids (valid-cards hand pile)]
	(if (empty? valids)
      (do
       (println "No playable cards in hand.")
       (println "Drawing cards until a playable card is found.")
	   (draw-until-playable hand pile deck))
	  (play-random hand valids pile deck))))

;Have the user select a card, looping if necessary
(defn choose-card [hand]
  (try
    (do
     (println "Pick a card:")
     (hand-show hand)
     (nth hand (read-int)))
    (catch IndexOutOfBoundsException e (choose-card hand))))

;Have the user select a card and then play it
(defn play-user-selection [hand valids pile deck]
  (let [card (choose-card valids)
        [hand pile] (play-card hand card pile)]
    (wait-enter)
    (clear-screen)
    [hand pile deck]))
   
;Have the player take a turn
(defn player-turn [hand pile deck]
  (let [valids (valid-cards hand pile)]
    (println "Your cards:")
    (hand-show hand)
    (println)
    (if (empty? valids)
      (do
       (println "No playable cards in hand.")
       (println "Drawing cards until a playable card is found.") 
       (draw-until-playable hand pile deck))
      (play-user-selection hand valids pile deck))))

;Take a turn based on the turn state
(defn game-turn [turn hand1 hand2 pile deck]
  (if (= turn 1)
	(let [[hand1 pile deck] (player-turn hand1 pile deck)]
	  [2 hand1 hand2 pile deck])
	(let [[hand2 pile deck] (ai-turn hand2 pile deck)]
	  [1 hand1 hand2 pile deck])))

;Main game loop
(defn game-loop []
  (loop [[player hand1 hand2 pile deck] (setup)
		 turn 1]
	(println (format "Turn %s - Player %s's turn=====" turn player))
    (println (format "Player 1 has %d cards" (count hand1)))
    (println (format "Player 2 has %d cards" (count hand2)))
    (println)
    (println (format "Top card: %s" (card-name (first pile))))
    (println)
	(cond 
	  (empty? hand1) (do (println "Player 1 wins!") 1)
	  (empty? hand2) (do (println "Player 2 wins!") 2)
	  :else (let [state (game-turn player hand1 hand2 pile deck)]
	          (recur state (inc turn))))))

;Actually run the game...
(game-loop)
