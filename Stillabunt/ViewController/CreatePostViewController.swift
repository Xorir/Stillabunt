//
//  CreatePostViewController.swift
//  Stillabunt
//
//  Created by Lord Summerisle on 2/11/18.
//  Copyright © 2018 ErmanMaris. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreLocation

class CreatePostViewController: UIViewController, UITextViewDelegate {
    
    private struct Constants {
        static let padding: CGFloat = 16.0
        static let textFieldHeightMultiplier: CGFloat = 0.25
    }
    
    var firebaseReference: DatabaseReference?
    var createTextView = UITextView()
    var sendTextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        firebaseReference = Database.database().reference()

        setTextView()
        setSendTextButton()
    }
    
    func setSendTextButton() {
        view.addSubview(sendTextButton)
        sendTextButton.translatesAutoresizingMaskIntoConstraints = false
        sendTextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding).isActive = true
        sendTextButton.topAnchor.constraint(equalTo: createTextView.bottomAnchor, constant: Constants.padding * 2).isActive = true
        sendTextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding).isActive = true
        sendTextButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        sendTextButton.backgroundColor = .purple
        sendTextButton.setTitle("Create Post", for: .normal)
        sendTextButton.addTarget(self, action: #selector(sendTextButtonAction), for: .touchUpInside)
    }
    
    @objc func sendTextButtonAction() {
        createTextView.resignFirstResponder()
    }
    
    func setTextView() {
        view.addSubview(createTextView)
        createTextView.translatesAutoresizingMaskIntoConstraints = false
        createTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding).isActive = true
        createTextView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor , constant: Constants.padding * 2).isActive = true
        createTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding).isActive = true
        createTextView.heightAnchor.constraint(equalToConstant: view.frame.height * Constants.textFieldHeightMultiplier).isActive = true
        
        createTextView.layer.borderWidth = 0.5
        createTextView.layer.borderColor = UIColor.purple.cgColor
        createTextView.layer.cornerRadius = 5.0
        createTextView.returnKeyType = .default
        createTextView.isEditable = true
        createTextView.delegate = self

    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("\(textView.text) message")
        if let latitude = LocationManager.sharedInstance.latitude, let longitude = LocationManager.sharedInstance.longitude {
            saveLocationToFirebase(message: textView.text, lat: latitude, long: longitude)
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func saveLocationToFirebase(message: String, lat: CLLocationDegrees?, long: CLLocationDegrees?) {
        if let latitude = lat, let longitude = long {
            
            firebaseReference?.child("coordinate").childByAutoId().setValue(["lat": "\(latitude)", "long": "\(longitude)", "message": "\(message)"], withCompletionBlock: { (error, reference) in
                if error == nil {
                    print("darn saved")
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
}
