//
//  AddReviewVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 03/08/23.
//

import UIKit
import Cosmos

class AddReviewVC: UIViewController {
    
    @IBOutlet weak var addReviewOutlet: UITextView!{
        didSet{
            addReviewOutlet.placeholder = "Describe your experience?"
        }
    }
    
    
    @IBOutlet weak var slider: CustomSlider! {
        didSet {
            slider.sliderHeight = CGFloat(18)
            slider.minimumValue = 0.0
            slider.maximumValue = 5.0
            slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var scoreRating: UILabel!
    
    private let ratingLb: Float = 0.0
    
    //Back Button
    private lazy var backBtn : UIButton = {
        //call back button
        let backBtn = UIButton.init(type: .custom)
        backBtn.setImage(UIImage(named:"Back"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        backBtn.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        return backBtn
    }()
    
    //Back Button
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //back button
        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn

        // Do any additional setup after loading the view.
    }
    

    @objc func sliderValueChanged(_ sender: CustomSlider) {
        let value = sender.value
        scoreRating.text = String(format: "%.1f", value) // Mengubah teks label rating dengan nilai slider
    }

}
