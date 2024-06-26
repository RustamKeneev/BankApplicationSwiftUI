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
 
    @Binding var selectedCategories: Set<TransactionCategory>

    @Environment(\.managedObjectContext) private var viewContext
    
    //MARK: - CARD FETCH
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionCategory.timestamp, ascending: false)],
        animation: .default)
    private var categories: FetchedResults<TransactionCategory>
    
    var body: some View {
        Form{
            Section(header: Text("Select a category")){
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
                .onDelete{ indexSet in
                    indexSet.forEach{ item in
                        let category = categories[item]
                        selectedCategories.remove(category)
                        viewContext.delete(category)
                    }
                    try? viewContext.save()
                }
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
    CategoriesListView(selectedCategories: .constant(.init()))
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
