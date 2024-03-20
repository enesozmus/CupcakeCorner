//
//  Order.swift
//  CupcakeCorner
//
//  Created by enesozmus on 19.03.2024.
//

import Foundation

// → We’re going to have a single class that stores all our data, which will be passed from screen to screen.
// → This means all screens in our app share the same data, which will work really well as you’ll see.

// → Defines and implements conformance of the Observable protocol.
// → This macro adds observation support to a custom type and conforms the type to the Observable protocol.
@Observable
class Order: Codable {
    // → A type that can be used as a key for encoding and decoding.
    // → Thanks to CodingKeys, we can visually change the names of the properties used in a model.
    enum CodingKeys: String, CodingKey {
        // → When you're working with a real server these names matter – you need to send the actual names up, rather than the weird versions produced by the @Observable macro.
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }
    
    // → This is a bad idea for mutable arrays because the order of your array can change at any time, but here our array order won’t ever change so it’s safe.
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 1
    
    var specialRequestEnabled = false {
        /*
            -> Property observers observe and respond to changes in a property’s value.
                  -> Property observers provide useful means to respond to changes in properties.
                  -> They are called every time the property’s value is set—Even when the new value is the same as the old value.
                  -> There are two types of property observers, willSet and didSet.
                      -> willSet is called right before the new value is set.
                      -> didSet is called right after the new value is set.
         */
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        // complicated cakes cost more
        cost += Decimal(type) / 2
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
}
