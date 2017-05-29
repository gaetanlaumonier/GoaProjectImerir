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
    var gameDurationTotal:TimeInterval = 30
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
    var backgroundMusicPlayer = AVAudioPlayer()
    var bruitageMusicPlayer = AVAudioPlayer()
    var cookieTaped : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AllClasse = buildClasseJoueur()
        backgroundMusicPlayer = GestionMusic(filename: "MadScientist")
        mom.loadGif(name: "Maman")
        
        cookie.layer.cornerRadius = cookie.frame.size.width/2
        progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 10.0)
        
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
        pageViewLabels = ["Ce cookie ci-dessus est ton objectif. Clique dessus le plus rapidement possible.", "Evite absolument de cliquer quand la maman te regarde !","Rempli au maximum la jauge vers la droite pour éviter de perdre de la vie.", "Avec la classe \(self.oneProfil.classeJoueur), \(AllClasse[idClasse].arcadeCookie as String)"]
        pageViewImages = ["Cookie", "Mom","progressBar", "\(AllClasse[idClasse].idClasse as String)"]
        pageViewTitles = ["Le gâteau","La mère","La barre d'humeur", "\(AllClasse[idClasse].idClasse as String)"]
        pageViewHints = ["Les bébés aussi ont plusieurs doigts.", "Clique sur le cookie quand tu ne voit que ses cheveux.", "Perte de 5 pv si elle n'est pas remplie à moitié à la fin.", ""]
        
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "CookiePageViewController") as! UIPageViewController
        
        pageViewController.dataSource = self
        
        let startVC = viewControllerAtIndex(index: 0)
        
        pageViewController.setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        
        var modal = view.frame
        modal.size.width = modal.width*0.75
        modal.size.height = modal.height*0.5
        
        pageViewController.view.frame = modal
        pageViewController.view.center = view.center
        
        
        UIGraphicsBeginImageContext(pageViewController.view.frame.size)
        UIImage(named: "Background Kid")?.draw(in: pageViewController.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        pageViewController.view.backgroundColor = UIColor(patternImage: image)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.8
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)

        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
        
        initGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        hideMom()
      //  FonduApparition(myView: self, myDelai: 1)
    }
    
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
    
    func startGame() {
        // Ajoute la gestion du tap sur le Cookie
        addGestures()
        
        // Lance la boucle qui diminue le score
        decreaseScoreLoop()
        
        // Lance la boucle d'affichage de mom
        hideMom()
        
       myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CookieViewController.TimerGesture), userInfo: nil, repeats: true)
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
    
    func TimerGesture(){
        gameTimer -= 1
        headerView.timerLabel.text = "\(Int(gameTimer)) s"
        if gameTimer == 0 {
            myTimer.invalidate()
            endGame()
        }
    }
    
    func endGame() {
        if let vc = UIStoryboard(name:"Dialogue", bundle:nil).instantiateInitialViewController() as? DialogueViewController
        {
            if progress <= 0.5 {
            self.oneProfil.lifePoint = self.oneProfil.lifePoint - 5
            changeColorLabelBad(label: headerView.lifePointLabel)
            self.headerView.lifePointLabel.text = "\(self.oneProfil.lifePoint) PV"
            }
            
            decreaseTimer.invalidate()
            self.oneProfil.sceneActuelle += 1
            if cookieTaped != 0 {
            self.oneProfil.statsCookie["pourcentage"]! = 100 * self.oneProfil.statsCookie["cookieGoodTaped"]! / cookieTaped
            } else {
                self.oneProfil.statsCookie["pourcentage"]! = 0
            }

            vc.oneProfil = self.oneProfil
            self.saveMyData()
            UIView.animate(withDuration: 3, delay: 0, options: .transitionCrossDissolve, animations: {
                self.backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
                self.view.alpha = 0
            } , completion: { success in
                self.backgroundMusicPlayer.stop()
            self.present(vc, animated: false, completion: nil)
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

    
    func decreaseScoreLoop() {
        decreaseTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(CookieViewController.decreaseScore), userInfo: nil, repeats: true)
    }
    
    func decreaseScore() {
        if gamePause == false {
        if progress >= progressDecrease {
            progress -= progressDecrease
        } else if progress > 0 {
            progress = 0
        }
        updateProgressBar()
        }
    }
    
    func addGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(CookieViewController.cookieClicked))
        
        cookie.isUserInteractionEnabled = true
        cookie.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func cookieClicked(tapGR: UITapGestureRecognizer){
       cookieTaped += 1
        if isReallyClicked(tapGR: tapGR){
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
             self.oneProfil.statsCookie["cookieGoodTaped"]! += 1
            }
            
            drawParticle(at: tapGR.location(in: view))
            animateCookie()
            updateProgressBar()
        }
    }
    
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
    
    func drawParticle(at: CGPoint) {
        
        let particle = UIImageView(frame: CGRect(x: at.x, y: at.y, width: 40, height: 40))
        
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
    
    func randomPos(origin: CGPoint) -> CGPoint {
        var decalageY:CGFloat = 1
        if isMomWatching { decalageY = -1 }
        
        let posX = origin.x + CGFloat(Int(arc4random_uniform(80)) - 40)
        let posY = origin.y + (abs(posX - origin.x) - 50) * decalageY
        
        return CGPoint(x: posX, y: posY)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            if let imageView = anim.value(forKey: "particle") as? UIImageView {
                imageView.removeFromSuperview()
            }
        }
    }
    
    func initHUD() {
        updateProgressBar()
        animateSmileys()
    }
    
    func updateProgressBar() {
        progressBar.setProgress(progress, animated: true)
        progressBar.progressTintColor = UIColor(red: 1 - CGFloat(progress), green: CGFloat(progress), blue: 0.0, alpha: 1.0)
    }
    
    func animateSmileys() {
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CookieViewController.animateSmileysScale), userInfo: nil, repeats: true)
        
        animateSmileysRotate()
    }
    
    func animateSmileysScale() {
        
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
    
    func animateHappyRotate() {
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
    
    func animateSadRotate() {
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
    
    func hideMom() {
        isMomWatching = false
        toggleMom()
        Timer.scheduledTimer(timeInterval: randomInterval(), target: self, selector: #selector(CookieViewController.showMom), userInfo: nil, repeats: false)
    }
    
    func showMom() {
        isMomWatching = true
        toggleMom()
        Timer.scheduledTimer(timeInterval: randomInterval(), target: self, selector: #selector(CookieViewController.hideMom), userInfo: nil, repeats: false)
    }
    
    func toggleMom(){
        let anim = CABasicAnimation(keyPath: "position.y")
        if isMomWatching {
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