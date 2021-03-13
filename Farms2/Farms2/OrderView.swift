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
    @ObservedObject var viewModel = OrderViewModel()
    @State var showAddSheetView = false
    
    /// The items in this group.
    @ObservedObject var orders: RealmSwift.List<Order>
    
    /// The button to be displayed on the top left.
    var leadingBarButton: AnyView?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(orders.freeze(), id: \._id) {
                    model in Text(model.name)
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle(Text("Models: \(orders.count)"))
            .navigationBarItems(
                leading:
                Button(action: {
                    //self.settings.logout()
                }) {Text("Logout")},
                trailing:
                Button(action: {
                    self.showAddSheetView.toggle()
                }) {Text("Add")}
                    .sheet(isPresented: $showAddSheetView) {
                        AddOrderView(viewModel: self.viewModel)
            })
        }
    }
    
    func delete(at offsets: IndexSet) {
        viewModel.removeOrder(offsets: offsets)
    }
    
}

/*
struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView(orders: List<Order>)
    }
}
*/
