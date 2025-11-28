//
//  CarsListView.swift
//  Coin strike car
//
//

import SwiftUI

struct CarsListView: View {
    @ObservedObject var viewModel: CarViewModel
    @Binding var showCarsList: Bool
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 20) {
                ForEach(viewModel.myCars, id: \.self) { car in
                    dataCollectCell(car: car)
                    
                }
            }
            
            Button {
                showCarsList = false
                viewModel.showAddNewCar = true
            } label: {
                Text("Add a new car")
                    .font(TextStyle.h3.font)
                    .foregroundStyle(.white)
                    .padding(.top, 20)
                    .frame(width: UIScreen.main.bounds.width * 3/5)
                    .overlay(alignment: .top) {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.white)
                            .padding(.horizontal, -20)
                    }
            }
            
        }
        .padding(20)
        .background(.bg)
        .clipShape(UnevenRoundedRectangle(bottomTrailingRadius: 15))
    }
    
    private func dataCollectCell(
        car: Car
    ) -> some View {
        HStack(alignment: .center, spacing: 40) {
            Text("\(car.make) \(car.model) \(car.year)")
                .font(TextStyle.h3.font)
                .foregroundStyle(.white)
                .onTapGesture {
                    viewModel.currentCar = car
                    showCarsList = false
                }
            
            HStack(alignment: .center, spacing: 8) {
                
                Button {
                    viewModel.delete(myCar: car)
                } label: {
                    Image(.deleteIconCS)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                }
            }
        }
    }
}

#Preview {
    CarsListView(viewModel: CarViewModel(), showCarsList: .constant(true)
    )
}
