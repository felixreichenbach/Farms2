//
//  View.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI

struct MyView: View {
    
    @ObservedObject var viewModel: MyViewModel
    
    init(viewModel: MyViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.myModel, id: \.id) { model in
                    Text(model.name)
                }
            }
            .navigationBarTitle(Text("Models"))
            .navigationBarItems(
                leading:
                Button(action: {
                    self.viewModel.cleanModels()
                }) {Text("Clean Realm")}
                ,trailing:
                Button(action: {
                    self.viewModel.addModel()
                }) {Text("Add")}
                    //.sheet(isPresented: $showSheetView) {
                    //    SheetView(showSheetView: self.$showSheetView, viewModel: self.viewModel)
                //}
            )
        }
    }
}

struct View_Previews: PreviewProvider {
    static var previews: some View {
        MyView(viewModel: MyViewModel())
    }
}
