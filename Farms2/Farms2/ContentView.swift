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
            ContentView(app: app!).environmentObject(AppState())
        }
    }
}

struct ContentView: View {
    @ObservedObject var app: RealmSwift.App
    @EnvironmentObject var state: AppState
    
    var body: some View {
        
        ZStack {
            
            // If a realm is open for a logged in user, show the ItemsView
            // else show the LoginView
            
            if let orders = state.orders {
                OrderView(orders: orders)
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
        ContentView(app: RealmSwift.App(id: Constants.MY_REALM_APP)).environmentObject(AppState())
    }
}
