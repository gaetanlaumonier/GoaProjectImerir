//
//  LabyrintheViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 05/04/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import AVFoundation

class LabyrintheViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet var background: UIImageView!
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet var arrowLeft: UIImageView!
    @IBOutlet var arrowDown: UIImageView!
    @IBOutlet var arrowRight: UIImageView!
    @IBOutlet var arrowUp: UIImageView!
    
    @IBOutlet var spikes: UIImageView!
    @IBOutlet var potionView: UIImageView!
    
    @IBOutlet var damageOverlay: UIImageView!
    @IBOutlet var minimap: UIView!
    
    var mazeObj:Maze!
    var maze: [[Maze.Cell]]!
    
    var oneProfil = ProfilJoueur()

    var pageViewController:UIPageViewController!
    var pageViewLabels:[String]!
    var pageViewImages:[String]!
    var pageViewTitles:[String]!
    var pageViewHints:[String]!
    var idClasse : Int = 0
    
    var isFirstMaze = false
    var player = MazePlayer()
    var currentRoom:Room!
    var healthLimit = 80
    var AllClasse = [ClasseJoueur]()
    
    var imagesList = [("LabFace",[Direction.North,Direction.South]),
                      ("LabFaceGauche",[Direction.North,Direction.West,Direction.South]),
                      ("LabFaceDroite",[Direction.North,Direction.East,Direction.South]),
                      ("LabGauche",[Direction.West,Direction.South]),
                      ("LabDroite",[Direction.East,Direction.South]),
                      ("LabCulDeSac",[Direction.South]),
                      ("LabGaucheDroite",[Direction.East,Direction.West,Direction.South]),
                      ("Lab4voies",[Direction.North,Direction.East,Direction.South,Direction.West])]
    
    var knownRooms = [Room]()
    var arrowsList:[Direction:UIImageView]!
    var spikesImages = [(img: UIImage, dmg: Int)]()
    var currentBat:UIImageView!
    var batGestureRecognizer:UITapGestureRecognizer!
    var minimapCells = [(x:Int,y:Int,layer:CALayer)]()
    var bruitageMusicPlayer = AVAudioPlayer()
    var bruitageMusicPlayerMonstre: AVAudioPlayer?
    var firstGameTimer = Timer()
    var elapsedTime = Int()
    var killMonster = AVAudioPlayer()
    var nbrBatKilled : Int = 0
    var nbrBatAppear : Int = 0
    var orientationView:UIView!
    
    var embedViewController:EmbedViewController!
    
    enum Direction : Int {
        case North, East, South, West
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initProfil()
        initPageView()
        
        initGame()
    }
    
    func initProfil() {
        AllClasse = buildClasseJoueur()
        switch self.oneProfil.classeJoueur{
        case "Geek":
            idClasse = 0
            break
        case "Noob":
            idClasse = 1
            break
        case "Hacker":
            idClasse = 2
            break
        case "Fonctionnaire":
            idClasse = 3
            break
        case "Personne":
            idClasse = 4
        default:
            break
        }
    }
    
    func initPageView() {
        pageViewLabels = ["Oriente toi dans le labyrinthe en cliquant sur les flèches directionnelles.", "Ramasse les potions pour retrouver des points de vie.","Attention au piège ! Ne passe que s'ils sont désarmés.", "Si un monstre apparaît, clique vite dessus !", "Avec la classe \(self.oneProfil.classeJoueur), \(AllClasse[idClasse].labyrinthe as String)"]
        pageViewImages = ["FlecheDroite", "Potion","Piege","BeteVerte", "\(AllClasse[idClasse].idClasse as String)"]
        pageViewTitles = ["Se Diriger","Les Potions","Les Pièges", "Les Monstres", "\(AllClasse[idClasse].idClasse as String)"]
        pageViewHints = ["Aide toi de la mini-map en haut à droite de l'écran.", "Ne soigne plus au-delà de 80PV.", "Traverse les quand tu ne vois plus de piques.", "Tout les monstres ne vont pas à la même vitesse.", ""]
        
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "LabyrinthePageViewController") as! UIPageViewController
        
        pageViewController.dataSource = self
        
        let startVC = viewControllerAtIndex(index: 0)
        
        pageViewController.setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        
        var modal = view.frame
        modal.size.width = modal.width*0.75
        modal.size.height = modal.height*0.5
        
        pageViewController.view.frame = modal
        pageViewController.view.center = view.center
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        headerView.lifePointLabel.text = "\(self.oneProfil.lifePoint) PV"
        headerView.timerLabel.isHidden = true
        
        //Init graphics that require the view to be displayed
        initMaze()
    }
    
    
    
    
    //// GAME INITIALIZATION ////
    
    // Called in viewDidAppear
    func initMaze() {
        
        // Generate a random maze using Maze class
        createMaze()
        
        // Spawn the player in the middle of the maze
        spawnPlayer(Int(maze.count/2), Int(maze.count/2))
        
        // Create the minimap
        initMap()
        
        // Load the initial room where the player has spawned
        loadRoom(player.x, player.y, completion: { _ in
            
            UIView.animate(withDuration: 0.5, animations: { _ in
                self.view.alpha = 1
            })
        })
    }
    
    // Called in viewDidLoad
    func initGame() {
        
        // Start with alpha 0 so the initial background image is not displayed while game is being initialized
        view.alpha = 0
        
        if self.oneProfil.classeJoueur == "Geek" {
            healthLimit = 90
        }
        
        potionView.loadGif(name: "Potion")
        
        // Remade GIF displaying method to be able to get the current image displaying
        spikes.loadGif(name: "Piege", completion: { _ in
            self.setupSpikesDict()
            self.spikes.image = nil
            self.spikes.image = self.spikesImages.first?.img
            self.animateSpikes()
        })
        
        // Add gesture recognizer to the view itself for tapping moving bats (to manage presentationLayer)
        batGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleBatTap))
        view.addGestureRecognizer(batGestureRecognizer)
        
        // Add gesture recognizers to arrows
        initArrows()
        
    }
    
    func createMaze() {
        mazeObj = Maze(width: 11, height: 11)
        maze = mazeObj.data
        embedViewController = getEmbedViewController()

        if isFirstMaze {
            maze[maze.count-2][maze.count-3] = Maze.Cell.Wall
            
        } else {
        embedViewController.backgroundMusicPlayer = GestionMusic(filename: "TheyreClosing")
        }
    }
    
    func initArrows() {
        arrowsList = [Direction.North:arrowUp,
                      Direction.East:arrowRight,
                      Direction.South:arrowDown,
                      Direction.West:arrowLeft]
        
        for arrow in arrowsList {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.arrowTapped))
            arrow.value.addGestureRecognizer(gesture)
        }
    }
    
    // Unproudly hand made gif (making possible the hacker's bonus and verification of currently displayed image)
    func setupSpikesDict() {
        
        if let img = self.spikes.image {
            
            if let imgList = img.images {
                
                spikesImages.append((img: imgList[0], dmg:0))
                
                if oneProfil.classeJoueur == "Hacker" {
                    spikesImages.append((img: imgList[0], dmg:0))
                }
                
                spikesImages.append((img: imgList[3], dmg:3))
            }
        }
        
        
    }
    
    func animateSpikes() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if let tuple = self.spikesImages.first {
                self.spikes.image = tuple.img
                self.spikesImages.append((img: tuple.img, dmg: tuple.dmg))
                self.spikesImages.remove(at: 0)
            }
        })
    }
    
    func spawnPlayer(_ x: Int,_ y: Int) {
        
        let possibleCells = [(x,y),
                             (x+1,y),
                             (x,y+1),
                             (x+1,y+1)]
        
        for position in possibleCells {
            if maze[position.0][position.1] == Maze.Cell.Wall {
                continue
            }
            player.x = position.0
            player.y = position.1
            break
        }
        
    }
    
    
    
    
    //// GLOBAL FUNCTIONS & IBActions ////
    
    // On arrow tapped
    func arrowTapped(_ sender: UITapGestureRecognizer) {
        
        guard let arrowView = sender.view else {
            return
        }
        self.bruitageMusicPlayer = self.GestionBruitage(filename: "Clik", volume: 0.9)
        UIView.animate(withDuration: 0.3, animations: { _ in
            arrowView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
        
        disableArrows()
        
        if arrowView.tag != 2 {
            manageSpikes()
        }
        
        UIView.animate(withDuration: 0.5, animations: { _ in
            self.view.alpha = 0
        }, completion: { _ in
            arrowView.transform = .identity
            self.hideArrows()
            self.moveTo(Direction(rawValue: arrowView.tag)!, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: { _ in
                    self.view.alpha = 1
                }, completion : { _ in
                    self.disableArrows()
                    self.drawNextBat()
                })
            })
        })
    }
    
    // On potion tapped
    @IBAction func onPotionTaken(_ sender: Any) {
        if let potion = currentRoom.potion {
            
            if self.oneProfil.lifePoint < healthLimit {
                gainHealth(potion.health)
            }
            bruitageMusicPlayer = GestionBruitage(filename: "Potion", volume: 0.6)
            currentRoom.potion = nil
            UIView.animate(withDuration: 0.5, animations: { _ in
                self.potionView.alpha = 0
            }, completion: { _ in
                self.potionView.isHidden = true
                self.potionView.alpha = 1
            })
        }
    }
    
    // Return the current spikes sequence (image and damage supposed to deal), called on leaving a room
    func findCurrentSpikeSeq() -> (img: UIImage, dmg: Int)? {
        if let currentImage = self.spikes.image {
            return spikesImages.first(where: { $0.img == currentImage })
        }
        
        return nil
    }
    
    // Avoid playing song when trap should deal 0 damage (when it is disabled)
    func manageSpikes() {
        if !spikes.isHidden {
            if let currentSeq = findCurrentSpikeSeq() {
                if currentSeq.dmg != 0 {
                bruitageMusicPlayer = GestionBruitage(filename: "Piege", volume: 0.5)
                }
                looseHealth(currentSeq.dmg)
            }
        }
    }
    
    // Sometimes arrows has to be visible but disabled
    func disableArrows() {
        for arrow in arrowsList {
            arrow.value.isUserInteractionEnabled = false
        }
    }
    
    // Hides every arrows (on entering a room that must display monsters)
    func hideArrows() {
        for arrow in arrowsList {
            arrow.value.alpha = 0
        }
    }
    
    // Make arrows visible and user interaction enabled
    func enableArrows() {
        for arrow in arrowsList {
            
            if arrow.value.alpha == 0 {
                UIView.animate(withDuration: 0.5, animations: { _ in
                    arrow.value.alpha = 1
                }, completion: { _ in
                    arrow.value.isUserInteractionEnabled = true
                })
            } else {
                arrow.value.isUserInteractionEnabled = true
            }
            
        }
    }
    
    // Function for loosing health (manages noob class)
    func looseHealth(_ amount: Int) {
        
        guard amount != 0 else {
            return
        }
        
        if self.oneProfil.classeJoueur == "Noob" {
            if drand48() < 0.2 {
                gainHealth(amount)
                return
            }
        }
        
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.byValue = CGFloat(0.2) * CGFloat(amount)
        anim.autoreverses = true
        anim.duration = 0.5
        changeColorLabelBad(label: headerView.lifePointLabel)
        self.oneProfil.lifePoint -= amount
        damageOverlay.layer.add(anim, forKey: nil)
        headerView.lifePointLabel.text = "\(self.oneProfil.lifePoint) PV"
    }
    
    // Function for gaining health
    func gainHealth(_ amount: Int) {
        changeColorLabelGood(label: headerView.lifePointLabel)
        self.oneProfil.lifePoint += amount
        headerView.lifePointLabel.text = "\(self.oneProfil.lifePoint) PV"
    }
    
    
    
    
    //// GAME ENDING ////
    
    // On timer ended for first maze, on exit found for the second one
    func endGame() {
        if let vc = UIStoryboard(name:"Dialogue", bundle:nil).instantiateInitialViewController() as? DialogueViewController {
        if isFirstMaze == true {
                firstGameTimer.invalidate()
                self.oneProfil.sceneActuelle += 1
                vc.oneProfil = self.oneProfil
                self.saveMyData()
                UIView.animate(withDuration: 7, animations: {
                    self.view.alpha = 0
                    self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 6)
                    self.bruitageMusicPlayer.setVolume(0, fadeDuration: 1)
                    
                    self.bruitageMusicPlayerMonstre?.setVolume(0, fadeDuration: 1)

                } , completion: { success in
                    self.bruitageMusicPlayer.stop()
                    self.embedViewController.showScene(vc)
                })
        } else {
                self.oneProfil.sceneActuelle += 1
                self.oneProfil.statsLabyrinthe["timeSpent"] = self.elapsedTime
            if nbrBatAppear < 1 {
                self.oneProfil.statsLabyrinthe["batKilled"] = 100
            } else {
            self.oneProfil.statsLabyrinthe["batKilled"] = 100 * self.nbrBatKilled / self.nbrBatAppear
            }
            vc.oneProfil = self.oneProfil
                self.saveMyData()
                UIView.animate(withDuration: 7, animations: {
                    self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 5.5)
                    self.bruitageMusicPlayerMonstre?.setVolume(0, fadeDuration: 1)
                    self.view.alpha = 0
                }, completion: { success in
                    self.bruitageMusicPlayerMonstre?.stop()
                    self.embedViewController.showScene(vc)
                })
            }
        }else {
                print("Could not instantiate view controller with identifier of type DialogueViewController")
                return
        }
    }
    
    func saveMyData(){
        var maData = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        maData.appendPathComponent("saveGame")
        NSKeyedArchiver.archiveRootObject(self.oneProfil, toFile: maData.path)
    }
    
    
    
    
    //// GAME LOGIC ////
    
    // Take an enum parameter which is passed by the arrow (player orientation is managed here)
    func moveTo(_ direction: Direction, completion: (() -> Swift.Void)? = nil) {
        
        let trueDirection = Direction(rawValue: (direction.rawValue + player.orientation.rawValue) % 4)!
        
        var newX = 0
        var newY = 0
        
        switch trueDirection {
        case .North:
            newX = -1
        case .East:
            newY = 1
        case .South:
            newX = 1
        case .West:
            newY = -1
        }
        
        player.orientation = MazePlayer.Orientation(rawValue: trueDirection.rawValue)!
        player.x = player.x + newX
        player.y = player.y + newY
        
        loadRoom(player.x, player.y, completion: { _ in
            completion?()
        })
    }
    
    // Global function for loading a new/old room
    func loadRoom(_ x: Int, _ y: Int, completion: (() -> Swift.Void)? = nil) {
        
        guard maze[x][y] == Maze.Cell.Space else {
            return
        }
        
        guard !isExitRoom() else {
            bruitageMusicPlayer = GestionBruitage(filename: "Sortie", volume: 1)
            endGame()
            return
        }
        
        if !spikes.isHidden && spikes.image == spikes.image?.images?[2] {
            looseHealth(5)
        }
        potionView.isHidden = true
        
        if let room = getKnownRoom((x: x, y: y)) {
            currentRoom = room
        } else {
            currentRoom = Room(x: x, y: y)
            knownRooms.append(currentRoom)
        }
        
        let imageName = getRoomImage()
        
        drawMinimapAdjacentCells()
        
        redrawHUD()
        
        background.loadGif(name: imageName, completion: {_ in
            completion?()
        })
    }
    
    // Return the string of the current room's image
    func getRoomImage() -> String {
        
        if player.x == maze.count - 2 && player.y == maze.count - 3 {
            return "LabSortie"
        }
        
        let baseDirections = getAvalaibleDirections(room: currentRoom)
        
        var finalDirections:[Direction] = []
        for direction in baseDirections {
            finalDirections.append(Direction(rawValue: (direction.rawValue - player.orientation.rawValue + 4) % 4)!)
        }
        
        if !finalDirections.contains(.South) {
            player.orientation = MazePlayer.Orientation(rawValue: player.orientation.rawValue+1)!
            return getRoomImage()
        }
        
        
        for possibleImage in imagesList {
            if possibleImage.1.sorted(by: {$0.rawValue < $1.rawValue}) == finalDirections.sorted(by: {$0.rawValue < $1.rawValue}) {
                return possibleImage.0
            }
        }
        
        return "LabSortie"
    }
    
    // Allow room to know which arrows it can display
    func getAvalaibleDirections(room: Room) -> [Direction] {
        
        if let cells = room.possibleCells {
            return cells
        }
        
        let possibleCells = [(Direction.North, [room.x-1,room.y]),
                             (Direction.East, [room.x,room.y+1]),
                             (Direction.South, [room.x+1,room.y]),
                             (Direction.West, [room.x,room.y-1])]
        
        var directions:[Direction] = []
        
        for cell in possibleCells {
            if maze[cell.1[0]!][cell.1[1]!] == Maze.Cell.Space {
                directions.append(cell.0)
            }
        }
        
        return directions
    }
    
    // Called on every room that is loaded
    func isExitRoom() -> Bool {
        return player.x == maze.count-1 && player.y == maze.count-3
    }
    
    // Return the Room object if the player has already visited it
    func getKnownRoom(_ location: (x: Int, y: Int)) -> Room? {
        return knownRooms.first(where: { $0.x == location.x && $0.y == location.y })
    }
    
    
    
    
    //// ROOM RELATED EVENTS ////
    
    // Called on loading a new room
    func redrawHUD() {
        drawArrows()
        drawPotion()
        drawSpikes()
    }
    
    // Hide bad arrows
    func drawArrows() {
        for arrow in arrowsList {
            arrow.value.isHidden = true
        }
        
        for direction in getAvalaibleDirections(room: currentRoom) {
            let trueDirection = Direction(rawValue: (direction.rawValue - player.orientation.rawValue + 4) % 4)!
            arrowsList[trueDirection]?.isHidden = false
        }
    }
    
    // If room has generated a potion, draw it
    func drawPotion() {
        if let potion = currentRoom.potion {
            potionView.isHidden = false
            potionView.transform = CGAffineTransform(scaleX: potion.scale, y: potion.scale)
        }
    }
    
    // Manage spikes on current room
    func drawSpikes() {
        
        spikes.isHidden = true
        
        guard getRoomImage() != "LabCulDeSac" && getRoomImage() != "LabSortie" else {
            return
        }
        
        if let hasSpikes = currentRoom.hasSpikes {
            
            if hasSpikes {
                spikes.isHidden = false
            }
            
        } else {
            if drand48() < 0.2 {
                currentRoom.hasSpikes = true
                spikes.isHidden = false
            }
        }
    }
    
    // Draw the next monster, can be called multiple times depending on the number of monsters the room should display
    func drawNextBat() {

        guard !currentRoom.bats.isEmpty else {
            self.enableArrows()
            return
        }

        let bat = currentRoom.bats.first!
        
        let posX = CGFloat(Double(view.bounds.width) * ((drand48() / 2) + 0.25))
        
        let batView = UIImageView(frame: CGRect(origin: CGPoint(x: posX, y: view.center.y) , size: CGSize(width: 1, height: 1)))
        
        self.view.insertSubview(batView, belowSubview: damageOverlay)
        nbrBatAppear += 1
        currentBat = batView
        batView.loadGif(name: bat.name, completion: { _ in
            batView.transform = CGAffineTransform(rotationAngle: -0.2)
            
            UIView.animate(withDuration: 0.05, delay: 0, options: [.repeat,.autoreverse], animations: { _ in
                batView.transform = CGAffineTransform(rotationAngle: 0.2)
            })

        })
        
        let speedFactor:Double
        
        if self.oneProfil.classeJoueur == "Fonctionnaire" {
            speedFactor = 0.75
        } else {
            speedFactor = 1
        }
        
        if bat.speed > 2 {
            bruitageMusicPlayerMonstre = GestionBruitageLoop(filename: "MonstresHigh", volume: 0.5)
        } else {
            bruitageMusicPlayerMonstre = GestionBruitageLoop(filename: "MonstreLow", volume: 0.5)
        }
        UIView.animate(withDuration: 3/bat.speed/speedFactor, delay: 0, options: .curveEaseIn ,animations: { _ in
            let size = (drand48()/2 + 1) * Double(self.view.bounds.midX)
            let randX = Double(arc4random_uniform(UInt32(Double(self.view.bounds.width) + size))) - size
            
            batView.frame = CGRect(x: randX, y: -size, width: size, height: size)
        }, completion: { (finished) in
            
            if finished {
                self.bruitageMusicPlayerMonstre?.stop()
                self.looseHealth(Int(arc4random_uniform(4)) + 1)
                self.killBat()
            }
            
        })
    }
    
    // On monster tapped
    func handleBatTap(_ sender: UITapGestureRecognizer) {
        
        guard currentBat != nil else {
            return
        }
        if let pres = currentBat.layer.presentation() {
            let tapLocation = sender.location(in: currentBat.superview)
            
            if pres.frame.contains(tapLocation) {
                nbrBatKilled += 1
                self.killBat()
            }
        }
    }
    
    // Manage monster's death
    func killBat() {
        
        if let bat = currentBat {
            bruitageMusicPlayerMonstre?.stop()
            killMonster = GestionBruitage(filename: "MonstreTaped", volume: 0.8)
            freezeBat()
            currentBat = nil
            self.currentRoom.bats.remove(at: 0)
            self.drawNextBat()

            UIView.animate(withDuration: 1, animations: { _ in
                bat.alpha = 0
            }, completion: { _ in
                bat.removeFromSuperview()
                
            })
        }
    }
    
    // Freeze the monster before it disappears, gif animation is canceled
    func freezeBat() {
        if let pres = currentBat.layer.presentation() {
            currentBat.layer.frame = pres.frame

            currentBat.layer.removeAllAnimations()
            currentBat.image = UIImage(named: "\((currentRoom.bats.first?.name)!).gif")
        }
    }
    
    
    
    
    //// MINIMAP ////
    
    // Draw minimap depending on maze's dimensions
    func initMap() {
        let cellSize = minimap.frame.width / CGFloat(maze.count)
        
        for line in 0...maze.count - 1 {
            for cell in 0...maze[line].count - 1 {
                let cellLayer = CALayer()
                cellLayer.frame = CGRect(x: CGFloat(cell) * cellSize, y: CGFloat(line) * cellSize, width: cellSize, height: cellSize)
                
                minimap.layer.addSublayer(cellLayer)

                minimapCells.append((x: cell, y: line, layer: cellLayer))
            }
        }
        
        let randomRotate = arc4random_uniform(4)
        
        minimap.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * Double(randomRotate)))
        
        let cellLayer = getMinimapCell(player.y, player.x)
        orientationView = UIView(frame: cellLayer.frame)
        
        let path = UIBezierPath()
        path.addArc(withCenter: minimap.layer.convert(cellLayer.position, to: cellLayer), radius: cellLayer.bounds.width/2, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.red.cgColor
        layer.path = path.cgPath
        
        let fovPath = UIBezierPath()
        fovPath.move(to: minimap.layer.convert(cellLayer.position, to: cellLayer))
        fovPath.addLine(to: CGPoint(x: -cellLayer.bounds.width, y: -cellLayer.bounds.height * 2))
        fovPath.addQuadCurve(to: CGPoint(x: cellLayer.bounds.width * 2, y: -cellLayer.bounds.height * 2), controlPoint: CGPoint(x: cellLayer.bounds.midX, y: -cellLayer.bounds.height * 3))
        
        let fovLayer = CAShapeLayer()
        fovLayer.path = fovPath.cgPath
        fovLayer.fillColor = UIColor.red.cgColor
        fovLayer.opacity = 0.4
        
        layer.addSublayer(fovLayer)
        orientationView.layer.addSublayer(layer)
        
        minimap.addSubview(orientationView)
    }
    
    // Return the layer for a cell of the minimap
    func getMinimapCell(_ x: Int,_ y: Int) -> CALayer {
        return minimapCells.first(where: { $0.x == x && $0.y == y })!.layer
    }
    
    // Refresh minimap cell layer at position (x,y)
    func drawMinimapCell(x: Int, y: Int) {

        if let cell = maze[safe: y]?[safe: x] {
            
            let cellLayer = getMinimapCell(x,y)
            
            if cell == Maze.Cell.Wall {
                cellLayer.backgroundColor = UIColor.gray.cgColor
            } else {
                cellLayer.backgroundColor = UIColor.white.cgColor
            }
        }
    }
    
    // Call drawMinimapCell depending on player field of view, manage player's position too
    func drawMinimapAdjacentCells() {
        
        let visionRange:Int
        
        if self.oneProfil.classeJoueur == "Hacker" {
            visionRange = 3
        } else {
            visionRange = 1
        }

        for y in -visionRange...visionRange {
            for x in -(visionRange-abs(y))...visionRange-abs(y) {
                drawMinimapCell(x: player.y + y, y: player.x + x)
            }
        }
        
        rotatePlayerArrow()
    }
    
    // Rotate the player red cone
    func rotatePlayerArrow() {
        let cellLayer = getMinimapCell(player.y, player.x)
        orientationView.frame.origin = cellLayer.frame.origin
        orientationView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2) * CGFloat(player.orientation.rawValue))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //// RULES PAGE VIEW ////
    
    func hideModal() {
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 0.7)
        for subview in self.view.subviews {
            guard subview is UIVisualEffectView else {
                continue
            }
            
            UIView.animate(withDuration: 1, animations: {_ in
                self.pageViewController.view.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            })
            
            UIView.animate(withDuration: 3,delay: 0, options: .curveEaseOut ,animations: {_ in
                subview.alpha = 0
            }, completion: { finished in
                subview.removeFromSuperview()
                self.pageViewController.view.removeFromSuperview()
                
                     self.firstGameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                        
                        self.elapsedTime += 1
                        if self.isFirstMaze {
                            if self.elapsedTime >= 10 {
                                self.endGame()
                            }
                        }
                    })
                })
            }
    }
    
    func viewControllerAtIndex(index: Int) -> ContentLabyrintheViewController {
        
        if pageViewLabels.count == 0 || index >= pageViewLabels.count {
            return ContentLabyrintheViewController()
        }
        
        let vc:ContentLabyrintheViewController = storyboard?.instantiateViewController(withIdentifier: "ContentLabyrintheViewController") as! ContentLabyrintheViewController
        
        vc.actualImage = pageViewImages[index]
        vc.actualLabel = pageViewLabels[index]
        vc.actualTitle = pageViewTitles[index]
        vc.actualHint = pageViewHints[index]
        vc.pageIndex = index
        
        if index == pageViewLabels.count - 1 {
            vc.isLastPage = true
        }
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentLabyrintheViewController
        var index = vc.pageIndex as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentLabyrintheViewController
        var index = vc.pageIndex as Int
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == pageViewLabels.count {
            return nil
        }
        
        return viewControllerAtIndex(index: index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewLabels.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

}
