//
//  GamesView.swift
//  chuggachugga
//
//  Created by Travis C on 9/13/24.
//

import SwiftUI

struct GamesView: View {    
    var body: some View {
        VStack{
            
            VStack {
                Text("games")
                        .font(.largeTitle.bold())
                
                Spacer()
                
                List {
                    NavigationLink(destination: PlayersView()) {
                        Text("Game 1")
                    }
                    NavigationLink(destination: PlayersView()) {
                        Text("Game 2")
                    }
                    NavigationLink(destination: PlayersView()) {
                        Text("Game 3")
                    }
                }
            }
        }
    }
}

#Preview {
    GamesView()
}
