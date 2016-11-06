//
//  CommandLineRouterTests.swift
//  CommandLineRouter
//
//  Created by Pilipenko Dima on 11/06/16.
//  Copyright © 2016 dimpiax. All rights reserved.
//

import XCTest
@testable import CommandLineRouter


class CommandLineRouterTests: XCTestCase {
    func testFindCommands() {
        var cml = CommandLineRouter()
        cml.setCommands(name: "Example I/O", commands:
            Command(shortName: "-i", name: "--input"),
            Command(shortName: "-o", name: "--output")
        )
        
        cml.setCommands(name: "Example Input", commands:
            Command(shortName: "-i", name: "--input")
        )
        
        do {
            try cml.route(["", "-i", "input_filename", "--output", "output_filename"]) { name, _, _ in
                XCTAssertEqual(name, "Example I/O")
            }
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testRouteProcessing() {
        var cml = CommandLineRouter()
        cml.setCommands(name: "Example Help", commands:
            Command(shortName: "-h", name: "--help")
        )
        
        do {
            try cml.route(["", "-h", "command"]) { _, command, argument in
                XCTAssertEqual(command.name, "--help")
                XCTAssertEqual(argument, "command")
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testConcurrentCommands() {
        var cml = CommandLineRouter()
        cml.setCommands(name: "Example I/O", commands:
            Command(shortName: "-i", name: "--input"),
            Command(shortName: "-o", name: "--output"),
            Command(shortName: "-d", name: "--destination")
        )
        
        cml.setCommands(name: "Example I/O", commands:
            Command(shortName: "-i", name: "--input"),
            Command(shortName: "-o", name: "--output"),
            Command(shortName: "-d", name: "--destination")
        )
        
        do {
            try cml.route(["", "-i", "input_filename", "--output", "output_filename", "-d", "destination_folder"]) { _, _, _ in }
        } catch {
            XCTAssert(true)
        }
    }
    
    static var allTests : [(String, (CommandLineRouterTests) -> () throws -> Void)] {
        return [
            ("findCommands", testFindCommands),
            ("routeProcessing", testRouteProcessing),
            ("concurrentCommands", testConcurrentCommands)
        ]
    }
}
