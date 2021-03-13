//
//  MySheetView.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI
import RealmSwift

struct AddOrderView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var orders: RealmSwift.List<Order>
    
    @State private var inputText: String = ""
    
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
                    addOrder(text: self.inputText)
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
    
    func addOrder(text: String){
        let newOrder = Order()
        newOrder.name = text
        guard let realm = orders.realm else {
            orders.append(newOrder)
            return
        }
        try! realm.write {
            orders.append(newOrder)
        }
    }
}


/*
struct AddOrderView_Previews: PreviewProvider {
    static var previews: some View {
        AddOrder*View(orders: Order())
    }
}
*/
