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



 struct OrderView_Previews: PreviewProvider {
    
    static var previews: some View {
        OrderView(orders: createData())
    }
    
    static func createData() -> RealmSwift.List<Order> {
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
            realm.add(Collection())
        }
        try! realm.write {
            realm.objects(Collection.self).first!.orders.append(Order())
        }
        return realm.objects(Collection.self).first!.orders
    }
 }


