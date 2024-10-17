import SpriteKit

class Cell: SKNode {
    var type: CellInfo
    var positionX: Int
    var positionY: Int
    private var texture: SKTexture
    private var spriteNode = SKSpriteNode()
    private var filledSpriteNode = SKSpriteNode()
    
    init(type: CellInfo, x: Int, y: Int) {
        self.type = type
        self.positionX = x
        self.positionY = y
        texture = SKTexture(image: .cell)
        spriteNode = SKSpriteNode(texture: texture)
        spriteNode.zPosition = 3
        super.init()
        cellConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func cellConfiguration() {
        self.name = NodeNames.gameCell.rawValue
        self.zPosition = 2
        self.addChild(spriteNode)
        self.setScale(0.37)
    }
    
    func makeBomb() {
        self.type = .bombInside
        filledSpriteNode = SKSpriteNode(texture: SKTexture(image: type.filledImage))
        filledSpriteNode.name = NodeNames.filledElement.rawValue
        filledSpriteNode.zPosition = 2
        filledSpriteNode.size = CGSize(width: spriteNode.frame.width * 0.8, height: spriteNode.frame.height)
        self.addChild(filledSpriteNode)
        animatedBombOpen()
    }
    
    func animatedBombClose(animationCompletion: (() -> ())? = nil) {
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        spriteNode.run(fadeInAction) {
            animationCompletion?()
        }
    }
    
    func animatedBombOpen() {
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
        spriteNode.run(fadeOutAction)
    }
    
    func getCellWidth() -> CGFloat {
        return spriteNode.frame.width * 0.35
    }
    
    func setSelected() {
        VibroManager.shared.vibro()
        type = .selected
        spriteNode.texture = SKTexture(image: .selectedCell)
    }
    
    func clearCell() {
        animatedPointFadeOut()
        animatedBombClose {
            self.filledSpriteNode.removeFromParent()
            self.type = .empty
            self.enumerateChildNodes(withName: NodeNames.filledElement.rawValue) { filledElement, _ in
                filledElement.removeFromParent()
            }
        }
    }
    
    private func animatedPointFadeOut() {
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
        filledSpriteNode.run(fadeOutAction)
    }
    
    func makeStartPoint() {
        self.type = .startPoint
        filledSpriteNode = SKSpriteNode(texture: SKTexture(image: type.filledImage))
        filledSpriteNode.name = NodeNames.filledElement.rawValue
        filledSpriteNode.zPosition = 5
        filledSpriteNode.alpha = 0
        filledSpriteNode.size = CGSize(width: spriteNode.frame.width, height: spriteNode.frame.height)
        self.addChild(filledSpriteNode)
        animatedPointAppearing()
    }
    
    private func animatedPointAppearing() {
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        filledSpriteNode.run(fadeInAction)
    }
    
    func makeFinishPoint() {
        self.type = .finishPoint
        filledSpriteNode = SKSpriteNode(texture: SKTexture(image: type.filledImage))
        filledSpriteNode.name = NodeNames.filledElement.rawValue
        filledSpriteNode.zPosition = 5
        filledSpriteNode.alpha = 0
        filledSpriteNode.size = CGSize(width: spriteNode.frame.width, height: spriteNode.frame.height)
        self.addChild(filledSpriteNode)
        animatedPointAppearing()
    }
    
    func cancelSelection() {
        spriteNode.texture = SKTexture(image: .cell)
        self.type = .empty
    }
}
