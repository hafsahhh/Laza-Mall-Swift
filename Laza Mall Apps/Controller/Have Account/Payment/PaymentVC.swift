//
//  PaymentVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 07/08/23.
//

import UIKit

class PaymentVC: UIViewController {

    @IBOutlet weak var cardPaymentCollect: UICollectionView!
    @IBOutlet weak var cardOwnerView: UITextField!{
        didSet{
            cardOwnerView.isEnabled = false
        }
    }
    
    @IBOutlet weak var cardNumberView: UITextField!{
        didSet{
            cardNumberView.isEnabled = false
        }
    }
    
    @IBOutlet weak var cardExpiredView: UITextField!{
        didSet{
            cardExpiredView.isEnabled = false
        }
    }
    
    @IBOutlet weak var cardCvvView: UITextField!{
        didSet {
            cardCvvView.isEnabled = false
        }
    }
    
    var cardModels = [CreditCard]()
    var coreDataManage = CoreDataManage()
    
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
    

    //Add Card Button
    @objc func addCardBtnAct(){
        let addCardBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        self.navigationController?.pushViewController(addCardBtn, animated: true)
    }
    
    // MARK: - Button Add New Card using programmaticly
    // Add new card Button
    private lazy var addCardBtn : UIButton = {
        //call back button
        let addCardBtn = UIButton.init(type: .custom)
        addCardBtn.setImage(UIImage(named:"PlusBtn"), for: .normal)
        addCardBtn.addTarget(self, action: #selector(addCardBtnAct), for: .touchUpInside)
        addCardBtn.frame = CGRect(x: 300, y: 0, width: 70, height: 70)
        return addCardBtn
    }()
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBarBtn = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem  = backBarBtn
        //cart button
        let addCardBarBtn = UIBarButtonItem(customView: addCardBtn)
        self.navigationItem.rightBarButtonItem  = addCardBarBtn
        
        cardPaymentCollect.dataSource = self
        cardPaymentCollect.delegate = self
        cardPaymentCollect.register(PaymentCollectCell.nib(), forCellWithReuseIdentifier: PaymentCollectCell.identifier)

        cardPaymentCollect.reloadData()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        cardModels = coreDataManage.retrieve()
        cardPaymentCollect.reloadData()
    }

    
    @IBAction func addNewCartBtn(_ sender: Any) {
        let addCardBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        self.navigationController?.pushViewController(addCardBtn, animated: true)
    }
    
}

extension PaymentVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("total card \(cardModels.count)")
        return cardModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listPayCell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentCollectCell.identifier, for: indexPath) as? PaymentCollectCell
        else {
            return UICollectionViewCell()
        }
        
        let card = cardModels[indexPath.item]
        
        listPayCell.fillCardDataFromCoreData(card: card)
        return listPayCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}


