//
//  Created by Artem Novichkov on 27.02.2023.
//

import SwiftUI

struct ContentView: View {

    @State var showSpoiler = true

    var body: some View {
        VStack {
            Text("Everything will be good")
                .font(.title)
                .spoiler(show: $showSpoiler)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

