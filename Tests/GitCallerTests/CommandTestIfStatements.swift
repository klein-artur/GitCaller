//
//  CommandTestIfStatements.swift
//  
//
//  Created by Artur Hellmann on 20.01.23.
//

@testable import GitCaller

import XCTest

final class CommandTestIfStatements: XCTestCase {

    func testIfParameterShouldSet() throws {
        let command = Git().commit
        
        let newCommand = command.conditional(true) { commit in
            commit.all()
        }
        
        XCTAssertEqual(newCommand.parameter.count, 1)
    }
    
    func testIfParameterShouldNotSet() throws {
        let command = Git().commit
        
        let newCommand = command.conditional(false) { commit in
            commit.all()
        }
        
        XCTAssertEqual(newCommand.parameter.count, 0)
    }
    
    func testIfLetParameterShouldSet() throws {
        let command = Git().commit
        
        let someOptional: Git? = Git()
        
        let newCommand = command.ifLet(someOptional) { commit, theOptional in
            commit.all()
        }
        
        XCTAssertEqual(newCommand.parameter.count, 1)
    }
    
    func testIfLetParameterShouldNotSet() throws {
        let command = Git().commit
        
        let someOptional: Git? = nil
        
        let newCommand = command.ifLet(someOptional) { commit, theOptional in
            commit.all()
        }
        
        XCTAssertEqual(newCommand.parameter.count, 0)
    }

}
