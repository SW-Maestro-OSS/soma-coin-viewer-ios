import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Hello, World!")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
