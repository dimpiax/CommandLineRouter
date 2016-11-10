//
//  Command.swift
//  CommandLineRouter
//
//  Created by Pilipenko Dima on 11/06/16.
//  Copyright © 2016 dimpiax. All rights reserved.
//

public struct Command {
    public let shortName: String
    public let name: String
    
    public let argument: String?

    public init(shortName: String, name: String) {
        self.shortName = shortName
        self.name = name
        self.argument = nil
    }
    
    public init(shortName: String, name: String, argument: String) {
        self.shortName = shortName
        self.name = name
        self.argument = argument
    }
}
