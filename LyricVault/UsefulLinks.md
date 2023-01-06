#  Some Useful Links


FSNotes github 
- notes manager for macOS and iOS
- has nice list view
- uses markdown
- https://github.com/glushchenko/fsnotes


Swift Markdown
- Swift package for parsing etc Markdown
- https://github.com/apple/swift-markdown

Core data
- https://apps4world.com/add-core-data-swiftui-tutorial.html
- https://www.answertopia.com/swiftui/a-swiftui-core-data-tutorial/
- https://johncodeos.com/how-to-use-core-data-in-ios-using-swift/

Core data entity relationships
- https://medium.com/@meggsila/core-data-relationship-in-swift-5-made-simple-f51e19b28326

Swift Extension Syntax
- https://docs.swift.org/swift-book/LanguageGuide/Extensions.html

Other
- https://stackoverflow.com/questions/71531226/how-to-authenticate-using-the-swiftydropbox-api-in-a-swiftui-project
using Data class object
- https://codecrew.codewithchris.com/t/generic-struct-foreach-requires-that-data-conform-to-hashable/11663


Selecting rows of a list
- https://stackoverflow.com/questions/72983950/swiftui-list-multiple-selection-data-model
- https://onmyway133.com/posts/how-to-allow-multiple-selection-in-list-in-swiftui/

Programmatic list selection
- https://stackoverflow.com/questions/57344305/swiftui-button-as-editbutton

Regex
- https://stackoverflow.com/questions/56718130/string-extension-for-matching-regular-expression


https://developer.apple.com/forums/thread/119194

Core Data Fetch Requests
- https://www.advancedswift.com/fetch-requests-core-data-swift/#fetch-a-single-object

Codeable
- https://stackoverflow.com/questions/47419291/codable-object-mapping-array-element-to-string



Dictionary keys:
- https://stackoverflow.com/questions/43718476/dictionary-fetch-all-keys-and-use-them-as-array

Yaml with Swift
- https://github.com/behrang/YamlSwift
- https://github.com/jpsim/Yams
NOTE
    - Yaml doesn't appear to be handled natively by Swift built-in libraries at this time
    - The above appear to the the two main 3rd party libraries available
    - Neither library have great documentation
    - YamlSwift if fucking ugly (why is everything loaded as a `Yaml` object ... rather than a Swift primitive. Grrr....)
    - Yams seems better. Backed up by a lot more github stars.
    - Unfortunately I can't figure out how to deal with Yaml containing a sequence of mappings (which isn't unusual!) for `chords`
    - My ugly solution (until I figure things out) is to use YamlSwift to serialize `chords` using YamlSwift and the rest with Yams. (ugg)


MVVP design pattern
- https://www.youtube.com/watch?v=gGM_Qn3CUfQ

Access a managed object context from a view model
- https://stackoverflow.com/questions/74063240/how-do-i-access-a-managed-object-context-in-the-environment-from-a-view-model

