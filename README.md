# GitCaller

This is a swift package currently in development. It is meant as a git bridge for swift, using git through shell, returning the result. Do not consider this as done. 

It is used by the project [GitBuddy](https://github.com/klein-artur/GitBuddy). 

## How it works.

The idea is to have a nice api to run git commands For example:

 - `git init` will be `Git().init`
 - `git clone url` will be `Git().clone(url: "git@github.com:klein-artur/GitParser.git")`
 - `git add -a` will be `Git().add.all()`
 - `git add filename` will be `Git().add.path("filename")`


To get the command as string, call `Git().init.resolve()`.

To run the command you have two possibilities:

 - `Git().init.run()` will return a `Combine` `Publisher` emitting the output. If multiple outputs happen the current output will be emitted.
 - `Git().init.runAsync()` will return a `async` function you can `await` to get the final output.


## Parsed Results

As this is under development at the moment just a few commands and parameters are supported. Feel free to add more by a PullRequest.
