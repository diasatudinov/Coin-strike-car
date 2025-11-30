struct SpendingBarChartView: View {
    let spendings: [Spending]
    
    private var barData: [SpendingBarData] {
        spendings.aggregatedByType()
    }
    
    private var maxValue: Double {
        barData.map { $0.totalValue.doubleValue }.max() ?? 0
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if barData.isEmpty {
                Text("No data")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 150)
            } else {
                GeometryReader { geo in
                    let width = geo.size.width
                    let height = geo.size.height
                    
                    let bottomPadding: CGFloat = 32      // место под подписи X
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
                        // Оси
                        Path { path in
                            // X ось (снизу)
                            let yAxisLineY = height - bottomPadding
                            path.move(to: CGPoint(x: leftPadding, y: yAxisLineY))
                            path.addLine(to: CGPoint(x: leftPadding + chartWidth, y: yAxisLineY))
                            
                            // Y ось (справа)
                            let xAxisLineX = leftPadding + chartWidth
                            path.move(to: CGPoint(x: xAxisLineX, y: topPadding))
                            path.addLine(to: CGPoint(x: xAxisLineX, y: yAxisLineY))
                        }
                        .stroke(Color.yellow, lineWidth: 2)
                        
                        // Столбцы
                        ForEach(Array(barData.enumerated()), id: \.element.id) { index, item in
                            let value = item.totalValue.doubleValue
                            let ratio = maxValue > 0 ? value / maxValue : 0
                            let barHeight = CGFloat(ratio) * chartHeight
                            
                            let x = leftPadding + CGFloat(index) * (barWidth + barSpacing)
                            let y = (height - bottomPadding) - barHeight
                            
                            VStack {
                                // Бар
                                Rectangle()
                                    .fill(item.type.spendingColor)
                                    .frame(width: barWidth, height: barHeight)
                                    .position(x: x + barWidth / 2, y: y + barHeight / 2)
                                
                                // Подпись под баром (SpendingType)
                                Text(item.type.rawValue)
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .frame(width: barWidth + 12)    // чуть шире бара
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.6)
                                    .rotationEffect(.degrees(-45))  // чтобы помещалось
                                    .offset(
                                        x: 0,
                                        y: 16 // опустить ниже оси X
                                    )
                                    .position(
                                        x: x + barWidth / 2,
                                        y: height - bottomPadding + 8
                                    )
                            }
                        }
                    }
                }
                .frame(height: 220)
            }
        }
    }
}