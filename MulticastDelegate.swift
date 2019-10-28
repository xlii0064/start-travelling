//
//  MulticastDelegate.swift
//  Start Traveling
//
//  Created by Xinbei Li on 16/4/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

//This class was referencing from week4 lab on moodle. It can be found on week4 lab sheet

import UIKit

class MulticastDelegate <T>{
private var delegates = Set<WeakObjectWrapper>()
            func addDelegate(_ delegate: T) {
                let delegateObject = delegate as AnyObject
                delegates.insert(WeakObjectWrapper(value: delegateObject)) }
            func removeDelegate(_ delegate: T) {
                let delegateObject = delegate as AnyObject
                delegates.remove(WeakObjectWrapper(value: delegateObject)) }
            func invoke(invocation: (T) -> ()) { delegates.forEach { (delegateWrapper) in
                if let delegate = delegateWrapper.value {
                    invocation(delegate as! T) }
                } }
}
private class WeakObjectWrapper: Equatable, Hashable {
    weak var value: AnyObject?
    init(value: AnyObject) {
        self.value = value }
    // Hash based on the address (pointer) of the value.
    var hashValue: Int {
        return ObjectIdentifier(value!).hashValue }
    // Equate based on equality of the value pointers of two wrappers.
    static func == (lhs: WeakObjectWrapper, rhs: WeakObjectWrapper) -> Bool {
        return lhs.value === rhs.value }
}
