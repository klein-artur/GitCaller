//
//  ParserTestLog.swift
//  
//
//  Created by Artur Hellmann on 03.01.23.
//

@testable import GitCaller

import XCTest

final class ParserTestLog: XCTestCase {
    
    var sut: LogResultParser!

    override func setUpWithError() throws {
        sut = LogResultParser()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testParsingGitLog() throws {
        // given
        let input = """
        <<<----%mCommitm%---->>>67faa10<<<----%mDatam%---->>> (HEAD -> main, origin/main, tag: test)<<<----%mDatam%---->>>67faa10a224db86ef4e796ab0a14b056ad4001a6<<<----%mDatam%---->>>da4830b5ef3697795ec38d59044291a6b2135214<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Fri, 6 Jan 2023 13:07:35 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Fri, 6 Jan 2023 13:07:35 +0100<<<----%mDatam%---->>>More hash handling improvements<<<----%mDatam%---->>>More hash handling improvements<<<----%mDatam%---->>>
        
        <<<----%mCommitm%---->>>da4830b<<<----%mDatam%---->>><<<----%mDatam%---->>>da4830b5ef3697795ec38d59044291a6b2135214<<<----%mDatam%---->>>8258f9663d1fbde63d97ac9a387f6a3dddf4b801<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Fri, 6 Jan 2023 12:15:27 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Fri, 6 Jan 2023 12:15:27 +0100<<<----%mDatam%---->>>improved Hash Handling<<<----%mDatam%---->>>improved Hash Handling<<<----%mDatam%---->>>
        
        diff --git a/test b/test
        index cf7acc3..017b47c 100644
        --- a/test
        +++ b/test
        @@ -1,4 +1,4 @@
        -asdfasdf
        +fdsaasdf
         asdf
         asdfasdf
         asdfasdfasdf
        <<<----%mCommitm%---->>>8258f96<<<----%mDatam%---->>><<<----%mDatam%---->>>8258f9663d1fbde63d97ac9a387f6a3dddf4b801<<<----%mDatam%---->>>b4dd6c93eec0df86b12055739db31491c59c8517 1050a3c5f6343e1bb6073df2a67566d47c11e6b2<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Thu, 5 Jan 2023 01:37:33 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Thu, 5 Jan 2023 01:37:33 +0100<<<----%mDatam%---->>>Merge branch 'main' of github.com:klein-artur/GitParser<<<----%mDatam%---->>>Merge branch 'main' of github.com:klein-artur/GitParser<<<----%mDatam%---->>>
        <<<----%mCommitm%---->>>b4dd6c9<<<----%mDatam%---->>><<<----%mDatam%---->>>b4dd6c93eec0df86b12055739db31491c59c8517<<<----%mDatam%---->>>258ae77965e33e9885dcc8072db5f53e3bd7f22f<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Thu, 5 Jan 2023 01:37:17 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Thu, 5 Jan 2023 01:37:17 +0100<<<----%mDatam%---->>>Adding parent commits to commit<<<----%mDatam%---->>>Adding parent commits to commit
        And more
        
        lines of
        
        message
        
        stuff<<<----%mDatam%---->>>
        <<<----%mCommitm%---->>>1050a3c<<<----%mDatam%---->>><<<----%mDatam%---->>>1050a3c5f6343e1bb6073df2a67566d47c11e6b2<<<----%mDatam%---->>>258ae77965e33e9885dcc8072db5f53e3bd7f22f<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Wed, 4 Jan 2023 22:15:24 +0100<<<----%mDatam%---->>>GitHub<<<----%mDatam%---->>>noreply@github.com<<<----%mDatam%---->>>Wed, 4 Jan 2023 22:15:24 +0100<<<----%mDatam%---->>>Update README.md<<<----%mDatam%---->>>Update README.md<<<----%mDatam%---->>><<<----%mCommitm%---->>>258ae77<<<----%mDatam%---->>><<<----%mDatam%---->>>258ae77965e33e9885dcc8072db5f53e3bd7f22f<<<----%mDatam%---->>>3c393184a116f4cbfa55aeb68ca39818e76dd870<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Wed, 4 Jan 2023 14:17:40 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Wed, 4 Jan 2023 14:17:40 +0100<<<----%mDatam%---->>>parsing commitlist<<<----%mDatam%---->>>parsing commitlist<<<----%mDatam%---->>>
        <<<----%mCommitm%---->>>3c39318<<<----%mDatam%---->>><<<----%mDatam%---->>>3c393184a116f4cbfa55aeb68ca39818e76dd870<<<----%mDatam%---->>>01edf9e57f55d457ca84072b1a0702ba97b58c98<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Tue, 3 Jan 2023 23:26:46 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Tue, 3 Jan 2023 23:26:46 +0100<<<----%mDatam%---->>>Parsing logs<<<----%mDatam%---->>>Parsing logs<<<----%mDatam%---->>>
        <<<----%mCommitm%---->>>01edf9e<<<----%mDatam%---->>><<<----%mDatam%---->>>01edf9e57f55d457ca84072b1a0702ba97b58c98<<<----%mDatam%---->>><<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Tue, 3 Jan 2023 00:18:13 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Tue, 3 Jan 2023 17:14:57 +0100<<<----%mDatam%---->>>Initial Commit<<<----%mDatam%---->>>Initial Commit<<<----%mDatam%---->>>
        """
        
        // when
        let result = sut.parse(result: input)
        let parsedLog = try! result.get()
        
        // then
        XCTAssertNotNil(parsedLog.commits)
        XCTAssertEqual(parsedLog.commits?.count, 8)
        XCTAssertEqual(parsedLog.commits?[0].objectHash, "67faa10a224db86ef4e796ab0a14b056ad4001a6")
        XCTAssertEqual(parsedLog.commits?[0].branches.count, 2)
        XCTAssertEqual(parsedLog.commits?[0].branches[0], "main")
        XCTAssertEqual(parsedLog.commits?[0].branches[1], "origin/main")
        XCTAssertEqual(parsedLog.commits?[0].tags.count, 1)
        XCTAssertEqual(parsedLog.commits?[0].tags[0], "test")
        XCTAssertEqual(parsedLog.commits?[0].author.name, "John Doe")
        XCTAssertEqual(parsedLog.commits?[0].author.email, "johndoe.thats@testl.com")
        
        XCTAssertEqual(parsedLog.commits?[2].parents.count, 2)
        XCTAssertEqual(parsedLog.commits?[2].parents[0], "b4dd6c93eec0df86b12055739db31491c59c8517")
        XCTAssertEqual(parsedLog.commits?[2].parents[1], "1050a3c5f6343e1bb6073df2a67566d47c11e6b2")
        
        let testDate = "Fri, 6 Jan 2023 13:07:35 +0100".toDate(format: "EEE, dd MMM yyyy HH:mm:ss ZZZZ")!
        
        XCTAssertEqual(parsedLog.commits?[0].authorDate, testDate)
        XCTAssertEqual(parsedLog.commits?[0].message, "More hash handling improvements")
        
        let otherTest = """
        Adding parent commits to commit
        And more
        
        lines of
        
        message
        
        stuff
        """
        
        XCTAssertEqual(parsedLog.commits?[3].message, otherTest)
        XCTAssertEqual(parsedLog.commits?[3].subject, "Adding parent commits to commit")
        
        let diffResult = """
        diff --git a/test b/test
        index cf7acc3..017b47c 100644
        --- a/test
        +++ b/test
        @@ -1,4 +1,4 @@
        -asdfasdf
        +fdsaasdf
         asdf
         asdfasdf
         asdfasdfasdf
        """
        
        XCTAssertEqual(parsedLog.commits?[1].diff, diffResult)
        
        XCTAssertNil(try parsedLog.commits?[0].diffResult)
        XCTAssertNotNil(try parsedLog.commits?[1].diffResult)
    }
    
    func testParsingGitLogSingleResult() throws {
        // given
        let input = """
        <<<----%mCommitm%---->>>da4830b<<<----%mDatam%---->>><<<----%mDatam%---->>>da4830b5ef3697795ec38d59044291a6b2135214<<<----%mDatam%---->>>8258f9663d1fbde63d97ac9a387f6a3dddf4b801<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Fri, 6 Jan 2023 12:15:27 +0100<<<----%mDatam%---->>>John Doe<<<----%mDatam%---->>>johndoe.thats@testl.com<<<----%mDatam%---->>>Fri, 6 Jan 2023 12:15:27 +0100<<<----%mDatam%---->>>improved Hash Handling<<<----%mDatam%---->>>improved Hash Handling<<<----%mDatam%---->>>
        
        diff --git a/test b/test
        index cf7acc3..017b47c 100644
        --- a/test
        +++ b/test
        @@ -1,4 +1,4 @@
        -asdfasdf
        +fdsaasdf
         asdf
         asdfasdf
         asdfasdfasdf
        """
        
        // when
        let result = sut.parse(result: input)
        let parsedLog = try! result.get()
        
        // then
        XCTAssertNotNil(parsedLog.commits)
        XCTAssertEqual(parsedLog.commits?.count, 1)
        
        let diffResult = """
        diff --git a/test b/test
        index cf7acc3..017b47c 100644
        --- a/test
        +++ b/test
        @@ -1,4 +1,4 @@
        -asdfasdf
        +fdsaasdf
         asdf
         asdfasdf
         asdfasdfasdf
        """
        
        XCTAssertEqual(parsedLog.commits?[0].diff, diffResult)
        XCTAssertNotNil(try parsedLog.commits?[0].diffResult)
    }
}
