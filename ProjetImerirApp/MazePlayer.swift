/**
 Represents the player from the maze minigame
*/
class MazePlayer {
    
    /**
     Associate a number from 0 to 3 to a direction
     - Orientation.North.rawValue = 0
     - Orientation.East.rawValue = 1
     - Orientation.South.rawValue = 2
     - Orientation.West.rawValue = 3
     */
    enum Orientation : Int {
        case North /// rawValue is equal to 0
        case East /// rawValue is equal to 1
        case South /// rawValue is equal to 2
        case West /// rawValue is equal to 3
    }
    
    var x:Int! /// X Position of the player in maze's array.
    var y:Int! /// Y Position of the player in maze's array.
    var orientation:Orientation = .North /// The player's orientation.
}
