//
//  AddTransactionForm.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 26/4/24.
//

import SwiftUI

struct AddTransactionForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var ammount = ""
    @State private var date = Date()
    
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Information")){
                    TextField("Name", text: $name)
                    TextField("Ammount", text: $ammount)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    NavigationLink {
                        Text("New category page")
                            .navigationTitle("New Title")
                    } label: {
                        Text("Many to many")
                    }

                }//: SECTION ONE
                Section(header: Text("Photo/Receipt")){
                    Button(action: {
                        
                    }, label: {
                        Text("Select Photo")
                    })
                }//: SECTION TWO
            }//: FORM
            .navigationTitle("Add Transaction")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }//: NAVIGATIONVIEW
    }
    
    private var saveButton: some View{
        Button(action: {
            
        }, label: {
            Text("Save")
        })
    }//CANCEL BUTTON
    
    private var cancelButton: some View{
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
        })
    }//CANCEL BUTTON
}

#Preview {
    AddTransactionForm()
}
