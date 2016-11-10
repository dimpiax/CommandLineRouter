//
//  CommandLineRouter.swift
//  CommandLineRouter
//
//  Created by Pilipenko Dima on 11/06/16.
//  Copyright © 2016 dimpiax. All rights reserved.
//

import Foundation

public struct CommandLineRouter {
    private var _commands: [CommandsFlow] = []
    
    public init() {
        // empty initializer
    }
    
    public mutating func setCommands(name: String, commands: Command...) {
        _commands.append(CommandsFlow(name: name, value: commands))
    }
    
    public func route(_ args: [String], callback: (CommandsFlow) -> Void) throws {
        // TODO: make arguments enum
        var arguments = Array(args.suffix(from: 1))
        
        // format path
        var path = [String]()
        for (index, value) in arguments.enumerated() where index % 2 == 0 {
            path.append(value)
        }
        
        let commandsFlow: CommandsFlow
        do {
            commandsFlow = try getCommandsFlow(path: path)
            
            // create commands flow with arguments
            var commands = [Command]()
            for index in 0..<commandsFlow.count {
                let command = commandsFlow[index]
                let argument = arguments[index*2+1]
                commands.append(Command(shortName: command.shortName, name: command.name, argument: argument))
            }
            
            // pass in route callback
            callback(CommandsFlow(name: commandsFlow.name, value: commands))
        } catch {
            throw error
        }
    }
    
    private func getCommandsFlow(path: [String]) throws -> CommandsFlow {
        var commands = _commands
        for (index, value) in path.enumerated() {
            commands = filterCommands(step: value, level: index, commandsSet: commands)
        }
        
        let pathLength = path.count
        commands = commands.filter { $0.count == pathLength }
        
        guard let result = commands.first else {
            throw NSError(domain: "Not found any matches commands chain", code: 0, userInfo: nil)
        }
        
        guard commands.count == 1 else {
            throw NSError(domain: "Found concurrent commands chain. Solution: review created commands sets", code: 0, userInfo: nil)
        }
        
        return result
    }
    
    private func filterCommands(step: String, level: Int, commandsSet: [CommandsFlow]) -> [CommandsFlow] {
        var result = [CommandsFlow]()
        for commands in commandsSet {
            guard level < commands.count else { continue }
            
            let command = commands[level]
            guard command.name == step || command.shortName == step else { continue }
            
            result.append(commands)
        }
        return result
    }
}
