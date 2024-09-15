import SwiftUI


struct Round: Identifiable {
    let id = UUID()
    let number: Int
    let score: Int
}

struct PlayerScoresView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var player: Player
    
    var rounds: [Round] {
            player.scores.enumerated().map { Round(number: $0 + 1, score: $1) }
        }
    
    var body: some View {
        VStack {
            Text("\(player.name)")
                .font(.largeTitle.bold())
            
            Spacer()
            
            List {
            ForEach(rounds) { round in
                Text("Round \(round.number) | \(round.score)")
                }
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
        }
    }
}
