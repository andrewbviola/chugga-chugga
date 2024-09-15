//
//  PlayerSettings.swift
//  chuggachugga
//
//  Created by Travis C on 9/14/24.
//

import SwiftUI

struct PlayerSettings: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var playerName: String = ""
    @Binding var players: [Player]
    
    var emojis = ["🦖", "🦕", "☄️"]
    var colors: [Color] = [.green, .blue, .gray]
    @State var selectEmoji = "🦕"
    @State var selectColor = Color.blue
    @State private var isShowingSheet = false
    
    var body: some View {
        
        VStack{
            Text("player settings")
                    .font(.largeTitle.bold())
            
            Circle()
                .fill(selectColor)
                .padding()
                .overlay(
                        Text(selectEmoji)
                            .font(.system(size: 144))
                    )
            
            Button("Select Profile Photo") {
                isShowingSheet.toggle()
            }
            .padding()
            .background(colorScheme == .dark ? Color.white : Color.black)
            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(10)
            
            TextField(
                "Player Name",
                text: $playerName
            )
            .border(.primary)
            .cornerRadius(3)
            
            Button("Submit") {
                players.append(Player(name: playerName, scores: [], total: 0, emoji: selectEmoji, color: selectColor))
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(colorScheme == .dark ? Color.white : Color.black)
            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(10)
        }
        .disableAutocorrection(true)
        .padding()
        .textFieldStyle(.roundedBorder)
        .sheet(isPresented: $isShowingSheet) {
            Grid (horizontalSpacing: 1, verticalSpacing: 1) {
                GridRow {
                    Button(emojis[0]){
                        selectColor = colors[0]
                        selectEmoji = emojis[0]
                        isShowingSheet.toggle()
                    }
                    .background(colors[0])
                    .clipShape(Circle())
                    .font(.system(size: 80))
                    .padding()
                    
                    Button(emojis[0]){
                        selectColor = colors[1]
                        selectEmoji = emojis[0]
                        isShowingSheet.toggle()
                    }
                    .background(colors[1])
                    .clipShape(Circle())
                    .font(.system(size: 80))
                    .padding()
                    
                    Button(emojis[0]){
                        selectColor = colors[2]
                        selectEmoji = emojis[0]
                        isShowingSheet.toggle()
                    }
                    .background(colors[2])
                    .clipShape(Circle())
                    .font(.system(size: 80))
                    .padding()
                }
                GridRow {
                    Button(emojis[1]){
                        selectColor = colors[0]
                        selectEmoji = emojis[1]
                        isShowingSheet.toggle()
                    }
                    .background(colors[0])
                    .clipShape(Circle())
                    .font(.system(size: 75))
                    .padding()
                    
                    Button(emojis[1]){
                        selectColor = colors[1]
                        selectEmoji = emojis[1]
                        isShowingSheet.toggle()
                    }
                    .background(colors[1])
                    .clipShape(Circle())
                    .font(.system(size: 75))
                    .padding()
                    
                    Button(emojis[1]){
                        selectColor = colors[2]
                        selectEmoji = emojis[1]
                        isShowingSheet.toggle()
                    }
                    .background(colors[2])
                    .clipShape(Circle())
                    .font(.system(size: 75))
                    .padding()
                }
                GridRow {
                    Button(emojis[2]){
                        selectColor = colors[0]
                        selectEmoji = emojis[2]
                        isShowingSheet.toggle()
                    }
                    .background(colors[0])
                    .clipShape(Circle())
                    .font(.system(size: 75))
                    .padding()
                    
                    Button(emojis[2]){
                        selectColor = colors[1]
                        selectEmoji = emojis[2]
                        isShowingSheet.toggle()
                    }
                    .background(colors[1])
                    .clipShape(Circle())
                    .font(.system(size: 75))
                    .padding()
                    
                    Button(emojis[2]){
                        selectColor = colors[2]
                        selectEmoji = emojis[2]
                        isShowingSheet.toggle()
                    }
                    .background(colors[2])
                    .clipShape(Circle())
                    .font(.system(size: 75))
                    .padding()
                }
            }
        }
    }
}

//#Preview {
//    PlayerSettings()
//}
