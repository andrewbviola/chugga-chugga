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
    var total: Int
}

struct Game: Identifiable, Hashable {
    let id = UUID()
    var gameName: String
    var players: [Player]
}

struct ContentView: View {
    
    @State var games: [String] = []
    
    var body: some View {
        VStack{

            NavigationView {
                
                VStack{
                    Image("DominoDark")
                        .resizable()
                        .frame(width: 100, height: 136)
                    
                    VStack {
                        Text("chugga chugga")
                                .font(.largeTitle.bold())
                        
                        NavigationLink(destination: GamesView(games: $games)) {
                            Text("CHUG")
                                .padding()
                                .background(Color.black)
                                .foregroundColor(Color.white)
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
