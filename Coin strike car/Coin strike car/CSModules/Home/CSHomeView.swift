//
//  CSHomeView.swift
//  Coin strike car
//
//

import SwiftUI
import Charts

struct CSHomeView: View {
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
                            
                            if let image = currentCar.image {
                                Image(uiImage: image)
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
                                    Image(systemName: "camera")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .foregroundStyle(.knopki)
                                    
                                }
                                .frame(height: 192)
                                .frame(maxWidth: .infinity)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(lineWidth: 1)
                                        .fill(.osnovnyeElementy)
                                }
                            }
                            
                            HStack(alignment: .center) {
                                Text("Current mileage")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.white)
                                Spacer()
                                
                                Text("\(currentCar.mileage) km")
                                    .font(TextStyle.text.font)
                                    .foregroundStyle(.knopki)
                                
                            }
                            
                            Rectangle()
                                .fill(.osnovnyeElementy)
                                .frame(height: 1)
                                .padding(.horizontal, 50)
                            
                            if currentCar.spendings.isEmpty {
                                Text("No records yet")
                                    .font(TextStyle.h1.font)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 80)
                            } else {
                                
                                VStack(spacing: 16) {
                                    HStack(alignment: .center) {
                                        Text("Monthly expenses")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundStyle(.white)
                                        Spacer()
                                        
                                        Text("$\(viewModel.sumSpendings())")
                                            .font(TextStyle.text.font)
                                            .foregroundStyle(.knopki)
                                        
                                    }
                                    
                                    DonutChartView(spendings: currentCar.spendings.makeSlicesForCurrentMonth())
                                        .padding(.vertical)
                                        .padding(.bottom, 10)
                                    
                                    HStack(alignment: .center) {
                                        Text("Latest works:")
                                            .font(TextStyle.h2.font)
                                            .foregroundStyle(.white)
                                        Spacer()
                                         
                                    }
                                    
                                    VStack(spacing: 12) {
                                        ForEach(currentCar.spendings.filter({ $0.spending == .service }), id: \.self)  { spending in
                                            HStack {
                                                Text("\(dateFormatter(date: spending.date))")
                                                    .foregroundStyle(.osnovnyeElementy)
                                
                                                if let work = spending.workType {
                                                    Text("\(work.rawValue)")
                                                        .foregroundStyle(.white)
                                                        .frame(maxWidth: .infinity)
                                                }
                                                
                                                Text("$\(spending.value)")
                                                    .foregroundStyle(.knopki)
                                            }
                                            
                                            
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
                }.padding(.horizontal, 20)
                    .padding(.bottom, 110)
            }
    }
    
    private func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        let name = formatter.string(from: date)
        return name.prefix(1).uppercased() + name.dropFirst()
    }
}

#Preview {
    NavigationStack {
        CSHomeView(viewModel: CarViewModel())
    }
}


extension Decimal {
    var doubleValue: Double {
        (self as NSDecimalNumber).doubleValue
    }
}

struct SpendingSlice: Identifiable {
    let id = UUID()
    let type: SpendingType
    let value: Decimal
    let percentage: Double   // 0...1
    let start: Double        // 0...1 для .trim(from:to:)
    let end: Double          // 0...1 для .trim(from:to:)
}

extension Array where Element == Spending {
    
    // MARK: - Базовый хелпер для сборки слайсов
    
    private func makeSlices(from spendings: [Spending]) -> [SpendingSlice] {
        // Сумма по каждому SpendingType
        var dict: [SpendingType: Decimal] = [:]
        for spending in spendings {
            dict[spending.spending, default: 0] += spending.value
        }
        
        let total = dict.values.reduce(0, +).doubleValue
        guard total > 0 else { return [] }
        
        // Сортируем по сумме (по убыванию)
        let sorted = dict.sorted { $0.value.doubleValue > $1.value.doubleValue }
        
        var result: [SpendingSlice] = []
        var currentStart: Double = 0
        
        for (type, value) in sorted {
            let valueDouble = value.doubleValue
            let part = valueDouble / total   // 0...1
            
            let slice = SpendingSlice(
                type: type,
                value: value,
                percentage: part,
                start: currentStart,
                end: currentStart + part
            )
            result.append(slice)
            currentStart += part
        }
        
        return result
    }
    
    // MARK: - Фильтры по датам
    
    private func filtered(from startDate: Date?, to endDate: Date?) -> [Spending] {
        filter { spending in
            let date = spending.date
            if let start = startDate, date < start { return false }
            if let end = endDate, date > end { return false }
            return true
        }
    }
    
