//
//  CSCarModel.swift
//  Coin strike car
//
//

import SwiftUI

struct Car: Codable, Hashable, Identifiable {
    var id = UUID()
    var make: String
    var model: String
    var year: String
    var mileage: String
    var vin: String
    var spendings: [Spending]
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

struct Spending: Codable, Hashable, Identifiable {
    var id = UUID()
    var spending: SpendingType
    var value: Decimal
    var date: Date
    var notes: String
    var mileage: Decimal?
    var workType: WorkType?
}

enum SpendingType: String, Codable, CaseIterable {
    case service = "Service / Repair"
    case fuel = "Fuel"
    case fines = "Fines"
    case parking = "Parking"
    case insurance = "Insurance"
    case wash = "Wash / Detailing"
    case tires = "Tires / Wheels"
    case accessories = "Accessories"
    case other = "Other"
    
    var spendingColor: Color {
        switch self {
        case .service:
                .osnovnyeElementy
        case .fuel:
                .knopki
        case .fines:
                .vtorostepenyeElementy
        case .parking:
                .parking
        case .insurance:
                .insurance
        case .wash:
                .wash
        case .tires:
                .tires
        case .accessories:
                .accessories
        case .other:
                .white
        }
    }
    
    var spendingIcon: ImageResource {
        switch self {
        case .service:
                .serviceIconCS
        case .fuel:
                .fuelIconCS
        case .fines:
                .finesIconCS
        case .parking:
                .parkingIconCS
        case .insurance:
                .insuranceIconCS
        case .wash:
                .washIconCS
        case .tires:
                .tiresIconCS
        case .accessories:
                .accessoriesIconCS
        case .other:
                .otherIconCS
        }
    }
}

enum WorkType: String, Codable, CaseIterable {
    case oilChange = "Oil Change"
    case filterReplacement = "Filter Replacement"
    case diagnostics = "Diagnostics"
    case brakePads = "Brake Pads"
    case coolant = "Coolant"
    case sparkPlugs = "Spark Plugs"
    case suspension = "Suspension"
    case airConditioning = "Air Conditioning"
    case electrical = "Electrical"
    case other = "Other Repairs"
}
