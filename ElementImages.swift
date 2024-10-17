import UIKit

enum NodeNames: String {
    case gameCell = "gameCell"
    case filledElement = "fillerElement"
    case gameField = "gameField"
}

enum CellInfo {
    case selected
    case startPoint
    case finishPoint
    case bombInside
    case empty
    
    var filledImage: UIImage {
        switch self {
            case .selected:
                return UIImage(resource: .selectedCell)
            case .bombInside:
                return UIImage(resource: .bomb)
            case .startPoint:
                return UIImage(resource: .point)
            case .finishPoint:
                return UIImage(resource: .point)
            case .empty:
                return UIImage(resource: .cell)
        }
    }
}
