//
//  MySheetView.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI

struct AddOrderView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: OrdersViewModel
    @State private var inputText: String = ""
    
    init(viewModel: OrdersViewModel) {
        self.viewModel = viewModel
    }
    
    private var validated: Bool {
        inputText.isEmpty
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add New Order")
                    .font(.headline)
                TextField("Enter Text", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    self.viewModel.addOrder(text: self.inputText)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .font(.headline)
                }.disabled(validated)
            }
            .navigationBarTitle(Text("New Order Form"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done").bold()
                })
        }
    }
}

struct AddSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddOrderView(viewModel: OrdersViewModel())
    }
}
