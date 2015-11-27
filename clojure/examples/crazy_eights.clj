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

;Print the game setup summary
(defn print-setup []
  (do
   (println "Deck was created and shuffled with 64 cards")
   (println "Dealt 5 cards to each player")
   (println "Created the center pile")
   (wait-enter)
   (clear-screen)))

;Set up the initial game state
(defn setup []
  (let [deck (deck-create)
        [hand1 deck] (deal-hand deck)
        [hand2 deck] (deal-hand deck)
        [pile deck] (deal-pile deck)
         hands [hand1 hand2]]
    (game-welcome)
    (print-setup)
    {:deck deck :hands hands :pile pile :player 0 :wild-suit nil :turn 1}))

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
(defn draw-until-playable-helper [hand pile deck]
  (loop [hand hand 
         pile pile 
         deck deck]
    (let [[top-pile rest-pile] (split-at 1 pile)
          [top-deck rest-deck] (split-at 1 deck)]
      (cond
       ;When the deck is empty, shuffle the pile into the deck
       (empty? top-deck) (recur hand top-pile (seq (shuffle rest-pile)))
       ;If the first card in the deck is playable, play it directly
       ;to the pile
       (playable? (first top-deck) pile) 
       (do 
        (println (format "Played the %s" (card-name (first top-deck))))
        (wait-enter)
        (clear-screen)
        [hand (concat top-deck pile) rest-deck])
       ;Otherwise, put the top card in the player's hand and try again
       :else (recur (concat hand top-deck) pile rest-deck)))))

;Draw cads until one can be played
(defn draw-until-playable [state]
  (let [{:keys [hands pile deck player]} state
        hand (nth hands player)
        x (do (println "No playable cards in hand.") (println "Drawing cards until a playable card is found.")) ;HACK
        [hand pile deck] (draw-until-playable-helper hand pile deck)
        hands (assoc hands player hand)]
    (merge state {:hands hands :pile pile :deck deck})))

;Get a list of cards that are playable in the hand
(defn valid-cards [hand pile]
  (filter #(playable? % pile) hand))

;Pick a random card from the hand.
(defn random-card [hand]
  (rand-nth hand))

;Play a random card for the AI
(defn play-ai-selection [state]
  (let [{:keys [hands pile]} state
        hand (nth hands 1)
        valids (valid-cards hand pile)
        card (random-card valids)
        [hand pile] (play-card hand card pile)
        hands (assoc hands 1 hand)]
    (wait-enter)
    (clear-screen)
    (merge state {:hands hands :pile pile})))

;Play a random card from a list of valid card
(comment
(defn play-ai-selection [hand valids pile deck]
  (let [card (random-card valids)
        [hand pile] (play-card hand card pile)]
    ;(wait-enter)
    ;(clear-screen)
    [hand pile deck])))


(defn ai-turn [state]
  (let [{:keys [hands pile]} state
        hand (nth hands 1)
        valids (valid-cards hand pile)]
    (if (empty? valids)
      (draw-until-playable state)
      (play-ai-selection state))))
  

;Simulate a single player's turn
(comment
(defn ai-turn [hand pile deck]
  (let [valids (valid-cards hand pile)]
  (if (empty? valids)
    (do
     (println "No playable cards in hand.")
     (println "Drawing cards until a playable card is found.")
     (draw-until-playable hand pile deck))
    (play-random hand valids pile deck)))))

;Have the user select a card, looping if necessary
(defn choose-card [hand]
  (try
   (do
    (println "Pick a card:")
    (hand-show hand)
    (nth hand (read-int)))
   (catch IndexOutOfBoundsException e (choose-card hand))))


;Have the user select a card and then play it
(defn play-user-selection [state]
  (let [{:keys [hands pile]} state
        hand (nth hands 0)
        valids (valid-cards hand pile)
        card (choose-card valids)
        [hand pile] (play-card hand card pile)
        hands (assoc hands 0 hand)]
    (wait-enter)
    (clear-screen)
    (merge state {:hands hands :pile pile})))

;Have the user select a card and then play it
(comment
(defn play-user-selection [hand valids pile deck]
  (let [card (choose-card valids)
        [hand pile] (play-card hand card pile)]
    ;(wait-enter)
    ;(clear-screen)
    [hand pile deck])))

;Have the player take a turn
(defn print-player-hand [hand]
  (do
   (println "Your cards:")
   (hand-show hand)
   (println)))

;Have the player take a turn
(defn player-turn [state]
  (let [{:keys [hands pile turn]} state
        hand (nth hands 0)
        valids (valid-cards hand pile)]
    (print-player-hand hand)
    (if (empty? valids)
      (draw-until-playable state)
      (play-user-selection state))))

;Print a quick summary of the current game state
(defn print-game-state [state]
  (let [{:keys [turn player hands pile]} state]
    (println (format "Turn %s - Player %s's turn=====" turn player))
    (println (format "Player 1 has %d cards" (count (nth hands 0))))
    (println (format "Player 2 has %d cards" (count (nth hands 1))))
    (println)
    (println (format "Top card: %s" (card-name (first pile))))
    (println)
    state))

;Take a turn based on the turn state
(defn game-turn [state]
  (let [{player :player} state]
    (print-game-state state)
    (if (= player 0)
      (player-turn state)
      (ai-turn state))))

;Check if the game is finished
;(i.e. one of the two hands is empty)
(defn game-over? [state]
  (let [{hands :hands} state]
    (or
     (empty? (nth hands 0))
     (empty? (nth hands 1)))))

;Declare the winner
(defn declare-winner [state]
  (let [{hands :hands} state]
    (cond
      (empty? (nth hands 0)) (println "Player 1 Wins!")
      (empty? (nth hands 1)) (println "Player 2 Wins!"))))

;Increment the turn counter and cycle through
;the players
(defn next-turn [state]
  (let [{:keys [turn player]} state
        player (if (= player 0) 1 0)
        turn (inc turn)]
    (merge state {:turn turn :player player})))

;Main game loop
(defn game-loop []
  (loop [state (setup)]
    (if (game-over? state)
      (declare-winner state)
      (recur (next-turn (game-turn state))))))

;Actually run the game...
(game-loop)

