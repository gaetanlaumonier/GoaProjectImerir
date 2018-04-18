//
//  CookieViewController.swift
//  CookieArcade
//
//  Created by Student on 21/01/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import AVFoundation

class CookieViewController: UIViewController, CAAnimationDelegate, UIPageViewControllerDataSource {
    
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var cookie: UIImageView!
    @IBOutlet var background: UIImageView!
    @IBOutlet var mom: UIImageView!
    @IBOutlet var sad: UIImageView!
    @IBOutlet var happy: UIImageView!
    @IBOutlet weak var headerView: HeaderView!
    
    var pageViewController:UIPageViewController!
    var pageViewLabels:[String]!
    var pageViewImages:[String]!
    var pageViewTitles:[String]!
    var pageViewHints:[String]!
    var decreaseTimer = Timer()
    var myTimer : Timer!
    var progress:Float = 0.5
    var isMomWatching = false
    var momInterval:TimeInterval!
    var gameDurationTotal:TimeInterval = 60
    var gameTimer : Int = 0
    var noob = false
    var geek = false
    var progressDecrease:Float = 0.002
    var AllClasse = [ClasseJoueur()]
    var idClasse : Int = 0
    var oneProfil = ProfilJoueur()
    
    var hfromLeft = true
    var sfromLeft = true
    var gamePause : Bool = false
    var bruitageMusicPlayer = AVAudioPlayer()
    var cookieTaped : Int = 0
    
    var embedViewController:EmbedViewController!
    var achievementTimer = Timer()
    var arcadeMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        embedViewController = getEmbedViewController()
        embedViewController.backgroundMusicPlayer = GestionMusic(filename: "MadScientist")
        mom.loadGif(name: "Maman")
        
