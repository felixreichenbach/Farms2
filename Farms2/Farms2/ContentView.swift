//
//  ContentView.swift
//  Farms2
//
//  Created by Felix Reichenbach on 26.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        Group {
            if (userState.loggedIn) {
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
