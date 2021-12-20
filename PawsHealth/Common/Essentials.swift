//
//  Essentials.swift
//  Hoowie
//
//  Created by Roger Pintó Diaz on 5/7/18.
//  Copyright © 2018 Roger Pintó Diaz. All rights reserved.
//

import UIKit

// MARK: - Threading
public func delay(_ delay: Double, onBackground: Bool = false, closure: @escaping () -> ()) {
    let queue: DispatchQueue
    if onBackground {
        queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
    } else {
        queue = DispatchQueue.main
    }
    
    let nanoSecPerSec: Double = Double(NSEC_PER_SEC)
    let delay: Double = delay * nanoSecPerSec / nanoSecPerSec
    
    queue.asyncAfter(deadline: DispatchTime.now() + delay, execute: closure)
}

public func onMain(_ closure: @escaping () -> ()) {
    DispatchQueue.main.async(execute: closure)
}

/// Basically just letting dispatch code on background or not without an if else
public func runSynchronously(_ synchronously: Bool = true, closure: @escaping () -> ()) {
    if synchronously {
        closure()
    } else {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: closure)
    }
}

public func onBackground(_ dispatchAgain: Bool = false, closure: @escaping () -> ()) {
    if Thread.isMainThread || dispatchAgain {
        MyLogD("dispatching onto new bg thread")
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: closure)
    } else {
        MyLogD("already on bg - just running code")
        closure()
    }
}

// MARK: - Logging
func MyLogI(_ message: String) {
    NSLog("ℹ️ \(message)")
}

func MyLogD(_ message: String) {
    #if DEBUG
    NSLog("✳️ \(message)")
    #endif
}

func MyLogE(_ message: String) {
    NSLog("🛑 \(message)")
}

let ls = R.string.localizable.self
