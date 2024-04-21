//
//  AddCardForm.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 21/4/24.
//

import SwiftUI

struct AddCardForm: View {
    @Binding var shouldPresentAddCardForm: Bool
    
    @State private var name = ""

    var body: some View {
        NavigationView{
            Form{
                Text("Add card form")
                TextField("Name", text: $name)
            }//: FORM
            .navigationTitle("Add credit card")
            .navigationBarItems(leading: Button(action: {
                shouldPresentAddCardForm.toggle()
            }, label: {
                Text("Cancel")
            }))
        }//: NAVIGATION
    }
}

#Preview {
    AddCardForm(shouldPresentAddCardForm: .constant(false))
}
