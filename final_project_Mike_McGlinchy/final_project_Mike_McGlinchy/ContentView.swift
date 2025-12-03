//
//  ContentView.swift
//  final_project_Mike_McGlinchy
//
//  Created by Mike McGlinchy on 11/11/25.
//

import SwiftUI
import Foundation


struct ContentView: View {
    // Instantiate the ViewModel using @StateObject. This ensures the
    //ViewModel persists across view updates.
    @StateObject private var viewModel = WordGameViewModel()
    //State variable to control the blinking animation.
    @State private var blinking: Bool = false
    
    var body: some View {
        NavigationStack {
            //Display a list of shuffled words and their input fields.
            List(0..<viewModel.shuffledWords.count, id: \.self) { index in
                VStack(alignment: .leading) {
                 //Display the shuffled word.
                    Text((viewModel.shuffledWords[index]))                        .font(.headline)
                    
                    HStack {
                        // Bind directly to the userGuesses array in the ViewModel
                        TextField("Your guess", text: $viewModel.userGuesses[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none) // Optional: common for word games
                            .disableAutocorrection(true) // Optional: common for word games
                        
                        // Display status icon if the guess is not empty
                        if !viewModel.userGuesses[index].isEmpty {
                            Image(systemName: viewModel.isGuessCorrect(index: index) ? "checkmark.circle.fill" : "xmark.circle.fill")
                                 //Set color based on correctness
                                .foregroundColor(viewModel.isGuessCorrect(index: index) ? .green : .red)
                                .imageScale(.large)
                        }
                    }
                    
                }
            }
            
            Button("Load New Words") {
                viewModel.loadNewWords()
            }
            //Display "All words are correct!" message at the bottom if true
            .safeAreaInset(edge: .bottom) {
                if viewModel.allWordsCorrect && !viewModel.originalWords.isEmpty {
                    Text("All words are correct!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.green.opacity(0.2)) //light green
                        .cornerRadius(10)  //rounded corners
                        .padding()
                        .opacity(blinking ? 0 : 1) //opacity for blinking effect
                        .animation(
                            Animation.easeInOut(duration: 0.8) // Adjust duration as needed
                                .repeatForever(autoreverses: true),
                            value: blinking  //Animate when the blinking state                   //changes
                            )
                            .onAppear {
                            // Start the blinking animation when the view appears
                            blinking = true
                            }
                            .onDisappear {
                               // Stop the blinking animation when the
                               //view is dismissed
                            blinking = false
                            }
                }
            }
            //navigation title for the view
            .navigationTitle("JUMBLE WORD GAME")
        
        }
        
    }
}
//Preview provider for Xcode Canvas to display the ContentView
#Preview {
    ContentView()
}




