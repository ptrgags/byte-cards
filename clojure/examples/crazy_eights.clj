#!/usr/bin/clojure
(load-file "../byte_cards.clj")

(defn wait-enter 
  "Taunt the user to press enter"
  []
  (do 
   (print "Press Enter to continue ")
   (flush)
   (read-line)))

(defn clear-screen 
  "Clear the screen"
  []
  (do 
   (print "\u001B[2J")
   (flush)))

(defn game-welcome 
  "Print a welcome message"
  []
  (do
    (println "Welcome to Crazy Eights!")
    (println "Today we have 2 players, Player 1 and Player 2!")
    (wait-enter)
    (clear-screen)))

(defn enumerate 
  "
  Enumerate a sequence
  
  coll -- the collection to enumerate

  returns a sequence of vectors [i x] where 
    i is the index and x is the value
  "
  [coll]
  (map vector (range) coll))

(defn hand-show 
  "
  Display a hand in enumerated fashion

  hand -- the hand to display
  "
  [hand]
  (doseq [[i x] (enumerate hand)]
    (println (format "%d) %s" i (card-name x)))))

(defn read-int 
  "Read an integer from stdin and return -1 on exceptions"
  []
  (try
   (print ">")
   (flush)
   (Integer/parseInt (read-line))
   (catch Exception e -1)))

(defn deck-create 
  "
  Create and shuffle a deck of cards

  returns a list that represents the deck
  "
  []
  (seq (shuffle (range 0 64))))

(defn deck-draw
  "
  Draw a card or multiple cards
  
  deck -- the original deck
  n -- the number of cards (default 1)

  returns [cards deck] where deck has n less cards
  "
  ([deck] (split-at 1 deck))
  ([deck n] (split-at n deck)))

;Deal 7 cards for a single player
(defn deal-hand 
  "
  Deal a hand of 7 cards
  
  deck -- the deck

  returns [hand deck]
  "
  [deck]
  (deck-draw deck 7))

(defn deal-pile 
  "
  Deal the first card to the pile.
  If the first card is an 8, reshuffle
  and try again

  deck -- the original deck
  
  returns [pile deck] where one card was
    moved from deck to pile
  "
  [deck]
  (let [top (first deck)]
    (if (= (card-rank top) 8)
      (deal-pile (shuffle deck))
      (deck-draw deck))))

(defn print-setup 
  "Print a summary of the game setup"
  []
  (do
   (println "Deck was created and shuffled with 64 cards")
   (println "Dealt 5 cards to each player")
   (println "Created the center pile")
   (wait-enter)
   (clear-screen)))

(defn setup 
  "
  Set up the initial game state

  returns a state map with the following keys:
    deck -- (list) newly created deck minus cards dealt
    hands -- (vector of list) hands for each player
    pile -- (list) center pile, starts with 1 card
    player -- (int) current player index
    wild-suit -- (int) wild suit when an 8 is played. starts at nil.
    turn -- (int) turn number. Starts at 1
  "
  []
  (let [deck (deck-create)
        [hand1 deck] (deal-hand deck)
        [hand2 deck] (deal-hand deck)
        [pile deck] (deal-pile deck)
         hands [hand1 hand2]]
    (game-welcome)
    (print-setup)
    {:deck deck :hands hands :pile pile :player 0 :wild-suit nil :turn 1}))


(defn play-card
  "
  Play a card onto the pile and update the
    wild suit

  card -- the card (integer)
  pile -- the pile (list)

  returns updated state variables: 
    [pile wild-suit]
  "
  [card pile]
  ;TODO: Move IO to separate function
  (do
   (println (format "Played the %s" (card-name card)))
   (wait-enter)
   (clear-screen)
   [(cons card pile) nil]))
   

(defn playable? 
  "
  Check if a card is playable given the
  top card in the pile

  card -- the top card
  pile -- the current pile

  returns true if the card is playable
  "
  [card pile]
  (let [top (first pile)]
  (or
   (= (card-rank card) 8)
   (= (card-rank card) (card-rank top))
   (= (card-suit card) (card-suit top)))))

(defn draw-until-playable-helper
  "
  Loop to draw cards until a playable one is found.

  hand -- the current player's hand
  pile -- the ceter pile
  deck -- the deck
  player -- the current player index

  returns updated [hand pile deck wild-suit]
  "
  [hand pile deck player]
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
       (let [[pile wild-suit] (play-card (first top-deck) pile)]
         [hand pile rest-deck wild-suit])
       ;Otherwise, put the top card in the player's hand andd try again
       :else (recur (concat hand top-deck) pile rest-deck)))))

(defn print-no-valid-cards-message
  "
  Print a message indicating that the user
  has no playable cards in his hand and has
  to draw for them.
  "
  []
  (do 
   (println "No playable cards in hand.") 
   (println "Drawing cards until a playable card is found.")))

