//
//  Observable.swift
//  MoranSaveTest
//
//  Created by moran levi on 13/02/2024.
//

import Foundation

class Observable<T> {
    typealias Listener = (T) -> ()
    
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    deinit {
        listener = nil
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        bind(listener)
        listener?(value)
    }
    
}
