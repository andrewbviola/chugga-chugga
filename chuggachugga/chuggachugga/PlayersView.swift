//
//  PlayersView.swift
//  chuggachugga
//
//  Created by Travis C on 9/13/24.
//

import SwiftUI

struct PlayersView: View {
    @State private var showingCamera = false
    
    var body: some View {
        VStack{
            Text("players")
                    .font(.largeTitle.bold())
            
            List {
                NavigationLink(destination: CounterView()) {
                    Text("Player 1 (#)")
                }
                NavigationLink(destination: CounterView()) {
                    Text("Player 2")
                }
                NavigationLink(destination: CounterView()) {
                    Text("Player 3")
                }
                NavigationLink(destination: CounterView()) {
                    Text("Player 4")
                }
                NavigationLink(destination: CounterView()) {
                    Text("Player 5")
                }
                NavigationLink(destination: CounterView()) {
                    Text("Player 6")
                }
                NavigationLink(destination: CounterView()) {
                    Text("Player 7")
                }
                NavigationLink(destination: CounterView()) {
                    Text("Player 8")
                }
            }
        }
    }
}

#Preview {
    PlayersView()
}
