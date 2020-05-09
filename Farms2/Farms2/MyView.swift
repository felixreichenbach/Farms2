//
//  View.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI

struct MyView: View {
    @EnvironmentObject var settings: UserState
    @ObservedObject var viewModel = MyViewModel()
    @State var showAddSheetView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.myOrders, id: \.id) {
                    model in Text(model.name)
                }
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
                    .sheet(isPresented: $showAddSheetView) {
                        AddSheetView(viewModel: self.viewModel,showSheetView: self.$showAddSheetView)
            })
        }
    }
}

struct View_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
    }
}
