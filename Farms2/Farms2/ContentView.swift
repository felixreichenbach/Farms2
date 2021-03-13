//
//  ContentView.swift
//  Farms2
//
//  Created by Felix Reichenbach on 26.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        
        // If a realm is open for a logged in user, show the ItemsView
        // else show the LoginView
        if let orders = state.orders {
            // If using Realm Sync and authentication, provide a logout button
            // in the top left of the ItemsView.
            let leadingBarButton = app != nil ? AnyView(LogoutButton().environmentObject(state)) : nil
            OrderView(orders: orders,
                      leadingBarButton: leadingBarButton)
                .disabled(state.shouldIndicateActivity)
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppState())
    }
}
