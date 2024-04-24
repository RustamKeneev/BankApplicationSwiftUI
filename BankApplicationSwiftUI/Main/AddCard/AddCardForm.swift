//
//  AddCardForm.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 21/4/24.
//

import SwiftUI
import CoreData

struct AddCardForm: View {
    @Binding var shouldPresentAddCardForm: Bool
    
    @State private var name = ""
    @State private var cardNumber = ""
    @State private var limit = ""
    @State private var cardType = "Visa"
    @State private var month = 1
    @State private var year = Calendar.current.component(.year, from: Date())
    @State private var color = Color.blue
    
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Card information")) {
                    TextField("Name", text: $name)
                    TextField("Credit Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Credit Limit", text: $limit)
                        .keyboardType(.numberPad)
                    Picker("Type", selection: $cardType){
                        ForEach(["Visa", "MasterCard", "Discover"], id: \.self){ cardType in
                            Text(String(cardType)).tag(String(cardType))
                        }//: LOOP
                    }//: PICKER
                }//: SECTION CARD INFO
                
                Section(header: Text("Expiratioin")) {
                    Picker("Month", selection: $month){
                        ForEach(1..<13, id: \.self){ num in
                            Text(String(num)).tag(String(num))
                        }//: LOOP
                    }//: PICKER MONTH
                    
                    Picker("Year", selection: $year){
                        ForEach(currentYear..<currentYear + 20, id: \.self){ num in
                            Text(String(num)).tag(String(num))
                        }//: LOOP
                    }//: PICKER YEAR
                }//: SECTION EXPIRATION
                
                Section(header: Text("Color")) {
                    ColorPicker("Color", selection: $color )
                }//: SECTION COLOR
                
            }//: FORM
            .navigationTitle("Add credit card")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }//: NAVIGATION
    }
    
    private var saveButton: some View {
        Button(action: {
            let viewContext = PersistenceController.shared.container.viewContext
            let card = Card(context: viewContext)
            card.name = self.name
            card.number = self.cardNumber
            card.limit = Int32(self.limit) ?? 0
            card.expMonth = Int16(self.month)
            card.expYear = Int16(self.year)
            card.timestamp = Date()
            card.color = UIColor(self.color).encode()
            do {
                try viewContext.save()
                shouldPresentAddCardForm.toggle() 
            }catch{
                print("error saved: \(error)")
            }
        }, label: {
            Text("Save")
        })
    }
    
    private var cancelButton: some View {
        Button(action: {
            shouldPresentAddCardForm.toggle()
        }, label: {
            Text("Cancel")
        })
    }
}

#Preview {
    AddCardForm(shouldPresentAddCardForm: .constant(false))
}
