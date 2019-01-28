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

class ViewController: UIViewController, MediaPickable {
    @IBOutlet weak var showCaseImageView: UIImageView!
    @IBOutlet weak var startBtn: UIButton!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.rx.tap.flatMap{self.getImage()}.bind(to: self.showCaseImageView.rx.image).disposed(by: disposeBag)
    }
    


}


