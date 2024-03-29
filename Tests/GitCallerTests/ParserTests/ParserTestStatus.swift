//
//  ParserTestStatus.swift
//  
//
//  Created by Artur Hellmann on 30.12.22.
//

@testable import GitCaller

import XCTest

final class ParserTestStatus: XCTestCase {
    
    var sut: StatusParser!

    override func setUpWithError() throws {
        sut = StatusParser()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }

    func testNoChangesUpToDateNothingToCommit() throws {
        // given
        let input = """
        On branch main
        Your branch is up to date with 'origin/main'.

        nothing to commit, working tree clean
        """
        
        // when
        let result = sut.parse(result: input)
        let status = try result.get()
        
        // then
        XCTAssertEqual(status.branch.name, "main")
        XCTAssertTrue(status.branch.isLocal)
        XCTAssertTrue(status.branch.upToDate)
        XCTAssertNotNil(status.branch.upstream)
        XCTAssertEqual(status.branch.upstream?.name, "origin/main")
        XCTAssertFalse(status.branch.upstream?.isLocal ?? true)
        XCTAssertEqual(status.status, .clean)
    }
    
    func testNotOnAGitRepository() throws {
        // given
        let input = "fatal: not a git repository (or any of the parent directories): .git"
        
        // then
        XCTAssertThrowsError(try sut.parse(result: input).get(), "Does not properly throw.") {
            XCTAssertEqual(($0 as? ParseError)?.type, .notARepository)
        }
    }
    
    func testNothingToComitOneBehind() throws {
        // given
        let input = """
        On branch main
        Your branch is behind 'origin/main' by 1 commit, and can be fast-forwarded.
          (use "git pull" to update your local branch)

        nothing to commit, working tree clean
        """
        
        // when
        let result = sut.parse(result: input)
        let status = try result.get()
        
        // then
        XCTAssertEqual(status.branch.name, "main")
        XCTAssertTrue(status.branch.isLocal)
        XCTAssertFalse(status.branch.upToDate)
        XCTAssertEqual(status.branch.behind, 1)
        XCTAssertNotNil(status.branch.upstream)
        XCTAssertEqual(status.branch.upstream?.name, "origin/main")
        XCTAssertFalse(status.branch.upstream?.isLocal ?? true)
        XCTAssertEqual(status.status, .clean)
    }
    
    func testNothingToComitDiverged() throws {
        // given
        let input = """
        On branch main
        Your branch and 'origin/main' have diverged,
        and have 2 and 1 different commits each, respectively.
          (use "git pull" to merge the remote branch into yours)

        nothing to commit, working tree clean
        """
        
        // when
        let result = sut.parse(result: input)
        let status = try result.get()
        
        // then
        XCTAssertEqual(status.branch.name, "main")
        XCTAssertTrue(status.branch.isLocal)
        XCTAssertFalse(status.branch.upToDate)
        XCTAssertEqual(status.branch.behind, 1)
        XCTAssertEqual(status.branch.ahead, 2)
        XCTAssertNotNil(status.branch.upstream)
        XCTAssertEqual(status.branch.upstream?.name, "origin/main")
        XCTAssertFalse(status.branch.upstream?.isLocal ?? true)
        XCTAssertEqual(status.status, .clean)
    }
    
    func testNothingToComitJustAhead() throws {
        // given
        let input = """
        On branch main
        Your branch is ahead of 'origin/main' by 1 commit.
          (use "git push" to publish your local commits)

        nothing to commit, working tree clean
        """
        
        // when
        let result = sut.parse(result: input)
        let status = try result.get()
        
        // then
        XCTAssertEqual(status.branch.name, "main")
        XCTAssertTrue(status.branch.isLocal)
        XCTAssertFalse(status.branch.upToDate)
        XCTAssertEqual(status.branch.behind, 0)
        XCTAssertEqual(status.branch.ahead, 1)
        XCTAssertNotNil(status.branch.upstream)
        XCTAssertEqual(status.branch.upstream?.name, "origin/main")
        XCTAssertFalse(status.branch.upstream?.isLocal ?? true)
        XCTAssertEqual(status.status, .clean)
    }
    