(defn draw-until-playable
  "
  Draw cards until one can be played
  
  state -- the current state map

  returns the updated state map after drawing cards.
  "
  [{:keys [hands pile deck player] :as state}]
  (do
   (print-no-valid-cards-message))
   (let [hand (nth hands player)
         [hand pile deck wild-suit] (draw-until-playable-helper hand pile deck player)
         hands (assoc hands player hand)]
     (merge state {:hands hands :pile pile :deck deck :wild-suit wild-suit})))

(defn valid-cards 
  "
  Get a list of cards that are playable from a hand given the 
  center pile

  hand -- the player's hand
  pile -- the center pile

  returns a list of all the cards that can be placed
  on the pile
  "
  [hand pile]
  (filter #(playable? % pile) hand))

;TODO: Can this be an alias for rand-nth instead of a defn?
(defn choose-card-ai
  "
  Choose a random card from a hand of cards.
  This is meant for the AI at the lowest
  difficulty setting.

  hand -- the player's hand

  returns a random card from the list hand
  "
  [hand]
  (rand-nth hand))

;TODO: Can we have this loop/recur instead of being called recursively?
(defn choose-card-human
  "Have the user select a card, looping if necessary"
  [hand]
  (try
   (println "Pick a card:")
   (hand-show hand)
   (nth hand (read-int))
   (catch IndexOutOfBoundsException e (choose-card-human hand))))

(defn choose-card
  "
  Choose a card in a way that reflect's the
  player's status as a human or AI.

  valids -- the valid cards to choose from
  player -- the player index. This determines
    if we should delegate to the AI or human 
    choosing function

  returns the selected card
  "
  [valids player]
  ;TODO: Allow for more than 2 players
  (if (= player 0)
    (choose-card-human valids)
    (choose-card-ai valids)))
  
(defn hand-remove-card
  "
  Remove a card from a hand

  hand -- the hand of cards
  card -- the card to remove
  "
  [hand card]
  (remove #(= card %) hand))

(defn play-selection
  "
  Have the player select a card and then 
  play it
  
  state -- the current state map

  returns the updated state map after the cards
    have been played
  "
  [{:keys [hands pile player] :as state}]
  (let [hand (nth hands player)
        valids (valid-cards hand pile)
        card (choose-card valids player)
        hand (hand-remove-card hand card)
        [pile wild-suit] (play-card card pile)
        hands (assoc hands player hand)]
    (merge state {:hands hands :pile pile :wild-suit wild-suit})))

(defn print-human-hand 
  "
  Print the cards in the player's hand
  "
  [hand]
  (do
   (println "Your cards:")
   (hand-show hand)
   (println)))

(defn player-turn
  "
  Have the player take a turn

  state -- the current state map

  returns an updated state map
    with the results of the player's turn
  "
  [{:keys [hands pile turn player] :as state}]
  (let [hand (nth hands player)
        valids (valid-cards hand pile)]
    ;TODO: This should check if a player is human, not just Player 1
    (when (= player 0)
      (print-human-hand hand))
    (if (empty? valids)
        (draw-until-playable state)
        (play-selection state))))

(defn print-game-state
  "
  Print a quick summary of the current game state

  state -- the current state map
  "
  [{:keys [turn player hands pile] :as state}]
  (do
   (println (format "Turn %s - Player %s's turn=====" turn (inc player)))
   ;TODO: Support more than 2 players
   (println (format "Player 1 has %d cards" (count (nth hands 0))))
   (println (format "Player 2 has %d cards" (count (nth hands 1))))
   (println)
   (println (format "Top card: %s" (card-name (first pile))))
   (println)))

(defn next-turn 
  "
  Increment the turn counter and cycle through
  the players

  state -- the game state map

  returns a state map with updated
  :turn and :player keys
  "
  [{:keys [turn player] :as state}]
  (let [player (if (= player 0) 1 0) ;TODO: Handle more than 2 players
        turn (inc turn)]
    (merge state {:turn turn :player player})))

(defn game-turn
  "
  Advance the game by one turn, either
  player or AI

  state -- the game state map
  
  returns an updated state map
  "
  [{player :player :as state}]
  (do
   (print-game-state state)
   (next-turn (player-turn state))))

(defn game-over? 
  "
  Check if the game is over
  (i.e. one of the two hands is empty)

  state -- the state map

  returns true if the game is over
  "
  [{hands :hands}]
  (or
   (empty? (nth hands 0))
   (empty? (nth hands 1))))

(defn declare-winner 
  "
  Declare the winner depending on which hand in hands is
  empty

  state -- the game state map
  "
  [{hands :hands}]
  ;TODO: Handle more than two players
  ;TODO: Better way to access a player's hand?
  (cond
    (empty? (nth hands 0)) (println "Player 1 Wins!")
    (empty? (nth hands 1)) (println "Player 2 Wins!")))

(defn game-loop 
  "Main Game Loop"
  []
  (loop [state (setup)]
    (if (game-over? state)
      (declare-winner state)
      (recur (game-turn state)))))

;Actually run the game...
(game-loop)