        cookie.layer.cornerRadius = cookie.frame.size.width/2
        progressBar.transform = CGAffineTransform(scaleX: 1.0, y: UIScreen.main.bounds.width/40)
        
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
            break
        default:
            break
        }
    }
    
    func initPageView() {
        pageViewLabels = ["Ce cookie ci-dessus est ton objectif. Clique dessus le plus rapidement possible.", "Evite absolument de cliquer quand la maman te regarde !","Rempli au maximum la jauge vers la droite pour éviter de perdre de la vie.", "Avec la classe \(self.oneProfil.classeJoueur), \(AllClasse[idClasse].arcadeCookie as String)"]
        pageViewImages = ["Cookie", "Mom","progressBar", "\(AllClasse[idClasse].idClasse as String)"]
        pageViewTitles = ["Le gâteau","La mère","La barre d'humeur", "\(AllClasse[idClasse].idClasse as String)"]
        pageViewHints = ["Les bébés aussi ont plusieurs doigts.", "Clique sur le cookie quand tu ne vois que ses cheveux.", "Des points de vie te seront retirés sinon.", ""]
        
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "CookiePageViewController") as! UIPageViewController
        
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
    
    
    
    
    
    //// GAME INITIALIZATION ////
    
    // Called in viewDidLoad
    func initGame() {
        
        // Gère les variables a modifier selon la classe du joueur
        initPlayerClass()
        
        //Initialise le headerView
        gameTimer = Int(gameDurationTotal)
        headerView.lifePointLabel.text = "\(self.oneProfil.lifePoint) PV"
        headerView.timerLabel.text = "\(Int(gameDurationTotal)) s"
        
        // Initialise l'interface
        initHUD()
    }
    
    func initPlayerClass() {
        
        if self.oneProfil.classeJoueur == "Fonctionnaire" {
            gameDurationTotal = gameDurationTotal * 1.4
        } else if self.oneProfil.classeJoueur  == "Geek" {
            geek = true
        } else if self.oneProfil.classeJoueur  == "Noob" {
            noob = true
        } else if self.oneProfil.classeJoueur  == "Hacker" {
            progressDecrease = 0.001
        }
    }
    
    func initHUD() {
        updateProgressBar()
        animateSmileys()
    }
    
    // Called on game rules modal closed
    func startGame() {
        // Ajoute la gestion du tap sur le Cookie
        addGestures()
        
        // Lance la boucle qui diminue le score
        decreaseScoreLoop()
        
        // Lance la boucle d'affichage de mom
        hideMom()
        
        // Lance la boucle du timer
        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CookieViewController.TimerGesture), userInfo: nil, repeats: true)
        
        achievementTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.embedViewController.updateAchievement("achievement.cookieclicks", Double(self.oneProfil.statsCookie["cookieGoodTaped"]!) / 100)
            self.embedViewController.updateAchievement("achievement.cookieclicks2", Double(self.oneProfil.statsCookie["cookieGoodTaped"]!) / 200)
        })
    }
    
    func addGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(CookieViewController.cookieClicked))
        
        cookie.isUserInteractionEnabled = true
        cookie.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func decreaseScoreLoop() {
        decreaseTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(CookieViewController.decreaseScore), userInfo: nil, repeats: true)
    }
    
    @objc func decreaseScore() {
        if gamePause == false {
            if progress >= progressDecrease {
                progress -= progressDecrease
            } else if progress > 0 {
                progress = 0
            }
            updateProgressBar()
        }
    }
    
    @objc func TimerGesture(){
        gameTimer -= 1
        headerView.timerLabel.text = "\(Int(gameTimer)) s"
        if gameTimer == 0 {
            myTimer.invalidate()
            endGame()
        }
    }
    
    func updateProgressBar() {
        progressBar.setProgress(progress, animated: true)
        progressBar.progressTintColor = UIColor(red: 1 - CGFloat(progress), green: CGFloat(progress), blue: 0.0, alpha: 1.0)
    }
    
    
    
    //// GAME ENDING ////
    
    func endGame() {
        let finalHealth = Int((progress - 0.5) * 20)
        
        oneProfil.lifePoint += finalHealth
        
        var dialogText = "Tu as rempli \(Int(progress * 100))% de la barre d'humeur.\n\n"
        
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
    
    @objc func returnToDialog() {
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
        
        decreaseTimer.invalidate()
        achievementTimer.invalidate()

        if arcadeMode {
            if let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InitController") as? InitViewController {
                UIView.animate(withDuration: 3, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
                    self.view.alpha = 0
                } , completion: { success in
                    vc.firstMenuForRun = false
                    self.embedViewController.showScene(vc)
                })
            }
        } else {
            if let vc = UIStoryboard(name:"Dialogue", bundle:nil).instantiateInitialViewController() as? DialogueViewController {
                self.oneProfil.sceneActuelle += 1
                if self.cookieTaped != 0 {
                    self.oneProfil.statsCookie["pourcentage"]! = 100 * self.oneProfil.statsCookie["cookieGoodTaped"]! / self.cookieTaped
                } else {
                    self.oneProfil.statsCookie["pourcentage"]! = 0
                }
                
                vc.oneProfil = self.oneProfil
                self.saveMyData()
                UIView.animate(withDuration: 3, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
                    self.view.alpha = 0
                } , completion: { success in
                    self.embedViewController.showScene(vc)
                })
            } else {
                print("Could not instantiate view controller with identifier of type DialogueViewController")
                return
            }
        }
    }
    
    func saveMyData(){
        var maData = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        maData.appendPathComponent("saveGame")
        NSKeyedArchiver.archiveRootObject(self.oneProfil, toFile: maData.path)
    }

    
    
    //// GAME LOGIC ////
    
    @objc func cookieClicked(tapGR: UITapGestureRecognizer){
        if isReallyClicked(tapGR: tapGR){
            cookieTaped += 1
            if isMomWatching {
                changeColorLabelBad(label: headerView.lifePointLabel)
                self.oneProfil.lifePoint -= 1
                headerView.lifePointLabel.text = "\(self.oneProfil.lifePoint) PV"
                if progress > 0.01 {
                    if noob {
                        progress = progress - 0.01 * (Float(arc4random_uniform(2)) + 1.0)
                    } else {
                        progress = progress - 0.01
                    }
                } else if progress > 0 {
                    progress = 0
                }
                
            } else {
                
                if progress < 0.99 {
                    if noob {
                        progress = progress + 0.01 * (Float(arc4random_uniform(2)) + 1.0)
                    } else {
                        progress = progress + 0.01
                    }
                } else if progress < 1 {
                    progress = 1
                }
                
                oneProfil.statsCookie["cookieGoodTaped"]! += 1
            }
            
            drawParticle(at: tapGR.location(in: view))
            animateCookie()
            updateProgressBar()
        }
    }
    
    //// Consider the round shape of the cookie
    func isReallyClicked(tapGR: UITapGestureRecognizer) -> Bool {
        let tap = tapGR.location(in: view)
        let center = cookie.center
        
        let distanceX = center.x - tap.x
        let distanceY = center.y - tap.y
        
        let distance = sqrt((distanceX * distanceX) + (distanceY * distanceY))
        let rayon = cookie.frame.width/2
        
        if distance <= rayon {
            return true
        }
        
        return false
    }
    
    
    
    //// GRAPHICS ////
    
    func animateCookie(){
        
        let anim = CABasicAnimation(keyPath: "transform.scale.x")
        anim.fromValue = 1
        anim.toValue = 0.9
        anim.duration = 0.18
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.autoreverses = true
        
        let anim2 = CABasicAnimation(keyPath: "transform.scale.y")
        anim2.fromValue = 1
        anim2.toValue = 0.9
        anim2.duration = 0.18
        anim2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim2.autoreverses = true
        
        if geek {
            anim.toValue = 0.8
            anim2.toValue = 0.8
        }
        
        cookie.layer.add(anim, forKey: nil)
        cookie.layer.add(anim2, forKey: nil)
    }
    
    func drawParticle(at: CGPoint) {
        
        let particle = UIImageView(frame: CGRect(x: at.x, y: at.y, width: view.bounds.width/10, height: view.bounds.width/10))
        
        if isMomWatching {
            
            particle.image = UIImage(named: "Sad")
            
        } else {
            
            particle.image = UIImage(named: "Happy")
            
        }
        
        let anim = CABasicAnimation(keyPath: "position")
        anim.fromValue = NSValue(cgPoint: at)
        let destination = randomPos(origin: at)
        anim.toValue = NSValue(cgPoint: destination)
        
        let anim2 = CABasicAnimation(keyPath: "opacity")
        anim2.fromValue = 1
        anim2.toValue = 0
        
        let group = CAAnimationGroup()
        group.animations = [anim, anim2]
        group.duration = 0.5
        group.delegate = self
        group.setValue(particle, forKey: "particle")
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        view.addSubview(particle)
        
        particle.layer.opacity = 0
        
        particle.layer.add(group, forKey: nil)
        
    }
    
    // Give a random ending position for drawing particle
    func randomPos(origin: CGPoint) -> CGPoint {
        var decalageY:CGFloat = 1
        if isMomWatching { decalageY = -1 }
        
        let posX = origin.x + CGFloat(CGFloat(arc4random_uniform(UInt32(CGFloat(view.bounds.width/5.0)))) - view.bounds.width/10.0)
        let posY = origin.y + (abs(posX - origin.x) - view.bounds.width/8.0) * decalageY
        
        return CGPoint(x: posX, y: posY)
    }
    
    // Remove particles when animation is finished
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            if let imageView = anim.value(forKey: "particle") as? UIImageView {
                imageView.removeFromSuperview()
            }
        }
    }
    
    
    
    //// Monkeys in progressView animations ////
    
    func animateSmileys() {
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CookieViewController.animateSmileysScale), userInfo: nil, repeats: true)
        
        animateSmileysRotate()
    }
    
    @objc func animateSmileysScale() {
        
        let anim = CABasicAnimation(keyPath: "transform.scale.x")
        anim.fromValue = 1
        anim.toValue = 0.9
        anim.duration = 0.5
        anim.autoreverses = true
        
        let anim2 = CABasicAnimation(keyPath: "transform.scale.y")
        anim2.fromValue = 1
        anim2.toValue = 0.9
        anim2.duration = 0.5
        anim2.autoreverses = true
        
        happy.layer.add(anim, forKey: nil)
        happy.layer.add(anim2, forKey: nil)
        
        sad.layer.add(anim, forKey: nil)
        sad.layer.add(anim2, forKey: nil)
    }
    
    func animateSmileysRotate() {
        animateHappyRotate()
        animateSadRotate()
    }
    
    @objc func animateHappyRotate() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.fromValue = 0
        
        if hfromLeft {
            hfromLeft = !hfromLeft
            anim.toValue = Double.pi / 4
        } else {
            hfromLeft = !hfromLeft
            anim.toValue = -Double.pi / 4
        }
        
        anim.duration = drand48() / 2 + 0.5
        anim.autoreverses = true
        
        happy.layer.add(anim, forKey: nil)
        
        Timer.scheduledTimer(timeInterval: anim.duration * 2, target: self, selector: #selector(CookieViewController.animateHappyRotate), userInfo: nil, repeats: false)
    }
    
    @objc func animateSadRotate() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.fromValue = 0
        
        if sfromLeft {
            sfromLeft = !sfromLeft
            anim.toValue = Double.pi / 4
        } else {
            sfromLeft = !sfromLeft
            anim.toValue = -Double.pi / 4
        }
        
        anim.duration = drand48() / 2 + 0.5
        anim.autoreverses = true
        
        sad.layer.add(anim, forKey: nil)
        
        Timer.scheduledTimer(timeInterval: anim.duration * 2, target: self, selector: #selector(CookieViewController.animateSadRotate), userInfo: nil, repeats: false)
    }
    
    
    
    //// MOM ////
    
    @objc func hideMom() {
        isMomWatching = false
        toggleMom(up: false)
        Timer.scheduledTimer(timeInterval: randomInterval(), target: self, selector: #selector(CookieViewController.showMom), userInfo: nil, repeats: false)
    }
    
    @objc func showMom() {
        
        // Wait 1/3s so the player don't loose life instantly
        Timer.scheduledTimer(withTimeInterval: 1/3, repeats: false, block: { _ in
            self.isMomWatching = true
        })
        
        toggleMom(up: true)
        Timer.scheduledTimer(timeInterval: randomInterval(), target: self, selector: #selector(CookieViewController.hideMom), userInfo: nil, repeats: false)
    }
    
    func toggleMom(up: Bool){
        let anim = CABasicAnimation(keyPath: "position.y")
        if up {
            anim.fromValue = mom.layer.position.y + mom.bounds.height
            anim.toValue = mom.layer.position.y
        } else {
            anim.fromValue = mom.layer.position.y
            anim.toValue = mom.layer.position.y + mom.bounds.height
        }
        anim.duration = 1
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        mom.layer.add(anim, forKey: nil)
    }
    
    func randomInterval() -> TimeInterval {
        return TimeInterval(exactly: Float(arc4random()) / Float(UINT32_MAX) * 4 + 1)!
    }
    
    
    
    //// PAGE VIEW ////
    
    @objc func hideModal() {
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
            for subview in self.view.subviews {
                guard subview is UIVisualEffectView else {
                    continue
                }
                
                UIView.animate(withDuration: 1) {
                    self.pageViewController.view.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                }
                
                UIView.animate(withDuration: 3,delay: 0, options: .curveEaseOut ,animations: {
                    subview.alpha = 0
                }, completion: { finished in
                    subview.removeFromSuperview()
                    self.pageViewController.view.removeFromSuperview()
                    self.startGame()
                })
        }
    }
    
    func viewControllerAtIndex(index: Int) -> ContentCookieViewController {
        
        if pageViewLabels.count == 0 || index >= pageViewLabels.count {
            return ContentCookieViewController()
        }
        
        let vc:ContentCookieViewController = storyboard?.instantiateViewController(withIdentifier: "CookieContentViewController") as! ContentCookieViewController
        
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
        
        let vc = viewController as! ContentCookieViewController
        var index = vc.pageIndex as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentCookieViewController
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
