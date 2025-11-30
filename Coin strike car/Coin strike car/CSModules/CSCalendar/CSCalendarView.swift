//
//  CSCalendarView.swift
//  Coin strike car
//
//

import SwiftUI

struct CSCalendarView: View {
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
                           
                            SpendingCalendarView(viewModel: viewModel, spendings: currentCar.spendings)
                            
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
        CSCalendarView(viewModel: CarViewModel())
    }
}


struct SpendingCalendarView: View {
    @ObservedObject var viewModel: CarViewModel
    let spendings: [Spending]
    
    @State private var displayedMonth: Date
    @State private var selectedDate: Date
    
    private let calendar = Calendar.current
    
    // MARK: - Init
    
    init(viewModel: CarViewModel, spendings: [Spending]) {
        self.viewModel = viewModel
        self.spendings = spendings
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let comps = calendar.dateComponents([.year, .month], from: today)
        let firstOfMonth = calendar.date(from: comps) ?? today
        
        _displayedMonth = State(initialValue: firstOfMonth)
        _selectedDate = State(initialValue: today)
        
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 12) {
            calendarView
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 1)
                        .fill(.osnovnyeElementy)
                }
                .padding(.horizontal, -12)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(monthYearString)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.knopki)
                
                // Список трат за выбранную дату
                spendingList
            }
        }
    }
}

// MARK: - Subviews

private extension SpendingCalendarView {
    
    func firstDayOfMonth(for date: Date) -> Date {
        let comps = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: comps) ?? date
    }

    func goToPreviousMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: -1, to: displayedMonth) else { return }
        let first = firstDayOfMonth(for: newDate)
        displayedMonth = first
        selectedDate = first
    }

    func goToNextMonth() {
        guard let newDate = calendar.date(byAdding: .month, value: 1, to: displayedMonth) else { return }
        let first = firstDayOfMonth(for: newDate)
        displayedMonth = first
        selectedDate = first
    }
    
    var calendarView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 28) {
                
                Text(shortMonthYearString)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.knopki)
                
                Spacer()
                
                Button {
                    goToPreviousMonth()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 18)
                        .foregroundColor(.knopki)
                }
                
                Button {
                    goToNextMonth()
                } label: {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 18)
                        .foregroundColor(.knopki)
                }
            }.padding(.horizontal, 8)
            
            weekdayHeader
                .padding(.vertical, 8)
            Rectangle()
                .fill(.osnovnyeElementy)
                .frame(height: 1)
                
            
            let days = generateDaysForMonth()
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7),
                spacing: 4
            ) {
                ForEach(Array(days.enumerated()), id: \.offset) { _, date in
                    if let date = date {
                        dayCell(date: date)
                    } else {
                        Rectangle()
                            .opacity(0)
                            .frame(height: 32)
                    }
                }
            }
        }
    }
    
    var weekdayHeader: some View {
        let symbols = calendar.veryShortWeekdaySymbols
        
        return HStack {
            ForEach(Array(symbols.enumerated()), id: \.offset) { _, symbol in
                Text(symbol)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    func dayCell(date: Date) -> some View {
        let day = calendar.component(.day, from: date)
        let isToday = calendar.isDateInToday(date)
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let hasSpendings = dayHasSpendings(on: date)
        
        // Показываем обводку "сегодня" только если день не выбран
        let showTodayRing = isToday && !isSelected
        
        return Button {
            selectedDate = date
        } label: {
            VStack(spacing: 2) {
                Circle()
                    .fill(hasSpendings ? Color.yellow : Color.clear)
                    .frame(width: 6, height: 6)
                
                Text("\(day)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isToday ? Color.osnovnyeElementy : .white)
                    .frame(width: 28, height: 28)
                    .padding(2)
                    .background(
                        Circle()
                            .fill(isSelected  ? Color.vtorostepenyeElementy : Color.clear)
                    )
            }.frame(maxWidth: .infinity, minHeight: 32)
            
        }
    }
    
    var spendingList: some View {
        let items = spendingsForSelectedDate
        
        return VStack(alignment: .leading, spacing: 20) {
            if items.isEmpty {
                
                if isDateInFuture(selectedDate) {
                    NavigationLink {
                        CSAddSpendingView(viewModel: viewModel, selectSpending: .fuel, date: selectedDate)                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("Schedule Work")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.osnovnyeElementy)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 25)
                            .background(.knopki)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(lineWidth: 1)
                                    .fill(.osnovnyeElementy)
                            }
                            .padding(.top, 60)
                            .frame(maxWidth: .infinity)
                        
                    }
                } else {
                    Text("No spendings for this day")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white.opacity(0.5))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.top, 60)
                }
            } else {
                ForEach(items) { spending in
                    VStack(spacing: 12) {
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
                        
                        Text("\"\(spending.notes)\"")
                            .font(TextStyle.h3.font)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }
    
    private func isDateInFuture(_ date: Date) -> Bool {
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: date)
        
        return target > today      // строго после сегодняшнего дня
    }
}

// MARK: - Helpers

private extension SpendingCalendarView {
    
    /// Дни текущего отображаемого месяца с пустыми ячейками в начале
    func generateDaysForMonth() -> [Date?] {
        var days: [Date?] = []
        
        let comps = calendar.dateComponents([.year, .month], from: displayedMonth)
        guard let firstOfMonth = calendar.date(from: comps),
              let range = calendar.range(of: .day, in: .month, for: firstOfMonth) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth) // 1...7
        let leadingEmpty = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        // пустые слоты до начала месяца
        for _ in 0..<leadingEmpty {
            days.append(nil)
        }
        
        // реальные даты месяца
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    /// Есть ли траты в эту дату
    func dayHasSpendings(on date: Date) -> Bool {
        spendings.contains { spending in
            calendar.isDate(spending.date, inSameDayAs: date)
        }
    }
    
    /// Траты за выбранный день
    var spendingsForSelectedDate: [Spending] {
        spendings.filter { spending in
            calendar.isDate(spending.date, inSameDayAs: selectedDate)
        }
    }
    
    var shortMonthYearString: String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "LLL yyyy"
        return formatter.string(from: displayedMonth).capitalized
    }
    
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: displayedMonth).capitalized
    }
}
