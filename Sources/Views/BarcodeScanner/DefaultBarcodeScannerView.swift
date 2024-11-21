//
//  DefaultBarcodeScannerView.swift
//
//
//  Created by Lionel Alves on 06/11/2024.
//

import SwiftUI

public struct DefaultBarcodeScannerView: View {

    @State private var barcode: String = ""
    @State private var isInvalidCode = false

    let isScanning: Bool
    let completion: (String) -> Void

    public init(isScanning: Bool, completion: @escaping (String) -> Void) {
        self.isScanning = isScanning
        self.completion = completion
    }

    private func resetState() {
        isInvalidCode = false
        barcode = ""
    }

    public var body: some View {
        BarcodeScannerScreen(barcode: $barcode, isCapturing: .constant(isScanning))
            .ignoresSafeArea(.all)
            .onChange(of: barcode) { newValue in
                if newValue.isEmpty { return }
                print("Found barcode \(barcode) which \(barcode.isAValidBarcode() ? "Valid" : "Invalid")")
                if newValue.isAValidBarcode() {
                    completion(barcode)
                } else {
                    isInvalidCode = true
                }
            }
            .alert("Invalid barcode", isPresented: $isInvalidCode) {
                Button("Dismiss") {
                    resetState()
                }
            } message: {
                Text("Barcode \(barcode) is invalid. Expected format should have 7,8,12 or 13 digits.")
            }
    }
}

// MARK: - Preview

#Preview {
    DefaultBarcodeScannerView(isScanning: true, completion: { _ in })
}
