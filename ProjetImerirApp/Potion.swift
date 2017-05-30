import UIKit


/// Potion randomly generated from Room object. Use is restricted to maze minigame.
class Potion {
    
    /**
     Amount of life points given by the potion.
     Randomly generated between 1 and 5.
     */
    var health: Int!
    
    /**
     Scale value that has to be applied to the image view.
     Randomly generated between 0.5 and 1.5.
     */
    var scale:CGFloat!
    
    /// Create a new potion with random health and scale.
    init() {
        self.health = 1 + Int(arc4random_uniform(5))
        self.scale = 0.5 + CGFloat(drand48())
    }
}
