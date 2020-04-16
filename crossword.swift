import Foundation

func crosswordPuzzle(crossword: [String], words: String) -> [String] {
	return solve(crossword: crossword, words: words)
}

func solve(crossword: [String], words: String, locationCache: [String: (Int,Int,Bool)] = [:]) -> [String] {

	if words == "" {
		return crossword
	}
		
	var crossword_ = crossword
	var array = words.components(separatedBy: ";")
	var locationCache_ = locationCache
	let word = array.popLast()!
		
	if let location = getPossibleLocations(crossword: crossword, word: word) {
		
		crossword_ = move(crossword: crossword_, word: word, location: location)	
		locationCache_[word] = location
		
	} else {
		
		// Restart 
			
		for (word, location) in locationCache {
						
			array.append(word)
			
			let chars = Array(String(word))
			let mapped: [Character] = chars.map { _ in
				return "-"
			}
			
			crossword_ = move(crossword: crossword_, word: String(mapped), location: location)	
		}
		
		array.append(word)
		let remaining = array.joined(separator: ";")
		return solve(crossword: crossword_, words: remaining)
	}
		
	let remaining = array.joined(separator: ";")
	return solve(crossword: crossword_, words: remaining, locationCache: locationCache_)
}

// x, y, horizontal
func getPossibleLocations(crossword: [String], word: String) -> (Int, Int, Bool)? {
	
	for i in 0..<10 {
		
		for j in 0..<(10 - word.count + 1) {
			
			var horizontal: Bool = true
			
			for (wordCharacterIndex, wordCharacter) in word.enumerated() {
				
				let row_ = Array(crossword)[i]
				let character_ = Array(row_)[j + wordCharacterIndex]
				let bingo = [String(wordCharacter), "-"]
				
				if !bingo.contains(String(character_)) {
					horizontal = false 
				} 
			}
			
			if horizontal {
				return (i, j, true)
			}
		}
	}
	
	for i in 0..<(10 - word.count + 1) {
		
		for j in 0..<10 {
			
			var vertical: Bool = true
			
			for (wordCharacterIndex, wordCharacter) in word.enumerated() {
				
				let row_ = Array(crossword)[i + wordCharacterIndex]
				let character_ = Array(row_)[j]
				let bingo = [String(wordCharacter), "-"]
				
				if !bingo.contains(String(character_)) {
					vertical = false 
				} 
			}
			
			if vertical {
				return (i, j, false)
			}
		}
	}
	
	return nil
}

func move(crossword: [String], word: String, location: (x: Int, y: Int, horizontal: Bool)) -> [String] {
	
	var crossword_ = crossword
	
	if location.horizontal {
		
		for (index, character) in word.enumerated() {
			
			let row_ = crossword_[location.x]
			var chars = Array(row_)
			chars[location.y + index] = character
			crossword_[location.x] = String(chars)
		}
		
		return crossword_
		
	} else {
		
		for (index, character) in word.enumerated() {
			
			let row_ = crossword_[location.x + index]
			var chars = Array(row_)
			chars[location.y] = character
			crossword_[location.x + index] = String(chars)
		}
		
		return crossword_
	}
}

let crossword = [
	"XXXXXX-XXX",
	"XX------XX",
	"XXXXXX-XXX",
	"XXXXXX-XXX",
	"XXX------X",
	"XXXXXX-X-X",
	"XXXXXX-X-X",
	"XXXXXXXX-X",
	"XXXXXXXX-X",
	"XXXXXXXX-X"
]
print(crosswordPuzzle(crossword: crossword, words: "ICELAND;MEXICO;PANAMA;ALMATY"))