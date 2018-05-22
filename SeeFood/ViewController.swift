//
//  ViewController.swift
//  SeeFood
//
//  Created by Kunal Mathur on 5/21/18.
//  Copyright © 2018 com.kunal. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imageViewPicker =  UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imageViewPicker.delegate = self
        imageViewPicker.sourceType = .camera
        imageViewPicker.allowsEditing = false
        
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let userPickedImage =  info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image:userPickedImage) else { fatalError("Could not convert the UserImage to CIImage")}
            
            detect(image: ciimage)
        }
        imageViewPicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage )
    {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else
        {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results =  request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            if let firstResult = results.first {
                if  firstResult.identifier.contains("hotdog")
                {
                    self.navigationItem.title = "Hotdog!"
                }
                else{
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do
        {
            try handler.perform([request])
        }
        catch
        {
            print(error)
        }
    }
    @IBAction func cameraTapped(_ sender: UIBarButtonItem)
    {
        present(imageViewPicker, animated: true, completion: nil)
        
    }
    
}

