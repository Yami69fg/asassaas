import Foundation

struct GameData {
    let Bg: String
    let targetScore: Int
}

let gameLevels: [GameData] = [
    GameData(Bg: "bg1", targetScore: 5),
    GameData(Bg: "bg2", targetScore: 10),
    GameData(Bg: "bg3", targetScore: 15),
    GameData(Bg: "bg2", targetScore: 20),
    GameData(Bg: "bg3", targetScore: 25),
    GameData(Bg: "bg1", targetScore: 45),
    GameData(Bg: "bg2", targetScore: 30),
    GameData(Bg: "bg3", targetScore: 40),
    GameData(Bg: "bg1", targetScore: 50),
    GameData(Bg: "bg3", targetScore: 60),
    GameData(Bg: "bg2", targetScore: 80),
    GameData(Bg: "bg1", targetScore: 100)
]

func getGameData(for level: Int) -> GameData? {
    guard level > 0 && level <= gameLevels.count else { return nil }
    return gameLevels[level - 1]
}
