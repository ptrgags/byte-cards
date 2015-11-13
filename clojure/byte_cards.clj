(def RANKS 16)
(def SUITS 4)
(def WILDS 4)
(def RANK_NAMES "0123456789ABCDEF")
(def SUIT_NAMES ["Spades" "Hearts" "Clubs" "Diamonds"])

(defn rank [card] 
	(bit-and card (- RANKS 1)))

(defn suit [card]
	(bit-and (unsigned-bit-shift-right card 4) (- SUITS 1)))

(defn wild [card]
	(bit-and (unsigned-bit-shift-right card 6) (- WILDS 4)))

(defn card-name 
	([card]
		(format "%s of %s"
			(get RANK_NAMES (rank card))
			(get SUIT_NAMES (suit card))))
	([card rank-names suit-names]
		(format "%s of %s" 
			(get rank-names (rank card)) 
			(get suit-names (suit card)))))

(println (suit 0xFF))
(println (rank 0xFF))
(println (card-name 0xFF)) 
