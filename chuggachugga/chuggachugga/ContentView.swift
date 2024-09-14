//
//  ContentView.swift
//  chuggachugga
//
//  Created by Travis C on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    
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
                        
                        NavigationLink(destination: GamesView()) {
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
