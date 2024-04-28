//
//  CardTransactionView.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 28/4/24.
//

import SwiftUI

struct CardTransactionView: View {
    
    let transaction: CardTransaction
    
    @State var shouldPresentActionSheet = false
    
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
            if let photoData = transaction.photoData,
               let uiImage = UIImage(data: photoData){
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            }
        }//:VSTACK
        .foregroundColor(Color(.label))
        .padding()
        .background(Color.white)
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
    let transaction = CardTransaction()
    return CardTransactionView(transaction: transaction)
}
