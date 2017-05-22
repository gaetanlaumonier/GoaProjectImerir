//
//  ConsoleViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 13/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import AVFoundation

class ConsoleViewController: UIViewController, CAAnimationDelegate, UIPageViewControllerDataSource {

    @IBOutlet var headerView: HeaderView!
    @IBOutlet var background: UIImageView!
    
    var spaceship: Spaceship!
    var shield: UIImageView!
    
    var gameDuration:CFTimeInterval = 20
    var timeLeft:CFTimeInterval = 20
    
    var spawnFromTop = true
    var missileSize:CGSize!
    
    var speedFactor = 1.0

    var missileViews = [UIImageView]()
    
    var numberOfHeals = 5.0
    var healViews = [UIImageView]()
    
    var numberOfBonus = 5.0
    var bonusViews = [UIImageView]()
    var bonusList = [(func: () -> (), desc: String)]()
    var snails = false
    var snailsTimer = Timer()
    
    var gameIsPaused = false
    var spawnerTimers = [String:Timer]()
    var gameTimer:Timer!
    var collisionTimer:Timer!
    
    var pageViewController:UIPageViewController!
    var pageViewLabels:[String]!
    var pageViewImages:[String]!
    var pageViewTitles:[String]!
    var pageViewHints:[String]!
    
    var oneProfil = ProfilJoueur()
    var idClasse = 0
    var AllClasse = [ClasseJoueur]()
    
    var backgroundMusicPlayer = AVAudioPlayer()
    var bruitageMusicPlayer1 = AVAudioPlayer()
    var bruitageMusicPlayer2 = AVAudioPlayer()
    var bruitageMusicPlayer3 = AVAudioPlayer()
    var bonusBruitageMusicPlayer = AVAudioPlayer()
    var bruit : Int = 0
    var nbrMissile : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        background.loadGif(name: "SpaceBackground")
        backgroundMusicPlayer = GestionMusic(filename: "Steamtech")
        initProfil()
        initPageView()
        
