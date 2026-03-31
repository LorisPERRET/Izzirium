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

    let type: SensorType
    let values: [ChartValue]
    let alert: AlertUI?
    

    @State private var scrollX: Date = .now
    
    var isWarning: Bool? {
        guard let (min, max) = alert?.getValue(for: type) else { return nil }
        if let last = values.last?.value, min != nil || max != nil {
            if let min, last < min {
                return true
            }
            
            if let max, max < last {
                return true
            }
            
            return false
        } else {
            return nil
        }
    }
    
    var valueColor: Color {
        guard let isWarning else { return .neutralMedium }
        
        if isWarning {
            return Color.warningMedium
        } else {
            return Color.successMedium
        }
    }
    
    var valueBackgroundColor: Color {
        guard let isWarning else { return .neutralMedium }
        
        if isWarning {
            return Color.warningLowest
        } else {
            return Color.successLowest
        }
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: MagicUnit.mu100.rawValue) {
                if let last = values.last {
                    valueCard(value: last)
                }
                
                ZZCard(
                    bodyContent: {
                        chart
                            .padding(.top, .mu050)
                            .frame(height: 300)
                    },
                    action: nil
                )
                .zzShadow(.small)
                .padding(.bottom, .mu400)
            }
            .padding(.mu100)
        }
        .zzNavigationTitle(title: type.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Subviews
    
    private func stateIcon(_ isWarning: Bool) -> some View {
        Image(systemName: isWarning ? "exclamationmark.triangle" : "checkmark.circle")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(valueColor)
            .frame(
                width: MagicUnit.mu150.rawValue,
                height: MagicUnit.mu150.rawValue
            )
            .padding(.mu075)
            .padding(.leading, .mu0125)
            .padding(.bottom, .mu0125)
            .background(alignment: .center) {
                Circle()
                    .fill(valueBackgroundColor)
            }
    }
    
    private func alertValue(min: Float?, max: Float?) -> some View {
        VStack {
            if let min, let max {
                ZZText(
                    "Plage normale: \(min)\(type.unitLabel ?? "") - \(max)\(type.unitLabel ?? "")",
                    font: .textS,
                    foregroundColor: Color.neutralMedium
                )
            } else if let min {
                ZZText(
                    "Valeur min: \(min)\(type.unitLabel ?? "")",
                    font: .textS,
                    foregroundColor: Color.neutralMedium
                )
            } else if let max {
                ZZText(
                    "Valeur max: \(max)\(type.unitLabel ?? "")",
                    font: .textS,
                    foregroundColor: Color.neutralMedium
                )
            }
            
            if let isWarning, isWarning {
                ZZText(
                    "**Attention:** La valeur est en dehors de la plage normale",
                    font: .textS,
                    foregroundColor: Color.warningMedium
                )
                .padding(.mu100)
                .background {
                    Color.warningLowest
                }
                .zzRadius(.medium)
            }
        }
    }
    
    private func valueCard(value: ChartValue) -> some View {
        ZZCard(
            bodyContent: {
                VStack(alignment: .leading, spacing: MagicUnit.mu050.rawValue) {
                    ZZText(
                        "Dernière mesure faite le \(value.date.formatted())",
                        font: .textS,
                        foregroundColor: Color.neutralLow,
                    )
                    
                    HStack {
                        VStack {
                            ZZText(
                                "Valeur actuelle",
                                font: .textS,
                                foregroundColor: Color.neutralMedium,
                            )
                            
                            ZZText(
                                "\(value.value)",
                                font: FontStyle(
                                    fontConvertible: ZZFonts.Poppins.regular,
                                    size: 32,
                                    lineHeight: 32,
                                    textStyle: .body
                                ),
                                foregroundColor: valueColor,
                            )
                        }
                        
                        if let isWarning {
                            stateIcon(isWarning)
                        }
                    }
                    
                    Divider()
                    
                    if let (min, max) = alert?.getValue(for: type) {
                        alertValue(min: min, max: max)
                    }
                }
            },
            action: nil
        )
        .background(
            RoundedRectangle(cornerRadius: RadiusStyle.medium.rawValue)
                .fill(Color.lightHightest)
                .zzShadow(.small)
        )
    }

    private var chart: some View {
        Chart {
            if let (min, max) = alert?.getValue(for: type) {
                if let max {
                    // MAX line
                    RuleMark(
                        y: .value("Max", max)
                    )
                    .foregroundStyle(Color.red)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                }
                
                if let min {
                    // MIN line
                    RuleMark(
                        y: .value("Min", min)
                    )
                    .foregroundStyle(Color.red)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                }
            }
            
            // Main line
            ForEach(values) { value in
                LineMark(
                    x: .value("Date", value.date),
                    y: .value("Valeur", value.value)
                )
                .foregroundStyle(Color.primaryMedium)
            }
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

#Preview("Good") {
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
        ],
        alert: AlertUI(
            phMin: 7.5,
            phMax: 8.5,
            tdsMin: 0,
            tdsMax: 0,
            turbidityMin: 0,
            turbidityMax: 0,
            temperatureMin: 0,
            temperatureMax: 0
        )
    )
}

#Preview("Bad") {
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
            ChartValue(date: Date().addingTimeInterval(600 * 60), value: 8.6)
        ],
        alert: AlertUI(
            phMin: 7.5,
            phMax: 8.5,
            tdsMin: 0,
            tdsMax: 0,
            turbidityMin: 0,
            turbidityMax: 0,
            temperatureMin: 0,
            temperatureMax: 0
        )
    )
}

#Preview("No alert") {
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
            ChartValue(date: Date().addingTimeInterval(600 * 60), value: 8.6)
        ],
        alert: nil
    )
}

#endif
