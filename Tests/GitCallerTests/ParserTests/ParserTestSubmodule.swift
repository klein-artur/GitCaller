//
//  ParserTestSubmodule.swift
//
//
//  Created by Artur Hellmann on 07.10.23.
//


@testable import GitCaller

import XCTest

final class ParserTestSubmodule: XCTestCase {
    
    var sut: SubmoduleParser!

    override func setUpWithError() throws {
        sut = SubmoduleParser()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testNoSubmodulesPresent() throws {
        // given
        let input = ""
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { parsed in
            XCTAssertTrue(parsed.submodules.isEmpty)
        }
    }
    
    func testSuccessMultipleSubmodules() throws {
        // given
        let input = """
        +e48e13207341a06c674b77dbb618f6f9c4897055 path/to/submodule1 (heads/master)
        -abcdefabcdefabcdefabcdefabcdefabcdefabcdef path/to/submodule2 (tags/v1.0.0)
        U1234567890123456789012345678901234567890 path/to/submodule3 (heads/feature-branch)
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { submodules in
            XCTAssertEqual(submodules.submodules.count, 3)
            
            let submodule1 = submodules.submodules[0]
            XCTAssertEqual(submodule1.path, "path/to/submodule1")
            XCTAssertEqual(submodule1.commitHash, "e48e13207341a06c674b77dbb618f6f9c4897055")
            XCTAssertEqual(submodule1.state, .modified)
            
            let submodule2 = submodules.submodules[1]
            XCTAssertEqual(submodule2.path, "path/to/submodule2")
            XCTAssertEqual(submodule2.commitHash, "abcdefabcdefabcdefabcdefabcdefabcdefabcdef")
            XCTAssertEqual(submodule2.state, .missing)
            
            let submodule3 = submodules.submodules[2]
            XCTAssertEqual(submodule3.path, "path/to/submodule3")
            XCTAssertEqual(submodule3.commitHash, "1234567890123456789012345678901234567890")
            XCTAssertEqual(submodule3.state, .conflicted)
        }
    }

    func testFatalInvalidLineFormat() throws {
        // given
        let input = """
        invalid line format
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkError(messageIfNotError: "should return a parse error invalid line format.", type: .invalidLineFormat)
    } 

}
