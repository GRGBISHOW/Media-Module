//
//  UIView.swift
//  Media Module
//
//  Created by Bishow Gurung on 1/7/19.
//  Copyright © 2019 Bishow Gurung. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class Views: UIView {
    
    
}

class MediaBtn: UIButton {
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        touchObserver()
    }
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.touchObserver()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func touchObserver() {
        self.rx.tap.subscribe(onNext: { () in
            
        }).disposed(by: disposeBag)
        
    }
    
}
