import SwiftUI

struct ContentView: View {

    @State private var isOnCall = CallStateObserver.shared.isOnCall

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: isOnCall ? "phone.fill" : "phone.slash")
                .imageScale(.large)
                .foregroundStyle(isOnCall ? .green : .secondary)

            Text(isOnCall ? "Rozmowa trwa" : "Brak aktywnej rozmowy")
                .font(.headline)
        }
        .padding()
        .onAppear {
            CallStateObserver.shared.onCallStateChanged = { active in
                isOnCall = active
            }
        }
    }
}

#Preview {
    ContentView()
}
