//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by enesozmus on 19.03.2024.
//

import SwiftUI

struct ContentView: View {
    
    // → We use @Observable classes with @State wrappers in views.
    @State private var order = Order()
    
    var body: some View {
        // → A view that displays a root view and enables you to present additional views over the root view.
        //→ Use a navigation stack to present a stack of views over a root view.
        NavigationStack {
            Form {
                
                // ...
                Section {
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 1...15)
                }
                
                // ...
                Section {
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled)
                    
                    if order.specialRequestEnabled  {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                
                // ...
                Section {
                    NavigationLink("Delivery details") {
                        Text("...")
                        // AddressView(order: order)
                    }
                }
                
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

#Preview {
    ContentView()
}
