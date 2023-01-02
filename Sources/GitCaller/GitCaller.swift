import Cocoa
import Combine

private func runTask(command: String, onReceive: ((String) -> Void)?, onCompletion: (() -> Void)?) -> String {
    let task = Process()
    
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"

    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    let outHandle = pipe.fileHandleForReading

    if let onReceive = onReceive, let onCompletion = onCompletion {
        outHandle.waitForDataInBackgroundAndNotify()

        var updateObserver: NSObjectProtocol!
        updateObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outHandle, queue: nil, using: { notification in
            let data = outHandle.availableData
            if !data.isEmpty {
                if let str = String(data: data, encoding: .utf8) {
                    onReceive(str)
                }
                outHandle.waitForDataInBackgroundAndNotify()
            } else {
                NotificationCenter.default.removeObserver(updateObserver!)
                onCompletion()
            }
        })
        
        var taskObserver : NSObjectProtocol!
        taskObserver = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification, object: task, queue: nil, using: { notification in
            NotificationCenter.default.removeObserver(taskObserver!)
        })
    }

    task.launch()
    
    if onReceive == nil || onCompletion == nil {
        return String(data: outHandle.readDataToEndOfFile(), encoding: .utf8) ?? ""
    } else {
        return ""
    }
    
}

public struct GitCall: Publisher {
    public typealias Output = String
    public typealias Failure = Never
    
    let command: String
    
    init(command: String) {
        self.command = command
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, String == S.Input {
        let subscription = GitCallSubscription(command: command, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
    
    
    final class GitCallSubscription<S: Subscriber>: Cancellable, Subscription where S.Input == Output, S.Failure == Failure {
        private let command: String
        private var subscriber: S?
        
        init(command: String, subscriber: S) {
            self.command = command
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) {
            _ = runTask(command: command, onReceive: { [weak self] result in
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
    fileprivate static func run(command: String) -> some Publisher<String, Never> {
        return GitCall(command: command)
    }
    
    fileprivate static func runAsync(command: String) async -> String {
        return runTask(command: command, onReceive: nil, onCompletion: nil)
    }
    
}

extension CommandSpec {
    
    /// Runs the current command and returns a `Publisher` that emits the states of the process.
    public func run() -> AnyPublisher<String, Never> {
        return GitCaller.run(command: self.resolve())
            .removeDuplicates()
            .scan("", { lastResult, nextResult in
                lastResult + nextResult
            })
            .eraseToAnyPublisher()
    }
    
    /// Provides an async await style run method.
    public func runAsync() async throws -> String {
        return await GitCaller.runAsync(command: self.resolve())
    }
}
