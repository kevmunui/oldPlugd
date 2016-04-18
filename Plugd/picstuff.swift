   @IBOutlet weak var profile_picture: UIImageView!


        profile_picture.layer.cornerRadius = profile_picture.frame.size.width / 2
        profile_picture.clipsToBounds = true
        profile_picture.layer.borderColor = UIColor.blackColor().CGColor
        profile_picture.layer.borderWidth = 3


  //image picker
    
    @IBAction func selectProfilePicture(sender: UIButton) {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }



     func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
    
        profile_picture.image = info[UIImagePickerControllerOriginalImage] as?
        UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
     
    
    }
