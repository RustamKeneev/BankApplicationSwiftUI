//
//  CardTransactionView.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 28/4/24.
//

import SwiftUI
import CoreData

struct CardTransactionView: View {
    
    let transaction: CardTransaction
    
    @State var shouldPresentActionSheet = false
    
    @Environment(\.colorScheme) var colorScheme
    
    private let dateFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.timeStyle = .none
        return formater
    }()
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.name ?? "")
                        .font(.headline)
                    if let date = transaction.timestamp{
                        Text(dateFormatter.string(from: date))
                    }
                }//: VSTACK
                Spacer()
                VStack(alignment: .trailing){
                    Button(action: {
                        shouldPresentActionSheet.toggle()
                    }, label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                    })//: BUTTON
                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 4, trailing: 0))
                    .actionSheet(isPresented: $shouldPresentActionSheet){
                        .init(title: Text(transaction.name ?? ""), message: nil, buttons: [
                            .destructive(Text("Delete"), action: handleDelete),
                            .cancel()
                        ])
                    }
                    Text(String(format:"$%.2f", transaction.ammount ))
                }//: VSTACK
            }//: HSTACK
            if let categories = transaction.categories as? Set<TransactionCategory>{
//                let array = Array(categories)
                let sortedByTimestampCategories = Array(categories).sorted(by: {$0.timestamp?.compare($1.timestamp ?? Date()) == .orderedDescending })
                HStack {
                    ForEach(sortedByTimestampCategories){ category in
                        HStack{
                            HStack(spacing: 12){
                                if let data = category.colorData, let uiColor = UIColor.color(data: data){
                                    let color = Color(uiColor)
                                    Text(category.name ?? "")
                                        .font(.system(size: 16, weight: .semibold))
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 8)
                                        .background(color)
                                        .foregroundColor(.white)
                                        .cornerRadius(6)
                                }
                            }//: HSTACK
                        }//: HSTACK
                        Spacer()
                    }//: LOOP
                }//: HSTACK
            }

            if let photoData = transaction.photoData,
               let uiImage = UIImage(data: photoData){
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            }
        }//:VSTACK
        .foregroundColor(Color(.label))
        .padding()
//        .background(colorScheme == .dark ? Color.gray : .white)
        .background(Color.cardBackground)
        .cornerRadius(6)
        .shadow(radius: 6)
        .padding()
    }
    
    private func handleDelete(){
        withAnimation{
            do {
                let context = PersistenceController.shared.container.viewContext
                context.delete(transaction)
                try context.save()
            }catch{
                print("Error handle delete \(error)")
            }
        }
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let transaction = CardTransaction(context: context)
    return CardTransactionView(transaction: transaction)
}
