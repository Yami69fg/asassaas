import SpriteKit
import GameplayKit

final class GameScene: SKScene {
    weak var gController: GameController?
    
    private var scoreArray = [Cell]()
    private var scoreLabel = SKLabelNode()
    private var count = SKLabelNode()
    private var targetScore: Int = 0
    private var youWin = true
    private var isFirstTouch = true
    private var animationEnd = false
    private var pathInProcess = false
    private var background = SKSpriteNode()
    private var fieldF = SKSpriteNode()
    private var scoreImage = SKSpriteNode()
    private var blackRectangle: SKSpriteNode!
    private var closeButton: SKSpriteNode!
    private var instructionLabel: SKLabelNode!
    var selectedLevel: Int = 1
    private let matrixHorisontal = [0, 1, 2, 3]
    private let matrixVertical = [0, 1, 2, 3]
    private var array = [Cell]()
    private var startPoint: CellInfo?
    private var current: Cell?
    private var overSound = SKAction()
    private var cellSound = SKAction()
    private var roundSound = SKAction()
    private var Bg: String = ""
    
    private var score = 0 {
        didSet {
            addScoreL()
        }
    }
    
    init(size: CGSize, level: Int, bg: String, targetScore: Int) {
        self.selectedLevel = level
        self.Bg = bg
        self.targetScore = targetScore
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        addElements()
        createArray()
    }

