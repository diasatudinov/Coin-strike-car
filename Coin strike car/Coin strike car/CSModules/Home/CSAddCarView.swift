//
//  CSAddCarView.swift
//  Coin strike car
//
//

import SwiftUI

struct CSAddCarView: View {
    @ObservedObject var carViewModel: CarViewModel
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var make = ""
    @State private var model = ""
    @State private var year = ""
    @State private var mileage = ""
    @State private var vin = ""

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Add your car")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                
                Spacer()
            }.padding(.horizontal, 20)
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 192)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(lineWidth: 1)
                                        .fill(.osnovnyeElementy)
                                    
                                }
                        } else {
                            VStack {
                                Image(.cameraPlusCS)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                
                                Text("Add photo")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            .frame(height: 192)
                            .frame(maxWidth: .infinity)
                            .overlay {
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(lineWidth: 1)
                                    .fill(.osnovnyeElementy)
                            }
                            .onTapGesture {
                                showingImagePicker = true
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 20) {
                            dataCollectCell(icon: .makeIcon) {
                                HStack(alignment: .bottom) {
                                    TextField(text: $make) {
                                        Text("Make")
                                            .font(TextStyle.h2.font)
                                            .foregroundStyle(.knopkaOff)
                                    }
                                    .font(TextStyle.h2.font)
                                    .foregroundStyle(.white)
                                    
                                    Text("*")
                                        .font(TextStyle.h2.font)
                                        .foregroundStyle(.vtorostepenyeElementy)
                                }
                            }
                            
                            dataCollectCell(icon: .modelIcon) {
                                HStack(alignment: .bottom) {
                                    TextField(text: $model) {
                                        Text("Model")
                                            .font(TextStyle.h2.font)
                                            .foregroundStyle(.knopkaOff)
                                    }
                                    .font(TextStyle.h2.font)
                                    .foregroundStyle(.white)
                                    
                                    Text("*")
                                        .font(TextStyle.h2.font)
                                        .foregroundStyle(.vtorostepenyeElementy)
                                }
                            }
                            
                            dataCollectCell(icon: .yearIcon) {
                                HStack(alignment: .bottom) {
                                    TextField(text: $year) {
                                        Text("Year")
                                            .font(TextStyle.h2.font)
                                            .foregroundStyle(.knopkaOff)
                                    }
                                    .font(TextStyle.h2.font)
                                    .foregroundStyle(.white)
                                    .keyboardType(.numberPad)
                                    
                                    Text("*")
                                        .font(TextStyle.h2.font)
                                        .foregroundStyle(.vtorostepenyeElementy)
                                }
                            }
                            
                            dataCollectCell(icon: .mileageIcon) {
                                HStack(alignment: .bottom) {
                                    TextField(text: $mileage) {
                                        Text("Current Mileage, km")
                                            .font(TextStyle.h2.font)
                                            .foregroundStyle(.knopkaOff)
                                    }
                                    .font(TextStyle.h2.font)
                                    .foregroundStyle(.white)
                                    .keyboardType(.decimalPad)
                                    
                                    Text("*")
                                        .font(TextStyle.h2.font)
                                        .foregroundStyle(.vtorostepenyeElementy)
                                }
                            }
                            
                            dataCollectCell(icon: .vinIcon) {
                                HStack(alignment: .bottom) {
                                    TextField(text: Binding(
                                        get: { vin },
                                        set: { vin = $0.uppercased() }
                                    )) {
                                        Text("VIN")
                                            .font(TextStyle.h2.font)
                                            .foregroundStyle(.knopkaOff)
                                    }
                                    .font(TextStyle.h2.font)
                                    .foregroundStyle(.white)
                                    .textCase(.uppercase)
                                    
                                }
                            }
                        }
                        
                        
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 150)
                    .ignoresSafeArea(edges: .bottom)
                    .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                        ImagePicker(selectedImage: $selectedImage, isPresented: $showingImagePicker)
                    }
                    
                }
            }
            .background(Color.bg.ignoresSafeArea())
            .overlay(alignment: .bottom) {
                Button {
                    if checkDataFull() {
                        if let selectedImage {
                            carViewModel.currentCar = Car(make: make, model: model, year: year, mileage: mileage, vin: vin, imageData: selectedImage.jpegData(compressionQuality: 0.8))
                        } else {
                            carViewModel.currentCar = Car(make: make, model: model, year: year, mileage: mileage, vin: vin)
                        }
                    }
                } label: {
                    Text("Save")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(.osnovnyeElementy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(checkDataFull() ? .knopki : .knopkaOff)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 1)
                                .fill(.osnovnyeElementy)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                        
                }
            }
        }
        .background(Color.osnovnyeElementy.ignoresSafeArea())
        .hideKeyboardOnTap()
        
    }
    
    private func checkDataFull() -> Bool {
        make != "" && model != "" && year != "" && mileage != ""
        
    }
    
    private func dataCollectCell<Content: View>(
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(height: 36)
            
            HStack(spacing: 4) {
                content()
                
            }.overlay(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 1)
                    .fill(.white)
                    .frame(height: 1)
            }
        }
    }
    
    private func loadImage() {
        if let selectedImage = selectedImage {
            print("Selected image size: \(selectedImage.size)")
        }
    }
    
}

#Preview {
    CSAddCarView(carViewModel: CarViewModel())
}

extension String {
    static let makeIcon = "tab1IconSelectedCS"
    static let modelIcon = "modelIconCS"
    static let yearIcon = "tab4IconSelectedCS"
    static let mileageIcon = "mileageIconCS"
    static let vinIcon = "vinIconCS"
}
