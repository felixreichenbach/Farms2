//
//  View.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI
import RealmSwift

struct OrderView: View {
    @State var showAddSheetView = false
    @EnvironmentObject var state: AppState
    
    /// The items in this group.
    @ObservedObject var orders: RealmSwift.List<Order>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(orders.freeze(), id: \._id){
                    order in Text(order.name)
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle(Text("Models: \(orders.count)"))
            .navigationBarItems(
                leading:
                    Button("Logout", action: logout),
                trailing:
                    Button(action: {
                        self.showAddSheetView.toggle()
                    }) {Text("Add")}
                    .sheet(isPresented: $showAddSheetView) {
                        AddOrderView(orders: orders)
                    })
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        guard let realm = orders.realm else {
            orders.remove(at: offsets.first!)
            return
        }
        try! realm.write {
            realm.delete(orders[offsets.first!])
        }
    }
    
    
    func logout(){
        guard let app = app else {
            return
        }
        state.shouldIndicateActivity = true
        app.currentUser?.logOut().receive(on: DispatchQueue.main).sink(receiveCompletion: { _ in }, receiveValue: {
            state.shouldIndicateActivity = false
            state.logoutPublisher.send($0)
        }).store(in: &state.cancellables)
    }
    
}

/*
 struct OrderView_Previews: PreviewProvider {
 static var previews: some View {
 OrderView(orders: List<Order>)
 }
 }
 */
