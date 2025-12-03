//
//  WordGameViewModel.swift
//  final_project_Mike_McGlinchy
//
//  Created by Mike McGlinchy on 11/30/25.
//

import SwiftUI
import Foundation

//Define the view model class that manages the game logic and state.
//It conforms to observableObject to allow SwiftUI views to observe its
//published properties
class WordGameViewModel: ObservableObject {
    @Published var originalWords: [String] = [] //list of correct words
    @Published var shuffledWords: [String] = []  //list of scrambled words
    @Published var userGuesses: [String] = Array(repeating: "", count: 6)
    //Array to store the user's input for each word, initialized with
    //empty strings
    // results property is now a computed property based on userGuesses
  
    let fileName = "words"  //name of text file containing the word list
    let fileExtension = "txt" //extension of the word file
    let wordCount = 6  //fixed number of words for each game

    //Initializer for the view model, automatically starts a new game
    init() {
        loadAndSelectRandomWords()
    }

    // New computed property to determine correctness of all words
    //Returns true if all guess fields have input and all inputs match
    //the original words.
    var allWordsCorrect: Bool {
        for index in 0..<originalWords.count {
            let guess = userGuesses[index].trimmingCharacters(in: .whitespacesAndNewlines).lowercased() //Get the trimmed and
                 //lowercase guess.
            //If any guess doesn't match the original
            //word or is empty, return false immediately
            if guess != originalWords[index].lowercased() || guess.isEmpty {
                return false // Not all words are correct or some are empty
            }
        }
        return true // All words are correct and not empty
    }

    // Function to check if guess is correct
    func isGuessCorrect(index: Int) -> Bool {
        let guess = userGuesses[index].trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return !guess.isEmpty && guess == originalWords[index].lowercased()
    }

    //function to load words from a text file in the app bundle and select a
    //random subset.
    func loadAndSelectRandomWords() {
        if let fileURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            do {
                //read file contents into a single string
                let contents = try String(contentsOf: fileURL, encoding: .utf8)
                //Split the string by newlines and filter out any empty lines
                let allWords = contents.components(separatedBy: CharacterSet.newlines)
                    .filter { !$0.isEmpty } // Remove empty lines

                // Select 6 random words using the shuffled() and prefix() methods
                let selectedWords = allWords.shuffled().prefix(wordCount)

                // Store original words and reset state
                self.originalWords = Array(selectedWords)
                self.userGuesses = Array(repeating: "", count: wordCount)
                //Reset user input fields for the new game

                // Create shuffled versions for user to unscramble
                self.shuffledWords = self.originalWords.map { String($0.shuffled()) }
                
            } catch {
                //handle errors during file reading
                print("Error loading words file: \(error.localizedDescription)")
            }
        } else {
            print("Words file not found")
        }
    }
    
    // Function to begin new game
    func loadNewWords() {
        loadAndSelectRandomWords()
    }
}

