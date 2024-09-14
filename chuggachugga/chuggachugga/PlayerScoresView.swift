//
//  PlayerScoresView.swift
//  chuggachugga
//
//  Created by Travis C on 9/14/24.
//

import SwiftUI

struct PlayerScoresView: View {
    
    @Binding var player: Player;
    
    var body: some View {
        
        VStack{
            Text("\(player.name)")
                .font(.largeTitle.bold())
            
            Spacer()
            List {
                ForEach(player.scores, id: \.self) { number in
                    Text("\(number)")
                }
            }
            Button("Add Score") {
                player.scores.append(10)
                player.total += 10
            }
            .padding()
            .background(Color.black)
            .foregroundColor(Color.white)
            .cornerRadius(10)
        }
    }
}

//#Preview {
//    @State var test = Player(name: "Test")
//    PlayerScoresView(player: $test)
//}
