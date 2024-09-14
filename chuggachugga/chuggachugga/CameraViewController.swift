//
//  CameraViewController.swift
//  chuggachugga
//
//  Created by Travis C on 9/14/24.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    var captureSession: AVCaptureSession!
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer!
    var photoOutput: AVCapturePhotoOutput!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo

        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("Unable to access back camera!")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }

            photoOutput = AVCapturePhotoOutput()
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }

            cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraPreviewLayer.videoGravity = .resizeAspectFill
            cameraPreviewLayer.frame = view.layer.bounds
            view.layer.addSublayer(cameraPreviewLayer)

            captureSession.startRunning()
        } catch {
            print("Error setting up camera: \(error)")
        }
    }

    @objc func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }

        guard let photoData = photo.fileDataRepresentation() else { return }

        let image = UIImage(data: photoData)
        // Handle the captured image
        print("Captured image: \(String(describing: image))")
    }
}

