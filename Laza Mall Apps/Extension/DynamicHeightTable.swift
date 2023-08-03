//
//  DynamicHeightTable.swift
//  Laza Mall Apps
//
//  Created by Siti Hafsah on 02/08/23.
//

import Foundation
import UIKit

class DynamicHeightCollectionView: UICollectionView {
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if bounds.size != intrinsicContentSize {
      self.invalidateIntrinsicContentSize()
    }
  }
  
  override func reloadData() {
    super.reloadData()
    self.invalidateIntrinsicContentSize()
  }
  
  override var intrinsicContentSize: CGSize {
    layoutIfNeeded()
    return collectionViewLayout.collectionViewContentSize
  }
  
}
