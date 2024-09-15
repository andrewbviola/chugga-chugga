//
//  PlayerScoresView.swift
//  chuggachugga
//
//  Created by Travis C on 9/14/24.
//

import SwiftUI

struct PlayerScoresView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var player: Player
    
    var body: some View {
        VStack {
            Text("\(player.name)")
                .font(.largeTitle.bold())
            
            Spacer()
            
            List() {
                
                ForEach(player.scores, id: \.self) { number in
                    Text("Round \(player.round) | \(number)")
                }
//                for (n, c) in player.scores.enumerated() {
//                    Text("Round \(n) | \(c)")
//                }
            }
            
            NavigationLink(destination: CameraView(onConfirm: { sum in
                player.scores.append(sum)
                player.total += sum

            })) {
                Text("Add Score")
                    .padding()
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .cornerRadius(10)
            }
            .padding()
            
//            Button("Add Score") {
//                player.scores.append(10)
//                player.total += 10
//            }
//            .padding()
//            .background(Color.black)
//            .foregroundColor(Color.white)
//            .cornerRadius(10)
        }
    }
}
//#Preview {
//    @State var test = Player(name: "Test")
//    PlayerScoresView(player: $test)
//}
