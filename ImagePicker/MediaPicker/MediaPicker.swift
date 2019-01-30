//
//  ImagePicker.swift
//  Media Module
//
//  Created by Bishow Gurung on 1/7/19.
//  Copyright © 2019 Bishow Gurung. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxAlertController
import MobileCoreServices
protocol MediaPickable: class {}

extension MediaPickable where Self: UIViewController {
    
    func getImage() -> Observable<UIImage?> {
       return  UIAlertController.rx.show(in: self,
                                              title: "Choose Photo",
                                              message: nil,
                                              buttons: [.default("Camera"), .default("Gallery"), .cancel("Cancel")],
                                              preferredStyle: .actionSheet).asObservable().flatMap { (choice) -> Observable<UIImage?> in
                                                    if choice == 0 {
                                                        return UIImagePickerController.isSourceTypeAvailable(.camera) ? self.getImage(fromSource: .camera) : Observable.create({ (_) -> Disposable in
                                                            return Disposables.create()
                                                        })
                                                    }else {
                                                        return self.getImage(fromSource: .photoLibrary)
                                                    }
                                                }

    }
    
    
    
    private func getImage(fromSource source: UIImagePickerController.SourceType) -> Observable<UIImage?> {
        return UIImagePickerController.rx.createWithParent(self) { picker in
            picker.sourceType = source
            picker.allowsEditing = true
            }.flatMap({ (controller) -> Observable<[UIImagePickerController.InfoKey : Any]> in
               return controller.rx.didFinishPickingMediaWithInfo
            }).map({ (info) -> UIImage? in
                return info[UIImagePickerController.InfoKey.editedImage] as? UIImage
                })
    }
    
    func recordVideo(withDevice device: UIImagePickerController.CameraDevice = .rear,
                     quality: UIImagePickerController.QualityType = .typeMedium,
                     maximumDuration: TimeInterval = 600, editable: Bool = false) -> Observable<URL> {
        return UIImagePickerController.rx.createWithParent(self) { picker in
            picker.sourceType = .camera
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.videoMaximumDuration = maximumDuration
            picker.videoQuality = quality
            picker.allowsEditing = editable
            if UIImagePickerController.isCameraDeviceAvailable(device) {
                picker.cameraDevice = device
            }
            }.flatMap({ (controller) -> Observable<[UIImagePickerController.InfoKey : Any]> in
                return controller.rx.didFinishPickingMediaWithInfo
            }).map({ (info) -> URL in
                return info[UIImagePickerController.InfoKey.mediaURL] as! URL
            })
    }
    
}

