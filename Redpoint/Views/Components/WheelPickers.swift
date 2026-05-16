//
//  WheelPickers.swift
//  Redpoint
//
//  Created by Anirudh Lakkaraju on 5/15/26.
//

import SwiftUI

// MARK: - Duration (h / min / s) — reusable across sports

struct DurationWheelPicker: UIViewRepresentable {
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        picker.backgroundColor = .clear
        DispatchQueue.main.async {
            picker.subviews.forEach { $0.backgroundColor = .clear }
        }
        return picker
    }

    func updateUIView(_ uiView: UIPickerView, context: Context) {
        uiView.selectRow(hours,   inComponent: 0, animated: false)
        uiView.selectRow(minutes, inComponent: 1, animated: false)
        uiView.selectRow(seconds, inComponent: 2, animated: false)
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: DurationWheelPicker

        init(_ parent: DurationWheelPicker) { self.parent = parent }

        func numberOfComponents(in pickerView: UIPickerView) -> Int { 3 }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0: return 24
            case 1: return 60
            case 2: return 60
            default: return 0
            }
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch component {
            case 0: return "\(row) h"
            case 1: return "\(row) min"
            case 2: return "\(row) s"
            default: return nil
            }
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
            case 0: parent.hours = row
            case 1: parent.minutes = row
            case 2: parent.seconds = row
            default: break
            }
        }
    }
}

// MARK: - Distance (whole / .fraction / unit)

struct DistanceWheelPicker: UIViewRepresentable {
    @Binding var whole: Int
    @Binding var fraction: Int
    @Binding var unit: String

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        picker.backgroundColor = .clear
        DispatchQueue.main.async {
            picker.subviews.forEach { $0.backgroundColor = .clear }
        }
        return picker
    }

    func updateUIView(_ uiView: UIPickerView, context: Context) {
        uiView.selectRow(whole,    inComponent: 0, animated: false)
        uiView.selectRow(fraction, inComponent: 1, animated: false)
        uiView.selectRow(unit == "mi" ? 0 : 1, inComponent: 2, animated: false)
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: DistanceWheelPicker
        let units = ["mi", "km"]

        init(_ parent: DistanceWheelPicker) { self.parent = parent }

        func numberOfComponents(in pickerView: UIPickerView) -> Int { 3 }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0: return 100
            case 1: return 10
            case 2: return 2
            default: return 0
            }
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch component {
            case 0: return "\(row)"
            case 1: return ".\(row)"
            case 2: return units[row]
            default: return nil
            }
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
            case 0: parent.whole = row
            case 1: parent.fraction = row
            case 2: parent.unit = units[row]
            default: break
            }
        }
    }
}

// MARK: - Pace (min / sec / unit)

struct PaceWheelPicker: UIViewRepresentable {
    @Binding var minutes: Int
    @Binding var seconds: Int
    @Binding var unit: String

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        picker.backgroundColor = .clear
        DispatchQueue.main.async {
            picker.subviews.forEach { $0.backgroundColor = .clear }
        }
        return picker
    }

    func updateUIView(_ uiView: UIPickerView, context: Context) {
        uiView.selectRow(minutes, inComponent: 0, animated: false)
        uiView.selectRow(seconds, inComponent: 1, animated: false)
        uiView.selectRow(unit == "mi" ? 0 : 1, inComponent: 2, animated: false)
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: PaceWheelPicker
        let units = ["/mi", "/km"]

        init(_ parent: PaceWheelPicker) { self.parent = parent }

        func numberOfComponents(in pickerView: UIPickerView) -> Int { 3 }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0: return 60
            case 1: return 60
            case 2: return 2
            default: return 0
            }
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch component {
            case 0: return "\(row)"
            case 1: return String(format: "%02d", row)
            case 2: return units[row]
            default: return nil
            }
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch component {
            case 0: parent.minutes = row
            case 1: parent.seconds = row
            case 2: parent.unit = String(units[row].dropFirst()) // strip "/" → "mi"/"km"
            default: break
            }
        }
    }
}
