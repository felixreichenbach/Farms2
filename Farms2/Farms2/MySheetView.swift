//
//  MySheetView.swift
//  Farms2
//
//  Created by Felix Reichenbach on 27.04.20.
//  Copyright © 2020 Felix Reichenbach. All rights reserved.
//

import SwiftUI

struct AddSheetView: View {
    
    @Binding var showSheetView: Bool
    @ObservedObject var viewModel: MyViewModel
    @State private var inputText: String = ""
    
    init(viewModel: MyViewModel, showSheetView: Binding<Bool>) {
        self.viewModel = viewModel
        self._showSheetView = showSheetView
    }
    
    private var validated: Bool {
        inputText.isEmpty
    }
    
    var body: some View {
        VStack {
            Text("Add New Model")
                .font(.headline)
            TextField("Enter Text", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                self.save()
                self.showSheetView.toggle()
            }) {
                Text("Save")
                    .font(.headline)
            }.disabled(validated)
        }
    }
    
    func save() {
        self.viewModel.addModel(text: inputText)
    }
}

struct AddSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddSheetView(viewModel: MyViewModel(), showSheetView: .constant(true))
    }
}
