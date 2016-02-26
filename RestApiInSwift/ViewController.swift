//
//  ViewController.swift
//  RestApiInSwift
//
//  Created by Aman Sandhu on 26/02/16.
//  Copyright © 2016 Chetu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RestApiModelClassDelegate {

    // MARK: - Class widget element declaration 
    @IBOutlet weak var emailTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    
    @IBOutlet weak var loginButton: UIButton?

    
    
    // MARK: -  UIViewController life cycle overrided method.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print("Hi inside of viewWillAppear method")
        
        self.screenDesign()
    }
    
    
    // MARK: -  screenDesign Method.
    func screenDesign()
    {
        emailTextField?.layer.cornerRadius = 5.0
        passwordTextField?.layer.cornerRadius = 5.0
        loginButton?.layer.cornerRadius = 5.0
        
        
        emailTextField?.text = "a@a.com"
        passwordTextField?.text = "123456"
    }
    
    // MARK: -  loginButtonTapped Method.
    @IBAction func loginButtonTapped(sender: UIButton)
    {
        passwordTextField?.resignFirstResponder()
        emailTextField?.resignFirstResponder()
        
        // MARK: - code to trim white space from textfield 
        emailTextField?.text = emailTextField?.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        passwordTextField?.text = passwordTextField?.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

        // MARK: - Textfield value length validations 
        if emailTextField?.text == ""
        {
            let alert = UIAlertController(title: "Alert!!", message: "Please add email first.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else if !self.isValidEmail((emailTextField?.text)!)
        {
            let alert = UIAlertController(title: "Alert!!", message: "Email is not valid.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else if passwordTextField?.text == ""
        {
            let alert = UIAlertController(title: "Alert!!", message: "Please add password first.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            // MARK: - Code to check internet availability to hit web api.
            if Helper.isConnectedToInternet()
            {
                SVProgressHUD.showWithStatus("Authenticate..", maskType: SVProgressHUDMaskType.Clear)
                _ = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("authenticateGuestCredentials"), userInfo: nil, repeats:   false)
            }
            else
            {
                let alert = UIAlertController(title: "No Internet", message: "Please check your internet connection.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    // MARK: -  Email validation method.
    func isValidEmail(testStr:String) -> Bool
    {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    
    // MARK: -  authenticateGuestCredentials Method.
    func authenticateGuestCredentials()
    {
        let requestDictionary: NSMutableDictionary = NSMutableDictionary()
        requestDictionary.setValue("n9@n9.com", forKey: "email")
        requestDictionary.setValue("12345678", forKey: "password")
        requestDictionary.setValue("+91", forKey: "country_code")
        requestDictionary.setValue("8699313639", forKey: "phone")
        requestDictionary.setValue("Nitin", forKey: "name")
        requestDictionary.setValue("iPhone5_IOS1.6.5GuestAppV2", forKey: "version")
        
        let restApiModelClassInstance = RestApiModelClass.sharedInstance
        restApiModelClassInstance.delegate = self
        restApiModelClassInstance.getRequestRestApiWith(requestDictionary as [NSObject : AnyObject], requestUrl: "", apiIdentifier: "login")
    }
    
    
    // MARK: -  RestApiModelClassDelegate Methods.
    func restApiDelegateWith( responseDictionary: [String : AnyObject]!,   apiIdentifier: String)
    {
        print("Response is :\(responseDictionary)")
        print("REST Api identifier is :\(apiIdentifier)")
        
        dispatch_async(dispatch_get_main_queue()) {
            // Update some UI
            SVProgressHUD.dismiss()
        }
    }
    
    
    
    
    // MARK: -  Memory management method.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

