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
    @State private var shouldShowEditForm = false
    @State var refreshId = UUID()
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
                        .default(Text("Edit"), action: {
                            shouldShowEditForm.toggle()
                        }),
                        .destructive(Text("Delete Card"), action: handleDelete),
                        .cancel()
                    ])
                })
            }
            HStack {
                let imageName = card.type?.lowercased() ?? ""
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 44)
                    .clipped()
                Spacer()
                Text("Balance 5,000$")
                    .font(.system(size: 18, weight: .semibold))
                
            }//: HSTACK
            Text(card.number ?? "")
            HStack{
                Text("Credit Limit: \(card.limit) $")
                Spacer()
                VStack(alignment: .trailing){
                    Text("Valid Thru")
                    Text("\(String(format: "%02d", card.expMonth + 1))/\(String(card.expYear % 2000))")
                }
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
        .fullScreenCover(isPresented: $shouldShowEditForm) {
            AddCardForm(card: self.card)
        }
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
