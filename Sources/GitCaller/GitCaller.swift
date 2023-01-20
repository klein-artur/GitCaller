import Cocoa
import Combine

private func runTask(command: String, predefinedInput: String?, onReceive: ((String) -> Void)?, onCompletion: (() -> Void)?) -> String {
    let task = Process()
    
    var theCommand = command
    if let predefinedInput = predefinedInput {
        theCommand = "printf '\(predefinedInput)' | \(command)"
    }
    
    task.arguments = ["-c", theCommand]
    task.launchPath = "/bin/zsh"

    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    let outHandle = pipe.fileHandleForReading

    if let onReceive = onReceive, let onCompletion = onCompletion {
        pipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            if data.isEmpty {
                handle.readabilityHandler = nil
                onCompletion()
            } else {
                if let str = String(data: data, encoding: .utf8) {
                    onReceive(str)
                }
            }
        }
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
    let predifinedInput: String?
    
    init(command: String, predifinedInput: String?) {
        self.command = command
        self.predifinedInput = predifinedInput
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, String == S.Input {
        let subscription = GitCallSubscription(command: command, predefinedInput: predifinedInput, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
    
    
    final class GitCallSubscription<S: Subscriber>: Cancellable, Subscription where S.Input == Output, S.Failure == Failure {
        private let command: String
        private let predefinedInput: String?
        private var subscriber: S?
        
        init(command: String, predefinedInput: String?, subscriber: S) {
            self.command = command
            self.subscriber = subscriber
            self.predefinedInput = predefinedInput
        }
        
        func request(_ demand: Subscribers.Demand) {
            _ = runTask(command: command, predefinedInput: predefinedInput, onReceive: { [weak self] result in
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
    fileprivate static func run(command: String, predefinedInput: String?) -> some Publisher<String, Never> {
        return GitCall(command: command, predifinedInput: predefinedInput)
    }
    
    fileprivate static func runAsync(command: String, predefinedInput: String?) async -> String {
        return runTask(command: command, predefinedInput: predefinedInput, onReceive: nil, onCompletion: nil)
    }
    
    
}

extension CommandSpec {
    
    /// Runs the current command and returns a `Publisher` that emits the states of the process.
    public func run(predefinedInput: String? = nil) -> AnyPublisher<String, Never> {
        return GitCaller.run(command: self.resolve(), predefinedInput: predefinedInput)
            .removeDuplicates()
            .scan("", { lastResult, nextResult in
                lastResult + nextResult
            })
            .eraseToAnyPublisher()
    }
    
    /// Provides an async await style run method.
    public func runAsync(predefinedInput: String? = nil) async throws -> String {
        return await GitCaller.runAsync(command: self.resolve(), predefinedInput: predefinedInput)
    }
}
