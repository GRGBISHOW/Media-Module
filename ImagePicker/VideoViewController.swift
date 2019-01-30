//
//  VideoViewController.swift
//  Media Module
//
//  Created by Bishow Gurung on 1/28/19.
//  Copyright © 2019 Bishow Gurung. All rights reserved.
//

import UIKit
import RxSwift
import AVFoundation
class VideoViewController: UIViewController, MediaPickable {

    @IBOutlet weak var camPreview: UIView!
    @IBAction func addVideoBtn(_ sender: Any) {
        self.recordVideo().subscribe(onNext:{[weak self] url in
            self?.addAVLayer(withUrl: url)
            }, onError: { err in
                print(err.localizedDescription)
        }).disposed(by: disposeBag)
        
    }
    
    var disposeBag = DisposeBag()
   
    override func viewDidLoad() {
       
    }
    
    func addAVLayer(withUrl url:URL) {
        self.camPreview.layer.sublayers = nil
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.camPreview.bounds
        self.camPreview.layer.addSublayer(playerLayer)
        player.play()
    }
    
}





