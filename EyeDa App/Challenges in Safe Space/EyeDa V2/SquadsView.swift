import SwiftUI

struct SquadsView: View {
    // Define the LeaderboardEntry struct here
    struct LeaderboardEntry: Identifiable {
        let id = UUID()
        let rank: Int
        let username: String
        let score: Int
    }

    // Sample leaderboard data (replace this with your actual data)
    let leaderboardData = [
        LeaderboardEntry(rank: 1, username: "U1", score: 100),
        LeaderboardEntry(rank: 2, username: "U2", score: 85),
        LeaderboardEntry(rank: 3, username: "U3", score: 70),
        LeaderboardEntry(rank: 4, username: "U4", score: 50),
    ]

    // Define the badge milestones here
    let milestones: [String] = [
        "Five trips with perfect cornering",
        "Nine trips with perfect braking",
        "100 trips with a score above 70"
    ]

    // Dummy data to simulate progress
    let progressData: [Double] = [3, 7, 85] // Replace with actual progress data

    var body: some View {
        VStack {
            Text("Safety Squads")
                .font(.custom("GlacialIndifference-Regular", size: 24))
                .italic()
                .foregroundColor(Color(hex: "#DD9212"))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "#72BFA1"))

            // Badge Milestones section
            VStack(alignment: .leading) {
                Text("Badge Milestones")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)

                ForEach(0..<milestones.count, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Text(milestones[index])
                            .foregroundColor(.white)
                            .padding(.horizontal)

                        ProgressBar(value: progressData[index], total: 100)
                            .frame(height: 10)
                            .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "#2B2934"))
            .cornerRadius(12)

            // Leaderboard list view
            List {
                ForEach(leaderboardData) { entry in
                    LeaderboardRow(entry: entry)
                }
            }
            .listStyle(PlainListStyle())

            // Your existing code for the rest of the squad view...
        }
    }
}


// LeaderboardRow implementation
struct LeaderboardRow: View {
    let entry: SquadsView.LeaderboardEntry

    var body: some View {
        HStack {
            Text("\(entry.rank)")
                .font(.headline)
                .foregroundColor(.white)
                .padding(8)
                .background(Color.blue)
                .cornerRadius(8)
            Text(entry.username)
                .foregroundColor(.black)
                .padding(.leading, 8)
            Spacer()
            Text("\(entry.score)")
                .foregroundColor(.black)
        }
        .padding(.horizontal)
    }
}

// ProgressBar implementation
struct ProgressBar: View {
    let value: Double
    let total: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)

                Rectangle()
                    .frame(width: min(CGFloat(self.value / self.total) * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color.green)
            }
            .cornerRadius(45.0)
        }
    }
}

