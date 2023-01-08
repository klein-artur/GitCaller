//
//  Branch.swift
//  
//
//  Created by Artur Hellmann on 30.12.22.
//

import Foundation

public class Branch {
    public let name: String
    public let isLocal: Bool
    public let behind: Int
    public let ahead: Int
    public let upstream: Branch?
    public let detached: Bool
    
    public var upToDate: Bool {
        return behind == 0 && ahead == 0
    }
    
    init(
        name: String,
        isLocal: Bool = true,
        behind: Int = 0,
        ahead: Int = 0,
        upstream: Branch? = nil,
        detached: Bool = false
    ) {
        self.name = name
        self.isLocal = isLocal
        self.behind = behind
        self.ahead = ahead
        self.upstream = upstream
        self.detached = detached
    }
}

enum BranchTreeItemType {
    case branch(Branch)
    case directory(String)
}

public class BranchTreeItem {
    let type: BranchTreeItemType
    var children: [BranchTreeItem]
    
    weak var parent: BranchTreeItem?
    
    init(
        type: BranchTreeItemType,
        children: [BranchTreeItem],
        parent: BranchTreeItem? = nil
    ) {
        self.type = type
        self.children = children
        self.parent = parent
    }
}

public extension BranchTreeItem {
    var depth: Int {
        (parent?.depth ?? -1) + 1
    }
}

extension Array where Element == Branch {
    func parseIntoTree() -> BranchTreeItem {
        let root = BranchTreeItem(type: .directory("root"), children: [])
        var currentParent = root
        for branch in self {
            let pathComponents = branch.name.split(separator: "/")
            for component in pathComponents {
                let componentName = String(component)
                if let matchingChild = currentParent.children.first(where: {
                    if case let .directory(name) = $0.type, name == componentName {
                        return true
                    }
                    return false
                }) {
                    currentParent = matchingChild
                } else if branch.name.hasSuffix(componentName) {
                    let newBranch = BranchTreeItem(type: .branch(branch), children: [], parent: currentParent)
                    currentParent.children.append(newBranch)
                } else {
                    let newDirectory = BranchTreeItem(type: .directory(componentName), children: [], parent: currentParent)
                    currentParent.children.append(newDirectory)
                    currentParent = newDirectory
                }
            }
            
            currentParent = root
        }
        return root
    }
}