    func testChanges() throws {
        // given
        let input = """
        On branch main
        Your branch is ahead of 'origin/main' by 1 commit.
          (use "git push" to publish your local commits)

        Changes to be committed:
          (use "git restore --staged <file>..." to unstage)
            modified:   shared/ContentView.swift
            deleted:    shared/DeviceDetail/EditDevicePrioView.swift
            new file:   shared/DeviceDetail/Test2.swift
            renamed:    test/testfile -> test/testfileNew

        Changes not staged for commit:
          (use "git add/rm <file>..." to update what will be committed)
          (use "git restore <file>..." to discard changes in working directory)
            modified:   Home.xcodeproj/project.pbxproj
            modified:   shared/DataRepository.swift
            deleted:    shared/DeviceDetail/DeviceDetailView.swift

        Untracked files:
          (use "git add <file>..." to include in what will be committed)
            shared/DeviceDetail/Test.swift
            shared/DeviceDetail/Test2.swift
        """
        
        // when
        let result = sut.parse(result: input)
        let status = try result.get()
        
        // then
        XCTAssertEqual(status.stagedChanges.count, 4)
        XCTAssertEqual(status.unstagedChanges.count, 3)
        XCTAssertEqual(status.untrackedChanges.count, 2)
        XCTAssertEqual(status.stagedChanges[0].state, .staged)
        XCTAssertEqual(status.stagedChanges[0].kind, .modified)
        XCTAssertEqual(status.stagedChanges[1].kind, .deleted)
        XCTAssertEqual(status.stagedChanges[2].kind, .newFile)
        XCTAssertEqual(status.unstagedChanges[0].state, .unstaged)
        XCTAssertEqual(status.unstagedChanges[2].kind, .deleted)
        XCTAssertEqual(status.untrackedChanges[1].path, "shared/DeviceDetail/Test2.swift")
        XCTAssertEqual(status.stagedChanges[3].path, "test/testfileNew")
        XCTAssertEqual(status.status, .unclean)
    }
    
    func testUnmergedState() throws {
        //given
        let input = """
        On branch main
        Your branch is ahead of 'origin/main' by 1 commit.
          (use "git push" to publish your local commits)

        You have unmerged paths.
          (fix conflicts and run "git commit")
          (use "git merge --abort" to abort the merge)

        Changes to be committed:
            new file:   Home.xcodeproj/xcuserdata/a.hellmann.xcuserdatad/xcschemes/xcschememanagement.plist
            new file:   shared/Constants.swift

        Unmerged paths:
          (use "git add <file>..." to mark resolution)
            both added:      .gitignore
            both modified:   Home.xcodeproj/project.pbxproj
            both added:      shared/ContentView.swift
            deleted by us:   some file
            deleted by them: some file
        """
        
        // when
        let result = sut.parse(result: input)
        let status = try result.get()
        
        // then
        XCTAssertEqual(status.unmergedChanges.count, 5)
        XCTAssertEqual(status.unmergedChanges[0].state, .unmerged)
        XCTAssertEqual(status.unmergedChanges[0].kind, .bothAdded)
        XCTAssertEqual(status.unmergedChanges[1].kind, .bothModified)
        XCTAssertEqual(status.status, .merging)
    }
    
    func testDetached() throws {
        // given
        let input = """
        HEAD detached at 52324728
        nothing to commit, working tree clean
        """
        
        // when
        let result = sut.parse(result: input)
        let status = try result.get()
        
        // then
        XCTAssertEqual(status.branch.name, "HEAD")
        XCTAssertTrue(status.branch.isLocal)
        XCTAssertTrue(status.branch.upToDate)
        XCTAssertNil(status.branch.upstream)
        XCTAssertTrue(status.branch.detached)
        XCTAssertEqual(status.status, .clean)
    }
    
    
    func testJustTwoChanges() throws {
        //given
        let input = """
        On branch feature/some-branch
        Your branch is up to date with 'origin/some-branch'.

        Changes not staged for commit:
          (use "git add <file>..." to update what will be committed)
          (use "git restore <file>..." to discard changes in working directory)
            modified:   Directory/SomeFile.plist
            modified:   DirectoryTest/Some/File/ThatChanged.swift

        no changes added to commit (use "git add" and/or "git commit -a")
        """
        
        // when
        let result = sut.parse(result: input)
        let status = try result.get()
        
        // then
        XCTAssertEqual(status.unstagedChanges.count, 2)
        XCTAssertEqual(status.status, .unclean)
    }
    
    func testJustRealChangesetShouldWork() throws {
        //given
        let input = """
        On branch main
        Your branch is up to date with 'origin/main'.

        Changes not staged for commit:
          (use "git add <file>..." to update what will be committed)
          (use "git restore <file>..." to discard changes in working directory)
            modified:   Sources/GitCaller/Call+Base.swift
            modified:   Sources/GitCaller/Parser.swift
            modified:   Sources/GitCaller/Parser/StatusParser.swift

        Untracked files:
          (use "git add <file>..." to include in what will be committed)
            Sources/GitCaller/Commands/CommandRestore.swift
            Sources/GitCaller/Commands/Parameter/Staged.swift
            Sources/GitCaller/Parser/AddParser.swift
            Sources/GitCaller/Parser/CommitParser.swift
            Sources/GitCaller/Parser/RestoreParser.swift
            Tests/GitCallerTests/ParserTests/ParserTestAdd.swift
            Tests/GitCallerTests/ParserTests/ParserTestCommit.swift
            Tests/GitCallerTests/ParserTests/ParserTestRestore.swift

        no changes added to commit (use "git add" and/or "git commit -a")
        """
        
        // when
        let result = sut.parse(result: input)
        let status = try result.get()
        
        // then
        XCTAssertEqual(status.unstagedChanges.count, 3)
        XCTAssertEqual(status.untrackedChanges.count, 8)
        XCTAssertEqual(status.status, .unclean)
    }
    
