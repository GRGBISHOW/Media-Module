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

class ViewController: UIViewController, ImagePickable {
    @IBOutlet weak var showCaseImageView: UIImageView!
    @IBOutlet weak var startBtn: UIButton!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.rx.tap.subscribe(onNext:{[weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.getImage().bind(to: strongSelf.showCaseImageView.rx.image).disposed(by: strongSelf.disposeBag)
        }).disposed(by: disposeBag)
        // Do any additional setup after loading the view, typically from a nib.
    }
    


}


