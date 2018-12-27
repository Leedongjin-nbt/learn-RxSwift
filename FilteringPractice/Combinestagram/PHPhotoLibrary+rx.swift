//
//  PHPhotoLibrary+rx.swift
//  Combinestagram
//
//  Created by DongJin Lee on 14/12/2018.
//  Copyright © 2018 Underplot ltd. All rights reserved.
//

import Foundation
import RxSwift
import Photos

extension PHPhotoLibrary {
    static var authorized: Observable<Bool> {
        return Observable<Bool>.create({ observer in
            if authorizationStatus() == .authorized {
                observer.onNext(true)
                observer.onCompleted()
            } else {
                requestAuthorization { newStatus in
                    observer.onNext(newStatus == .authorized)
                    observer.onCompleted()
                }
            }
        })
    }
    
}
