//
//  TransactionsListView.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 28/4/24.
//

import SwiftUI
import CoreData

struct TransactionsListView: View {
    @State var shouldShowAddTransactionForm = false
    @Environment(\.managedObjectContext) private var viewContext
    
    //MARK: - CARD TRANSACTION
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: false)],
        animation: .default)
    private var transactions: FetchedResults<CardTransaction>

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
                AddTransactionForm()
            }
            ForEach(transactions){ transaction in
                CardTransactionView(transaction: transaction)
            }//: LOOP TRANSACTION
        }//: VSTACK
    }
}

#Preview {
    TransactionsListView()
}
