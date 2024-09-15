//
//  ContentView.swift
//  chuggachugga
//
//  Created by Travis C on 9/13/24.
//

import SwiftUI

struct Player: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var scores: [Int]
    var round: Int = 0
    var total: Int
    var emoji: String
    var color: Color
}

struct Game: Identifiable, Hashable {
    let id = UUID()
    var gameName: String
    var players: [Player]
}

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var games: [String] = []
    
    var body: some View {
        VStack{

            NavigationView {
                
                VStack{
                    Image(colorScheme == .dark ? "DominoDark" : "DominoLight")
                        .resizable()
                        .frame(width: 100, height: 136)
                    
//                    Text("🚂")
//                        .font(.system(size: 144))
                    
                    VStack {
                        Text("chugga chugga")
                                .font(.largeTitle.bold())
                        
                        NavigationLink(destination: GamesView(games: $games)) {
                            Text("ALL ABOARD")
                                .padding()
                                .background(colorScheme == .dark ? Color.white : Color.black)
                                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
