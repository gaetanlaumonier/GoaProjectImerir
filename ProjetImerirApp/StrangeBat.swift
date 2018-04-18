import UIKit

/** This class is used to generate monsters in maze minigame. Each new StrangeBat is randomly generated from 3 premade objects.
 - BeteRouge = 2.3 speed
 - BeteVerte = 1.5 speed
 - BeteGrise = 1.8 speed
 
 Each name matches an image string located in Assets.xcassets folder.
 */
class StrangeBat {
    
    /// Speed value of the StrangeBat.
    var speed: Double!
    
    /// Asset name of the StrangeBat.
    var name: String!
    
    /// Create a new StrangeBat picked randomly from 3 premade name/speed values.
    init() {
        let rand = drand48()
        
        if rand < 0.33 {
            self.name = "BeteRouge"
            self.speed = 2.3
        } else if rand < 0.66 {
            self.name = "BeteVerte"
            self.speed = 1.5
        } else {
            self.name = "BeteGrise"
            self.speed = 1.8
        }
    }
}
