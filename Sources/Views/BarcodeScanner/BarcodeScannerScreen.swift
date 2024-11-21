//
//  BarcodeScanner.swift
//  
//
//  Created by Henadzi Ryabkin on 05/04/2023.
//

import SwiftUI
import UIKit

public struct BarcodeScannerScreen: UIViewControllerRepresentable {
    @Binding public var barcode: String
    @Binding public var isCapturing: Bool

    public func makeUIViewController(context: Context) -> BarcodeScannerController {
        let viewController = BarcodeScannerController()
        let coordinator = BarcodeScannerCoordinator(barcode: $barcode, isCapturing: $isCapturing)
        viewController.delegate = coordinator
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: BarcodeScannerController, context: Context) {
        if !uiViewController.initialised { return }
        if isCapturing {
            uiViewController.resumeCapturing()
        } else {
            uiViewController.pauseCapturing()
        }
    }
}

public class BarcodeScannerCoordinator: NSObject, BarcodeScannerDelegate {

    @Binding public var barcode: String
    @Binding public var isCapturing: Bool
    
    public init(barcode: Binding<String>, isCapturing: Binding<Bool>) {
        _barcode = barcode
        _isCapturing = isCapturing
    }
    
    public func didFindCode(code: String) {
        print("\(#function) \(code)")
        self.barcode = code
    }
    
    public func stoppedCapturing() {
        self.isCapturing = false
        self.barcode = ""
    }
}
