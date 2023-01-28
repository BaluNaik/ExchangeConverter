//
//  SucessUIView.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/28/23.
//

import SwiftUI

struct SucessUIView: View {
    weak var navigationController: UINavigationController?
    var rate: String?
    var totalAmount: String?
    
    var body: some View {
        NavigationView {
            VStack {
                Image("success")
                    .padding()
                Text("Greate Now you have \(totalAmount!) in your account.")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                Text("Your conversion rate 1/\(rate!)")
                    .foregroundColor(.white)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        navigationController?.popToRootViewController(animated: false)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .center)
            .offset(y: -50)
            .background(Color(red: 0, green: 117/255, blue: 219/255))
        }
        .accentColor(.white)
        .navigationBarBackButtonHidden(true)
    }
}

struct SucessUIView_Previews: PreviewProvider {
    static var previews: some View {
        SucessUIView()
    }
}
