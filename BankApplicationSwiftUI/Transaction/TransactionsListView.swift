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
    @State var shouldShowFilterSheet = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //MARK: - CARD TRANSACTION
    var fetchRequest: FetchRequest<CardTransaction>

    var body: some View {
        VStack{
            if fetchRequest.wrappedValue.isEmpty {
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
            }else{
                HStack{
                    Spacer()
                    addTransactionButton
                    filterButton
                        .sheet(isPresented: $shouldShowFilterSheet){
                            FilterSheet{ categories in 
                                
                            }
                        }
                }//: HSTACK
                .padding(.horizontal)
                ForEach(fetchRequest.wrappedValue){ transaction in
                    CardTransactionView(transaction: transaction)
                }//: LOOP TRANSACTION
            }
        }//: VSTACK
        .fullScreenCover(isPresented: $shouldShowAddTransactionForm){
            AddTransactionForm(card: self.card)
        }
    }
    
    private var addTransactionButton: some View{
        Button(action: {
            shouldShowAddTransactionForm.toggle()
        }, label: {
            Text("+ Transaction")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(.systemBackground))
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color(.label))
                .cornerRadius(6)
        })
    }//: ADD TRANSACTION BUTTON
    
    private var filterButton: some View{
        Button(action: {
            shouldShowFilterSheet.toggle()
        }, label: {
            HStack{
                Image(systemName: "line.horizontal.3.decrease.circle")
                Text("Filter")
            }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(.systemBackground))
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color(.label))
                .cornerRadius(6)
        })
    }//: ADD TRANSACTION BUTTON
}

struct TransactionsListView_Previews: PreviewProvider {
    static let firstCard: Card? = {
        let context = PersistenceController.shared.container.viewContext
        let request = Card.fetchRequest()
        request.sortDescriptors = [.init(key: "timestamp", ascending: false)]
        return try? context.fetch(request).first
    }()
    
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        ScrollView {
            if let card = firstCard {
                TransactionsListView(card: card)
            }
            
        }
        
            .environment(\.managedObjectContext, context)
    }
}


