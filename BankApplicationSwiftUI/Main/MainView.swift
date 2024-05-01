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
    @State private var cardSelectionIndex = 0
    @State private var selectedCardHash = -1
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //MARK: - CARD FETCH
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    var body: some View {
        NavigationView{
            ScrollView{
                if !cards.isEmpty{
                    TabView(selection: $selectedCardHash){
                        ForEach(cards){ card in
                            CreditCardView(card: card)
                                .padding(.bottom, 50)
                                .tag(card.hash)
                        }//: LOOP
                    }//: TABVIEW
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 280)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .onAppear{
                    self.selectedCardHash = cards.first?.hash ?? -1
                }
                    if let firstIndex = cards.firstIndex(where: {$0.hash == selectedCardHash}){
                        let card = self.cards[firstIndex]
                        TransactionsListView(card: card)
                    }
                }else{
                    emptyPromptMessage
                }
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm, onDismiss: nil){
                        AddCardForm(card: nil){ card in
                            self.selectedCardHash = card.hash
                        }
                    }
            }//: SCROLL
            .navigationTitle("Credit Cards")
            .navigationBarItems(
                leading: HStack {
            },
                trailing: addCardButton)
        }//: NAVIGATION VIEW
    }
    
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