        initClasses()
        initHeaderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        defineConstants()
    }
    
    func startGame() {
        startGameTimer()
        startSpawners()
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
        
        pageViewLabels = ["Déplace ton vaisseau à l'aide de ton doigt.",
                          "Evite les missiles que les vaisseaux extra-terrestres t'envoient.",
                          "Un bouclier t'es conféré lorsque tu subis des dégâts.",
                          "Attrape les orbes que tes alliés t'envoient pour récupérer des points de vie.",
                          "Récupère ces boites pour obtenir un bonus aléatoire.",
                          "Avec la classe \(AllClasse[idClasse].idClasse as String), \(AllClasse[idClasse].arcadeConsole as String)"]
        
        pageViewImages = ["Vaisseau",
                          "AlienMissile",
                          "Bouclier",
                          "SpaceHeal",
                          "SpaceBonusHD",
                          "\(AllClasse[idClasse].idClasse as String)"]
        
        pageViewTitles = ["Ton Vaisseau",
                          "Les Missiles",
                          "Le Bouclier",
                          "Les Orbes Stellaires",
                          "Les Bonus",
                          "\(AllClasse[idClasse].idClasse as String)"]
        
        pageViewHints = ["Ton vaisseau ne se déplace que sur l'axe horizontal.",
                         "Plus tu es loin de l'explosion, moins tu subiras de dégâts.",
                         "Tu deviens invincible pendant un court moment.",
                         "Leurs déplacements aléatoires ont une similarité.",
                         "Tu as acheté le jeu sur ta console, donc pas de malus ici !",
                         ""]
        
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "ConsolePageViewController") as! UIPageViewController
        
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
    
    func initHeaderView() {
        headerView.timerLabel.textColor = .white
        headerView.timerLabel.text = "\(Int(gameDuration)) s"
        headerView.lifePointLabel.text = "\(oneProfil.lifePoint) PV"
    }
    
    func initClasses() {
        if oneProfil.classeJoueur == "Fonctionnaire" {
            speedFactor = 1.4
            gameDuration *= 1.4
            timeLeft = gameDuration
        }
        
        if oneProfil.classeJoueur == "Geek" {
            numberOfHeals *= 1.5
        }
    }
    
    func pauseGame() {
        
        gameIsPaused = true
        
        for timer in spawnerTimers {
            timer.value.invalidate()
        }
        
        gameTimer.invalidate()
        collisionTimer.invalidate()
    }
    
    func resumeGame() {
        
        gameIsPaused = false
        
        startSpawners()
        startGameTimer()
    }
    
    
    // Avoid autoLayout repositionning spaceship on adding subviews
    func spawnSpaceship() {
        let width = view.bounds.width * 0.2
        
        let ship = Spaceship(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: width)))
        ship.image = UIImage(named: "Vaisseau")
        ship.center = view.center
        ship.isUserInteractionEnabled = true
        
        spaceship = ship
        
        ship.alpha = 0
        view.addSubview(ship)
        
        UIView.animate(withDuration: 1, animations: { _ in
            ship.alpha = 1
        })
        
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.duration = 10 * speedFactor
        anim.fromValue = 0
        anim.toValue = Double.pi * 2
        anim.repeatCount = .infinity
        anim.fillMode = kCAFillModeForwards
        
        spaceship.layer.add(anim, forKey: "rotation")
        
        
        let shield =  UIImageView(frame: ship.bounds)
        shield.image = UIImage(named: "Bouclier")
        shield.isHidden = true
        
        self.shield = shield
        
        ship.addSubview(shield)
    }
    
    func defineConstants() {
        let missileWidth = view.frame.width/8
        
        let image = #imageLiteral(resourceName: "AlienMissile.gif")
        let ratio = missileWidth / image.size.width
        
        missileSize = CGSize(width: missileWidth, height: image.size.height * ratio)
        
        
        bonusList.append((bonusBomb, "Tir de suppression !"))
        bonusList.append((bonusShield, "Le don de Xliglak !"))
        bonusList.append((bonusSlow, "Snails in space !?"))
    }
    
    func bonusBomb() {
        
        let bomb = UIImageView(frame: CGRect(x: 0, y: 0, width: spaceship.bounds.width*4, height: spaceship.bounds.width*4))
        
        bomb.center = spaceship.center
        
        bomb.loadGif(name: "SpaceBomb", completion: { _ in
            
            let duration = CFTimeInterval(UIImage.lastLoadedGIFDuration)

            self.view.insertSubview(bomb, aboveSubview: self.background)
            
            self.dropBomb(area: bomb.frame)
            
            Timer.scheduledTimer(withTimeInterval: duration / 1000, repeats: false, block: { _ in
                bomb.removeFromSuperview()
            })
        })
        
    }
    
    func dropBomb(area: CGRect) {
        
        for missile in missileViews {
            
            if let pres = missile.layer.presentation() {
                if area.contains(pres.position) {
                    explode(missile, hacked: true)
                }
                
            }
        }
        
    }
    
    func bonusShield() {
        activateShield(5.0)
    }
    
    func bonusSlow() {
        
        if snails {
            snailsTimer.invalidate()
        }
        
        snails = true
        snailsTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { _ in
            self.snails = false
        })
        

        for missile in missileViews {
            
            guard missile.tag != 10 && missile.tag != 20 else {
                continue
            }

            if let pres = missile.layer.presentation() {

                if let oldAnim = missile.layer.animation(forKey: "position") {

                    missile.tag = 20
                    
                    let finalPos = oldAnim.value(forKey: "finalPos") as! CGFloat
                    
                    missile.layer.removeAnimation(forKey: "position")
                    
                    let startPos = missile.frame.origin.y
                    
                    missile.frame = pres.frame
                    
                    
                    let anim = CABasicAnimation(keyPath: "position.y")
                    anim.duration = CFTimeInterval(CGFloat(10) * (abs(missile.frame.origin.y - finalPos) / abs(startPos - finalPos)))

                    anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
                    anim.toValue = finalPos
                    anim.delegate = self
                    anim.setValue(missile, forKey: "parent")
                    anim.setValue(anim.toValue, forKey: "finalPos")
                    anim.isRemovedOnCompletion = false
                    anim.fillMode = kCAFillModeForwards
                    
                    missile.layer.add(anim, forKey: "position")
                }
            }
        }
    }
    
    func startGameTimer() {
        
        // Check collisions 50 times per seconds
        collisionTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { _ in
            self.checkForCollisions()
        })
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.timeLeft -= 1
            self.headerView.timerLabel.text = String("\(Int(self.timeLeft)) s")
            
            if self.timeLeft <= 0 {
                self.endGame()
            }
        })
    }
    
    func endGame() {
        pauseGame()
        activateShield(10.0)
        
        if let vc = UIStoryboard(name:"Dialogue", bundle:nil).instantiateInitialViewController() as? DialogueViewController {
            self.oneProfil.sceneActuelle += 1
            self.oneProfil.statsConsole["pourcentage"] = 100 - (100 * self.oneProfil.statsConsole["missileHit"]! / nbrMissile)
            vc.oneProfil = self.oneProfil
            self.saveMyData()
            UIView.animate(withDuration: 7, delay: 0, options: .transitionCrossDissolve, animations: {
                self.backgroundMusicPlayer.setVolume(0, fadeDuration: 6)
                self.view.alpha = 0
            } , completion: { _ in
                self.backgroundMusicPlayer.stop()
                self.present(vc, animated: false, completion: nil)
            })
        }else {
            print("Could not instantiate view controller with identifier of type DialogueViewController")
            return
        }
    }
    
    func startSpawners() {
        
        if oneProfil.classeJoueur == "Hacker" {
            startHacking()
        }
        
        startMissileSpawner()
        startHealSpawner()
        startBonusSpawner()
        
    }
    
    func startHacking() {
        
        spawnerTimers["hacker"] = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            
            if drand48() < 0.1 {
                self.explode(self.missileViews[Int(arc4random_uniform(UInt32(self.missileViews.count)))], hacked: true)
            }
            
        })
        
    }

    func startMissileSpawner() {
        
        spawnerTimers["missile"] = Timer.scheduledTimer(withTimeInterval: (timeLeft/gameDuration + 0.1) * speedFactor, repeats: false, block: { _ in
            
            if self.gameIsPaused {
                return
            }
            
            self.spawnMissile()
            self.nbrMissile += 1
            self.spawnFromTop = !self.spawnFromTop
            
            self.startMissileSpawner()
        })
        
    }
    
    func startHealSpawner() {
        
        spawnerTimers["heal"] = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            
            if drand48() < self.numberOfHeals / self.gameDuration {
                self.spawnHeal()
            }
            
        })
    }
    
    func startBonusSpawner() {
        
        spawnerTimers["bonus"] = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            
            if drand48() < self.numberOfBonus / self.gameDuration {
                self.spawnBonus()
            }
            
        })
        
    }
    
    func spawnBonus() {
        
        var y:CGFloat
        
        if spawnFromTop {
            y = -spaceship.bounds.width/2
        } else {
            y = view.bounds.height
        }
        
        let spawnPoint =  CGPoint(x: CGFloat(drand48()) * (view.frame.width - spaceship.bounds.width/2), y: y)
        let bonus = UIImageView(frame: CGRect(x: spawnPoint.x, y: spawnPoint.y, width: spaceship.bounds.width/2, height: spaceship.bounds.width/2))
        bonus.tag = Int(arc4random_uniform(UInt32(bonusList.count)))
        
        var finalY = -bonus.bounds.height
        
        if spawnFromTop {
            finalY = view.bounds.height
        }
        
        bonusViews.append(bonus)
        view.addSubview(bonus)
        
        bonus.loadGif(name: "SpaceBonus", completion: { _ in
            UIView.animate(withDuration: (drand48() * 2 + 1) * self.speedFactor, delay: 0, options: [.curveEaseIn], animations: { _ in
                
                bonus.frame.origin.y = finalY
                
            }, completion: { (finished) in
                
                if finished && bonus.tag != 10{
                    self.bonusViews.remove(at: self.bonusViews.index(of: bonus)!)
                    bonus.removeFromSuperview()
                }
                
            })
        })
    }
    
    func spawnHeal() {

        let size: CGSize
        
        if oneProfil.classeJoueur == "Geek" {
            size = spaceship.bounds.size
        } else {
            size = CGSize(width: spaceship.bounds.width/2, height: spaceship.bounds.width/2)
        }
        
        let healView = UIImageView(frame: CGRect(origin: CGPoint(x:0,y:0), size: size))
        healView.loadGif(name: "SpaceHeal")
        healView.alpha = 0
        
        healViews.append(healView)
        view.addSubview(healView)
        
        UIView.animate(withDuration: 1, animations: { _ in
            healView.alpha = 1
        })
        
        let path = UIBezierPath()
        
        let startX = CGFloat(drand48()) * view.bounds.width
        
        path.move(to: CGPoint(x:startX,y:0))
        
        let endX = view.bounds.width - startX
        
        let x1: CGFloat!
        let x2: CGFloat!
        
        if startX > view.bounds.midX {
            x1 = -(startX / view.bounds.width) * view.bounds.width * 2
            x2 = view.bounds.width + (startX / view.bounds.width) * view.bounds.width * 2
        } else {
            x1 = view.bounds.width + (endX / view.bounds.width) * view.bounds.width * 2
            x2 = -(endX / view.bounds.width) * view.bounds.width * 2
        }
        
        path.addCurve(to: CGPoint(x:endX,y:view.bounds.height), controlPoint1: CGPoint(x:x1,y:view.bounds.height * 0.25), controlPoint2: CGPoint(x:x2,y:view.bounds.height * 0.75))

        
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.path = path.cgPath
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.duration = 3 * speedFactor
        anim.setValue(path.cgPath, forKey: "path")
        
        healView.layer.add(anim, forKey: "position")
        
        Timer.scheduledTimer(withTimeInterval: anim.duration * 2/3, repeats: false, block: { _ in
            
            // Impossible avec delay car les instructions contenues dans le block sont exécutées instantanément
            if healView.tag != 10 {
                UIView.animate(withDuration: anim.duration * 1/3, animations: { _ in
                    healView.alpha = 0
                }, completion: { _ in
                    self.healViews.remove(at: self.healViews.index(of: healView)!)
                    healView.removeFromSuperview()
                })
            }
            
        })
    }
    
    func spawnMissile() {
        
        var y:CGFloat
        
        if spawnFromTop {
            y = -missileSize.height
        } else {
            y = view.bounds.height
        }
        
        let spawnPoint =  CGPoint(x: CGFloat(drand48()) * (view.frame.width - missileSize.width), y: y)
        let missile = UIImageView(frame: CGRect(origin: spawnPoint, size: missileSize))
        
        missile.loadGif(name: "AlienMissile")
        
        var angle:CGFloat = 0
        var decalage = (spaceship.bounds.midY + missile.bounds.midY) * 0.7
        
        if !spawnFromTop {
            decalage = -decalage
            angle = CGFloat(Double.pi)
        }
        
        missile.transform = CGAffineTransform(rotationAngle: angle)
        
        missileViews.append(missile)
        view.addSubview(missile)

        let anim = CABasicAnimation(keyPath: "position.y")
        
        if snails {
            anim.duration = 10
        } else {
            anim.duration = (drand48() * 2 + 2) * speedFactor
        }
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        anim.toValue = view.center.y - decalage
        anim.delegate = self
        anim.setValue(missile, forKey: "parent")
        anim.setValue(anim.toValue, forKey: "finalPos")
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        
        missile.layer.add(anim, forKey: "position")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            let missile = anim.value(forKey: "parent") as! UIImageView

            missile.center.y = anim.value(forKey: "finalPos") as! CGFloat

            explode(missile)
        }
    }
    
    func explode(_ missile: UIImageView, hacked: Bool = false) {
        
        guard missile.tag != 10 else {
            return
        }
        
        if let pres = missile.layer.presentation() {
            
            missile.tag = 10
            
            let explosionView = UIImageView(frame: CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: missile.bounds.height*2, height: missile.bounds.height*2)))
            explosionView.center = CGPoint(x: pres.position.x, y: pres.position.y)
            if bruit == 0 {
                self.bruitageMusicPlayer1 = GestionBruitage(filename: "Explosion", volume: 0.8)
                bruit += 1
            } else if bruit == 1{
                self.bruitageMusicPlayer2 = GestionBruitage(filename: "Explosion", volume: 0.8)
                bruit += 1
            } else {
                self.bruitageMusicPlayer3 = GestionBruitage(filename: "Explosion", volume: 0.8)
                bruit = 0
            }
            view.addSubview(explosionView)
            explosionView.loadGif(name: "Explosion", completion: { _ in
                let duration = CFTimeInterval(UIImage.lastLoadedGIFDuration)
                
                missile.layer.removeAnimation(forKey: "position")
                
                if !hacked {
                    self.manageExplosionDamages(explosionView.frame)
                }
                
                UIView.animate(withDuration: 0.5, animations: { _ in
                    missile.alpha = 0
                }, completion: { _ in
                    self.missileViews.remove(at: self.missileViews.index(of: missile)!)
                    missile.removeFromSuperview()
                })
                
                Timer.scheduledTimer(withTimeInterval: duration / 1000, repeats: false, block: { _ in
                    explosionView.removeFromSuperview()
                })
            })
        }
    }
    
    func manageExplosionDamages(_ explosion: CGRect) {
        
        let aoeWidth = explosion.width / 3
        
        if spaceship.center.x > explosion.midX - aoeWidth && spaceship.center.x < explosion.midX + aoeWidth {
            
            let distance = abs(explosion.midX - spaceship.center.x)
            
            let damage =  (aoeWidth - distance) / aoeWidth * 2 + 1
            self.oneProfil.statsConsole["missileHit"]! += 1
            looseHealth(Int(round(damage)))
        }
    }
    
    func looseHealth(_ amount: Int) {
        
        guard shield.isHidden else {
            return
        }
        
        if oneProfil.classeJoueur == "Noob" {
            if drand48() < 0.2 {
                bonusBomb()
            }
        }
        
        changeColorLabelBad(label: headerView.lifePointLabel)
        oneProfil.lifePoint -= amount
        headerView.lifePointLabel.text = "\(oneProfil.lifePoint) PV"
        activateShield(1.0 * speedFactor)
        
    }
    
    func activateShield(_ duration: Double) {
        
        shield.alpha = 0.5
        
        shield.tag = 10
        
        shield.isHidden = false
        
        Timer.scheduledTimer(withTimeInterval: TimeInterval(duration * 1/3), repeats: false, block: { _ in
            
            var tickCount = 2.0

            self.shield.tag = 0
            self.shield.alpha = 0
            Timer.scheduledTimer(withTimeInterval: TimeInterval(Double(duration * 2/3) / tickCount), repeats: true, block: { timer in

                guard self.shield.tag == 0 else {
                    timer.invalidate()
                    return
                }
                
                self.shield.alpha = abs(self.shield.alpha - 0.5)

                tickCount -= 1
                if tickCount <= 0 {
                    self.shield.isHidden = true
                    timer.invalidate()
                }
            })
            
        })
        
    }
    
    func checkForCollisions() {
        
        
        for healView in healViews {
            
            if let pres = healView.layer.presentation() {
                
                let points = [pres.frame.origin,
                              CGPoint(x: pres.frame.origin.x, y: pres.frame.origin.y + pres.frame.height),
                              CGPoint(x: pres.frame.origin.x + pres.frame.width, y: pres.frame.origin.y),
                              CGPoint(x: pres.frame.origin.x + pres.frame.width, y: pres.frame.origin.y + pres.frame.height)]
                
                
                
                for point in points {
                    if spaceship.frame.contains(point) {
                        
                        onCollision(healView)
                        break
                    }
                }

            }
        }
        
        for bonusView in bonusViews {
            
            if let pres = bonusView.layer.presentation() {
                
                let points = [pres.frame.origin,
                              CGPoint(x: pres.frame.origin.x, y: pres.frame.origin.y + pres.frame.height),
                              CGPoint(x: pres.frame.origin.x + pres.frame.width, y: pres.frame.origin.y),
                              CGPoint(x: pres.frame.origin.x + pres.frame.width, y: pres.frame.origin.y + pres.frame.height)]
                
                
                
                for point in points {
                    if spaceship.frame.contains(point) {
                        
                        onCollision(bonusView)
                        break
                    }
                }
                
            }
        }
    }
    
    func onCollision(_ itemTouched: UIImageView) {
        
        guard itemTouched.tag != 10 else {
            return
        }
        
        if healViews.contains(itemTouched) {
            
            guard itemTouched.layer.presentation() != nil else {
                return
            }
            
            let anim = CAKeyframeAnimation(keyPath: "position")
            
            let oldPath = itemTouched.layer.animation(forKey: "position")?.value(forKey: "path") as! CGPath
            let finalPoint = oldPath.currentPoint

            let newX: CGFloat!
            if finalPoint.x > view.bounds.midX {
                newX = 0 - finalPoint.x
            } else {
                newX = view.bounds.width + finalPoint.x
            }
            
            let path = UIBezierPath()
            path.move(to: itemTouched.layer.presentation()!.frame.origin)
            path.addQuadCurve(to: headerView.lifePointLabel.center, controlPoint: CGPoint(x: newX, y: finalPoint.y))
            
            anim.path = path.cgPath
            anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            anim.duration = 3 * speedFactor
            
            itemTouched.layer.removeAnimation(forKey: "position")
            itemTouched.layer.add(anim, forKey: nil)
            self.gainHealth(3)
            bonusBruitageMusicPlayer = GestionBruitage(filename: "Bonus", volume: 1)

            UIView.animate(withDuration: anim.duration * 1/3, delay: anim.duration * 2/3, animations: { _ in
                itemTouched.alpha = 0
            }, completion: { _ in
                self.healViews.remove(at: self.healViews.index(of: itemTouched)!)
                itemTouched.removeFromSuperview()
            })
        } else if bonusViews.contains(itemTouched) {
            bonusBruitageMusicPlayer = GestionBruitage(filename: "Bonus", volume: 1)
            UIView.animate(withDuration: 1, animations: { _ in
                itemTouched.alpha = 0
            }, completion: { _ in
                self.bonusViews.remove(at: self.bonusViews.index(of: itemTouched)!)
                itemTouched.removeFromSuperview()
            })
            
            drawMessage(bonusList[itemTouched.tag].desc)
            bonusList[itemTouched.tag].func()
        }
        
        itemTouched.tag = 10
    }
    
    func gainHealth(_ amount: Int) {
        changeColorLabelGood(label: headerView.lifePointLabel)
        oneProfil.lifePoint += amount
        headerView.lifePointLabel.text = "\(oneProfil.lifePoint) PV"
    }
    
    func drawMessage(_ msg: String) {
        let label = UILabel(frame: CGRect(x: 0, y: view.bounds.height * 0.15, width: view.bounds.width, height: view.bounds.height/10))
        label.text = msg
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 15
        label.layer.shadowOpacity = 1.0
        
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: label.bounds.width, height: label.bounds.height))
        label.layer.shadowPath = shadowPath.cgPath
        
        label.textAlignment = .center
        label.setupLabelDynamicSize(fontSize: 18)
        label.textColor = .white
        label.alpha = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        
        
        self.view.addSubview(label)
        UIView.animate(withDuration: 1, animations: {_ in
            label.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            label.alpha = 1
        },completion: {_ in
            UIView.animate(withDuration: 3, animations: {_ in
                label.alpha = 0
            }, completion: {_ in
                label.removeFromSuperview()
            })
        })
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveMyData(){
        var maData = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        maData.appendPathComponent("saveGame")
        NSKeyedArchiver.archiveRootObject(self.oneProfil, toFile: maData.path)
    }
    
    func hideModal() {
        bruitageMusicPlayer1 = GestionBruitage(filename: "Clik", volume : 1)
        for subview in self.view.subviews {
            
            guard subview is UIVisualEffectView else {
                continue
            }
            
            UIView.animate(withDuration: 1, animations: {_ in
                self.pageViewController.view.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                subview.alpha = 0
            }, completion: { _ in
                self.pageViewController.view.removeFromSuperview()
                subview.removeFromSuperview()
                self.spawnSpaceship()
                self.startGame()
            })
        }
    }
    
    func viewControllerAtIndex(index: Int) -> ContentConsoleViewController {
        
        if pageViewLabels.count == 0 || index >= pageViewLabels.count {
            return ContentConsoleViewController()
        }
        
        let vc:ContentConsoleViewController = storyboard?.instantiateViewController(withIdentifier: "ContentConsoleViewController") as! ContentConsoleViewController
        
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
        
        let vc = viewController as! ContentConsoleViewController
        var index = vc.pageIndex as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentConsoleViewController
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
