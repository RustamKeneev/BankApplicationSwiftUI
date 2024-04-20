//
//  CreditCardView.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 20/4/24.
//

import SwiftUI

struct CreditCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            Text("Apple Blue Visa Card")
                .font(.system(size: 24, weight: .semibold))
            HStack {
                Image("visa")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 44)
                
                Spacer()
                Text("Balance 5,000$")
                    .font(.system(size: 18, weight: .semibold))

            }//: HSTACK
            Text("1234 1234 1234 1234")
            Text("Credit Limit: 50,000$")
            HStack{
                Spacer()
            }//: HSTACK
        }//: VSTACK
        .padding()
        .background(
            LinearGradient(colors: [Color.blue.opacity(0.6), Color.blue], startPoint: .top, endPoint: .bottom
        ))
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(Color.black.opacity(0.5), lineWidth: 1)
        )
        .foregroundColor(Color.white)
        .cornerRadius(8)
        .shadow(radius: 8)
        .padding(.horizontal)
        .padding(.top, 8)    }
}

#Preview {
    CreditCardView()
}
