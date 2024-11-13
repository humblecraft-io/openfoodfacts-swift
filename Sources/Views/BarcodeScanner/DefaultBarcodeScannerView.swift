//
//  DefaultBarcodeScannerView.swift
//
//
//  Created by Lionel Alves on 06/11/2024.
//

import SwiftUI

public struct DefaultBarcodeScannerView: View {

    @State private var barcode: String = ""
    @State private var isEditing = false
    @State private var isInvalidCode = false
    @State private var isScanning = true

    let completion: (String) -> Void

    public init(completion: @escaping (String) -> Void) {
        self.completion = completion
    }

    private func resetState() {
        isInvalidCode = false
        barcode = ""
        isScanning = true
    }

    public var body: some View {
        BarcodeScannerScreen(barcode: $barcode, isCapturing: $isScanning).ignoresSafeArea(.all)
//            .navigationDestination(isPresented: $isEditing, destination: {
//                ProductPage(barcode: barcode) { uploadedProduct in
//                    print(uploadedProduct?.json() ?? "returned product is nil")
//                    resetState()
//                }
//            })
//            .onChange(of: isEditing) { newValue in
//                if newValue == false {
//                    resetState()
//                }
//            }
            .onChange(of: barcode) { newValue in
                if newValue.isEmpty { return }
                print("Found barcode \(barcode) which \(barcode.isAValidBarcode() ? "Valid" : "Invalid")")
                if newValue.isAValidBarcode() {
                    resetState()
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
    DefaultBarcodeScannerView(completion: { _ in })
}