    func testOneNewFileAndOneUnmerged() throws {
        // given
        let input = """
        On branch main
        Your branch is ahead of 'origin/main' by 3 commits.
          (use "git push" to publish your local commits)

        All conflicts fixed but you are still merging.
          (use "git commit" to conclude merge)

        Changes to be committed:
            new file:   testfile.orig

        Changes not staged for commit:
          (use "git add <file>..." to update what will be committed)
          (use "git restore <file>..." to discard changes in working directory)
            modified:   testfile


        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { statusResult in
            XCTAssertEqual(statusResult.stagedChanges.count, 1)
            XCTAssertEqual(statusResult.unstagedChanges.count, 1)
        }
    }
    
    func testInMergingProcessAllResolved() throws {
        // given
        let input = """
        On branch main
        Your branch is ahead of 'origin/main' by 3 commits.
          (use "git push" to publish your local commits)

        All conflicts fixed but you are still merging.
          (use "git commit" to conclude merge)

        Changes to be committed:
            modified:   testfile
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { status in
            XCTAssertEqual(status.status, .merging)
        }
    }
    
    func testInMergingProcess() throws {
        // given
        let input = """
        On branch main
        Your branch is ahead of 'origin/main' by 1 commit.
          (use "git push" to publish your local commits)

        You have unmerged paths.
          (fix conflicts and run "git commit")
          (use "git merge --abort" to abort the merge)

        Changes to be committed:
            new file:   Home.xcodeproj/xcuserdata/a.hellmann.xcuserdatad/xcschemes/xcschememanagement.plist
            new file:   shared/Constants.swift

        Unmerged paths:
          (use "git add <file>..." to mark resolution)
            both added:      .gitignore
            both modified:   Home.xcodeproj/project.pbxproj
            both added:      shared/ContentView.swift
            deleted by us:   some file
            deleted by them: some file
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { status in
            XCTAssertEqual(status.status, .merging)
        }
    }
    
    func testInRebasingProcess() throws {
        // given
        let input = """
        interactive rebase in progress; onto cce8677
        Last command done (1 command done):
           pick 785d8c2 test
        No commands remaining.
        You are currently rebasing branch 'this-is-a-test' on 'cce8677'.
          (fix conflicts and then run "git rebase --continue")
          (use "git rebase --skip" to skip this patch)
          (use "git rebase --abort" to check out the original branch)

        Unmerged paths:
          (use "git restore --staged <file>..." to unstage)
          (use "git add <file>..." to mark resolution)
            both modified:   testfile

        no changes added to commit (use "git add" and/or "git commit -a")
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { status in
            XCTAssertEqual(status.status, .rebasing)
            XCTAssertEqual(status.rebasingStepsDone, 1)
            XCTAssertEqual(status.rebasingStepsRemaining, 0)
            XCTAssertEqual(status.numberObRebaseSteps, 1)
        }
    }
    
    func testInRebasingSecondStepProcess() throws {
        // given
        let input = """
        interactive rebase in progress; onto 3916fe5
        Last command done (1 command done):
           pick cce8677 Some test
        Next command to do (1 remaining command):
           pick 89b2d5c Test
          (use "git rebase --edit-todo" to view and edit)
        You are currently rebasing branch 'this-is-a-test' on '3916fe5'.
          (all conflicts fixed: run "git rebase --continue")

        nothing to commit, working tree clean
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { status in
            XCTAssertEqual(status.status, .rebasing)
            XCTAssertEqual(status.rebasingStepsDone, 1)
            XCTAssertEqual(status.rebasingStepsRemaining, 1)
            XCTAssertEqual(status.numberObRebaseSteps, 2)
        }
    }
    
    func testInRebasingCommitedButConContinuedStepProcess() throws {
        // given
        let input = """
        interactive rebase in progress; onto d103908
        Last command done (1 command done):
           pick cce8677 Some test
        Next commands to do (8 remaining commands):
           pick 3916fe5 This is a test
           pick f876218 teste
          (use "git rebase --edit-todo" to view and edit)
        You are currently editing a commit while rebasing branch 'this-is-a-test' on 'd103908'.
          (use "git commit --amend" to amend the current commit)
          (use "git rebase --continue" once you are satisfied with your changes)
        
        nothing to commit, working tree clean
        """
        
        // when
        let result = sut.parse(result: input)
        
        // then
        result.checkSuccess { status in
            XCTAssertEqual(status.status, .rebasing)
            XCTAssertEqual(status.rebasingStepsDone, 1)
            XCTAssertEqual(status.rebasingStepsRemaining, 8)
            XCTAssertEqual(status.numberObRebaseSteps, 9)
        }
    }

}
