//
//  CameraView.swift
//  chuggachugga
//
//  Created by Travis C on 9/14/24.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    var onConfirm: ((Int) -> Void)?
    
    func makeUIViewController(context: Context) -> CameraViewController {
            let viewController = CameraViewController()
            viewController.onConfirm = onConfirm
            return viewController
        }

        func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}
