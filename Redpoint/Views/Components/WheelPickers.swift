//
//  WheelPickers.swift
//  Redpoint
//
//  Created by Anirudh Lakkaraju on 5/15/26.
//

import SwiftUI
                                                                                                                  
// MARK: - Duration (h / min / s) — reusable across sports

struct DurationWheelPicker: View {
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int
                                                                                                                  
    var body: some View {
        HStack(spacing: 0) {
            Picker("", selection: $hours) {
                ForEach(0..<24, id: \.self) { Text("\($0)").tag($0) }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .center) {
                HStack { Spacer(); Text("h").padding(.trailing, 8) }
                    .allowsHitTesting(false)
                    .font(.title3)
            }

            Picker("", selection: $minutes) {
                ForEach(0..<60, id: \.self) { Text("\($0)").tag($0) }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .center) {
                HStack { Spacer(); Text("min").padding(.trailing, 8) }
                    .allowsHitTesting(false)
                    .font(.title3)
            }

            Picker("", selection: $seconds) {
                ForEach(0..<60, id: \.self) { Text("\($0)").tag($0) }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .center) {
                HStack { Spacer(); Text("s").padding(.trailing, 8) }
                    .allowsHitTesting(false)
                    .font(.title3)
            }
        }
        .overlay(alignment: .center){
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.tertiarySystemFill))
                .frame(height: 35)
                .padding(.horizontal, 8)
                .allowsHitTesting(false)
        }
        }
}
                                                                                                                  
// MARK: - Distance (whole / .fraction / unit)

struct DistanceWheelPicker: View {
    @Binding var whole: Int
    @Binding var fraction: Int
    @Binding var unit: String

    var body: some View {
        HStack(spacing: 0) {
            Picker("", selection: $whole) {
                ForEach(0..<100, id: \.self) { Text("\($0)").tag($0) }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
                                                                                                                  
            Picker("", selection: $fraction) {
                ForEach(0..<10, id: \.self) { Text(".\($0)").tag($0) }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
                                                                                                                  
            Picker("", selection: $unit) {
                Text("mi").tag("mi")
                Text("km").tag("km")
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Pace (min / sec / unit)

struct PaceWheelPicker: View {
    @Binding var minutes: Int
    @Binding var seconds: Int
    @Binding var unit: String
                                                                                                                  
    var body: some View {
        HStack(spacing: 0) {
            Picker("", selection: $minutes) {
                ForEach(0..<60, id: \.self) { Text("\($0)").tag($0) }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
                                                                                                                  
            Picker("", selection: $seconds) {
                ForEach(0..<60, id: \.self) { Text(String(format: "%02d", $0)).tag($0) }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)

            Picker("", selection: $unit) {
                Text("/mi").tag("mi")
                Text("/km").tag("km")
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)
        }
    }
}
