//
//  CSExpensesView.swift
//  Coin strike car
//
//

import SwiftUI

struct CSExpensesView: View {
    @ObservedObject var viewModel: CarViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let currentCar = viewModel.currentCar {
                    
                    HStack(spacing: 8) {
                        Text("\(currentCar.make) \(currentCar.model) \(currentCar.year)")
                            .font(.system(size: 24, weight: .bold))
                        
                        
                        Image(systemName: "chevron.down")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 8)
                            .bold()
                    }.foregroundStyle(.white)
                        .onTapGesture {
                            viewModel.showCarsList.toggle()
                        }
                    
                }
                Spacer()
            }.padding(.horizontal, 20)
            
            if let currentCar = viewModel.currentCar {
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                           
                            ForEach(currentCar.spendings, id: \.self) { spending in
                                
                                VStack(spacing: 8) {
                                    HStack {
                                        HStack {
                                            Image(spending.spending.spendingIcon)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 30)
                                            
                                            Text("\(spending.spending.rawValue)")
                                                .font(TextStyle.h3.font)
                                                .foregroundStyle(.white)
                                        }.frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("$\(spending.value)")
                                            .font(TextStyle.text.font)
                                            .foregroundStyle(.knopki)
                                    }
                                    
                                    HStack {
                                        Text("\(dateFormatter(date: spending.date))")
                                            .font(TextStyle.text.font)
                                            .foregroundStyle(.osnovnyeElementy)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        if let mileage = spending.mileage {
                                            Text("\(mileage) km")
                                                .font(TextStyle.text.font)
                                                .foregroundStyle(.vtorostepenyeElementy)
                                        }
                                    }
                                    
                                    Text("\"\(spending.notes)\"")
                                        .font(TextStyle.h3.font)
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                            }
                            
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .background(.bg)
                        .overlay(alignment: .topLeading) {
                            if viewModel.showCarsList {
                                CarsListView(viewModel: viewModel, showCarsList: $viewModel.showCarsList)
                            }
                        }
                        .padding(.bottom, 250)
                    }
                }.background(.bg)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.osnovnyeElementy.ignoresSafeArea())
        .overlay(alignment: .bottom) {
            HStack {
                NavigationLink {
                    CSAddSpendingView(viewModel: viewModel, selectSpending: .service)
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("+ Work")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(.osnovnyeElementy)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 1)
                                .fill(.knopki)
                        }
                }
                
                NavigationLink {
                    CSAddSpendingView(viewModel: viewModel, selectSpending: .fuel)                            .navigationBarBackButtonHidden()
                } label: {
                    Text("+ Spending")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.osnovnyeElementy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(.knopki)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 1)
                                .fill(.osnovnyeElementy)
                        }
                        
                        
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 110)
        }
    }
    
    private func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        let name = formatter.string(from: date)
        return name.prefix(1).uppercased() + name.dropFirst()
    }
}


#Preview {
    NavigationStack {
        CSExpensesView(viewModel: CarViewModel())
    }
}
