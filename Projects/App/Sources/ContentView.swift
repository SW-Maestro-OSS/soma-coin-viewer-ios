import SwiftUI
import Domain
import PresentationUtil

struct ContentView: View {
    
    @Injected var testPepository: TestRepository
    
    @State var text: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear(perform: {
            text = testPepository.getSayHelloText()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
