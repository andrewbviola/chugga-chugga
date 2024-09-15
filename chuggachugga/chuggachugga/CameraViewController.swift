//
//  CameraViewController.swift
//

import UIKit
import AVFoundation
import Vision

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
    var THRESHOLD: Float = 0.7
    var captureSession = AVCaptureSession()
    var previewView = UIImageView()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var videoOutput: AVCaptureVideoDataOutput!
    var frameCounter = 0
    var frameInterval = 1
    var sum: Int = 0
    var onConfirm: ((Int) -> Void)?
    var videoSize = CGSize.zero
    let colors: [UIColor] = {
        var colorSet: [UIColor] = []
        for _ in 0...80 {
            let color = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
            colorSet.append(color)
        }
        return colorSet
    }()
    let ciContext = CIContext()
    var classes: [String] = []
    private var latestPixelBuffer: CVPixelBuffer?
    private let captureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Capture", for: .normal)
        button.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm", for: .normal)
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // Initially hidden
        return button
    }()

    private let retakeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retake", for: .normal)
        button.addTarget(self, action: #selector(retakeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // Initially hidden
        return button
    }()

    
    lazy var yoloRequest: VNCoreMLRequest! = {
        do {
            let model = try yolov8n().model
            guard let classes = model.modelDescription.classLabels as? [String] else {
                fatalError()
            }
            self.classes = classes
            let vnModel = try VNCoreMLModel(for: model)
            let request = VNCoreMLRequest(model: vnModel)
            return request
        } catch let error {
            fatalError("mlmodel error.")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupVideo()

        // Setup buttons
        setupButton(captureButton, title: "Capture")
        setupButton(confirmButton, title: "Confirm")
        setupButton(retakeButton, title: "Retake")

        // Add buttons to the view
        view.addSubview(captureButton)
        view.addSubview(confirmButton)
        view.addSubview(retakeButton)

        // Initially hide the confirm and retake buttons
        confirmButton.isHidden = true
        retakeButton.isHidden = true

        // Setup button constraints
        setupButtonConstraints()
    }


    func setupButton(_ button: UIButton, title: String) {
        // Set the title
        button.setTitle(title, for: .normal)
        
        // Set padding (use contentEdgeInsets for padding in UIButton)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        // Set background color
        button.backgroundColor = .black
        
        // Set text color
        button.setTitleColor(.white, for: .normal)
        
        // Set corner radius for rounded corners
        button.layer.cornerRadius = 10
        
        // Enable autolayout for positioning
        button.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupButtonConstraints() {
        // Capture button (centered at the bottom)
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        // Confirm button (bottom right)
        NSLayoutConstraint.activate([
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        // Retake button (bottom left)
        NSLayoutConstraint.activate([
            retakeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            retakeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }

    
    func setupCaptureButtons() {
        // Add buttons to the view
        view.addSubview(captureButton)
        view.addSubview(confirmButton)
        view.addSubview(retakeButton)
        
        // Set button constraints
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            retakeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            retakeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }



    
    @objc func captureButtonTapped() {
        // Hide the capture button and show the confirm and retake buttons
        captureButton.isHidden = true
        confirmButton.isHidden = false
        retakeButton.isHidden = false

        // Capture the current image from the camera
        if let pixelBuffer = getCurrentPixelBuffer() {
            // Perform detection
            if let drawImage = detection(pixelBuffer: pixelBuffer) {
                // Print detection labels and their confidence values
                let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
                do {
                    try handler.perform([yoloRequest])
                    if let results = yoloRequest.results as? [VNRecognizedObjectObservation] {
                        var countArray = [Int]()
                        for result in results {
                            if let label = result.labels.first?.identifier as? String {
                                let confidence: Float = result.confidence
                                if confidence > THRESHOLD {
                                    countArray.append(Int(label)!)
                                }
                            }
                        }
                        for number in countArray {
                            sum += number
                        }
                        confirmButton.setTitle("Confirm: \(sum)", for: .normal)
                    }
                } catch {
                    print("Error performing detection: \(error)")
                }
                showCapturedImage(drawImage)
            }
        }
    }

    
    @objc func confirmButtonTapped() {
        // Handle the confirmation of the captured image
        // For example, you could save the image or proceed with further actions
        
        // Hide the confirm and retake buttons, and show the capture button
        confirmButton.isHidden = false
        retakeButton.isHidden = false
        captureButton.isHidden = false
        view.isHidden = true
        onConfirm?(sum)
        
        if let viewControllers = navigationController?.viewControllers {
                // Example: Pop to the view controller at index 0
                // Adjust the index based on your navigation stack
            
                let targetIndex = max(0, viewControllers.count - 3) // Pop to the second last view controller in the stack
                let targetVC = viewControllers[targetIndex]
                navigationController?.popToViewController(targetVC, animated: true)
            }
        
    }


    @objc func retakeButtonTapped() {
        // Remove the captured image view if it exists
        if let capturedImageView = view.subviews.first(where: { $0 is UIImageView && $0 != previewView }) {
            capturedImageView.removeFromSuperview()
        }
        
        // Show the capture button and hide the confirm and retake buttons
        captureButton.isHidden = false
        confirmButton.isHidden = true
        retakeButton.isHidden = true
        sum = 0
    }


    func getCurrentPixelBuffer() -> CVPixelBuffer? {
        return latestPixelBuffer
    }

    
    func showCapturedImage(_ image: UIImage) {
        // Create and configure the UIImageView for the captured image
        let imageView = UIImageView(image: image)
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.isUserInteractionEnabled = true
        
        view.addSubview(imageView)
        
        view.bringSubviewToFront(captureButton)
        view.bringSubviewToFront(confirmButton)
        view.bringSubviewToFront(retakeButton)
        
        // Hide the capture button and show the confirm and retake buttons
        captureButton.isHidden = true
        confirmButton.isHidden = false
        retakeButton.isHidden = false
    }


    func setupVideo() {
        previewView.frame = view.bounds
        previewView.contentMode = .scaleAspectFill
        view.addSubview(previewView)

        captureSession.beginConfiguration()

        let device = AVCaptureDevice.default(for: AVMediaType.video)
        let deviceInput = try! AVCaptureDeviceInput(device: device!)

        captureSession.addInput(deviceInput)
        videoOutput = AVCaptureVideoDataOutput()

        let queue = DispatchQueue(label: "VideoQueue")
        videoOutput.setSampleBufferDelegate(self, queue: queue)
        captureSession.addOutput(videoOutput)
        if let videoConnection = videoOutput.connection(with: .video) {
            if videoConnection.isVideoOrientationSupported {
                videoConnection.videoOrientation = .portrait
            }
        }
        captureSession.commitConfiguration()
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func detection(pixelBuffer: CVPixelBuffer) -> UIImage? {
        do {
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
            try handler.perform([yoloRequest])
            guard let results = yoloRequest.results as? [VNRecognizedObjectObservation] else {
                return nil
            }
            
            let confidenceThreshold: Float = THRESHOLD
            var detections: [Detection] = []
            
            for result in results {
                // Filter based on confidence threshold
                if result.confidence >= confidenceThreshold {
                    let flippedBox = CGRect(x: result.boundingBox.minX, y: 1 - result.boundingBox.maxY, width: result.boundingBox.width, height: result.boundingBox.height)
                    let box = VNImageRectForNormalizedRect(flippedBox, Int(videoSize.width), Int(videoSize.height))

                    guard let label = result.labels.first?.identifier as? String,
                          let colorIndex = classes.firstIndex(of: label) else {
                        continue
                    }
                    
                    let detection = Detection(box: box, confidence: result.confidence, label: label, color: colors[colorIndex])
                    detections.append(detection)
                }
            }
            
            let drawImage = drawRectsOnImage(detections, pixelBuffer)
            return drawImage
        } catch {
            return nil
        }
    }
    
    func drawRectsOnImage(_ detections: [Detection], _ pixelBuffer: CVPixelBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
        let size = ciImage.extent.size
        guard let cgContext = CGContext(data: nil,
                                        width: Int(size.width),
                                        height: Int(size.height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 4 * Int(size.width),
                                        space: CGColorSpaceCreateDeviceRGB(),
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))
        for detection in detections {
            let invertedBox = CGRect(x: detection.box.minX, y: size.height - detection.box.maxY, width: detection.box.width, height: detection.box.height)
            if let labelText = detection.label {
                cgContext.textMatrix = .identity
                
                let text = "\(labelText) : \(round(detection.confidence*100))"
                
                let textRect  = CGRect(x: invertedBox.minX + size.width * 0.01, y: invertedBox.minY - size.width * 0.01, width: invertedBox.width, height: invertedBox.height)
                let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
                
                let textFontAttributes = [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: textRect.width * 0.1, weight: .bold),
                    NSAttributedString.Key.foregroundColor: detection.color,
                    NSAttributedString.Key.paragraphStyle: textStyle
                ]
                
                cgContext.saveGState()
                defer { cgContext.restoreGState() }
                let astr = NSAttributedString(string: text, attributes: textFontAttributes)
                let setter = CTFramesetterCreateWithAttributedString(astr)
                let path = CGPath(rect: textRect, transform: nil)
                
                let frame = CTFramesetterCreateFrame(setter, CFRange(), path, nil)
                cgContext.textMatrix = CGAffineTransform.identity
                CTFrameDraw(frame, cgContext)
                
                cgContext.setStrokeColor(detection.color.cgColor)
                cgContext.setLineWidth(9)
                cgContext.stroke(invertedBox)
            }
        }
        
        guard let newImage = cgContext.makeImage() else { return nil }
        return UIImage(ciImage: CIImage(cgImage: newImage))
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        frameCounter += 1
        if videoSize == CGSize.zero {
            guard let width = sampleBuffer.formatDescription?.dimensions.width,
                  let height = sampleBuffer.formatDescription?.dimensions.height else {
                fatalError()
            }
            videoSize = CGSize(width: CGFloat(width), height: CGFloat(height))
        }
        if frameCounter == frameInterval {
            frameCounter = 0
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            
            // Update the latest pixel buffer
            latestPixelBuffer = pixelBuffer
            
            // Process and update preview view
            guard let drawImage = detection(pixelBuffer: pixelBuffer) else {
                return
            }
            DispatchQueue.main.async {
                self.previewView.image = drawImage
            }
        }
    }
}

struct Detection {
    let box:CGRect
    let confidence:Float
    let label:String?
    let color:UIColor
}
