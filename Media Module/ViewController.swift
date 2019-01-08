//
//  ViewController.swift
//  Media Module
//
//  Created by Bishow Gurung on 1/7/19.
//  Copyright © 2019 Bishow Gurung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var showCaseImageView: UIImageView!
    @IBOutlet weak var startBtn: UIButton!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startBtn.rx.tap
            .flatMapLatest { [weak self] _ in //1 tap -> picker
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = false
                    } //2 -> info
                    .flatMap { $0.rx.didFinishPickingMediaWithInfo }
                    .take(1)
               
                
            }.subscribe(onNext: { (info) in
                print(info)
            }, onError: { (err) in
                print(err.localizedDescription)
            }, onCompleted: {
                print("completed")
            }) {
                print("disposed")
        }.disposed(by: disposeBag)
        
            
        
        
//        startBtn.rx.tap.subscribe(onNext:{[weak self] _ in
//            guard let strongSelf = self else {return}
//            strongSelf.getImage().subscribe(onNext: { img in
//                print(img == nil)
//            }).disposed(by: strongSelf.disposeBag)
//
//                //.bind(to: strongSelf.showCaseImageView.rx.image).disposed(by: strongSelf.disposeBag)
//        }).disposed(by: disposeBag)
        // Do any additional setup after loading the view, typically from a nib.
    }
    


}


