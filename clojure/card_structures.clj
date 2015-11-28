;Deck - a list of cards -------------------------------

(defn deck-create 
  "Create and shuffle a deck of cards

  returns a list that represents the deck"
  []
  (seq (shuffle (range 0 64))))

(defn deck-draw
  "Draw a card or multiple cards
  
  deck -- the original deck
  n -- the number of cards (default 1)

  returns [cards deck] where deck has n less cards"
  ([deck] (split-at 1 deck))
  ([deck n] (split-at n deck)))

;Discard Pile - a list of cards -----------------------

;DeckAndDiscard - a vector [deck discard] -------------

;Hand - a vector of cards -----------------------------

(defn hand-show 
  "Display a hand in enumerated fashion

  hand -- the hand to display"
  [hand]
  (doseq [[i x] (map vector (range) hand)]
    (printf "%d) %s\n" i (card-name x))))

(defn hand-remove
  "Remove a card from a hand

  hand -- the hand of cards
  card -- the card to remove"
  [hand card]
  (remove #(= card %) hand))

;Utility Functions

(defn deal-hand 
  "Deal a hand of n cards from a deck

  returns [hand deck]"
  [deck n]
  (deck-draw deck n))
