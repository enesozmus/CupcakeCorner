//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by enesozmus on 19.03.2024.
//

import SwiftUI

struct AddressView: View {
    
    // → A property wrapper type that supports creating bindings to the mutable properties of observable objects.
    // → You can use this property wrapper to create bindings to mutable properties of a data model object that conforms to the Observable protocol.
    // → The @Bindable property wrapper allows us to get bindings from any property in an @Observable object, including all SwiftData model objects.
    @Bindable var order: Order
    
    var body: some View {
        Form {
            // ...
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            // ...
            Section {
                NavigationLink("Check out") {
                    Text("...")
                    // CheckoutView(order: order)
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: Order())
}
