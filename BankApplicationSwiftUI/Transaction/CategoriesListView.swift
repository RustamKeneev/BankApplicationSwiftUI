//
//  CategoriesListView.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 30/4/24.
//

import SwiftUI
import CoreData

struct CategoriesListView: View {
    
    @State private var name = ""
    @State private var color = Color.red
    
    //MARK: - CARD FETCH
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionCategory.timestamp, ascending: false)],
        animation: .default)
    private var categories: FetchedResults<TransactionCategory>
    
    var body: some View {
        Form{
            Section(header: Text("Select a category")){
                ForEach(categories){ category in
                    Text(category.name ?? "")
                }//: LOOP
            }//: SECTION SELECT CATEGORY
            
            Section(header: Text("Create a category")){
                TextField("Name", text: $name)
                ColorPicker("Color", selection: $color)
                Button(action: handleCreate){
                    HStack {
                        Spacer()
                        Text("Create")
                            .foregroundColor(.white)
                        Spacer()
                    }//: HSTACK
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
                }//: BUTTON
                .buttonStyle(PlainButtonStyle())
            }//: SECTION CREATE CATEGORY
        }//: FORM
    }
    
    private func handleCreate(){
        let context = PersistenceController.shared.container.viewContext
        let category =  TransactionCategory(context: context)
        category.name = self.name
        category.colorData = UIColor(color).encode()
        category.timestamp = Date()
        try? context.save()
        self.name = ""
    }
}

#Preview {
    CategoriesListView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
