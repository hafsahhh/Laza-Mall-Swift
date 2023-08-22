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
            slider.addTarget(self, action: #selector(sliderValueChangedBaru(_:)), for: .valueChanged)
        }
    }
    
    @objc func sliderValueChangedBaru(_ sender: CustomSlider) {
        let value = sender.value
        scoreRating.text = String(format: "%.1f", value) // Mengubah teks label rating dengan nilai slider
        reviewRating = Double(value)
    }
    
    @IBOutlet weak var scoreRating: UILabel!
    
    
    var addReviewId: Int!
    var reviewComment: String?
    var reviewRating: Double = 0.0
    var addReviewViewModel = AddReviewViewModel()
    //    private let ratingLb: Double = 0.0
    
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
        
        //        addReviewProductByApi()
        //        setupSlider()
    }
    
    // MARK: - Navigation
    func addReviewProductByApi() {
        if let comment = addReviewOutlet.text,
           let ratingText = scoreRating.text,
           let id = addReviewId,
           let rating = Double(ratingText)
            
        {
            // Panggil fungsi API menggunakan nilai dari TextField
            addReviewViewModel.addReviewProductApi(comment: comment, rating: rating, id: id) { result in
                switch result {
                case .success(let data):
                    self.addReviewViewModel.apiAlertAddreview = { status in
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                            ShowAlert.addReview(on: self, title: status, message: "successfully add review in this product")
                        }
                    }
                    print("API Response Data: \(String(describing: data))")
                case .failure(let error):
                    self.addReviewViewModel.apiAlertAddreview = { status in
                        DispatchQueue.main.async {
                            ShowAlert.addReview(on: self, title: status, message: "error")
                        }
                    }
                    print("API Add Review Error: \(error)")
                }
            }
        } else {
            print("Invalid input data")
        }
        
    }
    
    // MARK: - Slider Configuration
    
    func setupSlider() {
        slider.sliderHeight = CGFloat(18)
        slider.minimumValue = 0.0
        slider.maximumValue = 5.0
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func sliderValueChanged(_ sender: CustomSlider) {
        let value = sender.value
        scoreRating.text = String(format: "%.1f", value) // Mengubah teks label rating dengan nilai slider
    }
    
    //fungsi untuk melihat hasil review
    func reviewAllController(){
        let addreviewCtrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNestedVC") as! HomeNestedVC
        addreviewCtrl.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(addreviewCtrl, animated: true)
    }
    
    
    @IBAction func submitRevieBtn(_ sender: UIButton) {
        addReviewProductByApi()
    }
}
