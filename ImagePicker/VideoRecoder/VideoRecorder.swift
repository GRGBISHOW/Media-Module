//
//  VideoRecorder.swift
//  Media Module
//
//  Created by Bishow Gurung on 1/28/19.
//  Copyright © 2019 Bishow Gurung. All rights reserved.
//

import Foundation
import MobileCoreServices
import RxSwift
import UIKit
import AVFoundation
protocol VideoReocordable : class {}


extension VideoReocordable where Self: UIViewController {
    func preview() -> Observable<UIView>{
        return Observable.create { observer in
            
            return Disposables.create()
        }
    }
    
    func recordVideo(device: UIImagePickerController.CameraDevice = .rear,
                          quality: UIImagePickerController.QualityType = .typeMedium,
                          maximumDuration: TimeInterval = 600, editable: Bool = false) -> Observable<URL> {
        return Observable.create { observer in
            
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.videoMaximumDuration = maximumDuration
            picker.videoQuality = quality
            picker.allowsEditing = editable
            if UIImagePickerController.isCameraDeviceAvailable(device) {
                picker.cameraDevice = device
            }
            
            return Disposables.create()
        }
    }
}

