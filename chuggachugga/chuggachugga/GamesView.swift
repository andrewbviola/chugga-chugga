//
//  GamesView.swift
//  chuggachugga
//
//  Created by Travis C on 9/13/24.
//

import SwiftUI

struct GamesView: View {    
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var games: [String]
    @State var players: [Player] = []
    @State var numGames = 0
    
    func delete(at offsets: IndexSet) {
        games.remove(atOffsets: offsets)
    }
    
    var body: some View {
        VStack{
            
            VStack {
                Text("Games")
                        .font(.largeTitle.bold())
                
                Spacer()
                
//                List {
//                    NavigationLink(destination: PlayersView(players: $players)) {
//                        Text("Game 1")
//                    }
//                    NavigationLink(destination: PlayersView(players: $players)) {
//                        Text("Game 2")
//                    }
//                    NavigationLink(destination: PlayersView(players: $players)) {
//                        Text("Game 3")
//                    }
//                }
                
                List {
                    ForEach(games, id: \.self) { game in
                        NavigationLink(destination: PlayersView(players: $players)) {
                            Text(game)
                        }
                    }
                    .onDelete(perform: delete)
                }
                
                Button("Add Game") {
                    games.append("Game " + "\(numGames + 1)")
                    numGames += 1
                }
                .padding()
                .background(colorScheme == .dark ? Color.white : Color.black)
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .cornerRadius(10)
            }
        }
    }
}

//#Preview {
//    GamesView()
//}
