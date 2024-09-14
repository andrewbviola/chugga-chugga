//
//  PlayersView.swift
//  chuggachugga
//
//  Created by Travis C on 9/13/24.
//

import SwiftUI

struct PlayersView: View {
    
    @Binding var players: [Player]
    
    func delete(at offsets: IndexSet) {
        players.remove(atOffsets: offsets)
    }
    
    var body: some View {
        
        VStack{
            Text("Players")
                    .font(.largeTitle.bold())
            
//            List(players) { player in
//                NavigationLink(destination: PlayerScoresView(player: $players[players.firstIndex(where: { $0.id == player.id })!])) {
//                    Text("\(player.name) \(player.total)")
//                }
//            }
            
            List {
                ForEach(players, id: \.self) { player in
                    NavigationLink(destination: PlayerScoresView(player: $players[players.firstIndex(where: { $0.id == player.id })!])) {
                        Text("\(player.name) \(player.total)")
                    }
                }
                .onDelete(perform: delete)
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

//#Preview {
//    PlayersView()
//}
