import Cocoa
import Combine

private func runTask(arguments: [String], inputPipe: Pipe?, onReceive: ((String) -> Void)?, onCompletion: (() -> Void)?) -> String {
    let task = Process()
    
    let env = [
        "GIT_EDITOR": Bundle.module.url(forResource: "FakeEditor", withExtension: "")?.path() ?? ""
    ]
    
    task.arguments = arguments
    task.launchPath = "/usr/bin/git"
    task.environment = env

    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe

    task.standardInput = inputPipe ?? Pipe()
    
    let outHandle = pipe.fileHandleForReading

    pipe.fileHandleForReading.readabilityHandler = { handle in
        let data = handle.availableData
        if data.isEmpty {
            handle.readabilityHandler = nil
            onCompletion?()
        } else {
            if let str = String(data: data, encoding: .utf8) {
                print(str)
                onReceive?(str)
            }
        }
    }

    task.launch()
    
    if onReceive == nil || onCompletion == nil {
        let result = String(data: outHandle.readDataToEndOfFile(), encoding: .utf8) ?? ""
        print(result)
        return result
    } else {
        return ""
    }
    
}

public struct GitCall: Publisher {
    public typealias Output = String
    public typealias Failure = Never
    
    let arguments: [String]
    let inputPipe: Pipe?
    
    init(arguments: [String], inputPipe: Pipe?) {
        self.arguments = arguments
        self.inputPipe = inputPipe
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, String == S.Input {
        let subscription = GitCallSubscription(arguments: arguments, inputPipe: inputPipe, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
    
    
    final class GitCallSubscription<S: Subscriber>: Cancellable, Subscription where S.Input == Output, S.Failure == Failure {
        private let arguments: [String]
        private let inputPipe: Pipe?
        private var subscriber: S?
        
        init(arguments: [String], inputPipe: Pipe?, subscriber: S) {
            self.arguments = arguments
            self.subscriber = subscriber
            self.inputPipe = inputPipe
        }
        
        func request(_ demand: Subscribers.Demand) {
            _ = runTask(arguments: arguments, inputPipe: inputPipe, onReceive: { [weak self] result in
                _ = self?.subscriber?.receive(result)
            }, onCompletion: { [weak self] in
                self?.subscriber?.receive(completion: .finished)
            })
        }
        
        func cancel() {
            subscriber = nil
        }
        
    }
    
}

struct GitCaller {
    
    // MARK: Private
    fileprivate static func run(arguments: [String], inputPipe: Pipe?) -> some Publisher<String, Never> {
        return GitCall(arguments: arguments, inputPipe: inputPipe)
    }
    
    fileprivate static func runAsync(arguments: [String], inputPipe: Pipe?) async -> String {
        return runTask(arguments: arguments, inputPipe: inputPipe, onReceive: nil, onCompletion: nil)
    }
    
    
}

extension CommandSpec {
    
    /// Runs the current command and returns a `Publisher` that emits the states of the process.
    public func run(inputPipe: Pipe? = nil) -> AnyPublisher<String, Never> {
        return GitCaller.run(arguments: self.resolve(), inputPipe: inputPipe)
            .removeDuplicates()
            .scan("", { lastResult, nextResult in
                lastResult + nextResult
            })
            .eraseToAnyPublisher()
    }
    
    /// Provides an async await style run method.
    public func runAsync(inputPipe: Pipe? = nil) async throws -> String {
        return await GitCaller.runAsync(arguments: self.resolve(), inputPipe: inputPipe)
    }
}

public extension Pipe {
    func putIn(content: String) throws {
        guard let data = "\(content)\n".data(using: .utf8) else {
            return
        }
        try self.fileHandleForWriting.write(contentsOf: data)
    }
}
