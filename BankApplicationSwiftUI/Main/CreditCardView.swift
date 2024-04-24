//
//  CreditCardView.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 20/4/24.
//

import SwiftUI
import CoreData

struct CreditCardView: View {
    let card: Card
    @State private var shouldActionSheet = false
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            HStack{
                Text(card.name ?? "")
                    .font(.system(size: 24, weight: .semibold))
                Spacer()
                Button(action: {
                    shouldActionSheet.toggle()
                }, label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 24, weight: .bold))
                })
                .actionSheet(isPresented: $shouldActionSheet, content: {
                    .init(title: Text(self.card.name ?? ""), message: Text("Options"), buttons: [
                        .destructive(Text("Delete Card"), action: handleDelete),
                        .cancel()
                    ])
                })
            }
            HStack {
                Image("visa")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 44)
                
                Spacer()
                Text("Balance 5,000$")
                    .font(.system(size: 18, weight: .semibold))
                
            }//: HSTACK
            Text(card.number ?? "")
            Text("Credit Limit: \(card.limit) $")
            HStack{
                Spacer()
            }//: HSTACK
        }//: VSTACK
        .padding()
        .background(
            VStack {
                if let colorData = card.color,
                   let uiColor = UIColor.color(data: colorData) {
                    let actualColor = Color(uiColor)
                    LinearGradient(
                        gradient: Gradient(colors: [actualColor.opacity(0.6), actualColor]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                } else {
                    Color.purple
                }
            }//: VStack            
        )
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(Color.black.opacity(0.5), lineWidth: 1)
        )
        .foregroundColor(Color.white)
        .cornerRadius(8)
        .shadow(radius: 8)
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private func handleDelete(){
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(card)
        do {
            try viewContext.save()
        }catch{
            print("Error -> \(error)")
        }
    }
}


#Preview {
    if let sampleCard = Card.fetchSampleCard() {
        CreditCardView(card: sampleCard)
    } else {
        Text("No card available for preview")
    }
}
