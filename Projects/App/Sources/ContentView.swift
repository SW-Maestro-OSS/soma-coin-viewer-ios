import SwiftUI
import Domain
import CoreUtil
import I18N

struct ContentView: View {
    
    
    @State var text: String = ""
    
    var body: some View {
        VStack {
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear(perform: {
        
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
