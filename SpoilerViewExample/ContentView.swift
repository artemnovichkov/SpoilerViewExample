//
//  Created by Artem Novichkov on 27.02.2023.
//

import SwiftUI

struct ContentView: View {

    @State var spoilerIsOn = true

    var body: some View {
        VStack {
            Text("Everything will be good")
                .font(.title)
                .opacity(0)
                .modifier(SpoilerModifier(isOn: true))
            Text("You're awesome!")
                .font(.title)
                .spoiler(isOn: $spoilerIsOn)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

