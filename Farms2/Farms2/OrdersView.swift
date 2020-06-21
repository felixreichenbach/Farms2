//
//  View.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI

struct OrdersView: View {
    @EnvironmentObject var settings: AppState
    @ObservedObject var viewModel = OrdersViewModel()
    @State var showAddSheetView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.myOrders.freeze(), id: \._id) {
                    model in Text(model.name)
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle(Text("Models: \(viewModel.myOrders.count)"))
            .navigationBarItems(
                leading:
                Button(action: {
                    self.settings.logout()
                }) {Text("Logout")},
                trailing:
                Button(action: {
                    self.showAddSheetView.toggle()
                }) {Text("Add")}
            )
            .sheet(isPresented: self.$showAddSheetView) {
                AddOrderView(viewModel: self.viewModel)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        viewModel.removeOrder(offsets: offsets)
    }
    
}

struct View_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
    }
}
