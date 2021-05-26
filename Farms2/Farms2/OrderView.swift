//
//  NewView.swift
//  Farms2
//
//  Created by Felix Reichenbach on 25.05.21.
//  Copyright © 2021 Felix Reichenbach. All rights reserved.
//

import SwiftUI
import RealmSwift

struct OrderView: View {
    
    var body: some View {
        ZStack {
            TabView {
                Orders()
                    .tabItem {
                        Label("Orders", systemImage: "list.dash")
                    }
                UserProfile()
                    .tabItem {
                        Label("Profile", systemImage: "square.and.pencil")
                    }
            }
        }
    }
}

struct Orders: View {
    
    @EnvironmentObject var state: AppState
    
    @State var showAddSheetView = false
    
    var body: some View {
        NavigationView {
            VStack {
                // If a realm is open for a logged in user, show the ItemsView
                // else show empty
                if let orders = state.orders {
                    List {
                        ForEach(orders.freeze(), id: \._id){
                            order in Text(order.name)
                        }
                        .onDelete(perform: delete)
                    }
                } else {
                    Text("Empty")
                }
            }
            .navigationBarTitle(Text("Orders:"))
            .navigationBarItems(
                leading:
                    Button("Logout", action: logout),
                trailing:
                    Button(action: {
                        self.showAddSheetView.toggle()
                    }) {Text("Add")}
                    .sheet(isPresented: $showAddSheetView) {
                        AddOrderView(showAddSheetView: self.$showAddSheetView)
                    })
        }
    }
    
    func delete(at offsets: IndexSet) {
        state.delete(at: offsets)
    }
    
    func logout(){
        state.logout()
    }
    
}

struct NewView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView().environmentObject(AppState())
    }
}
