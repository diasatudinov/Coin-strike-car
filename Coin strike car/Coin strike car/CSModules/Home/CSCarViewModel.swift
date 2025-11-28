//
//  CSCarViewModel.swift
//  Coin strike car
//
//

import SwiftUI

class CarViewModel: ObservableObject {
    // MARK: – Dives
    @Published var myCars: [Car] = [
    ] {
        didSet { saveMyCars() }
    }
    
    @Published var currentCar: Car? {
        didSet { saveCurrentCar() }
    }
    
    @Published var showAddNewCar = false
    @Published var showCarsList = false
    // MARK: – UserDefaults keys
    private var myCarsfileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("myCars1.json")
    }
    
    private var currentCarfileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("currentCar1.json")
    }
    // MARK: – Init
    init() {
        
        loadMyCars()
        loadCurrentCar()
    }
    
    // MARK: – Save / Load MY CARS
    
    private func saveMyCars() {
        let url = myCarsfileURL
        do {
            let data = try JSONEncoder().encode(myCars)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Failed to save myDives:", error)
        }
    }
    
    private func loadMyCars() {
        let url = myCarsfileURL
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let dives = try JSONDecoder().decode([Car].self, from: data)
            myCars = dives
        } catch {
            print("Failed to load myDives:", error)
        }
    }
    
    // MARK: SAVE CurrentCar
    
    private func saveCurrentCar() {
        let url = currentCarfileURL
        do {
            let data = try JSONEncoder().encode(currentCar)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Failed to save myDives:", error)
        }
    }
    
    private func loadCurrentCar() {
        let url = currentCarfileURL
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let savedCar = try JSONDecoder().decode(Car.self, from: data)
            currentCar = savedCar
        } catch {
            print("Failed to load myDives:", error)
        }
    }
    
    func add(myCar: Car) {
        guard !myCars.contains(myCar) else { return }
        myCars.append(myCar)
        
    }
    
    func delete(myCar: Car) {
        guard let index = myCars.firstIndex(of: myCar) else { return }
        myCars.remove(at: index)
    }
    
    func add(spending: Spending, to car: Car) {
        guard let index = myCars.firstIndex(of: car) else { return }
        
        myCars[index].spendings.append(spending)
        currentCar = myCars[index]
        
    }
    
    func sumSpendings() -> Decimal {
        if let currentCar = currentCar {
            var sum: Decimal = 0.0
            for spending in currentCar.spendings {
                sum += spending.value
            }
            return sum
        }
        return 0
    }
}
