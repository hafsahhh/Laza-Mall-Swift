//
//  PaymentVC.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 07/08/23.
//

import UIKit


protocol choosePaymentProtocol: AnyObject{
    func delegatCardPayment(cardNumber: String, bankName: String)
}

class PaymentVC: UIViewController {

    @IBOutlet weak var cardPaymentCollect: UICollectionView!
    @IBOutlet weak var cardOwnerTf: UITextField!{
        didSet{
            cardOwnerTf.isEnabled = false
        }
    }
    
    @IBOutlet weak var cardNumberTf: UITextField!{
        didSet{
            cardNumberTf.isEnabled = false
        }
    }
    
    @IBOutlet weak var cardExpiredTf: UITextField!{
        didSet{
            cardExpiredTf.isEnabled = false
        }
    }
    
    @IBOutlet weak var cardCvvTf: UITextField!{
        didSet {
            cardCvvTf.isEnabled = false
        }
    }
    
    var cardModels = [CreditCard]()
    var coreDataManage = CoreDataManage()
    var selectedCellIndex: IndexPath?
    var numberCardChoose: String?
    weak var delegate: choosePaymentProtocol?
    var bank: String = "BNI"
    
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
//        let backToCart = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as! CartVC
//        self.navigationController?.pushViewController(backToCart, animated: true)
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
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }

    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        retrieveCardOnStart()
        
    }
    
    //MARK: Func Retrive Crad
    func retrieveCardOnStart() {
        cardModels.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.coreDataManage.retrieve { creditCard in
                self?.cardModels.append(contentsOf: creditCard)
                // Set first item as selected
                if self?.cardModels.count ?? 0 > 0{
                    let indexPath = IndexPath(item: 0, section: 0)
                    self?.performCardInTextfield(indexPath: indexPath)
                    self?.cardPaymentCollect.reloadData()
                }
            }
        }
    }
    
    // MARK: - Delete Card Func
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
    
    // MARK: - Delete Card Btn
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
    
    // MARK: - Edit Card Btn
    @IBAction func editCardBtn(_ sender: Any) {
        guard let editCardBtn = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditCradVC") as? EditCradVC else { return }
        guard let numberCard = cardNumberTf.text else {return}
        guard let nameCard = cardOwnerTf.text else {return}
        editCardBtn.editCardOwner = nameCard
        editCardBtn.editCardNumber = numberCard
        editCardBtn.indexPathCardNumber = self.numberCardChoose
        self.navigationController?.pushViewController(editCardBtn, animated: true)
    }
    
    // MARK: - Choose Card Btn
    @IBAction func chooseCardBtn(_ sender: Any) {
        guard let chooseCardNumber = cardNumberTf.text else {return}
        let chooseBank = bank
        print("protocol payment ini nomer kartu: \(chooseCardNumber), \(chooseBank)")
        self.delegate?.delegatCardPayment(cardNumber: chooseCardNumber, bankName: chooseBank)
    self.navigationController?.popViewController(animated: true)
    }
    
    
}


// MARK: - Extensions Payment View Controller
extension PaymentVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("total card \(cardModels.count)")
        return cardModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        print("Screen width: \(width)")
        let heightToWidthRatio: Double = Double(200) / Double(300)
        let height = width * heightToWidthRatio
        print(width, height, separator: " - ")
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listPayCell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentCollectCell.identifier, for: indexPath) as? PaymentCollectCell
        else {
            return UICollectionViewCell()
        }
        let card = cardModels[indexPath.item]
        //waktu untuk nampilin kartu agar bisa berubah warna
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            listPayCell.fillCardDataFromCoreData(card: card)
        }
        return listPayCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performCardInTextfield(indexPath: indexPath)
    }
    
    // MARK: - Func Show Card in textfield
    //Func untuk menampilkan informasi crad di tetfield
    func performCardInTextfield(indexPath: IndexPath){
        selectedCellIndex = indexPath
        let card = cardModels[indexPath.item]
        self.numberCardChoose = card.cardNumber
        cardOwnerTf.text = card.cardOwner
        cardNumberTf.text = card.cardNumber
        cardExpiredTf.text = "\(card.cardExpYear)/\(card.cardExpMonth)"
        cardCvvTf.text = String(card.cardCvv)
    }
  

    // MARK: - scrollViewDidEndDecelerating
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


