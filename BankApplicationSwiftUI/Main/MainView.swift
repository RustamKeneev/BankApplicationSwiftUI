//
//  MainView.swift
//  BankApplicationSwiftUI
//
//  Created by Rustam Keneev on 20/4/24.
//

import SwiftUI

struct MainView: View {
    
    @State var shouldPresentAddCardForm = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                TabView{
                    ForEach(0..<5){ num in
                        CreditCardView()
                            .padding(.bottom, 50)
                    }//: LOOP
                }//: TABVIEW
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 280)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm, onDismiss: nil){
                        AddCardForm(shouldPresentAddCardForm: $shouldPresentAddCardForm)
                    }
            }//: SCROLL
            .navigationTitle("Credit Cards")
            .navigationBarItems(trailing: addCardButton)
        }//: NAVIGATION VIEW
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
