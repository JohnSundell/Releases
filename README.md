# 🚢 Releases

Using **Releases** you can easily resolve all released versions from a Git repository, in either a Swift script
or command line tool. It supports both remote & local repositories and provides convenience APIs for sorting,
filtering out pre-released versions, etc.

## Usage

Simply call `Releases.versions(for: url)` and you'll get an array of `Version` back:

```swift
let url = URL(string: "https://github.com/johnsundell/unbox")!
let releases = Releases.versions(for: url)

// Print the latest version
print(releases.last)
```

Remove all pre-release versions (like `Alpha`, `Beta`, etc):

```swift
let url = URL(string: "https://github.com/johnsundell/unbox")!
let releases = Releases.versions(for: url).withoutPreReleases()

// Print the latest stable version
print(releases.last)
```

## Installation

- Add `.package(url: "https://github.com/JohnSundell/Releases.git", from: "5.0.0")` to your `Package.swift` file's `dependencies`.
- Update your packages using `$ swift package update`.

## Help, feedback or suggestions?

- [Open a PR](https://github.com/JohnSundell/Releases/pull/new/master) if you want to make some change to Releases.
- Contact [@johnsundell on Twitter](https://twitter.com/johnsundell) for discussions, news & announcements about Releases & other projects.
