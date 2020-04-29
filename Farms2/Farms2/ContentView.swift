//
//  ContentView.swift
//  Farms2
//
//  Created by Felix Reichenbach on 26.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        Group {
            if (settings.loggedIn) {
                MyView(viewModel: MyViewModel())
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
