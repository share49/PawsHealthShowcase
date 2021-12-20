//
//  ChartsView.swift
//  PawsHealth
//
//  Created by Pinto Diaz, Roger on 7/4/20.
//  Copyright © 2020 Hoowie. All rights reserved.
//

import Charts
import UIKit

final class ChartsView: LineChartView {

    private var sets = [[ChartPoint]]()

    func setupLineChart(pets: [Pet]) {
        sets.removeAll()

        for pet in pets {
            var chartPointWeights = [ChartPoint]()

            pet.sortedWeights.forEach { (weight) in
                let chartPoint = ChartPoint(date: weight.date, petName: pet.name, weight: weight.weightDouble, colorName: pet.colorName)
                chartPointWeights.append(chartPoint)
            }

            if !chartPointWeights.isEmpty {
                sets.append(chartPointWeights)
            }
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"

        var dataSets = [LineChartDataSet]()

        for i in sets { //Array of array of structs

            // sort the internal array by date
            let sort = i.sorted { item1, item2 in
                let date1 = dateFormatter.date(from: item1.date)
                let date2 =  dateFormatter.date(from: item2.date)
                return date1!.compare(date2!) == ComparisonResult.orderedAscending
            }

            var dataEntries: [ChartDataEntry] = []
            for stat in 0...(sort.count - 1) {
                let date = dateFormatter.date(from: sort[stat].date)
                let timeIntervalForDate: TimeInterval = date!.timeIntervalSince1970
                let dataEntry = ChartDataEntry(x: Double(timeIntervalForDate), y: sort[stat].weight)
                dataEntries.append(dataEntry)

                if stat == (sort.count - 1) {
                    let color = Colors.getColor(from: sort[stat].colorName ?? "systemTeal")
                    let chartDataSet = LineChartDataSet(entries: dataEntries, label: "\(sort[stat].petName)")
                    chartDataSet.setCircleColor(color)
                    chartDataSet.setColor(color, alpha: 1.0)

                    chartDataSet.drawValuesEnabled = true
                    dataSets.append(chartDataSet)
                    startChart(dataSets: dataSets, entries: dataEntries.count)
                }
            }
        }
    }

    private func startChart(dataSets: [LineChartDataSet], entries: Int) {
        self.animate(xAxisDuration: 0.7, yAxisDuration: 0.7)
        self.dragEnabled = true
        self.legend.form = .circle
        self.drawGridBackgroundEnabled = false

        let xaxis = self.xAxis
        xaxis.valueFormatter = ChartFormatter()
        xaxis.labelCount = entries
        xaxis.granularityEnabled = true
        xaxis.granularity = 1.0
        xaxis.centerAxisLabelsEnabled = true
        xaxis.avoidFirstLastClippingEnabled = true
        xaxis.drawLimitLinesBehindDataEnabled = true
        xaxis.labelPosition = .bottom

        let rightAxis = self.rightAxis
        rightAxis.enabled = false

        let leftAxis = self.leftAxis
        leftAxis.drawZeroLineEnabled = true
        leftAxis.drawGridLinesEnabled = true

        self.data = LineChartData(dataSets: dataSets)
    }
}
