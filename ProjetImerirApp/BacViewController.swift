//
//  BacViewController.swift
//  ProjetImerirApp
//
//  Created by Student on 17/05/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import AVFoundation

class BacViewController: UIViewController, UIPageViewControllerDataSource {

    @IBOutlet var ficheView: Fiche!
    @IBOutlet var headerView: HeaderView!
    
    @IBOutlet var window: UIImageView!
    @IBOutlet var coffee: UIImageView!
    @IBOutlet var bowl: UIImageView!
    
    @IBOutlet var paperBin: UIImageView!
    @IBOutlet var checkmark: UIImageView!
    
    var gameDuration = 60.0
    var timeLeft = 60.0
    var timers = [String:Timer]()
    
    var currentSheets = [Fiche]()
    var fatigueBar: UIProgressView!
    var hungerBar: UIProgressView!
    
    var timeToFillBowl = 5.0
    var timeToOpenWindow = 8.0
    var timeToFillCoffee = 6.0
    
    var speedFactor:Double = 1.0
    
    var matieresList = ["Français", "Mathématiques", "Anglais", "Informatique", "Économie", "Histoire", "Géographie", "Philosophie"]
    var toStudy:[String]!
    
    var isAddict = false
    var isOnCoffee = false
    
    var pageViewController:UIPageViewController!
    var pageViewLabels:[String]!
    var pageViewImages:[String]!
    var pageViewTitles:[String]!
    var pageViewHints:[String]!
    
    var oneProfil = ProfilJoueur()
    var idClasse = 0
    var AllClasse = [ClasseJoueur]()
    
    var bruitageMusicPlayer = AVAudioPlayer()
    
    var studiedSheets = 0
    var goodSheets = 0
    var totalSheets = 0
    
    var embedViewController:EmbedViewController!
    var arcadeMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedViewController = getEmbedViewController()
        embedViewController.backgroundMusicPlayer = GestionMusic(filename: "SurrealChase")
        setSubjectsToStudy()
        
        initProfil()
        initPageView()
        
        initClasses()
        initHeaderView()
        
