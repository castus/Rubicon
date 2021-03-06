//
//  Type.swift
//  Rubicon
//
//  Created by Kryštof Matěj on 26/04/2017.
//  Copyright © 2017 Kryštof Matěj. All rights reserved.
//

public enum TypePrefix: String {
    case escaping = "@escaping"
    case autoclosure = "@autoclosure"
}

public struct Type {
    public var name: String
    public var isOptional: Bool
    public var isClosure: Bool
    public var prefix: TypePrefix?

    public init(name: String, isOptional: Bool, isClosure: Bool = false, prefix: TypePrefix? = nil) {
        self.name = name
        self.isOptional = isOptional
        self.isClosure = isClosure
        self.prefix = prefix
    }
}
