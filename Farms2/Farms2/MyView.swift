//
//  View.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI

struct MyView: View {
    @EnvironmentObject var settings: UserSettings
    @ObservedObject var viewModel = MyViewModel()
    @State var showMySheetView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.myModel, id: \.id) {
                    model in Text(model.name)
                }
            }
            .navigationBarTitle(Text("Models: \(viewModel.myModel.count)"))
            .navigationBarItems(
                leading:
                Button(action: {
                    self.settings.logout()
                }) {Text("Logout")},
                trailing:
                Button(action: {
                    self.showMySheetView.toggle()
                }) {Text("Add")}
                    .sheet(isPresented: $showMySheetView) {
                        MySheetView(viewModel: self.viewModel,showSheetView: self.$showMySheetView)
            })
        }
    }
}

struct View_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
    }
}
