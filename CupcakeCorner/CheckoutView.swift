//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by enesozmus on 19.03.2024.
//

import SwiftUI

struct CheckoutView: View {
    
    var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    var currencyCode: Decimal.FormatStyle.Currency { .currency(code: Locale.current.currency?.identifier ?? "USD")
    }
            
    
    var body: some View {
        // → A scrollable view.
        // → The scroll view displays its content within the scrollable content region.
        ScrollView {
            VStack {
                // → A view that asynchronously loads and displays an image.
                // → This view uses the shared URLSession instance to load an image from the specified URL, and then display it.
                // → Until the image loads, the view displays a standard placeholder that fills the available space.
                // → After the load completes successfully, the view updates to display the image.
                
                // → init(url:scale:)
                    // → Loads and displays an image from the specified URL.
                    // → The scale to use for the image.
                
                // → init(url:scale:content:placeholder:)
                    // → Loads and displays a modifiable image from the specified URL using a custom placeholder until the image loads.
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                    // → Sets the mode by which SwiftUI resizes an image to fit its space.
                    // → The .resizable() modifier method configures an image in a View, resizing itself to fit the surrounding space of its parent container.
                        .resizable()
                    // → A view that scales this view to fit its parent, maintaining this view’s aspect ratio.
                        .scaledToFit()
                } placeholder: {
                    // → You can specify a custom placeholder using init(... placeholder: ...).
                    ProgressView()
                }
                // → Positions this view within an invisible frame with the specified size.
                    // → width : A fixed width for the resulting view.
                    // → height : A fixed height for the resulting view.
                    // → alignment : The alignment of this view inside the resulting frame.
                .frame(height: 233)
                
                Text("Your total cost is \(order.cost, format: currencyCode)")
                    .font(.title)
                
                Button("Place Order") {
                    // → A unit of asynchronous work.
                    // → In Swift, a task refers to a unit of work that can be executed concurrently or asynchronously.
                    // → When you create an instance of Task, you provide a closure that contains the work for that task to perform.
                    Task {
                        //→ The Task the closure is marked with the async keyword, and the await the keyword is used to wait for the result of the asynchronous operation.
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }
    
    // ...
    func placeOrder() async {
        // → Convert our current order object into some JSON data that can be sent.
        // → For this code to work, the Order class must conform to Codable protocol.
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        /*
            -> Tell Swift how to send that data over a network call.
            -> The second step means using a new type called URLRequest
            -> The HTTP method of a request determines how data should be sent.
            -> There are several HTTP methods, but in practice only GET (“I want to read data”) and POST (“I want to write data”) are used much.
            -> So, the next code for placeOrder() will be to create a URLRequest object, then configure it to send JSON data using a HTTP POST request.
         
            -> Of course, the real question is where to send our request, and I don’t think you really want to set up your own web server in order to follow this tutorial.
            -> So, instead we’re going to use a really helpful website called https://reqres.in
        */
        
        // → URL -> A uniform resource locator (URL) is the address of a specific webpage or file (such as video, image, GIF, etc.) on the internet.
        // → A value that identifies the location of a resource, such as an item on a remote server or the path to a local file.
        // → You can construct URLs and access their parts.
        
        // → Creating the URL we want to read.
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        // → A URL load request that is independent of protocol or URL scheme.
        // → URLRequest encapsulates two essential properties of a load request: the URL to load and the policies used to load it.
        // → In addition, for HTTP and HTTPS requests, URLRequest includes the HTTP method (GET, POST, and so on) and the HTTP headers.

        // → URLRequest only represents information about the request.
        // → Use other classes, such as URLSession, to send the request to a server.
        var request = URLRequest(url: url)
        // → Sets a value for the header field.
            // → value -> The new value for the header field.
            // → field -> The name of the header field to set.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // → Fetching the data for that URL.
        // → Run that request and process the response.
        do {
            // → Our work is being done by the data(from:) method, which takes a URL and returns the Data object at that URL.
            // → This method belongs to the URLSession class.
            // → The return value from data(from:) is a tuple containing the data at the URL and some metadata describing how the request went.
            // →  We don’t use the metadata, but we do want the URL’s data, hence the underscore
                // → URLSession -> An object that coordinates a group of related, network data transfer tasks.
                // → The URLSession class and related classes provide an API for downloading data from and uploading data to endpoints indicated by URLs.
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            // → Decoding the result of that data into a Response struct.
            // → Handle the result
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
            
        } catch {
            // → So, if our download succeeds our data constant will be set to whatever data was sent back from the URL,
            // → but if it fails for any reason our code prints “Invalid data” and does nothing else.
            print("Check out failed: \(error.localizedDescription)")
        }
        
    }
}

#Preview {
    CheckoutView(order: Order())
}
