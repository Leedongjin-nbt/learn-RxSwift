//
//  ViewController.swift
//  learnRxSwift
//
//  Created by DongJin Lee on 30/11/2018.
//  Copyright © 2018 DongJin Lee. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    let disposeBag = DisposeBag()
    let pubSubject = PublishSubject<String>()
    let behaviourSubject = BehaviorSubject<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func subscribeString() {
        
        
    }

}