        for subview in [coffee,window,bowl] {
            addShadow(on: subview!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initSwipeIndicatorsShadows()
        
        createNewSheet()
        createNewSheet()
        
        createProgressViews()
    }
    
    func startGame() {
        startGameTimers()
        fillBowl()
        fillCoffee()
        openWindow()
    }
    
    
    
    //// GAME INITIALIZATION ////
    
    // Init random subjects to study
    func setSubjectsToStudy() {
        let toPop = Int(matieresList.count/2)
        var toStudy = matieresList
        
        for _ in 1...toPop {
            toStudy.remove(at: Int(arc4random_uniform(UInt32(toStudy.count))))
        }
        
        self.toStudy = toStudy
    }
    
    // Init profil
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
    
    // Init page view
    func initPageView() {
        
        pageViewLabels = ["Voici la liste des matières que tu devras réviser : \(toStudy.joined(separator: ", ")).",
                          "Fais basculer les fiches que tu veux réviser vers la droite et les autres vers la gauche.",
                          "La première représente ton énergie et la deuxième ton appétit, garde les remplies pour ne pas perdre de points de vie.",
                          "Clique dessus dès qu'elle est ouverte afin de faire remonter ta barre d'énergie.",
                          "Permet de faire remonter la barre d'appétit.",
                          "Donne des super pouvoirs.",
                          "Avec la classe \(AllClasse[idClasse].idClasse as String), \(AllClasse[idClasse].arcadeBac as String)"]
        
        pageViewImages = ["",
                          "Fiche",
                          "Barres",
                          "Fenetre",
                          "Bol",
                          "Cafe",
                          "\(AllClasse[idClasse].idClasse as String)"]
        
        pageViewTitles = ["Les matières",
                          "Les fiches de révision",
                          "Les barres de santé",
                          "La fenêtre",
                          "Le bol de céréales",
                          "Le café",
                          "\(AllClasse[idClasse].idClasse as String)"]
        
        pageViewHints = ["Retiens les bien.",
                         "Le tinder des fiches de révisions !",
                         "Ne t'oblige pas à garder un oeil dessus.",
                         "Permet de prendre un bol d'air.",
                         "Permet de prendre un bol de céréales.",
                         "Les fiches à réviser deviennent vertes, les autres rouges.",
                         ""]
        
        pageViewController = storyboard?.instantiateViewController(withIdentifier: "BacPageViewController") as! UIPageViewController
        
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

    // Init header view
    func initHeaderView() {
        headerView.timerLabel.textColor = .white
        headerView.timerLabel.text = "\(Int(gameDuration)) s"
        headerView.lifePointLabel.text = "\(oneProfil.lifePoint) PV"
    }
    
    // Modify variables depending on player's class
    func initClasses() {
        switch oneProfil.classeJoueur {
            case "Geek":
                timeToFillBowl = 4
                break
            case "Fonctionnaire":
                gameDuration *= 1.4
                timeLeft = gameDuration
                timeToOpenWindow = 6
                speedFactor = 1.4
                break
            case "Hacker":
                timeToFillCoffee = 5.0
                break
            default:
                break
        }
    }
    
    // Add white shadow to a view (aka. coffee, window, bowl)
    func addShadow(on view: UIView) {
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = view.bounds.height/10
        view.clipsToBounds = false
    }

    // Add shadows to side swipe indicators
    func initSwipeIndicatorsShadows() {
        
        let binPath = UIBezierPath(rect: CGRect(x: -paperBin.bounds.width - paperBin.frame.origin.x, y: 0, width: paperBin.bounds.width, height: paperBin.bounds.height))
        
        let binLayer = CAShapeLayer()
        binLayer.path = binPath.cgPath
        binLayer.shadowOpacity = 1
        binLayer.shadowColor = UIColor.red.cgColor
        binLayer.shadowRadius = paperBin.bounds.width
        binLayer.shadowOffset = CGSize(width: 0, height: 0)
        
        paperBin.layer.addSublayer(binLayer)
        
        let checkmarkPath = UIBezierPath(rect: CGRect(x: view.bounds.width - checkmark.frame.origin.x, y: 0, width: checkmark.bounds.width, height: checkmark.bounds.height))
        
        let checkmarkLayer = CAShapeLayer()
        checkmarkLayer.path = checkmarkPath.cgPath
        checkmarkLayer.shadowOpacity = 1
        checkmarkLayer.shadowColor = UIColor.green.cgColor
        checkmarkLayer.shadowRadius = checkmark.bounds.width
        checkmarkLayer.shadowOffset = CGSize(width: 0, height: 0)
        
        checkmark.layer.addSublayer(checkmarkLayer)
    }
    
    // Add progress bars
    func createProgressViews() {
        
        let yScale = view.bounds.height/100
        
        let fatigueBar = UIProgressView(frame: CGRect(x: 0, y: headerView.bounds.height + view.bounds.height/20, width: view.bounds.width/2, height: 10))
        fatigueBar.progress = 1
        fatigueBar.trackTintColor = .white
        fatigueBar.progressTintColor = .blue
        
        fatigueBar.layer.cornerRadius = yScale
        fatigueBar.clipsToBounds = true
        
        fatigueBar.layer.borderColor = UIColor.gray.cgColor
        fatigueBar.layer.borderWidth = 0.3
        fatigueBar.center.x = view.center.x
        
        let scale = CGAffineTransform(scaleX: 1, y: yScale)
        let rotate = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        fatigueBar.transform = scale.concatenating(rotate)
        
        self.fatigueBar = fatigueBar
        view.insertSubview(fatigueBar, aboveSubview: window)
        
        let hungerBar = UIProgressView(frame: CGRect(x: 0, y: headerView.bounds.height + view.bounds.height/10, width: view.bounds.width/2, height: 10))
        
        hungerBar.progress = 1
        hungerBar.trackTintColor = .white
        hungerBar.progressTintColor = .green
        
        hungerBar.layer.cornerRadius = yScale
        hungerBar.clipsToBounds = true
        
        hungerBar.layer.borderColor = UIColor.gray.cgColor
        hungerBar.layer.borderWidth = 0.3
        print(hungerBar.bounds.width)
        hungerBar.center.x = view.center.x
        
        hungerBar.transform = scale.concatenating(rotate)
        
        self.hungerBar = hungerBar
        view.insertSubview(hungerBar, aboveSubview: window)
        
        let eyeIcon = UIImageView(frame: CGRect(x: fatigueBar.frame.origin.x + fatigueBar.bounds.width - yScale * 3,
                                                y: 0,
                                                width: fatigueBar.bounds.height * yScale * 3,
                                                height: fatigueBar.bounds.height * yScale * 3))
        eyeIcon.image = UIImage(named: "OeilIcon")
        eyeIcon.center.y = fatigueBar.center.y
        
        view.insertSubview(eyeIcon, aboveSubview: fatigueBar)
        
        let bowlIcon = UIImageView(frame: CGRect(x: hungerBar.frame.origin.x + hungerBar.bounds.width - yScale * 3,
                                                 y: 0,
                                                 width: hungerBar.bounds.height * yScale * 3,
                                                 height: hungerBar.bounds.height * yScale * 3))
        bowlIcon.image = UIImage(named: "BolIcon")
        bowlIcon.center.y = hungerBar.center.y
        
        view.insertSubview(bowlIcon, aboveSubview: hungerBar)
    }
    
    
    
    //// GLOBAL FUNCTIONS AND TIMERS ////
    
    // Start global timers which could be paused
    func startGameTimers() {
        
        timers["game"] = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.timeLeft -= 1
            self.headerView.timerLabel.text = String("\(Int(self.timeLeft)) s")
            
            if self.timeLeft <= 0 {
                self.endGame()
            }
        })
        
        timers["life_decrease"] = Timer.scheduledTimer(withTimeInterval: 1 * speedFactor, repeats: true, block: { _ in
            self.looseHealth(1)
        })
        
        // La fenetre s'ouvre toutes les 8 secondes et donne 50% de la barre, donc on doit enlever 1/16 de la barre chaque seconde pour la vider en 8s, on rajoute 25% de marge de temps de réaction et on divise par 10 car l'actualisation se fait chaque 0.1 seconde
        let fatigue_decrease:Float = Float((1.0 / 8 / 2.5 * 0.1) / speedFactor)
        let hunger_decrease:Float = Float((1.0 / 5 / 2.5 * 0.1) / speedFactor)
        
        timers["progress_decrease"] = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            
            if self.hungerBar.progress > 0.1 {
                self.hungerBar.progress -= hunger_decrease
            }
            
            if self.fatigueBar.progress > 0.1 {
                self.fatigueBar.progress -= fatigue_decrease
            }
        })
        
        timers["progress_check"] = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            
            if self.hungerBar.progress <= 0.1 {
                self.looseHealth(1)
            }
            
            if self.fatigueBar.progress <= 0.1 {
                self.looseHealth(1)
            }
        })
        
        if oneProfil.classeJoueur == "Noob" {
            timers["noob"] = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                
                if drand48() < 1/6 {
                    self.autoStudyCurrentSheet()
                }
                
            })
        }
    }
    
    // Loose health
    func looseHealth(_ amount: Int) {
        oneProfil.lifePoint -= amount
        headerView.lifePointLabel.text = "\(oneProfil.lifePoint) PV"
    }
    
    // Gain health
    func gainHealth(_ amount: Int) {
        oneProfil.lifePoint += amount
        headerView.lifePointLabel.text = "\(oneProfil.lifePoint) PV"
    }
    
    // Pause timers
    func pauseGame() {
        for timer in timers {
            timer.value.invalidate()
        }
    }
    
    // Resume game
    func resumeGame() {
        startGameTimers()
    }
    
    // Endgame - move to dialogue
    func endGame() {
        pauseGame()
        
        if !isAddict {
            embedViewController.updateAchievement("achievement.bacnocoffee")
        }
        
        if arcadeMode {
            if let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InitController") as? InitViewController
            {
                UIView.animate(withDuration: 7, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 6)
                    self.view.alpha = 0
                } , completion: { success in
                    vc.firstMenuForRun = false
                    self.embedViewController.showScene(vc)
                })
            }
        } else {
            if let vc = UIStoryboard(name:"Dialogue", bundle:nil).instantiateInitialViewController() as? DialogueViewController {
                oneProfil.sceneActuelle += 1
                
                oneProfil.statsBac["goodClassification"] = studiedSheets
                if totalSheets > 0 {
                    oneProfil.statsBac["pourcentage"] = 100 * goodSheets / totalSheets
                } else {
                    oneProfil.statsBac["pourcentage"] = 0
                }
                vc.oneProfil = oneProfil
                saveMyData()
                UIView.animate(withDuration: 7, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.embedViewController.backgroundMusicPlayer.setVolume(0, fadeDuration: 6)
                    self.view.alpha = 0
                } , completion: { _ in
                    self.embedViewController.showScene(vc)
                })
            }else {
                print("Could not instantiate view controller with identifier of type DialogueViewController")
                return
            }
        }
    }
    
    
    
    //// GAME LOGIC - IBActions ////
    
    // Pan gesture manager
    @IBAction func onSwipe(_ sender: UIPanGestureRecognizer) {
        
        guard sender.view != nil else {
            return
        }
        
        let origin =  CGPoint(x: 0, y: 0)
        let translation : CGPoint = sender.translation(in: sender.view)
        
        // Rotate depending on finger's position
        let txy = CGAffineTransform(translationX: translation.x, y: -abs(translation.x) / 15)
        let rot = CGAffineTransform(rotationAngle: translation.x / 1500)
        let t = rot.concatenating(txy);
        sender.view!.transform = t
        
        // Show swipe indicators
        if (translation.x > view.bounds.width/4) {
            checkmark.isHidden = false
        } else if (translation.x < -view.bounds.width/4) {
            paperBin.isHidden = false
        } else {
            checkmark.isHidden = true
            paperBin.isHidden = true
        }

        // Manage actions when touch ends
        if sender.state == UIGestureRecognizerState.ended {
            
            if (translation.x > view.bounds.width/4) {
                
                swapToRight(sender.view!)
                
            } else if (translation.x < -view.bounds.width/4) {
                
                swapToLeft(sender.view!)
                
            } else {
                
                UIView.animate(withDuration: 0.5, delay:0, options: .allowUserInteraction, animations: { _ in
                    let txy = CGAffineTransform(translationX: origin.x, y: origin.y)
                    let rot = CGAffineTransform(rotationAngle: 0)
                    sender.view!.transform = rot.concatenating(txy);
                })
            }
        }
    }
    
    // On window tapped
    @IBAction func onWindowOpened(_ sender: UITapGestureRecognizer) {
        if let view = sender.view! as? UIImageView {
            
            guard view.image!.isEqual(UIImage(named: "FenetreOuverte")) else {
                return
            }
            
            openWindow()
            
            bruitageMusicPlayer = GestionBruitage(filename: "Fenetre", volume: 1)
            view.image = #imageLiteral(resourceName: "FenetreFermee")
            view.layer.shadowOpacity = 0
            fatigueBar.progress += 0.5
        }
    }
    
    // On coffee tapped
    @IBAction func onCoffeeDrunk(_ sender: UITapGestureRecognizer) {
        if let view = sender.view! as? UIImageView {
            
            guard view.image!.isEqual(UIImage(named: "CafePlein")) else {
                return
            }
            
            bruitageMusicPlayer = GestionBruitage(filename: "BoireCafe", volume: 1)
            view.image = #imageLiteral(resourceName: "CafeVide")
            view.layer.shadowOpacity = 0
            fillCoffee()
            
            let wasAddict = isAddict
            isAddict = true
            
            removeAddictionEffects()
            addCoffeeEffects()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { _ in
                if !wasAddict {
                    self.drawMessage("Coffee Addict !")
                }
                
                self.isOnCoffee = false
                self.addAddictionEffects()
            })
        }
    }
    
    // On bowl tapped
    @IBAction func onCerealEaten(_ sender: UITapGestureRecognizer) {
        if let view = sender.view! as? UIImageView {
            
            guard view.image!.isEqual(UIImage(named: "BolPlein")) else {
                return
            }
            
            fillBowl()
            
            bruitageMusicPlayer = GestionBruitage(filename: "BolCereale", volume: 1)
            view.image = #imageLiteral(resourceName: "BolVide")
            view.layer.shadowOpacity = 0
            hungerBar.progress += 0.5
        }
    }
    
    
    
    //// GAME LOGIC - PRIMARY ////
    
    // Called when sheet is dropped on the right side of the screen
    func swapToRight(_ view: UIView) {
        
        view.tag = 10
        UIView.animate(withDuration: 0.5, animations: { _ in
            let txy = CGAffineTransform(translationX: self.view.bounds.width, y: -abs(self.view.bounds.width) / 15)
            let rot = CGAffineTransform(rotationAngle: self.view.bounds.width / 1500)
            view.transform = rot.concatenating(txy);
        }, completion: { _ in
            view.removeFromSuperview()
        })
        
        onSheetStudied(view)
    }
    
    // Called when sheet is dropped on the left side of the screen
    func swapToLeft(_ view: UIView) {
        
        view.tag = 10
        UIView.animate(withDuration: 0.5, animations: { _ in
            let txy = CGAffineTransform(translationX: -self.view.bounds.width, y: -abs(self.view.bounds.width) / 15)
            let rot = CGAffineTransform(rotationAngle: -self.view.bounds.width / 1500)
            view.transform = rot.concatenating(txy);
        }, completion: { _ in
            view.removeFromSuperview()
        })
        
        onSheetThrown(view)
    }
    
    // When sheet is dropped on the right
    func onSheetStudied(_ sheet: UIView) {
        let sheet = sheet as! Fiche
        onSheetSwiped(sheet)
        
        if isGoodSubject(sheet.matiere) {
            goodSheets += 1
            studiedSheets += 1
            gainHealth(1)
        } else {
            looseHealth(1)
        }
    }
    
    // When sheet is dropped on the left
    func onSheetThrown(_ sheet: UIView) {
        let sheet = sheet as! Fiche
        onSheetSwiped(sheet)
        
        if isGoodSubject(sheet.matiere) {
            looseHealth(1)
        } else {
            goodSheets += 1
            gainHealth(1)
        }
    }
    
    // On sheet swiped (left or right)
    func onSheetSwiped(_ sheet: Fiche) {
        currentSheets.remove(at: currentSheets.index(of: sheet)!)
        
        totalSheets += 1
        
        checkmark.isHidden = true
        paperBin.isHidden = true
        
        createNewSheet()
    }
    
    // Create new sheet view
    func createNewSheet() {
        let sheet = Fiche(frame: ficheView.frame, matiere: getRandomMatiere())
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(onSwipe))
        sheet.addGestureRecognizer(gesture)
        
        sheet.addFakeText()
        
        if oneProfil.classeJoueur == "Fonctionnaire" {
            sheet.isUserInteractionEnabled = false
            sheet.frame.origin.y = view.bounds.height
            
            UIView.animate(withDuration: 1, animations: { _ in
                sheet.frame.origin.y = self.ficheView.frame.origin.y
            }, completion: { _ in
                sheet.isUserInteractionEnabled = true
            })
        }
        
        view.insertSubview(sheet, aboveSubview: ficheView)
        currentSheets.append(sheet)
        
        
        if isOnCoffee {
            addCoffeeEffect(on: sheet)
        } else if isAddict {
            addAddictionEffect(on: sheet)
        }
    }
    
    func openWindow() {
        Timer.scheduledTimer(withTimeInterval: timeToOpenWindow * speedFactor, repeats: false, block: { _ in
            self.window.image = #imageLiteral(resourceName: "FenetreOuverte")
            self.window.layer.shadowOpacity = 1
        })
    }
    
    func fillBowl() {
        Timer.scheduledTimer(withTimeInterval: timeToFillBowl * speedFactor, repeats: false, block: { _ in
            self.bowl.image = #imageLiteral(resourceName: "BolPlein")
            self.bowl.layer.shadowOpacity = 1
        })
    }
    
    func fillCoffee() {
        Timer.scheduledTimer(withTimeInterval: timeToFillCoffee * speedFactor, repeats: false, block: { _ in
            self.coffee.image = #imageLiteral(resourceName: "CafePlein")
            self.coffee.layer.shadowOpacity = 1
        })
    }
    
    
    
    //// GAME LOGIC - SECONDARY (Visual effects & enhanced getters) ////
    
    func isGoodSubject(_ subject: String) -> Bool {
        if toStudy.contains(subject) {
            return true
        }
        return false
    }
    
    func getRandomMatiere() -> String {
        return matieresList[Int(arc4random_uniform(UInt32(matieresList.count)))]
    }
    
    func addAddictionEffect(on sheet: Fiche) {
        
        for line in sheet.fakeTextView.layer.sublayers! {
            line.backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 0.9).cgColor
        }
        
        let hue = CGFloat(drand48())
        
        sheet.view.backgroundColor = UIColor(hue: hue, saturation: 1, brightness: 0.9, alpha: 1)
        sheet.view.layer.shadowOpacity = 0
        
        let invertedHue:CGFloat
        
        if hue < 0.5 {
            invertedHue = hue + 0.5
        } else {
            invertedHue = hue - 0.5
        }
        
        sheet.matiereLabel.textColor = UIColor(hue: invertedHue, saturation: 1, brightness: 0.9, alpha: 1)
        
        sheet.matiereLabel.text = String(Array(sheet.matiere.lowercased().characters).shuffled).capitalizingFirstLetter()
    }
    
    func removeAddictionEffect(on sheet: Fiche) {
        
        sheet.view.backgroundColor = .lightGray
        
        for line in sheet.fakeTextView.layer.sublayers! {
            line.backgroundColor = UIColor.black.cgColor
        }
        
        sheet.matiereLabel.text = sheet.matiere
    }
    
    func removeAddictionEffects() {
        
        for sheet in currentSheets {
            removeAddictionEffect(on: sheet)
        }
    }
    
    func addAddictionEffects() {
        
        for sheet in currentSheets {
            addAddictionEffect(on: sheet)
        }
    }
    
    func addCoffeeEffects() {
        isOnCoffee = true
        
        for sheet in currentSheets {
            addCoffeeEffect(on: sheet)
        }
    }
    
    func addCoffeeEffect(on sheet: Fiche) {
        sheet.matiereLabel.textColor = .black
        sheet.view.layer.shadowPath = UIBezierPath(rect: sheet.view.frame).cgPath
        sheet.view.layer.shadowRadius = 15
        sheet.view.layer.shadowOffset = CGSize()
        sheet.view.layer.shadowOpacity = 1
        
        if toStudy.contains(sheet.matiere) {
            sheet.view.layer.shadowColor = UIColor.green.cgColor
            sheet.view.backgroundColor = .green
        } else {
            sheet.view.layer.shadowColor = UIColor.red.cgColor
            sheet.view.backgroundColor = .red
        }
    }
    
    func autoStudyCurrentSheet() {
        
        if let sheet = currentSheets.first(where: { $0.tag != 10 }) {
            
            sheet.removeGestureRecognizer(sheet.gestureRecognizers!.first!)
            
            if isGoodSubject(sheet.matiere) {
                swapToRight(sheet)
            } else {
                swapToLeft(sheet)
            }
        }
    }

    
    
    //// MISC ////
    
    func drawMessage(_ msg: String) {
        let label = UILabel(frame: CGRect(x: 0, y: view.bounds.height * 0.4, width: view.bounds.width, height: view.bounds.height/20))
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
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
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
    
    
    
    //// SAVE & PAGEVIEW ////
    
    func saveMyData(){
        var maData = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        maData.appendPathComponent("saveGame")
        NSKeyedArchiver.archiveRootObject(self.oneProfil, toFile: maData.path)
    }
    
    func hideModal() {
        bruitageMusicPlayer = GestionBruitage(filename: "Clik", volume : 1)
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
                self.startGame()
            })
        }
    }
    
    func viewControllerAtIndex(index: Int) -> ContentBacViewController {
        
        if pageViewLabels.count == 0 || index >= pageViewLabels.count {
            return ContentBacViewController()
        }
        
        let vc:ContentBacViewController = storyboard?.instantiateViewController(withIdentifier: "ContentBacViewController") as! ContentBacViewController
        
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
        
        let vc = viewController as! ContentBacViewController
        var index = vc.pageIndex as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentBacViewController
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
