# GitCaller

This is a swift package currently in development. It is meant as a git bridge for swift, using git through shell, returning the result. Do not consider this as done. 

I try to release stable versions via the main branch, but it can be way behind the current state of development. So feel free to use the develop branch which will always have the newest state (but also issues and unclean states).

It is used by the project [Jagu](https://github.com/klein-artur/Jagu). 

## Integration as a Swift Package.

Integrate it using the url of this package shown in the browser.

## How it works.

The idea is to have a nice api to run git commands For example:

 - `git init` will be `Git().init`
 - `git clone url` will be `Git().clone(url: "git@github.com:klein-artur/GitParser.git")`
 - `git add -a` will be `Git().add.all()`
 - `git add filename` will be `Git().add.path("filename")`


To get the command as string, call `Git().init.getString()`.

To run the command you have two possibilities:

 - `Git().init.run()` will return a `Combine` `Publisher` emitting the output. If multiple outputs happen the current output will be emitted.
 - `Git().init.runAsync()` will return a `async` function you can `await` to get the final output.


## Parsed Results

This lib will also give you complete objects holding data.

There is a protocol `Repository`. The default implementation is `GitRepo`

This repo implementation already has a few methods to get parsed objects. For example:

`GitRepo.standard.clone(url: String)` will clone a repo from the given URL.
`GitRepo.standard.log(branchName: String)` will give you a `LogResult` holding commits, plus information how to draw a git path. 

And more.

## Woha!!! Slow Slow!

As this is under development at the moment just a few commands and parameters are supported. Feel free to add more by a PullRequest.
