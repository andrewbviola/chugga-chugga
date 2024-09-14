//
//  PlayerSettings.swift
//  chuggachugga
//
//  Created by Travis C on 9/14/24.
//

import SwiftUI

struct PlayerSettings: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var playerName: String = ""
    @Binding var players: [Player]
    
    var body: some View {
        
        VStack{
//            Text("player settings")
//                    .font(.largeTitle.bold())
//            
//            Circle()
//                .padding()
//                .overlay(
//                        Image("DominoDark")
//                            .resizable()
//                            .frame(width: 150, height: 204)
//                    )
//            
//            Button("Add Photo") {
//            }
//            .padding()
//            .background(Color.black)
//            .foregroundColor(Color.white)
//            .cornerRadius(10)
            
            TextField(
                "Player Name",
                text: $playerName
            )
            .padding()
            
            Button("Submit") {
                players.append(Player(name: playerName, scores: [], total: 0))
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(Color.white)
            .cornerRadius(10)
        }
        .disableAutocorrection(true)
        .textFieldStyle(.roundedBorder)
    }
}

//#Preview {
//    PlayerSettings()
//}
