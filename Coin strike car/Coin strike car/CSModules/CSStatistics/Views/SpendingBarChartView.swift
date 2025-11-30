//
//  SpendingBarChartView.swift
//  Coin strike car
//
//

import SwiftUI

struct SpendingBarChartView: View {
    let spendings: [Spending]    // сюда можно передать уже отфильтрованный период (месяц / год)

    private var barData: [SpendingBarData] {
        spendings.aggregatedByTypeIncludingAllTypes()
    }
    
    private var maxValue: Double {
        barData.map { $0.totalValue.doubleValue }.max() ?? 0
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if barData.allSatisfy({ $0.totalValue == 0 }) {
                // Все нули — можно показать заглушку
                Text("No data")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: .infinity, minHeight: 150)
            } else {
                GeometryReader { geo in
                    let width = geo.size.width
                    let height = geo.size.height
                    
                    let bottomPadding: CGFloat = 40      // место под подписи X
                    let topPadding: CGFloat = 8
                    let rightPadding: CGFloat = 24       // место под правую ось
                    let leftPadding: CGFloat = 8
                    
                    let chartHeight = height - topPadding - bottomPadding
                    let chartWidth = width - leftPadding - rightPadding
                    
                    let barCount = barData.count
                    let barSpacing: CGFloat = 8
                    let totalSpacing = barSpacing * CGFloat(max(barCount - 1, 0))
                    let barWidth = max((chartWidth - totalSpacing) / CGFloat(barCount), 4)
                    
                    ZStack {
                        // Оси (X снизу, Y справа)
                        Path { path in
                            // X ось
                            let xAxisY = height - bottomPadding
                            path.move(to: CGPoint(x: leftPadding, y: xAxisY))
                            path.addLine(to: CGPoint(x: leftPadding + chartWidth, y: xAxisY))
                            
                            // Y ось справа
                            let yAxisX = leftPadding + chartWidth
                            path.move(to: CGPoint(x: yAxisX, y: topPadding))
                            path.addLine(to: CGPoint(x: yAxisX, y: xAxisY))
                        }
                        .stroke(Color.yellow, lineWidth: 1)
                        .padding(.horizontal, 5)
                        
                        // Столбцы
                        ForEach(Array(barData.enumerated()), id: \.element.id) { index, item in
                            let value = item.totalValue.doubleValue
                            
                            // Если по типу не было value — даём минимальный процент
                            let ratio = maxValue > 0 ? (value == 0 ? 0.05 : value / maxValue) : 0
                            
                            let barHeight = CGFloat(ratio) * chartHeight
                            
                            let x = leftPadding + CGFloat(index) * (barWidth + barSpacing)
                            let y = (height - bottomPadding) - barHeight
                            
                            VStack(spacing: 0) {
                                // Столбец
                                Rectangle()
                                    .fill(item.type.spendingColor)
                                    .frame(width: barWidth, height: barHeight)
                                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 8, topTrailingRadius: 8))
                                    .position(x: x + barWidth / 2,
                                              y: y + barHeight / 2)
                                    
                                
                                // Подпись под столбцом
                                Text(item.type.rawValue)
                                    .font(.system(size: 5))
                                    .foregroundColor(.white)
                                    .frame(width: max(barWidth + 10, 50))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.6)
                                    .offset(y: 16)
                                    .position(
                                        x: x + barWidth / 2,
                                        y: height / 3.8
                                    )
                            }
                        }
                    }
                }
                .frame(height: 180)
            }
        }
    }
}

struct SpendingBarData: Identifiable {
    let id = UUID()
    let type: SpendingType
    let totalValue: Decimal
}

extension Array where Element == Spending {
    /// Аггрегируем по типам, включая все SpendingType (даже если по ним нет трат)
    func aggregatedByTypeIncludingAllTypes() -> [SpendingBarData] {
        // Сумма по каждому типу из фактических трат
        var dict: [SpendingType: Decimal] = [:]
        for spending in self {
            dict[spending.spending, default: 0] += spending.value
        }
        
        // Пробегаем по всем enum-кейсам, даже если суммы нет
        return SpendingType.allCases.map { type in
            let total = dict[type] ?? 0
            return SpendingBarData(type: type, totalValue: total)
        }.reversed()
    }
}

#Preview {
    CSStatisticsView(viewModel: CarViewModel())
}
