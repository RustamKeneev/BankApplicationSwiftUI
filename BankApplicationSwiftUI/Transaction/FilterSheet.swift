//
//  FilterSheet.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 2/5/24.
//

import SwiftUI
import CoreData

struct FilterSheet: View {

    @State var selectedCategories = Set<TransactionCategory>()
    
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - CARD FETCH
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionCategory.timestamp, ascending: false)],
        animation: .default)
    private var categories: FetchedResults<TransactionCategory>

    let didSaveFilters: (Set<TransactionCategory>) -> ()
    
    var body: some View {
        NavigationView{
            Form{
                ForEach(categories){ category in
                    Button(action: {
                        if selectedCategories.contains(category){
                            selectedCategories.remove(category)
                        }else{
                            selectedCategories.insert(category)
                        }
                    }, label: {
                        HStack(spacing: 12){
                            if let data = category.colorData, let uiColor = UIColor.color(data: data){
                                let color = Color(uiColor)
                                Spacer()
                                    .frame(width: 30, height: 10)
                                    .background(color)
                            }
                            Text(category.name ?? "")
                                .foregroundColor(Color(.label))
                            Spacer()
                            if selectedCategories.contains(category){
                                Image(systemName: "checkmark")
                            }
                        }//: HSTACK
                    })
                }//: LOOP
            }//: FORM
            .navigationTitle("Select filters")
            .navigationBarItems(trailing: saveButton)
        }//: NAVIGATION VIEW
    }
    private var saveButton: some View{
        Button(action: {
            didSaveFilters(selectedCategories)
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Save")
        })
    }
}

#Preview {
    FilterSheet(didSaveFilters: { selectedCategories in
        print("Selected categories: \(selectedCategories)")
    })
}
