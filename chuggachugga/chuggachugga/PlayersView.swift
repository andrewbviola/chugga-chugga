//
//  PlayersView.swift
//  chuggachugga
//
//  Created by Travis C on 9/13/24.
//

import SwiftUI

struct Player: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var scores: [Int]
    var total: Int
}

struct PlayersView: View {
    
    @State var players: [Player] = [
        Player(name: "Andrew", scores: [], total: 0),
        Player(name: "Travis", scores: [], total: 0)
    ]
    
    var body: some View {
        
        VStack{
            Text("players")
                    .font(.largeTitle.bold())
            
            List(players) { player in
                NavigationLink(destination: PlayerScoresView(player: $players[players.firstIndex(where: { $0.id == player.id })!])) {
                    Text("\(player.name) \(player.total)")
                }
            }
            
            NavigationLink(destination: PlayerSettings(players: $players)) {
                Text("Add Player")
                    .padding()
                    .background(Color.black)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    PlayersView()
}
