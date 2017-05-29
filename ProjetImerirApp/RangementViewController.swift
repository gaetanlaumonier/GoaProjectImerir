//
//  RangementViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 12/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import AVFoundation

class RangementViewController: UIViewController, UIPageViewControllerDataSource {

    @IBOutlet var Conteneurs: [UIImageView]!
   
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var scoreLabel: DesignableLabel!

    var noob = false
    var animationMultiplier:CFTimeInterval = 1
    var oneProfil = ProfilJoueur()
    
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
    var AllClasse = [ClasseJoueur]()
    var idClasse : Int = 0
    var pageViewController: UIPageViewController!
    var pageViewLabels:[String]!
    var pageViewImages:[String]!
    var pageViewTitles:[String]!
    var pageViewHints:[String]!
    var gamePause : Bool = false
    var backgroundMusicPlayer = AVAudioPlayer()
    var bruitageMusicPlayer = AVAudioPlayer()
    var objInContainer : Int = 0
    var goodObjectInContainer : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.lifePointLabel.text = "\(self.oneProfil.lifePoint) PV"
        headerView.timerLabel.text = "\(Int(gameDuration)) s"
        AllClasse = buildClasseJoueur()
        backgroundMusicPlayer = GestionMusic(filename: "Fantasy")
        backgroundMusicPlayer.volume = 0.8

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
        
        pageViewLabels = ["Cet objet est un de tes objectifs, ton but est de le ranger dans le bon conteneur.", "Les jouets vont dans le coffre, les déchets dans la poubelle et les vêtements dans l'armoire.","Touche une icône \"bonus\" pour voir ce qu'il rapporte.", "Avec la classe \(self.oneProfil.classeJoueur), \(AllClasse[idClasse].arcadeRangement as String)"]
        pageViewImages = ["LaserGun", "CoffreAJouet","Bonus", "\(AllClasse[idClasse].idClasse as String)"]
        pageViewTitles = ["Les Objets","Les Conteneurs","Les Bonus", "\(AllClasse[idClasse].idClasse as String)"]
        pageViewHints = ["Les objets bougent de plus en plus vite.", "Tu perds de la vie quand tu te trompe de conteneur.", "La majorité des bonus a un impact positif.", ""]
        
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "RangementPageViewController") as! UIPageViewController
        
        pageViewController.dataSource = self
        
        let startVC = viewControllerAtIndex(index: 0)
        
        pageViewController.setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        
        var modal = view.frame
        modal.size.width = modal.width*0.75
        modal.size.height = modal.height*0.5
        
        pageViewController.view.frame = modal
        pageViewController.view.center = view.center
        
        
        UIGraphicsBeginImageContext(pageViewController.view.frame.size)
        
        
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
                self.headerView.timerLabel.text = "\(Int(self.timeLeft)) s"
            } else {
                self.endGame()
            }
        })
    }
    
    func scoreGestureFinal(){
        if score <= 20 {
            self.oneProfil.lifePoint -= 15
        } else if score <= 30 {
            self.oneProfil.lifePoint -= 10
        } else if score <= 50 {
            self.oneProfil.lifePoint -= 5
        } else if score <= 70 {
            self.oneProfil.lifePoint -= 2
        }
        
        if score < 71 {
            changeColorLabelBad(label: headerView.lifePointLabel)
            headerView.lifePointLabel.text = "\(self.oneProfil.lifePoint) PV"
        }
    }
    
    func endGame() {
        endGameTimer.invalidate()
        
        let objPerSecond = Double(goodObjectInContainer) / gameDuration
        
        let finalHealth = Int(objPerSecond * 10 - 10)
        
        oneProfil.lifePoint += finalHealth
        
        var dialogText = "Tu as rangé ta chambre à une vitesse de \(String(format: "%.2f", objPerSecond)) objets par seconde.\n\n"
        
        if finalHealth > 0 {
            changeColorLabelGood(label: headerView.lifePointLabel)
            dialogText += "Tu gagnes \(finalHealth) PV !"
        } else if finalHealth < 0 {
            changeColorLabelBad(label: headerView.lifePointLabel)
            dialogText += "Tu perds \(abs(finalHealth)) PV !"
        } else {
            dialogText += "Tu es pile dans la moyenne !"
        }
        headerView.lifePointLabel.text = "\(oneProfil.lifePoint) PV"
        
        let _ = endGamePopup(text: dialogText, onClick: #selector(returnToDialog))
    }
    
    func returnToDialog() {
        if let vc = UIStoryboard(name:"Dialogue", bundle:nil).instantiateInitialViewController() as? DialogueViewController
        {
            UIView.animate(withDuration: 3, delay: 0, options: .transitionCrossDissolve, animations: {
                self.backgroundMusicPlayer.setVolume(0, fadeDuration: 2.5)
                self.view.alpha = 0
            } , completion: { success in
                self.oneProfil.sceneActuelle += 1
                if self.objInContainer != 0 {
                    self.oneProfil.statsRangement["pourcentage"]! = 100 * self.goodObjectInContainer / self.objInContainer
                } else {
                    self.oneProfil.statsRangement["goodClassification"]! = 0
                }
                self.oneProfil.statsRangement["goodClassification"]! = self.goodObjectInContainer
                
                vc.oneProfil = self.oneProfil
                self.saveMyData()
                self.backgroundMusicPlayer.stop()
                self.view.window?.rootViewController = vc
            })
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
    
    func initPlayerClass() {
        
        if self.oneProfil.classeJoueur == "Fonctionnaire" {
            gameDuration = gameDuration * 1.4
            animationMultiplier = 2
        } else if self.oneProfil.classeJoueur == "Geek" {
            objectSize = CGSize(width: 150, height: 150)
        } else if self.oneProfil.classeJoueur == "Noob" {
            noob = true
        } else if self.oneProfil.classeJoueur == "Hacker" {
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
            
            view.insertSubview(imageView, aboveSubview: Conteneurs[0])
            print(objetViews)
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
            objInContainer += 1
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
        goodObjectInContainer += 1
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
        self.oneProfil.lifePoint -= 1
        changeColorLabelBad(label: headerView.lifePointLabel)
        headerView.lifePointLabel.text = "\(self.oneProfil.lifePoint) PV"
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
        UIView.animate(withDuration: 0.5 * animationMultiplier, delay: 0, options: [.allowUserInteraction], animations: {_ in
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
        UIView.animate(withDuration: 1 * animationMultiplier, delay: animationMultiplier - 1 , options: [.allowUserInteraction], animations: {_ in
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
                            self.objInContainer += 1
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
        bruitageMusicPlayer = GestionBruitage(filename: "Bonus", volume: 1)
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
        endGameTimer.invalidate()
        startEndTimer()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {_ in
            self.slowGameFactor = 1
            self.endGameTimer.invalidate()
            self.startEndTimer()
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
                        self.objInContainer += 1
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
        label.setupLabelDynamicSize(fontSize: 18)
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
            
            guard self.endGameTimer.isValid else {
                return
            }
            
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
    
    func hideModal() {
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
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
                self.initGame()
                self.startGame()
            })
        }
    }
    
    func viewControllerAtIndex(index: Int) -> ContentRangementViewController {
        
        if pageViewLabels.count == 0 || index >= pageViewLabels.count {
            return ContentRangementViewController()
        }
        
        let vc:ContentRangementViewController = storyboard?.instantiateViewController(withIdentifier: "ContentRangementViewController") as! ContentRangementViewController
        
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
        
        let vc = viewController as! ContentRangementViewController
        var index = vc.pageIndex as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentRangementViewController
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