    func showInstruction() {
        if let viewController = self.gController {
            let firstInstruction = InstructionController()
            firstInstruction.modalPresentationStyle = .overFullScreen
            
            viewController.present(firstInstruction, animated: true, completion: nil)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isFirstTouch {
            startRound()
            isFirstTouch.toggle()
        }
        
        if let touch = touches.first {
            if let touchedCell = nodes(at: touch.location(in: self)).first(where: { $0.name == NodeNames.gameCell.rawValue }) as? Cell {
                guard animationEnd else { return }
                if touchedCell.type == .startPoint {
                    current = touchedCell
                    startPoint = .startPoint
                    pathInProcess = true
                    VibroManager.shared.vibro()
                }
                if touchedCell.type == .finishPoint {
                    current = touchedCell
                    startPoint = .finishPoint
                    pathInProcess = true
                    VibroManager.shared.vibro()
                }
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if pathInProcess {
                if let newCell = nodes(at: touch.location(in: self)).first(where: { $0.name == NodeNames.gameCell.rawValue }) as? Cell {
                    if newCell.type == .empty, newCell.positionX == current?.positionX || newCell.positionY == current?.positionY {
                        newCell.setSelected()
                        playCellSound()
                        scoreArray.append(newCell)
                        current = newCell
                    }
                    if newCell.positionX != current?.positionX, newCell.positionY != current?.positionY {
                        cancelSelection()
                    }
                    if newCell.type == .selected, newCell != current {
                        cancelSelection()
                    }
                    if newCell.type == .bombInside {
                        gameOver()
                    }
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if let endedCell = nodes(at: touch.location(in: self)).first(where: { $0.name == NodeNames.gameCell.rawValue }) as? Cell {
                if startPoint == .startPoint, endedCell.type == .finishPoint, pathInProcess {
                    touchEnd()
                }
                if startPoint == .finishPoint, endedCell.type == .startPoint, pathInProcess {
                    touchEnd()
                }
            }
        }
        cancelSelection()
    }

    private func touchEnd() {
        VibroManager.shared.vibro()
        roundWin()
        pathInProcess = false
    }

    private func cancelSelection() {
        scoreArray.removeAll()
        pathInProcess = false
        current = nil
        array.forEach { cell in
            if cell.type == .selected {
                cell.cancelSelection()
            }
        }
    }

    private func roundWin() {
        score += scoreArray.count
        if score >= targetScore {
            gameOver()
        }
        playRoundSound()
        clear()
        run(SKAction.run {
            self.clear()
        }) {
            self.run(SKAction.wait(forDuration: 0.4)) {
                self.startRound()
            }
        }
    }

    func restart() {
        clear()
        score = 0
        isFirstTouch = true
    }

    private func gameOver() {
        if score < targetScore {
            youWin = false
        }
        playOverSound()
        pathInProcess = false
        scoreArray.removeAll()
        array.forEach { cell in
            if cell.type == .bombInside {
                cell.animatedBombOpen()
            }
        }
        self.run(SKAction.wait(forDuration: 0.3)) {
            self.gController?.gameOver(score: self.score, win: self.youWin)
        }
    }

    private func startRound() {
        self.animationEnd = false
        run(SKAction.run {
            self.createGamePoints()
        }) {
            self.run(SKAction.wait(forDuration: 0.5)) {
                self.array.forEach { cell in
                    if cell.type == .bombInside {
                        cell.animatedBombClose {
                            self.animationEnd = true
                        }
                    }
                }
            }
        }
    }

    private func clear() {
        array.forEach { cell in
            cell.clearCell()
        }
    }

    private func createGamePoints() {
        let leftColumn = array.filter( { $0.positionX == 0 } )
        let rightColumn = array.filter( { $0.positionX == 3 } )
        leftColumn.randomElement()?.makeStartPoint()
        rightColumn.randomElement()?.makeFinishPoint()
        createBombs()
    }

    private func createBombs() {
        let firstColumn = array.filter( { $0.positionX == 0 } )
        let secondColumn = array.filter( { $0.positionX == 1 } )
        let thirdColumn = array.filter( { $0.positionX == 2 } )
        let fourthColumn = array.filter( { $0.positionX == 3 } )
        guard let leftPoint = firstColumn.first(where: { $0.type == .startPoint }),
              let rightPoint = fourthColumn.first(where: { $0.type == .finishPoint }) else { return }
        let firstBomb = firstColumn.shuffled().first(where: { $0.type != .startPoint && abs($0.positionY - leftPoint.positionY) > 1 })
        let firstSpace = firstColumn.first(where: { $0.type == .empty && abs($0.positionY - leftPoint.positionY) == 1 })
        let secondBomb = secondColumn.shuffled().first(where: { $0.positionY != firstSpace?.positionY })
        let thirdBomb = secondColumn.shuffled().first(where: { $0.positionY != firstSpace?.positionY && $0.positionY != secondBomb?.positionY })
        let fourthBomb = thirdColumn.shuffled().first(where: { $0.positionY == thirdBomb?.positionY })
        firstBomb?.makeBomb()
        secondBomb?.makeBomb()
        thirdBomb?.makeBomb()
        fourthBomb?.makeBomb()
        if rightPoint.positionY == 1 || rightPoint.positionY == 2 {
            let fifthBomb = fourthColumn.shuffled().first(where: { $0.type != .finishPoint && abs($0.positionY - rightPoint.positionY) > 1 })
            fifthBomb?.makeBomb()
        }
    }

    private func addElements() {
        background = SKSpriteNode(texture: SKTexture(imageNamed: Bg))
        background.zPosition = 0
        background.setScale(1)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        fieldF = SKSpriteNode(texture: SKTexture(image: .bgArray))
        fieldF.setScale(0.37)
        fieldF.zPosition = 1
        fieldF.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(fieldF)
        
        scoreImage = SKSpriteNode(texture: SKTexture(image: .scoreBG))
        scoreImage.zPosition = 1
        scoreImage.setScale(0.36)
        scoreImage.position = CGPoint(x: frame.midX + scoreImage.frame.width * 0.2, y: frame.maxY - scoreImage.frame.height)
        addChild(scoreImage)
        
        scoreLabel.text = "SCORE"
        scoreLabel.fontColor = .white
        scoreLabel.fontName = "Ministro"
        scoreLabel.fontSize = 19
        scoreLabel.zPosition = 2
        let labelYPosition = scoreImage.frame.midY - scoreLabel.frame.height * 0.33
        scoreLabel.position = CGPoint(x: scoreImage.frame.midX + scoreLabel.frame.height * 1.5, y: labelYPosition)
        addChild(scoreLabel)
        
        count.text = "\(score)"
        count.fontColor = UIColor(red: 1, green: 0.984, blue: 0.325, alpha: 1)
        count.fontName = "Ministro"
        count.fontSize = 19
        count.zPosition = 2
        count.position = CGPoint(x: scoreLabel.frame.maxX + count.frame.width, y: labelYPosition)
        addChild(count)
        
        overSound = SKAction.playSoundFileNamed("gameOverSound", waitForCompletion: false)
        cellSound = SKAction.playSoundFileNamed("cellReturn", waitForCompletion: false)
        roundSound = SKAction.playSoundFileNamed("nextRound", waitForCompletion: false)
    }

    private func createArray() {
        let testCell = Cell(type: .empty, x: 10, y: 10)
        let cellWidth = testCell.getCellWidth()
        let startXPosition = frame.minX + cellWidth
        let inset = ((frame.width - cellWidth * 2) / Double(matrixHorisontal.count - 1))
        
        let startYPosition = frame.midY + inset * 1.5
        matrixVertical.forEach { posY in
            createHorisontalCells(inset: inset, yPos: posY, startX: startXPosition, startY: startYPosition - inset * CGFloat(posY))
        }
    }

    private func playOverSound() {
        if SettingsManager.soundsEnabled {
            run(overSound)
        }
    }

    private func playCellSound() {
        if SettingsManager.soundsEnabled {
            run(cellSound)
        }
    }

    private func playRoundSound() {
        if SettingsManager.soundsEnabled {
            run(roundSound)
        }
    }

    private func addScoreL() {
        count.text = "\(score)"
        let upscale = SKAction.scale(to: 1.08, duration: 0.13)
        let downscale = SKAction.scale(to: 1, duration: 0.13)
        let sequence = SKAction.sequence([upscale, downscale])
        count.run(sequence)
    }

    private func createHorisontalCells(inset: CGFloat, yPos: Int, startX: CGFloat, startY: CGFloat) {
        matrixHorisontal.forEach { xPos in
            let cell = Cell(type: .empty, x: xPos, y: yPos)
            cell.position = CGPoint(x: startX + inset * CGFloat(xPos), y: startY)
            addChild(cell)
            array.append(cell)
        }
    }
}
