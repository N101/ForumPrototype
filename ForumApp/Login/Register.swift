import UIKit

class Register: UIViewController , UITextFieldDelegate{


    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var mName: UITextField!
    @IBOutlet weak var Email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        fName.delegate = self   // used to enable the hidding and showing
        lName.delegate = self   // of the textboxes (here used for hiding
        mName.delegate = self   // the keyboard with the return key)
        Email.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayMessage (userMessage: String) -> Void{
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            { (action:UIAlertAction!) in
                // COde in this block will will trigger when the OK button is pressed
                print("OK button pressed")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion:  nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func Next(_ sender: Any) {
       
        // Validate whether all info has been inputted correclty
        if ((fName.text?.isEmpty)! || (lName.text?.isEmpty)! || (mName.text?.isEmpty)! || (Email.text?.isEmpty)!) {
            // Display error message
            displayMessage(userMessage: "Please fill out all boxes")
            return
        } else {
            let next = RegisterPassword(nibName: "RegisterPassword", bundle: nil)
            next.Fname = fName.text!
            next.Lname = lName.text!
            next.Mname = mName.text!
            next.email = Email.text!
            navigationController?.pushViewController(next, animated: true)
        }
    
    }
    
    
    @IBAction func Back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
