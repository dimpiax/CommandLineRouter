//
//  CommandLineRouter.swift
//  CommandLineRouter
//
//  Created by Pilipenko Dima on 11/06/16.
//  Copyright © 2016 dimpiax. All rights reserved.
//

import Foundation

public struct CommandLineRouter {
    private struct Commands {
        let name: String
        
        var count: Int {
            return _value.count
        }
        
        private let _value: [Command]
        
        init(name: String, value: [Command]) {
            self.name = name
            _value = value
        }
        
        subscript(index: Int) -> Command {
            return _value[index]
        }
    }
    
    private var _commands: [Commands] = []
    
    public mutating func setCommands(name: String, commands: Command...) {
        _commands.append(Commands(name: name, value: commands))
    }
    
    public func route(_ args: [String], callback: (String, Command, String) -> Void) throws {
        // TODO: make arguments enum
        //var arguments = args.suffix(from: 1).map {
        //}
        
        // format path
        var path = [String]()
        for (index, value) in args.enumerated() where index % 2 == 1 {
            if index == 0 { continue }
            path.append(value)
        }
        
        let commands: Commands
        do {
            commands = try getCommandsQuery(path: path)
        } catch {
            throw error
        }
        
        // skip first, because 0 element is executor
        var isCommand: Bool
        for (index, value) in args.enumerated() {
            if index == 0 { continue }
            
            isCommand = index % 2 == 1
            
            let commandIndex = (index-1) / 2
            if !isCommand {
                callback(commands.name, commands[commandIndex], value)
            }
        }
    }
    
    private func getCommandsQuery(path: [String]) throws -> Commands {
        var commands = _commands
        for (index, value) in path.enumerated() {
            commands = filterCommands(step: value, level: index, commandsSet: commands)
        }
        
        guard let result = commands.first else {
            throw NSError(domain: "Not found any matches commands query", code: 0, userInfo: nil)
        }
        
        guard commands.count == 1 else {
            throw NSError(domain: "Found concurrent commands query. Solution: review created commands sets", code: 0, userInfo: nil)
        }
        
        return result
    }
    
    private func filterCommands(step: String, level: Int, commandsSet: [Commands]) -> [Commands] {
        var result = [Commands]()
        for commands in commandsSet {
            guard level < commands.count else { continue }
            
            let command = commands[level]
            guard command.name == step || command.shortName == step else { continue }
            
            result.append(commands)
        }
        return result
    }
}
