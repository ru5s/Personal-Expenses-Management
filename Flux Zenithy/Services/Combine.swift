//
//  Combine.swift
//  Flux Zenithy
//
//  Created by Den on 03/04/24.
//

import Combine

class CombineManager {
    static let shared = CombineManager()
    private init () {}
    var value = CurrentValueSubject<Bool, Never>(false)
    var calculate = CurrentValueSubject<Bool, Never>(false)
}
