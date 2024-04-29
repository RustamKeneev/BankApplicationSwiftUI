//
//  TransactionsListView.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 28/4/24.
//

import SwiftUI
import CoreData

struct TransactionsListView: View {
    
    let card: Card
    
    init(card: Card){
        self.card = card
        fetchRequest = FetchRequest<CardTransaction>(entity: CardTransaction.entity(), sortDescriptors: [
            .init(key: "timestamp", ascending: false)
        ], predicate: .init(format: "card == %@", self.card))
    }
    
    @State var shouldShowAddTransactionForm = false
    @Environment(\.managedObjectContext) private var viewContext
    
    //MARK: - CARD TRANSACTION
    var fetchRequest: FetchRequest<CardTransaction>

    var body: some View {
        VStack{
            Text("Get started by adding your first transaction")
            Button(action: {
                shouldShowAddTransactionForm.toggle()
            }, label: {
                Text("+ Transaction")
                    .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
                    .background(Color(.label))
                    .foregroundColor(Color(.systemBackground))
                    .font(.headline)
                    .cornerRadius(6)
            })
            .fullScreenCover(isPresented: $shouldShowAddTransactionForm){
                AddTransactionForm(card: self.card)
            }
            ForEach(fetchRequest.wrappedValue){ transaction in
                CardTransactionView(transaction: transaction)
            }//: LOOP TRANSACTION
        }//: VSTACK
    }
}

#Preview {
    if let sampleCard = Card.fetchSampleCard() {
        TransactionsListView(card: sampleCard)
    } else {
        Text("No card available for preview")
    }
}


