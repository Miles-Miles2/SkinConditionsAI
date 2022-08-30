//
//  MultitabView.swift
//  SkinConditionsAI
//
//  Created by Keiser on 8/22/22.
//

import SwiftUI

struct MultitabView: View {
        @State private var tabSelection=1
        var body: some View {
            TabView(selection:$tabSelection) {
                RunAIView()
                    .tabItem{
                       Label("Run AI",systemImage: "play.fill")
                    }
                    .tag(1)
                InfoView()
                    .tabItem{
                       Label("Info",systemImage: "info.circle")
                    }
                    .tag(2)
                CreditsView()
                    .tabItem{
                       Label("Credits",systemImage: "person.fill")
                    }
                    .tag(3)
            }
        }
}

struct MultitabView_Previews: PreviewProvider {
    static var previews: some View {
        MultitabView()
    }
}
