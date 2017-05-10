//
//  LoginViewController.swift
//  fits
//
//  Created by Vibes on 3/28/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private var _authHandle: FIRAuthStateDidChangeListenerHandle!
    
    var user: FIRUser?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpLink: UIButton!

    func configureAuth() {

// MARK: Signout user. REMOVE PRIOR TO LAUNCH
       // try? FIRAuth.auth()?.signOut()
        _authHandle = FIRAuth.auth()?.addStateDidChangeListener({ (auth:FIRAuth, user:FIRUser?) in
            if let user = user {
                self.user = user
                
// MARK: Segue to Looks view controller
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let loggedInScene = storyboard.instantiateViewController(withIdentifier: "SwipeControllerVC") as! EZSwipeControllerVC
                
                self.present(loggedInScene, animated: true)

            }
        })
        
    }
    
    func deconfigureAuth() {
        FIRAuth.auth()?.removeStateDidChangeListener(_authHandle!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// MARK: Border color of email and password text fields.
        usernameTextField.layer.borderColor = UIColor(red: 255/255.0, green: 80/255.0, blue: 0, alpha: 1.0).cgColor
        usernameTextField.layer.borderWidth = 1.0
        usernameTextField.setNeedsLayout()
        passwordTextField.layer.borderColor = UIColor(red: 255/255.0, green: 80/255.0, blue: 0, alpha: 1.0).cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.setNeedsLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureAuth()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        deconfigureAuth()
    }
    
// MARK: Keyboard - Start editing the textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -200, up: true)
    }
    
// MARK: Keyboard - Finish editing the textfield
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -200, up: false)
    }
    
// MARK: Keyboard animations
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        textField.autocorrectionType = .no
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }

// MARK: Firebase user login
    @IBAction func loginAction(_ sender: AnyObject) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
// MARK: Alert for Invalid Username
        if (usernameTextField.text?.isEmpty)! {
            let alertLogin = UIAlertController(title: "Invalid Username", message: "Username field can not be left empty.", preferredStyle: UIAlertControllerStyle.alert)
            
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            
            self.present(alertLogin, animated: true, completion: nil)
            
            alertLogin.addAction(okButton)
 
// MARK: Alert for Invalid Password
        } else if (passwordTextField.text?.isEmpty)! {
            let alertPassword = UIAlertController(title: "Invalid Password", message: "Password field can not be left empty.", preferredStyle: UIAlertControllerStyle.alert)
            
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            
            self.present(alertPassword, animated: true, completion: nil)
            
            alertPassword.addAction(okButton)
        }

        guard let email = usernameTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let user = user, error == nil {
                
                print("user logged in \(user.email!)")
                User.shared.email = user.email
            
                Firebase.shared.ref.child("users").child(User.shared.username).setValue(["email": user.email])

                
            } else if let error = error as NSError?, let firAuthError = FIRAuthErrorCode(rawValue: error.code) {
                
// MARK: Alerts for Firebase login errors
                let alertFIRLogin = UIAlertController(title: firAuthError.title, message: firAuthError.message, preferredStyle: UIAlertControllerStyle.alert)

                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                
                self.present(alertFIRLogin, animated: true, completion: nil)
                
                alertFIRLogin.addAction(okButton)
            }
        }
    }
}

// MARK: List of Firebase errors and messages
extension FIRAuthErrorCode {
    var title: String {
        return ""
    }
    
    var message: String {
        switch self {
        case .errorCodeEmailAlreadyInUse:
            return ("Email address already in use.")
        case .errorCodeInvalidEmail:
            return ("Invalid email address.")
        case .errorCodeUserNotFound:
            return ("User not found.")
        case .errorCodeWeakPassword:
            return ("Weak password.")
        case .errorCodeWrongPassword:
            return ("Wrong password.")
        case .errorCodeKeychainError:
            return ("Key chain error.")
        default:
            return ("This is Vibhas' fault. Merge error.")
        }
    }
}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            usernameTextField.becomeFirstResponder()
        }
        
        if textField == passwordTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        if textField.resignFirstResponder() {

        }
        
        return true
    }
}
