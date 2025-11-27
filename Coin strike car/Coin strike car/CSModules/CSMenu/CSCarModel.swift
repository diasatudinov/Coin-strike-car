//
//  CSCarModel.swift
//  Coin strike car
//
//

import SwiftUI

struct Car: Codable, Hashable, Identifiable {
    var id = UUID()
    let make: String
    let model: String
    let year: String
    let mileage: String
    let vin: String
    var imageData: Data?
    
    var image: UIImage? {
        get {
            guard let imageData else { return nil }
            return UIImage(data: imageData)
        }
        set {
            imageData = newValue?.jpegData(compressionQuality: 0.8)
        }
    }
    
}
