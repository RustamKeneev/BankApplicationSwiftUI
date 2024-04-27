//
//  MainView.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 20/4/24.
//

import SwiftUI
import CoreData

struct MainView: View {
    
    @State var shouldPresentAddCardForm = false
    @State var shouldShowAddTransactionForm = false
    
    @Environment(\.managedObjectContext) private var viewContext

    //MARK: - CARD FETCH
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    //MARK: - CARD TRANSACTION
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: false)],
        animation: .default)
    private var transactions: FetchedResults<CardTransaction>
    
    var body: some View {
        NavigationView{
            ScrollView{
                if !cards.isEmpty{
                TabView{
                    ForEach(cards){ card in
                        CreditCardView(card: card)
                            .padding(.bottom, 50)
                    }//: LOOP
                }//: TABVIEW
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 280)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
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
                                        
                                    }, label: {
                                        Image(systemName: "ellipsis")
                                            .font(.system(size: 24))
                                    })//: BUTTON
                                    .padding(EdgeInsets(top: 6, leading: 8, bottom: 4, trailing: 0))
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
                    }//: LOOP TRANSACTION
                }else{
                    emptyPromptMessage
                }
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm, onDismiss: nil){
                        AddCardForm()
                    }
            }//: SCROLL
            .navigationTitle("Credit Cards")
            .navigationBarItems(
                leading: HStack {
                addItemButton
                deleteAllButton
            },
                trailing: addCardButton)
        }//: NAVIGATION VIEW
    }
    
    private let dateFormatter: DateFormatter = {
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.timeStyle = .none
        return formater
    }()
    
    private var emptyPromptMessage: some View {
        VStack{
            Text("You currently have no cards in the system")
                .padding(.horizontal, 48)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Button(action: {
                shouldPresentAddCardForm.toggle()
            }, label: {
                Text("+ Add Your First Card")
                    .foregroundColor(Color(.systemBackground))
                    .padding(EdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14))
                    .background(Color(.label))
                    .cornerRadius(6)
            })//: BUTTON
            
        }//: VSTACK
        .font(.system(size: 22, weight: .bold))
    }
    
    private var deleteAllButton: some View {
        Button{
            cards.forEach { card in
                viewContext.delete(card)
            }
            do {
                try viewContext.save()
            }catch{
                
            }
        } label: {
            Text("Delete all")
        }
    }
    
    var addItemButton: some View{
        Button(action: {
            withAnimation {
//                offsets.map { items[$0] }.forEach(viewContext.delete)
                let viewContext = PersistenceController.shared.container.viewContext
                let card = Card(context: viewContext)
                card.timestamp = Date()
                do {
                    try viewContext.save()
                } catch {
//                    let nsError = error as NSError
//                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }, label: {
            Text("Add Item")
        })
    }
    
    var addCardButton: some View {
        Button(action: {
            shouldPresentAddCardForm.toggle()
        }, label: {
            Text("+ Card")
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color.black)
                .cornerRadius(6)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
        })
    }
}

#Preview {
    MainView()
}
