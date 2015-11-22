#!/usr/bin/clojure

;Settings for default representation
(def RANKS 16)
(def SUITS 4)
(def WILDS 4)
(def RANK_NAMES "0123456789ABCDEF")
(def SUIT_NAMES ["Spades" "Hearts" "Clubs" "Diamonds"])

;Rank of the card is the last 4 bits
(defn card-rank [card] 
  (bit-and card (- RANKS 1)))

;Suit of the card is the second set of 2 bits from the left
(defn card-suit [card]
  (bit-and (unsigned-bit-shift-right card 4) 
           (- SUITS 1)))

;Wild number is the first 2 bits from the left
(defn card-wild [card]
  (bit-and (unsigned-bit-shift-right card 6) 
           (- WILDS 4)))

;display the card as "<rank> of <suit>"
(defn card-name 
  ([card]
   (format "%s of %s"
	       (get RANK_NAMES (card-rank card))
	       (get SUIT_NAMES (card-suit card))))
  ([card rank-names suit-names]
   (format "%s of %s" 
           (get rank-names (card-rank card)) 
		   (get suit-names (card-suit card)))))
