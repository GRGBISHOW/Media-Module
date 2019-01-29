//
//  MainViewController.swift
//  Media Module
//
//  Created by Bishow Gurung on 1/29/19.
//  Copyright © 2019 Bishow Gurung. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class MainViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!
    var data = ["Image Picker", "Video Picker"]
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        Observable.of(data).bind(to: menuTableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) (setupCell).disposed(by: disposeBag)
        menuTableView.rx.itemSelected.subscribe(onNext: { indexPath in
            switch indexPath.item {
                case 0:
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageViewController")
                    self.navigationController?.pushViewController(vc, animated: true)
                
                case 1:
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController")
                    self.navigationController?.pushViewController(vc, animated: true)
                
            default:
                print("other index")
            }
        }).disposed(by: disposeBag)
    }
    
    func setupCell(row: Int, element: String, cell: UITableViewCell){
        cell.textLabel?.text = element
    }
    
   

}


