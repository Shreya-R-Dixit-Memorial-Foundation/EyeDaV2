import SwiftUI
import Combine
import HealthKit 

class AppLifecycleObserver: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var leaveCount = UserDefaults.standard.integer(forKey: "leaveCount")

    init() {
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                self?.incrementLeaveCount()
            }
            .store(in: &cancellables)
    }

    private func incrementLeaveCount() {
        leaveCount += 1
        UserDefaults.standard.set(leaveCount, forKey: "leaveCount")
    }

    func resetLeaveCount() {
        leaveCount = 0
        UserDefaults.standard.set(0, forKey: "leaveCount")
    }
}

extension Color {
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        if hexString.count != 6 {
            self.init(UIColor.gray) // Fallback to gray color if hex string is invalid
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: 1.0
        )
    }
}

struct HomeView: View {
    @State private var currentDate = Date()
    @ObservedObject private var appLifecycleObserver = AppLifecycleObserver()
    @State private var isDriveStarted = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(currentDate, style: .date)
                .font(.headline)
                .foregroundColor(Color(hex: "#FDF050"))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Overall Score")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#478370"))
                
                Text("You have left the app \(appLifecycleObserver.leaveCount) times.")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            Button(action: {
                startDrive()
            }) {
                Text("Start Drive")
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(8)
            
            Button(action: {
                endDrive()
            }) {
                Text("End Drive")
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.red)
            .cornerRadius(8)
            
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(hex: "#2B2934"))
        .onAppear {
            startTimer()
            requestHealthKitAuthorization()
        
            // Request HealthKit authorization when the view appears
        }
        .onDisappear(perform: {
        })
        .navigationTitle("Home")
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            currentDate = Date()
        }
    }
    
    private func startDrive() {
        appLifecycleObserver.resetLeaveCount()
        isDriveStarted = true
    }
    
    private func endDrive() {
        appLifecycleObserver.resetLeaveCount()
        isDriveStarted = false
    }
    
    private func requestHealthKitAuthorization() {
        let healthStore = HKHealthStore()
        
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        healthStore.requestAuthorization(toShare: nil, read: [sleepType]) { (success, error) in
            if success {
                print("HealthKit authorization granted for sleep data.")
            } else {
                print("HealthKit authorization denied for sleep data: \(error?.localizedDescription ?? "Unknown Error")")
            }
        }
    }
}
