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
    var selectedCellIndex: IndexPath?
    var numberCardChoose: String?
    
    
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
        let backToCart = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as! CartVC
        self.navigationController?.pushViewController(backToCart, animated: true)
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

        retrieveCard()
        cardPaymentCollect.reloadData()
    }
    
    //MARK: FUNCTION
    func retrieveCard() {
        cardModels.removeAll()
        coreDataManage.retrieve { [weak self] creditCard in
            self?.cardModels.append(contentsOf: creditCard)
            self?.cardPaymentCollect.reloadData()
        }
    }
    
    
    func deleteCard(indexPath: IndexPath) {
        let card = cardModels[indexPath.row]
        coreDataManage.delete(card) { [weak self] in
            DispatchQueue.main.async {
                self?.cardModels.remove(at: indexPath.row)
                self?.cardPaymentCollect.deleteItems(at: [indexPath])
            }
        }
        print("successfully delete card")
    }
    
    @IBAction func deleteCardBtn(_ sender: UIButton) {
        guard let selectedCell = selectedCellIndex else {return}
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure want to delete this cards?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
                self?.deleteCard(indexPath: selectedCell)
            }
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)

    }
    
    @IBAction func editCardBtn(_ sender: Any) {
        guard let editCardBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditCradVC") as? EditCradVC else { return }
        editCardBtn.editCardOwner = cardOwnerView.text!
        editCardBtn.editCardNumber = cardNumberView.text!
        editCardBtn.indexPathCardNumber = self.numberCardChoose
        self.navigationController?.pushViewController(editCardBtn, animated: true)
    }
    
}

extension PaymentVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performCardInTextfield(indexPath: indexPath)
    }
    //Func untuk menampilkan informasi crad di tetfield
    func performCardInTextfield(indexPath: IndexPath){
        selectedCellIndex = indexPath
        let card = cardModels[indexPath.item]
        self.numberCardChoose = card.cardNumber
        cardOwnerView.text = card.cardOwner
        cardNumberView.text = card.cardNumber
        cardExpiredView.text = card.cardExpYear + "/" + card.cardExpMonth
        cardCvvView.text = card.cardCvv
        // Memastikan tampilan terbaru ditampilkan
        cardPaymentCollect.reloadData()
    }
  

    // Metode ini akan dipanggil setelah user selesai menggeser dan koleksi berhenti bergerak (decelerating).
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Menggunakan if let untuk memeriksa apakah selectedCellIndex tidak nil
        guard let selectedIndexPath = selectedCellIndex else { return }
        let currentIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        
        // Dapatkan bagian (section) dari selectedIndexPath
        let selectedSection = selectedIndexPath.section
        // Buat IndexPath baru dengan selectedSection dan currentIndex
        let newIndexPath = IndexPath(item: currentIndex, section: selectedSection)
        
        // Memanggil fungsi performCardInTextfield dengan newIndexPath
        performCardInTextfield(indexPath: newIndexPath)
        
        // Dapat memeriksa apakah currentIndex sama dengan selectedRow atau tidak
        if currentIndex != selectedIndexPath.row {
            // Melakukan tindakan yang sesuai jika currentIndex berbeda
            print("Indeks terpilih setelah berhenti: \(currentIndex)")
        }
    }

    
}


