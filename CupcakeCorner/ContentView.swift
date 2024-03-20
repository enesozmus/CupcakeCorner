//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by enesozmus on 19.03.2024.
//

import SwiftUI

struct ContentView: View {
    
    // → That’s the only place the order will be created – every other screen in our app will be passed that property so they all work with the same data.
    // → We use @Observable classes with @State wrappers in views.
    @State private var order = Order()
    
    var body: some View {
        // → A view that displays a root view and enables you to present additional views over the root view.
        // → Use a navigation stack to present a stack of views over a root view.
        NavigationStack {
            Form {
                
                // ...
                Section {
                    AsyncImage(url: URL(string: "https://img.freepik.com/premium-vector/cupcakes-with-swirled-rainbow-icing-tasty-shiny-muffins-with-colorful-cream_499431-714.jpg?w=600"), scale: 3) { image in
                        image
                        // → Sets the mode by which SwiftUI resizes an image to fit its space.
                        // → The .resizable() modifier method configures an image in a View, resizing itself to fit the surrounding space of its parent container.
                            .resizable()
                        // → A view that scales this view to fit its parent, maintaining this view’s aspect ratio.
                            .scaledToFit()
                            .cornerRadius(12)
                    } placeholder: {
                        // → You can specify a custom placeholder using init(... placeholder: ...).
                        ProgressView()
                    }
                }
                
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
                        Toggle("🧁 Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("✨ Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                
                // ...
                Section {
                    // → You can add views to the top of the stack by clicking or tapping a NavigationLink.
                    // → And you can remove views using built-in, platform-appropriate controls, like a "back button" or a "swipe gesture".
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        HStack {
                            Image(systemName: "shippingbox")
                                .symbolRenderingMode(.hierarchical)
                            Text("Delivery details")
                        }
                        .font(.headline)
                    }
                }
                
            }
            //.navigationTitle("Cupcake Corner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Spacer()
                        Text("Cupcake Corner").font(.system(.title2, design: .serif).bold())
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
