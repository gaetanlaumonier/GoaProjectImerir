//
//  RangementViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 12/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class RangementViewController: UIViewController {

    @IBOutlet var Conteneurs: [UIImageView]!
    @IBOutlet var scoreLabel: DesignableLabel!
    
    var playerClass = "Geek"
    var noob = false
    var animationMultiplier:CFTimeInterval = 1
    
    var detritus = ["Boulette", "Poussiere", "Salete"]
    var vetements = ["Chaussette1", "Chaussette2", "Jean", "T-shirt"]
    var jouets = ["ChienPeluche", "Girafe", "LaserGun", "Ourson", "RubiksCube", "Train"]
    
    var objectSize = CGSize(width: 100, height: 100)
    
    var objets:[String]!
    var objetViews = [Objet]()
    var bonusList = [AnyClass]()
    
    var score = 0
    var gameDuration = 60.0
    var timeLeft = 60.0
    var slowGameFactor = 1.0
    
    var originalSize:CGFloat!
    
    var endGameTimer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startGame()
    }
    
    func initGame() {
        objets = detritus + vetements + jouets
        bonusList = [FreezeTime.self, FreezeObjects.self, SlowTime.self, ScoreUp.self, ScoreDown.self, SomeHelp.self]
        initPlayerClass()
        timeLeft = gameDuration
    }
    
    func startGame() {
        originalSize = scoreLabel.fontSize
        spawnObject(nombre: 5)
        spawnBonusLoop()
        startEndTimer()
    }
    
    func startEndTimer() {
        endGameTimer = Timer.scheduledTimer(withTimeInterval: 0.1 * slowGameFactor, repeats: true, block: {_ in
            if self.timeLeft > 0 {
                self.timeLeft -= 0.1
            } else {
                self.endGame()
            }
        })
    }
    
    func endGame() {
        endGameTimer.invalidate()
    }
    
    func initPlayerClass() {
        
        if playerClass == "Fonctionnaire" {
            gameDuration = gameDuration * 1.4
            animationMultiplier = 2
        } else if playerClass == "Geek" {
            objectSize = CGSize(width: 150, height: 150)
        } else if playerClass == "Noob" {
            noob = true
        } else if playerClass == "Hacker" {
            startHacking()
        }
        
    }

    func spawnObject(nombre: Int = 1) {
        for _ in 1...nombre {
            let pos = getValidPosition()
            let imageView = getRandomObject()
            
            imageView.frame.size = objectSize
            imageView.center = pos

            imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.alpha = 0
            
            view.insertSubview(imageView, aboveSubview: Conteneurs[1])

            objetViews.append(imageView)
            animateIn(objet: imageView)
        }
    }
    
    func getValidPosition() -> CGPoint {
        let x = Int(objectSize.width/2) + Int(arc4random_uniform(UInt32(view.bounds.width - objectSize.width)))
        let y = Int(objectSize.height/2) + Int(arc4random_uniform(UInt32(view.bounds.height - objectSize.height)))
        
        let point = CGPoint(x: x, y: y)
        
        for conteneur in Conteneurs {
            
            if conteneur.frame.contains(point){
                return getValidPosition()
            }
        }

        return point
    }
    
    func getRandomObject() -> Objet {
        let index = Int(arc4random_uniform(UInt32(objets.count)))
        let objet =  Objet(image: UIImage(named: objets[index]))
        objet.isExclusiveTouch = true
        objet.isUserInteractionEnabled = true
        addTag(objet: objet, type: objets[index])
        return objet
    }
    
    func addTag(objet: Objet, type: String) {
        if jouets.contains(type){
            objet.tag = 1
        } else if vetements.contains(type){
            objet.tag = 2
        } else {
            objet.tag = 3
        }
    }
    
    func onObjectDropped(objet: Objet) {
        if let conteneur = isInContainer(objet: objet) {
            if isInGoodContainer(objet: objet, conteneur: conteneur) {
                onValidContainer(objet: objet)
            } else {
                onInvalidContainer(objet: objet)
            }
        } else {
            startWiggling(objet: objet)
        }
    }
    
    func isInContainer(objet: Objet) -> UIImageView? {
        for conteneur in Conteneurs {
            if conteneur.frame.contains(objet.center) {
                return conteneur
            }
        }
        
        return nil
    }
    
    func isInGoodContainer(objet: Objet, conteneur: UIImageView) -> Bool {
        return objet.tag == conteneur.tag
    }
    
    func onValidContainer(objet: Objet) {
        score += 1
        updateScore()
        animateOut(objet: objet)
    }
    
    func onInvalidContainer(objet: Objet) {
        if noob {
            if drand48() < 0.33 {
                if let conteneur = getContainerOf(objet: objet) {
                    objet.isUserInteractionEnabled = false
                    let position = CGPoint(x: conteneur.center.x - objet.bounds.midX, y: conteneur.center.y - objet.bounds.midY)
                    animateTo(objet: objet, position: position, completion: {_ in
                        self.onValidContainer(objet: objet)
                    })
                    return
                }
            }
        }
        score -= 1
        updateScore()
        animateTo(objet: objet, position: objet.previousPosition, completion: {(finished: Bool) in
            if finished {
                objet.isMoving = false
                objet.isWiggling = true
                self.startWiggling(objet: objet)
            }
        })
    }
    
    func getContainerOf(objet: Objet) -> UIImageView? {
        for conteneur in Conteneurs {
            if conteneur.tag == objet.tag {
                return conteneur
            }
        }
        return nil
    }
    
    func animateTo(objet: Objet, position: CGPoint, duration: CFTimeInterval = 0.5, options: UIViewAnimationOptions = [.allowUserInteraction, .curveEaseOut] ,completion: ((Bool) -> Swift.Void)? = nil) {
        
        UIView.animate(withDuration: duration * animationMultiplier, delay: 0, options: options, animations: {_ in
            objet.frame.origin = position
            objet.isMoving = true
            objet.isWiggling = false
        }, completion: completion)
        
    }
    
    func animateOut(objet: Objet) {
        UIView.animate(withDuration: 1 * animationMultiplier, delay: 0, options: [.allowUserInteraction], animations: {_ in
            objet.isDying = true
            objet.isUserInteractionEnabled = false
            objet.isWiggling = false
            objet.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: { (finished: Bool) in
            if finished {
                self.objetViews.remove(at: self.objetViews.index(of: objet)!)
                objet.removeFromSuperview()
                self.spawnObject()
            }
        })
    }
    
    func animateIn(objet: Objet) {
        UIView.animate(withDuration: 1 * animationMultiplier, delay: animationMultiplier/2 , options: [.allowUserInteraction], animations: {_ in
            objet.isSpawning = true
            objet.alpha = 1
        }, completion: {_ in
            objet.isSpawning = false
            if !objet.isGrabbed && !objet.isDying && !objet.isMoving {
                self.startWiggling(objet: objet)
            }
        })
    }
    
    func startHacking() {
        let interval = self.gameDuration/4
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            if drand48() < 1/interval {
                
                let index = Int(arc4random_uniform(UInt32(self.objetViews.count)))
                let objet = self.objetViews[index]
                
                if objet.isGrabbed || objet.isSpawning || objet.isDying {
                    return
                }
                
                if let conteneur = self.getContainerOf(objet: objet) {
                    
                    objet.frame = objet.layer.presentation()!.frame
                    
                    let position = CGPoint(x: conteneur.center.x - objet.bounds.midX, y: conteneur.center.y - objet.bounds.midY)
                    objet.layer.removeAllAnimations()
                    objet.isUserInteractionEnabled = false
                    self.stopWiggling(objet: objet)
                    self.animateTo(objet: objet, position: position, completion: {(finished: Bool) in
                        
                        if finished {
                            self.onValidContainer(objet: objet)
                        }
                        
                    })
                }
            }
        })
    }
    
    func startWiggling(objet: Objet) {
        if objet.wiggleTimer == nil {
            
            if !objet.isFrozen && !objet.isGrabbed {
                objet.wiggleTimer = Timer.scheduledTimer(withTimeInterval: 0, repeats: false, block: {_ in
                    self.keepWiggling(objet: objet)
                })
            }
        }
    }
    
    func keepWiggling(objet: Objet) {
        if objet.wiggleTimer != nil {
                let point = self.getValidPosition()
                objet.isWiggling = true
                
                UIView.animate(withDuration: objet.wiggleSpeed * animationMultiplier, delay: 0, options: [.allowUserInteraction, .curveLinear], animations: {_ in
                    objet.center = point
                    objet.isMoving = true
                    objet.isWiggling = false
                }, completion: { (finished: Bool) in
                    if finished {
                        self.keepWiggling(objet: objet)
                    }
                    objet.isMoving = false
                })
            }
    }
    
    func stopWiggling(objet: Objet) {
        if objet.wiggleTimer != nil {
            objet.isWiggling = false
            objet.wiggleTimer.invalidate()
            objet.wiggleTimer = nil
        }
    }
    
    func updateScore() {
        scoreLabel.fontSize = originalSize + CGFloat(score) / 10
        scoreLabel.text = String(score)
    }
    
    func onBonusPicked(sender: Bonus) {
        sender.onBonusPicked()
    }
    
    func freezeTime() {
        endGameTimer.invalidate()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {_ in
            self.startEndTimer()
        })
    }
    
    func slowTime() {
        slowGameFactor = 2
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {_ in
            self.slowGameFactor = 1
        })
    }
    
    func scoreUp(score: Int) {
        self.score += score
        updateScore()
    }
    
    func scoreDown(score: Int) {
        self.score -= score
        updateScore()
    }
    
    func freezeObjects() {
        var actualObjs = [Objet]()
        for obj in objetViews {
            if !obj.isDying {
                actualObjs.append(obj)
                obj.isWiggling = false
                self.stopWiggling(objet: obj)
                obj.isFrozen = true
                obj.layer.removeAllAnimations()
                obj.frame = obj.layer.presentation()!.frame
            }
        }
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: {_ in
            for obj in actualObjs {
                if self.view.subviews.contains(obj) {
                    obj.isFrozen = false
                    self.startWiggling(objet: obj)
                }
            }
        })
    }
    
    func someHelp() {
        for objet in objetViews {
            
            if objet.isDying {
                continue
            }
            
            if let conteneur = self.getContainerOf(objet: objet) {
                objet.frame = objet.layer.presentation()!.frame
                
                let position = CGPoint(x: conteneur.center.x - objet.bounds.midX, y: conteneur.center.y - objet.bounds.midY)
                objet.isMoving = true
                objet.layer.removeAllAnimations()
                objet.isUserInteractionEnabled = false
                self.stopWiggling(objet: objet)
                self.animateTo(objet: objet, position: position, completion: {(finished: Bool) in
                    
                    if finished {
                        
                        self.onValidContainer(objet: objet)
                    }
                    
                })
            }
        }
    }
    
    func drawMessage(bonus: Bonus) {
        let label = UILabel(frame: CGRect(x: 0, y: bonus.frame.origin.y, width: self.view.bounds.width, height: 30))
        label.text = bonus.msg
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 15
        label.layer.shadowOpacity = 1.0
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: label.bounds.width, height: label.bounds.height))
        label.layer.shadowPath = shadowPath.cgPath
        
        label.textAlignment = .center
        label.setupLabelDynamicSize(fontSize: 20)
        label.textColor = bonus.color
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
    
    func spawnBonusLoop() {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: {_ in
            if drand48() < 0.5 {
                self.spawnRandomBonus()
            }
        })
    }
    
    func spawnRandomBonus() {
        let count = bonusList.count
        let bonusClass = bonusList[Int(arc4random_uniform(UInt32(count)))] as! Bonus.Type
        
        let rect = CGRect(origin: CGPoint(x:0,y:0), size: self.objectSize)
        
        let bonus = bonusClass.init(frame: rect)
        bonus.center = self.getValidPosition()
        bonus.alpha = 0
        bonus.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        bonus.setImage(#imageLiteral(resourceName: "Bonus"), for: .normal)
        self.view.addSubview(bonus)
        self.animateBonus(bonus: bonus)
    }
    
    func animateBonus(bonus: Bonus){
        UIView.animate(withDuration: 2, delay: 0, options: [.allowUserInteraction, .autoreverse], animations: {_ in
            
            bonus.alpha = 1
            bonus.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }, completion:{(finished: Bool) in
            
            if finished {
                bonus.removeFromSuperview()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
