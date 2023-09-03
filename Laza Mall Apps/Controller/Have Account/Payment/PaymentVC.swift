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
    var selectedCellIndex = 0
    
    
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
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure want to delete this cards?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
                let indexPathToDelete = IndexPath(item: self?.selectedCellIndex ?? 0, section: 0)
                self?.deleteCard(indexPath: indexPathToDelete)
            }
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)

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
        selectedCellIndex = indexPath.item
        cardPaymentCollect.scrollToItem(
            at: IndexPath(item: selectedCellIndex, section: 0),
            at: .centeredHorizontally,
            animated: true)
        
        // Mendapatkan objek CreditCard yang sesuai
        let selectedCard = cardModels[selectedCellIndex]
        print("selected card: \(selectedCard)")
        // Mengisi UITextField dengan nilai-nilai dari objek CreditCard
        cardOwnerView.text = selectedCard.cardOwner
        print("ini card owner: \(String(describing: cardOwnerView.text))")
        cardNumberView.text = selectedCard.cardNumber
        cardExpiredView.text = "\(selectedCard.cardExpMonth)/\(selectedCard.cardExpYear)"
        cardCvvView.text = selectedCard.cardCvv
        
        // Memastikan tampilan terbaru ditampilkan
        cardPaymentCollect.reloadData()
    }
  
    // Metode ini akan dipanggil ketika user mulai melepas geserannya dan koleksi sedang dalam proses berhenti bergerak (decelerating).
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let itemWidth = cardPaymentCollect.bounds.width
        let offset = scrollView.contentOffset.x
        setSelectedCellOnEndSwipe(scrollViewOffset: offset, cellWidth: itemWidth)
    }

    // Metode ini akan dipanggil setelah user selesai menggeser dan koleksi berhenti bergerak (decelerating).
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Menghitung indeks terpilih yang diperbarui setelah pengguna melakukan geseran.
        let currentIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        
        if selectedCellIndex != currentIndex {
            selectedCellIndex = currentIndex
            print("Indeks terpilih setelah berhenti: \(selectedCellIndex)")
        }
    }

    
    func setSelectedCellOnEndSwipe(scrollViewOffset: CGFloat, cellWidth: CGFloat) {
        if scrollViewOffset > cellWidth * CGFloat(selectedCellIndex + 1) {
            // Geser ke kanan
            selectedCellIndex += 1
        } else if scrollViewOffset < cellWidth * CGFloat(selectedCellIndex) {
            // Geser ke kiri
            selectedCellIndex = max(selectedCellIndex - 1, 0)
        }

        // Geser ke sel yang sesuai
        cardPaymentCollect.scrollToItem(
            at: IndexPath(item: selectedCellIndex, section: 0),
            at: .centeredHorizontally,
            animated: true)

        print("selected index: \(selectedCellIndex)")
    }

    
}


