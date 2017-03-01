//
//  ViewController.swift
//  CookieArcade
//
//  Created by Student on 21/01/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit


class ViewController: UIViewController, CAAnimationDelegate, UIPageViewControllerDataSource {
    
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet var cookie: UIImageView!
    @IBOutlet var background: UIImageView!
    @IBOutlet var mom: UIImageView!
    @IBOutlet var sad: UIImageView!
    @IBOutlet var happy: UIImageView!
    
    var pageViewController:UIPageViewController!
    var pageViewLabels:[String]!
    var pageViewImages:[String]!
    var pageViewTitles:[String]!
    var pageViewHints:[String]!
    
    var progress:Float = 0.5
    var isMomWatching = false
    var momInterval:TimeInterval!
    var gameDuration:TimeInterval = 60
    var playerClass = "Fonctionnaire"
    var noob = false
    var geek = false
    var progressDecrease:Float = 0.002
    
    var hfromLeft = true
    var sfromLeft = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cookie.layer.cornerRadius = cookie.frame.size.width/2
        progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 10.0)
        
        pageViewLabels = ["Ce cookie ci-dessus représente ton principal objectif en tant que bébé rebel.", "Mais attention, une personne dont la gentillesse pourrait te parraitre familière ne te laissera pas accéder à ton but si facilement.","Cette jauge représente ta joie d'être bébé, la remplir te rendras moins grincheux"]
        pageViewImages = ["Cookie", "Mom","progressBar"]
        pageViewTitles = ["Le gâteau","La mère","La barre d'humeur"]
        pageViewHints = ["Les bébés aussi ont plusieurs doigts", "Ne clique pas sur le cookie si elle te regarde", ""]
        
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        
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
    }
    
    func initGame() {
        
        // Gère les variables a modifier selon la classe du joueur
        initPlayerClass()
        
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
        
        Timer.scheduledTimer(timeInterval: gameDuration, target: self, selector: #selector(ViewController.endGame), userInfo: nil, repeats: false)
    }
    
    func initPlayerClass() {
        
        if playerClass == "Fonctionnaire" {
            gameDuration = gameDuration * 1.4
        } else if playerClass == "Geek" {
            geek = true
        } else if playerClass == "Noob" {
            noob = true
        } else if playerClass == "Hacker" {
            progressDecrease = 0.001
        }
        
    }
    
    func endGame() {
        //Segue
    }
    
    func decreaseScoreLoop() {
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.decreaseScore), userInfo: nil, repeats: true)
    }
    
    func decreaseScore() {
        if progress >= progressDecrease {
            progress -= progressDecrease
        } else if progress > 0 {
            progress = 0
        }
        updateProgressBar()
    }
    
    func addGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ViewController.cookieClicked))
        
        cookie.isUserInteractionEnabled = true
        cookie.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func cookieClicked(tapGR: UITapGestureRecognizer){
        if isReallyClicked(tapGR: tapGR){
            if isMomWatching {
                
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
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.animateSmileysScale), userInfo: nil, repeats: true)
        
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
            anim.toValue = M_PI_4
        } else {
            hfromLeft = !hfromLeft
            anim.toValue = -M_PI_4
        }
        
        anim.duration = drand48() / 2 + 0.5
        anim.autoreverses = true
        
        happy.layer.add(anim, forKey: nil)
        
        Timer.scheduledTimer(timeInterval: anim.duration * 2, target: self, selector: #selector(ViewController.animateHappyRotate), userInfo: nil, repeats: false)
    }
    
    func animateSadRotate() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.fromValue = 0
        
        if sfromLeft {
            sfromLeft = !sfromLeft
            anim.toValue = M_PI_4
        } else {
            sfromLeft = !sfromLeft
            anim.toValue = -M_PI_4
        }
        
        anim.duration = drand48() / 2 + 0.5
        anim.autoreverses = true
        
        sad.layer.add(anim, forKey: nil)
        
        Timer.scheduledTimer(timeInterval: anim.duration * 2, target: self, selector: #selector(ViewController.animateSadRotate), userInfo: nil, repeats: false)
    }
    
    func hideMom() {
        isMomWatching = false
        toggleMom()
        Timer.scheduledTimer(timeInterval: randomInterval(), target: self, selector: #selector(ViewController.showMom), userInfo: nil, repeats: false)
    }
    
    func showMom() {
        isMomWatching = true
        toggleMom()
        Timer.scheduledTimer(timeInterval: randomInterval(), target: self, selector: #selector(ViewController.hideMom), userInfo: nil, repeats: false)
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
    
    func viewControllerAtIndex(index: Int) -> ContentViewController {
        
        if pageViewLabels.count == 0 || index >= pageViewLabels.count {
            return ContentViewController()
        }
        
        let vc:ContentViewController = storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        
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
        
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentViewController
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
