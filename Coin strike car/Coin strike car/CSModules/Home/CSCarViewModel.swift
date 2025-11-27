//
//  CarViewModel.swift
//  Coin strike car
//
//

import SwiftUI

class CarViewModel: ObservableObject {
    // MARK: – Dives
    @Published var myCars: [Car] = [
        
    ] {
        didSet { saveMyDives() }
    }
    
    @Published var currentCar: Car?
    
    // MARK: – UserDefaults keys
    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("myCars.json")
    }
    // MARK: – Init
    init() {
        loadMyDives()
    }
    
    // MARK: – Save / Load Backgrounds
    
    private func saveMyDives() {
        let url = fileURL
        do {
            let data = try JSONEncoder().encode(myCars)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Failed to save myDives:", error)
        }
    }
    
    private func loadMyDives() {
        let url = fileURL
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
    
    func add(myCar: Car) {
        guard !myCars.contains(myCar) else { return }
        myCars.append(myCar)
        
    }
    
    func delete(myCar: Car) {
        guard let index = myCars.firstIndex(of: myCar) else { return }
        myCars.remove(at: index)
    }
}
