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

    public init(shortName: String, name: String) {
	self.shortName = shortName
	self.name = name
    }
}
