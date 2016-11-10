//
//  CommandLineRouter.swift
//  CommandLineRouter
//
//  Created by Pilipenko Dima on 11/10/16.
//  Copyright © 2016 dimpiax. All rights reserved.
//

public struct CommandsFlow {
    public let name: String
    
    public var count: Int {
        return _value.count
    }
    
    private let _value: [Command]
    
    init(name: String, value: [Command]) {
        self.name = name
        _value = value
    }
    
    public subscript(index: Int) -> Command {
        return _value[index]
    }
}
