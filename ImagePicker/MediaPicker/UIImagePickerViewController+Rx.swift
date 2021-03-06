//
//  UIImagePickerViewController+Rx.swift
//  Media Module
//
//  Created by Bishow Gurung on 1/10/19.
//  Copyright © 2019 Bishow Gurung. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import AVFoundation

func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async {
            dismissViewController(viewController, animated: animated)
        }
        
        return
    }
    
    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}


extension Reactive where Base: UIImagePickerController {
    static func createWithParent(_ parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> () = { x in }) -> Observable<UIImagePickerController> {
        return Observable.create { [weak parent] observer in
            let imagePicker = UIImagePickerController()
            
            let dismissDisposable = imagePicker.rx
                .didCancel
                .subscribe(onNext: { [weak imagePicker] _ in
                    guard let imagePicker = imagePicker else {
                        return
                    }
                    dismissViewController(imagePicker, animated: animated)
                })
            
            let ds = imagePicker.rx
                .didFinishPickingMediaWithInfo
                .subscribe(onNext: { [weak imagePicker] _ in
                    guard let imagePicker = imagePicker else {
                        return
                    }
                    dismissViewController(imagePicker, animated: animated)
                })
            
            do {
                try configureImagePicker(imagePicker)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }
            
            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }
            
            parent.present(imagePicker, animated: animated, completion: nil)
            observer.on(.next(imagePicker))
            
            return Disposables.create(dismissDisposable, ds, Disposables.create {
                dismissViewController(imagePicker, animated: animated)
            })
        }
    }
}


extension Reactive where Base: UIImagePickerController {
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey : Any]> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                print("this is a \(a)")
                return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, Any>.self, a[1])
            })
    }
    
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishRecordingTo: Observable<URL> {
        return delegate.methodInvoked(#selector(AVCaptureFileOutputRecordingDelegate.fileOutput(_:didFinishRecordingTo:from:error:))).map { (a) in
            if a.count > 3 {
                throw try castOrThrow(Error.self, a[3])
            }else {
                return try castOrThrow(URL.self, a[1])
            }
            
        }
    }
    
    public var didStartRecordingTo: Observable<URL> {
        return delegate.methodInvoked(#selector(AVCaptureFileOutputRecordingDelegate.fileOutput(_:didStartRecordingTo:from:))).map { (a) in
           return try castOrThrow(URL.self, a[1])
        }
    }
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didCancel: Observable<()> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }
    
    
    
    
}

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}


open class RxImagePickerDelegateProxy: RxNavigationControllerDelegateProxy, UIImagePickerControllerDelegate {
    public init(imagePicker: UIImagePickerController) {
        super.init(navigationController: imagePicker)
    }
}
