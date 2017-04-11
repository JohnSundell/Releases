# 🚢 Releases

Using **Releases** you can easily resolve all released versions from a Git repository, in either a Swift script
or command line tool. It supports both remote & local repositories and provides convenience APIs for sorting,
filtering out pre-released versions, etc.

## Usage

Simply call `Releases.versions(for: url)` and you'll get an array of `Version` back:

```swift
let url = URL(string: "git@github.com:johnsundell/unbox")!
let releases = Releases.versions(for: url)

// Print the latest version
print(releases.last)
```

Remove all pre-release versions (like `Alpha`, `Beta`, etc):

```swift
let url = URL(string: "git@github.com:johnsundell/unbox")!
let releases = Releases.versions(for: url).withoutPreReleases()

// Print the latest stable version
print(releases.last)
```

## Installation

### For scripts

- Install [Marathon](https://github.com/johnsundell/marathon).
- Add Releases to Marathon using `$ marathon add git@github.com:JohnSundell/Releases.git`.
- Alternatively, add `git@github.com:JohnSundell/Releases.git` to your `Marathonfile`.
- Write your script, then run it using `$ marathon run yourScript.swift`.

### For command line tools

- Add `.Package(url: "https://github.com/JohnSundell/Releases.git", majorVersion: 1)` to your `Package.swift` file.
- Update your packages using `$ swift package update`.

## Help, feedback or suggestions?

- [Open an issue](https://github.com/JohnSundell/Releases/issues/new) if you need help, if you found a bug, or if you want to discuss a feature request.
- [Open a PR](https://github.com/JohnSundell/Releases/pull/new/master) if you want to make some change to Releases.
- Contact [@johnsundell on Twitter](https://twitter.com/johnsundell) for discussions, news & announcements about Releases & other projects.
