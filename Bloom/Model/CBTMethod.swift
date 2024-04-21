

import Foundation

struct CBTMethod {
    var title: String
    var description: String
    var isStar: Bool
    var type: CBTMethodType
}

enum CBTMethodType {
    case Grounding
    case DeepBreathing
    case Progressive
    case Mindful
    case Thought
    case Engage
}
