//
//  ViewController.swift
//  Instagrid v3
//
//  Created by Guillaume Bourlart on 13/12/2021.
//

//
//  ViewController.swift
//  Instagrid
//
//  Created by Guillaume Bourlart on 23/09/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var app = App() // App  creation
    @IBOutlet weak var appTitle: UILabel! //App title
    @IBOutlet weak var swipeLabel: UILabel! //Label "Swipe to share"
    @IBOutlet weak var Arrow: UIImageView! // Arrow logo
    @IBOutlet weak var screenZone: UIView! //ScreenableZone to share
    
    // Button to add image
    @IBOutlet weak var image1: UIButton!
    @IBOutlet weak var image2: UIButton!
    @IBOutlet weak var image3: UIButton!
    @IBOutlet weak var image4: UIButton!
    @IBOutlet weak var image5: UIButton!
    @IBOutlet weak var image6: UIButton!
    // Button to change model
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        
        deviceRotated()
        setAspectFill()
        
        //display application title
        appTitle.text = app.appTitle
        
        //Observe screen orientation
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        //Initialisation du grid
        didTapButton(button3)
        
        //Add gesture recognizer for swipe up
        let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeToShare(SwipeGestureRecognizer:)))
        swipeGestureUp.direction = .up
        screenZone.addGestureRecognizer(swipeGestureUp)
        
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeToShare(SwipeGestureRecognizer:)))
        swipeGestureLeft.direction = .left
        screenZone.addGestureRecognizer(swipeGestureLeft)
        
        
        
    }
    
    //call required function to adapt the application
    @IBAction func didTapButton(_ sender: UIButton) {
        let tag = sender.tag
        if let grid = App.Grid(rawValue: tag),
           grid != app.grid{
            button1.setImage(nil, for: .normal)
            button2.setImage(nil, for: .normal)
            button3.setImage(nil, for: .normal)
            sender.setImage(UIImage(named: "Selected"), for: .normal)
            app.grid = grid
            changeModel()
        }
    }
    
   
    //Modify model
    func setAspectFill(){
        
        //set aspect fill for each UIImage
        image1.imageView?.contentMode = .scaleAspectFill
        image2.imageView?.contentMode = .scaleAspectFill
        image3.imageView?.contentMode = .scaleAspectFill
        image4.imageView?.contentMode = .scaleAspectFill
        image5.imageView?.contentMode = .scaleAspectFill
        image6.imageView?.contentMode = .scaleAspectFill
    }
    //Modify model
    func changeModel(){
        
        //reinitialisation of each image after layout changed
        image1.setImage(UIImage(named: "Plus"), for: .normal)
        image2.setImage(UIImage(named: "Plus"), for: .normal)
        image3.setImage(UIImage(named: "Plus"), for: .normal)
        image4.setImage(UIImage(named: "Plus"), for: .normal)
        image5.setImage(UIImage(named: "Plus"), for: .normal)
        image6.setImage(UIImage(named: "Plus"), for: .normal)
        
        
        
        //Layout update
        switch app.grid{
        case .largeLittle:
            image1.isHidden = true
            image2.isHidden = true
            image3.isHidden = true
            image4.isHidden = false
            image5.isHidden = false
            image6.isHidden = false
            
        case .littleLarge:
            image1.isHidden = false
            image2.isHidden = false
            image3.isHidden = false
            image4.isHidden = true
            image5.isHidden = true
            image6.isHidden = true
            
        case .fullLittle:
            image1.isHidden = false
            image2.isHidden = false
            image3.isHidden = true
            image4.isHidden = true
            image5.isHidden = false
            image6.isHidden = false
        }
    }
    
    
    
    //Open image picker when user tap on a button
    var tappedImage: UIButton?
    @IBAction func openImageSelector(_ sender: UIButton) {
        tappedImage = sender
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        //Storing chosen Image
        if let tempImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            //adding new image
            tappedImage?.setImage(tempImage, for: .normal)
        }
        //Dismiss
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    //SWIPE UP
    
    @objc func swipeToShare(SwipeGestureRecognizer: UISwipeGestureRecognizer){
        
        if (UIDevice.current.orientation.isLandscape == true &&  SwipeGestureRecognizer.direction == .left) || (UIDevice.current.orientation.isLandscape == false &&  SwipeGestureRecognizer.direction == .up){
            //Create the UIImage
            let renderer = UIGraphicsImageRenderer(size: screenZone.frame.size)
            let image = renderer.image(actions: { context in
                screenZone.layer.render(in: context.cgContext)
            })
            
            // Preparing to move the screen zone (UI)
            let screenHeight = UIScreen.main.bounds.height
            let screenWidth = UIScreen.main.bounds.width
            var transformation: CGAffineTransform
            if UIDevice.current.orientation.isLandscape == true {
                transformation = CGAffineTransform(translationX: -screenWidth, y: 0)
                
            }else{
                transformation = CGAffineTransform(translationX: 0, y: -screenHeight)
            }
            
            //Moving the screen Zone
            UIView.animate(withDuration: 0.5, animations: {
                self.screenZone.transform = transformation
            }) { (success) in
                if success {
                    self.share(image: image)
                }
            }
        }
    }
    
    func share(image: UIImage){
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            
            // User completed activity
            self.resetGridPlacement()
        }
    }
    
    func resetGridPlacement(){
        
        UIView.animate(withDuration: 0.5, animations: {
            self.screenZone.transform = .identity
        }, completion: nil)
    }
    
    //called when rotation changed
    
    @objc func deviceRotated() {
        swipeLabel.text = app.swipeLabel
        if UIDevice.current.orientation.isLandscape == true {
            Arrow.image = UIImage(named: "Arrow Left")
        } else {
            Arrow.image = UIImage(named: "Arrow Up")
        }
        
        if UIScreen.main.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact && UIScreen.main.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.compact{
            appTitle.font = UIFont(name: "ThirstySoftRegular", size: 28)
            swipeLabel.font = UIFont(name: "Delm-Medium", size: 16)
        }else{
            appTitle.font = UIFont(name: "ThirstySoftRegular", size: 32)
            swipeLabel.font = UIFont(name: "Delm-Medium", size: 27)
        }
        
    }
}




