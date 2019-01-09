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
import RxCocoa
import RxAlertController

protocol ImagePickable: class {}

extension ImagePickable where Self: UIViewController {
    
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
    
}

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
            
            return Disposables.create(dismissDisposable, Disposables.create {
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
    public var didCancel: Observable<()> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }
    
}


fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}
