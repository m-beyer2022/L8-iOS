import SwiftUI

struct SettingsView: View {
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("streamingQuality") private var streamingQuality = "High"
    @AppStorage("explicitContent") private var explicitContent = true
    @AppStorage("autoPlay") private var autoPlay = true
    @AppStorage("cacheSize") private var cacheSize = "1.2 GB"
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Preferences").font(.headline)) {
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                    Picker("Streaming Quality", selection: $streamingQuality) {
                        Text("Low").tag("Low")
                        Text("Medium").tag("Medium")
                        Text("High").tag("High")
                    }
                    Toggle("Explicit Content", isOn: $explicitContent)
                    Toggle("Auto-play", isOn: $autoPlay)
                }
                
                Section(header: Text("Account").font(.headline)) {
                    NavigationLink("Subscription") {
                        Text("Subscription Details")
                            .navigationTitle("Subscription")
                    }
                    NavigationLink("Payment Methods") {
                        Text("Payment Methods")
                            .navigationTitle("Payment")
                    }
                }
                
                Section(header: Text("Storage").font(.headline)) {
                    HStack {
                        Text("Cache Size")
                        Spacer()
                        Text(cacheSize)
                            .foregroundColor(.secondary)
                    }
                    Button("Clear Cache") {
                        // Mock cache clearing
                        cacheSize = "0.0 GB"
                    }
                    .foregroundColor(.blue)
                }
                
                Section {
                    Button("Sign Out") {
                        // Mock sign out
                    }
                    .foregroundColor(.red)
                }
                
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersion)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .listStyle(.insetGrouped)
            .tint(.purple) // App accent color
        }
    }
}

#Preview {
    SettingsView()
}
