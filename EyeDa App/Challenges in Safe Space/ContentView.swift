
import SwiftUI

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        if hexString.count != 6 {
            self.init(white: 0.5, alpha: 1.0)
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

struct TabBarItem: View {
    let icon: String
    let label: String
    let iconColor: Color

    init(icon: String, label: String, iconColorHex: String) {
        self.icon = icon
        self.label = label
        self.iconColor = Color(UIColor(hex: iconColorHex))
        UINavigationBar.appearance().tintColor = UIColor.blue // Set a more visible color

    }

    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
            Text(label)
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                HomeView()
            }
            .accentColor(.blue)
            .tabItem {
                TabBarItem(icon: "house.fill", label: "Home", iconColorHex: "#1A5944")
            }
            
            NavigationView {
                SettingsView()
            }
            .accentColor(.blue)
            .tabItem {
                TabBarItem(icon: "gearshape.fill", label: "Settings", iconColorHex: "#00FF29")
            }
            
            NavigationView {
                SquadsView()
            }
            .tabItem {
                TabBarItem(icon: "person.2.fill", label: "Squads", iconColorHex: "#1A5944")
            }
            
            NavigationView {
                EyeView()
            }
            .tabItem {
                TabBarItem(icon: "eye.fill", label: "Eyeda", iconColorHex: "#1A5944")
            }
        }
    }
}
