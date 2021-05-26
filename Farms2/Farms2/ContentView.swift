//
//  ContentView.swift
//  Farms2
//
//  Created by Felix Reichenbach on 26.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI
import RealmSwift

// Global application object
let app: RealmSwift.App? = RealmSwift.App(id: Constants.MY_REALM_APP)

@main
struct Farms2App: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AppState())
        }
    }
}

struct ContentView: View {

    @EnvironmentObject var state: AppState
    @State var view: String = ""
    
    var body: some View {
        
        ZStack {
            if (state.orders != nil) {
                NewView()
            } else {
                LoginView()
            }
            // If the app is doing work in the background,
            // overlay an ActivityIndicator
            if state.shouldIndicateActivity {
                SplashScreen()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppState())
    }
}