    // Траты за текущий месяц (календарный)
    var currentMonthSpendings: [Spending] {
        let calendar = Calendar.current
        let now = Date()
        return filter { spending in
            calendar.isDate(spending.date, equalTo: now, toGranularity: .month)
        }
    }
    
    // Траты за прошлый месяц (предыдущий календарный месяц)
    var lastMonthSpendings: [Spending] {
        let calendar = Calendar.current
        let now = Date()
        guard let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: now) else {
            return []
        }
        return filter { spending in
            calendar.isDate(spending.date, equalTo: lastMonthDate, toGranularity: .month)
        }
    }
    
    // Последние 3 месяца (от сегодняшней даты включительно)
    var last3MonthsSpendings: [Spending] {
        let calendar = Calendar.current
        let now = Date()
        guard let start = calendar.date(byAdding: .month, value: -3, to: now) else { return [] }
        return filtered(from: start, to: now)
    }
    
    // Последние 6 месяцев
    var last6MonthsSpendings: [Spending] {
        let calendar = Calendar.current
        let now = Date()
        guard let start = calendar.date(byAdding: .month, value: -6, to: now) else { return [] }
        return filtered(from: start, to: now)
    }
    
    // Последний год (12 месяцев от сегодня)
    var lastYearSpendings: [Spending] {
        let calendar = Calendar.current
        let now = Date()
        guard let start = calendar.date(byAdding: .year, value: -1, to: now) else { return [] }
        return filtered(from: start, to: now)
    }
    
    // Все время
    var allTimeSpendings: [Spending] {
        self
    }
    
    // MARK: - Публичные функции для диаграммы
    
    func makeSlicesForCurrentMonth() -> [SpendingSlice] {
        makeSlices(from: currentMonthSpendings)
    }
    
    func makeSlicesForLastMonth() -> [SpendingSlice] {
        makeSlices(from: lastMonthSpendings)
    }
    
    func makeSlicesForLast3Months() -> [SpendingSlice] {
        makeSlices(from: last3MonthsSpendings)
    }
    
    func makeSlicesForLast6Months() -> [SpendingSlice] {
        makeSlices(from: last6MonthsSpendings)
    }
    
    func makeSlicesForLastYear() -> [SpendingSlice] {
        makeSlices(from: lastYearSpendings)
    }
    
    func makeSlicesForAllTime() -> [SpendingSlice] {
        makeSlices(from: allTimeSpendings)
    }
}

struct DonutChartView: View {
    var spendings: [SpendingSlice]
    
    
    private var totalValue: Decimal {
        spendings.reduce(0) { $0 + $1.value }
    }
    
    private var currentMonthName: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_EN")
        formatter.dateFormat = "LLLL"
        let name = formatter.string(from: Date())
        return name.prefix(1).uppercased() + name.dropFirst()
    }
    
    private var currentYearName: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_EN")
        formatter.dateFormat = "YYYY"
        let name = formatter.string(from: Date())
        return name.prefix(1).uppercased() + name.dropFirst()
    }
    
    var body: some View {
        HStack(spacing: 40) {
            ZStack {
                GeometryReader { geo in
                    let lineWidth = min(geo.size.width, geo.size.height) * 0.18
                    
                    ZStack {
                        ForEach(spendings) { slice in
                            Circle()
                                .trim(from: slice.start, to: slice.end)
                                .stroke(
                                    slice.type.spendingColor,
                                    style: StrokeStyle(
                                        lineWidth: lineWidth,
                                        lineCap: .butt
                                    )
                                )
                                .rotationEffect(.degrees(-90)) // чтобы начало было сверху
                        }
                        
                        Circle()
                            .fill(Color.black) // подмени на свой цвет фона
                            .frame(
                                width: geo.size.width * 0.2,
                                height: geo.size.height * 0.2
                            )
                        
                        // текст в центре
                        VStack(spacing: 4) {
                            Text("\(currentMonthName)\n\(currentYearName)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                        }
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                
            }
            .frame(height: 150)
            
            if !spendings.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(spendings) { slice in
                        HStack(spacing: 8) {
                            
                            Text("\(slice.type.rawValue) -")
                                .foregroundColor(.white)
                            
                            Text("\(Int(slice.percentage * 100))%")
                                .foregroundColor(slice.type.spendingColor)
                        }.font(.system(size: 12, weight: .semibold))
                    }
                }
                .padding(.top, 8)
            }
                        
        }
    }
}
