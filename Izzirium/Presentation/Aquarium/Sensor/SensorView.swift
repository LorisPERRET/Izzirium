//
//  SensorView.swift
//  Izzirium
//
//  Created by Loris Perret on 17/11/2025.
//

import Charts
import DesignSystem
import Foundation
import SwiftUI

struct SensorView: View {
    
    struct ChartValue: Identifiable {
        
        // MARK: - Properties

        let id = UUID()
        let date: Date
        let value: Float
    }
    
    // MARK: - Properties

    let title: String
    let values: [ChartValue]
    
    // MARK: - Body

    var body: some View {
        VStack {
            ZZCard(
                bodyContent: {
                    chart
                        .padding(.top, .mu050)
                },
                action: nil
            )
            .zzShadow(.medium)
        }
        .zzNavigationTitle(title: title)
        .navigationBarTitleDisplayMode(.large)
        .padding(.mu100)
    }
    
    // MARK: - Subviews

    private var chart: some View {
        Chart(values) { value in
            LineMark(
                x: .value("Date", value.date),
                y: .value("Valeur", value.value)
            )
            .foregroundStyle(Color.primaryMedium)
        }
        .xConfig(values)
        .yConfig(values)
    }
}

private extension View {
    func xConfig(_ values: [SensorView.ChartValue]) -> some View {
        self
            .chartXAxis {
                AxisMarks(values: values.map { $0.date }) { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel(
                            format:
                                .dateTime
                                .hour(.twoDigits(amPM: .omitted))
                                .minute(.twoDigits)
                        )
                    }
                    AxisGridLine()
                    AxisTick()
                }
            }
            .chartXScale(domain: {
                let dates = values.map { $0.date }
                let minDate = dates.min() ?? Date()
                let maxDate = dates.max() ?? Date()
                return [
                    minDate,
                    maxDate.advanced(by: 1_800)
                ]
            }())
    }

    func yConfig(_ values: [SensorView.ChartValue]) -> some View {
        self
            .chartYAxis {
                AxisMarks(values: values.map { $0.value }) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(
                        format: Decimal.FormatStyle.number.precision(.fractionLength(2))
                    )
                }
            }
            .chartYScale(domain: {
                let minValue = (values.map { $0.value }).min() ?? 0
                let maxValue = (values.map { $0.value }).max() ?? 1
                let delta = (maxValue - minValue) * 0.05
                return [
                    minValue - delta,
                    maxValue + delta
                ]
            }())
    }
}

#if DEBUG

#Preview {
    SensorView(
        title: "PH",
        values: [
            SensorView.ChartValue(date: Date(), value: 0),
            SensorView.ChartValue(date: Date().addingTimeInterval(100), value: 1),
            SensorView.ChartValue(date: Date().addingTimeInterval(300), value: 2)
        ]
    )
}

#endif
