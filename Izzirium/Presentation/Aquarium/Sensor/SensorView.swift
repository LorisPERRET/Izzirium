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

    // MARK: - Properties

    let type: LogType
    let values: [ChartValue]

    @State private var scrollX: Date = .now

    // MARK: - Body

    var body: some View {
        VStack {
            if let date = values.map(\.date).max() {
                ZZText("Dernière mesure faite le \(date.formatted())")
            }
            ZZCard(
                bodyContent: {
                    chart
                        .padding(.top, .mu050)
                },
                action: nil
            )
            .zzShadow(.medium)
            .padding(.bottom, .mu400)
        }
        .zzNavigationTitle(title: type.title)
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
        .chartScrollableAxes(.horizontal)
        .chartScrollPosition(x: $scrollX)
        .onAppear {
            scrollToLatest(values)
        }
        .onChange(of: values) { _, newValues in
            scrollToLatest(newValues)
        }
    }
    
    private func scrollToLatest(_ values: [ChartValue]) {
        let window: TimeInterval = 3 * 60 * 60
        let dates = values.map { $0.date }
        guard let latest = dates.max() else { return }

        // center = rightEdge - window/2  => rightEdge = latest
        var targetCenter = latest.addingTimeInterval(-window / 2)

        // clamp à gauche (si pas assez d'historique)
        if let earliest = dates.min() {
            let minCenter = earliest.addingTimeInterval(window / 2)
            if targetCenter < minCenter { targetCenter = minCenter }
        }

        scrollX = targetCenter
    }
}

private extension View {
    func xConfig(_ values: [ChartValue]) -> some View {
        self
            .chartXAxis {
                let dates = values.map { $0.date }.sorted()

                AxisMarks(values: dates) { value in
                    if value.as(Date.self) != nil {
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
                let dates = values.map { $0.date }.sorted()
                let minDate = dates.first ?? Date()
                let maxDate = dates.last ?? Date()

                if minDate == maxDate {
                    return [
                        minDate.addingTimeInterval(-60),
                        maxDate.addingTimeInterval(60)
                    ]
                }

                return [minDate, maxDate]
            }())
    }

    func yConfig(_ values: [ChartValue]) -> some View {
        let yValues = values.map { $0.value }
        let minValue = yValues.min() ?? 0
        let maxValue = yValues.max() ?? 1
        
        var labels = [minValue, maxValue]
        if let lastValue = yValues.last {
            labels.append(lastValue)
        }

        return self
            .chartYAxis {
                AxisMarks(values: yValues) { value in
                    AxisTick()
                }
                
                AxisMarks(values: labels) { value in
                    AxisGridLine()
                    AxisValueLabel(
                        format: Decimal.FormatStyle.number.precision(.fractionLength(2))
                    )
                }
            }
            .chartYScale(domain: {
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
        type: .ph,
        values: [
            ChartValue(date: Date(), value: 7.2),
            ChartValue(date: Date().addingTimeInterval(30 * 60), value: 7.4),
            ChartValue(date: Date().addingTimeInterval(60 * 60), value: 7.1),
            ChartValue(date: Date().addingTimeInterval(90 * 60), value: 7.6),
            ChartValue(date: Date().addingTimeInterval(120 * 60), value: 8.2),
            ChartValue(date: Date().addingTimeInterval(150 * 60), value: 8.9),
            ChartValue(date: Date().addingTimeInterval(180 * 60), value: 9.4),
            ChartValue(date: Date().addingTimeInterval(210 * 60), value: 9.1),
            ChartValue(date: Date().addingTimeInterval(240 * 60), value: 8.7),
            ChartValue(date: Date().addingTimeInterval(270 * 60), value: 8.3),
            ChartValue(date: Date().addingTimeInterval(300 * 60), value: 7.9),
            ChartValue(date: Date().addingTimeInterval(330 * 60), value: 7.5),
            ChartValue(date: Date().addingTimeInterval(360 * 60), value: 7.2),
            ChartValue(date: Date().addingTimeInterval(390 * 60), value: 7.0),
            ChartValue(date: Date().addingTimeInterval(420 * 60), value: 7.3),
            ChartValue(date: Date().addingTimeInterval(450 * 60), value: 7.8),
            ChartValue(date: Date().addingTimeInterval(480 * 60), value: 8.4),
            ChartValue(date: Date().addingTimeInterval(510 * 60), value: 8.9),
            ChartValue(date: Date().addingTimeInterval(540 * 60), value: 9.2),
            ChartValue(date: Date().addingTimeInterval(570 * 60), value: 8.8),
            ChartValue(date: Date().addingTimeInterval(600 * 60), value: 8.1)
        ]
    )
}

#endif
