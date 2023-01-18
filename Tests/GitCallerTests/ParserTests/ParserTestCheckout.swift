//
//  ParseTestCheckout.swift
//  
//
//  Created by Artur Hellmann on 09.01.23.
//

@testable import GitCaller

import XCTest

final class ParserTestCheckout: XCTestCase {
    
    var sut: CheckoutResultParser!

    override func setUpWithError() throws {
        sut = CheckoutResultParser()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFatalBranchExistsExample() throws {
        // given
        let input = """
        fatal: a branch named 'other' already exists
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkError(messageIfNotError: "should return a parse error not branch already exists.", type: .branchExsists)
    }
    
    func testBranchNotExists() throws {
        // given
        let input = """
        error: pathspec 'Branch' did not match any file(s) known to git
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkError(messageIfNotError: "should return a parse error not branch already exists.", type: .branchNotExsists)
    }
    
    func testSuccess() throws {
        // given
        let input = """
        Switched to branch 'other'
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { checkout in
            XCTAssertTrue(checkout.didChange)
        }
    }
    
    func testSuccessNew() throws {
        // given
        let input = """
        Switched to a new branch 'other'
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { checkout in
            XCTAssertTrue(checkout.didChange)
        }
    }
    
    func testSuccessWithoutChange() throws {
        // given
        let input = """
        Already on 'other'
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { checkout in
            XCTAssertFalse(checkout.didChange)
        }
    }
    
    func testSuccessfullCheckoutRemoteWithTrack() throws {
        // given
        let input = """
        branch 'other' set up to track 'origin/other'.
        Switched to a new branch 'other'
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { checkout in
            XCTAssertTrue(checkout.didChange)
        }
    }

}

extension Result where Failure == ParseError {
    func checkError(messageIfNotError: String, type: ParseErrorType) {
        switch self {
        case .success(_):
            XCTFail(messageIfNotError)
        case let .failure(error):
            if error.type != type {
                XCTFail("Should have thrown \(type.rawValue) but did \(error.type)")
            }
        }
    }
    
    func checkSuccess(checker: ((Success) -> Void)) {
        switch self {
        case let .success(value):
            checker(value)
        case let .failure(error):
            XCTFail("Should have succeeded, but failed with \(error).")
        }
    }
}
