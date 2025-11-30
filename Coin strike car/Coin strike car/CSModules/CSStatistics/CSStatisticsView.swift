//
//  CSStatisticsView.swift
//  Coin strike car
//
//

import SwiftUI

enum FilterDataPeriod: String, Codable, CaseIterable {
    case thisMonth = "This Month"
    case lastMonth = "Last Month"
    case threeMonths = "3 Months"
    case sixMonths = "6 Months"
    case year = "Year"
    case allTime = "All Time"
}

struct CSStatisticsView: View {
    @ObservedObject var viewModel: CarViewModel
    @State var dataPeriod: FilterDataPeriod = .thisMonth
    @State private var showDatesList = false
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
                
                Button {
                    showDatesList.toggle()
                } label: {
                    Image(.yearIcon)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(height: 32)
                }
                    
            }.padding(.horizontal, 20)
            
            if let currentCar = viewModel.currentCar {
                VStack {
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                           
                            DonutChartView(spendings: filterDataPeriod(spendings: currentCar.spendings))
                                .padding(.vertical)
                                .padding(.bottom, 10)
                            
                            Rectangle()
                                .fill(.osnovnyeElementy)
                                .frame(height: 1)
                                .padding(.horizontal, 50)
                            
                            VStack {
                                ForEach(viewModel.myCars, id: \.self) { car in
                                    
                                    VStack {
                                        SpendingBarChartView(spendings:  filterDataChart(spendings: car.spendings))
                                            .overlay(alignment: .topLeading) {
                                                Text("\(car.make) \(car.model) \(car.year)")
                                                    .font(TextStyle.h3.font)
                                                    .foregroundStyle(.white)
                                            }
                                        
                                        HStack {
                                            Text("Total:")
                                                .font(TextStyle.h2.font)
                                                .foregroundStyle(.white)
                                            
                                            Text("$\(viewModel.sumSpendings(spendings: filterDataChart(spendings: car.spendings)))")
                                                .font(TextStyle.h2.font)
                                                .foregroundStyle(.knopki)
                                        }
                                    }
                                                
                                    
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
                        .overlay(alignment: .topTrailing, content: {
                            if showDatesList {
                                DatesListView(viewModel: viewModel, dataPeriod: $dataPeriod, showDatesList: $showDatesList)
                            }
                        })
                        .padding(.bottom, 250)
                    }
                }.background(.bg)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.osnovnyeElementy.ignoresSafeArea())
    }
    
    private func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        let name = formatter.string(from: date)
        return name.prefix(1).uppercased() + name.dropFirst()
    }
    
    private func filterDataPeriod(spendings: [Spending]) -> [SpendingSlice] {
        switch dataPeriod {
        case .thisMonth:
            spendings.makeSlicesForCurrentMonth()
        case .lastMonth:
            spendings.makeSlicesForLastMonth()
        case .threeMonths:
            spendings.makeSlicesForLast3Months()
        case .sixMonths:
            spendings.makeSlicesForLast6Months()
        case .year:
            spendings.makeSlicesForLastYear()
        case .allTime:
            spendings.makeSlicesForAllTime()
        }
    }
    
    private func filterDataChart(spendings: [Spending]) -> [Spending] {
        return switch dataPeriod {
        case .thisMonth:
            spendings.currentMonthSpendings
        case .lastMonth:
            spendings.lastMonthSpendings
        case .threeMonths:
            spendings.last3MonthsSpendings
        case .sixMonths:
            spendings.last6MonthsSpendings
        case .year:
            spendings.lastYearSpendings
        case .allTime:
            spendings.allTimeSpendings
        }
    }
    
    
}


#Preview {
    CSStatisticsView(viewModel: CarViewModel())
}
