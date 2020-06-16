//
//  ContentView.swift
//  Farms2
//
//  Created by Felix Reichenbach on 26.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack{
            Group {
                if (appState.loggedIn) {
                    MyView(viewModel: MyViewModel())
                } else {
                    LoginView()
                }
            }
            SplashScreen()
                .opacity(appState.showSplash ? 1 : 0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
