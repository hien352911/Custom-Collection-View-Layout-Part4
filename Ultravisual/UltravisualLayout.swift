//
//  UltravisualLayout.swift
//  RWDevCon
//
//  Created by Mic Pringle on 27/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

/* The heights are declared as constants outside of the class so they can be easily referenced elsewhere */
struct UltravisualLayoutConstants {
  struct Cell {
    /* The height of the non-featured cell */
    static let standardHeight: CGFloat = 100
    /* The height of the first visible cell */
    static let featuredHeight: CGFloat = 280
  }
}

class UltravisualLayout: UICollectionViewLayout {
  
  // MARK: Properties and Variables
  
  /* The amount the user needs to scroll before the featured cell changes */
  let dragOffset: CGFloat = 180.0
  
  var cache = [UICollectionViewLayoutAttributes]()
  
  /* Returns the item index of the currently featured cell */
  var featuredItemIndex: Int {
    get {
      /* Use max to make sure the featureItemIndex is never < 0 */
      return max(0, Int(collectionView!.contentOffset.y / dragOffset))
    }
  }
  
  /* Returns a value between 0 and 1 that represents how close the next cell is to becoming the featured cell */
  var nextItemPercentageOffset: CGFloat {
    get {
      return (collectionView!.contentOffset.y / dragOffset) - CGFloat(featuredItemIndex)
    }
  }
  
  /* Returns the width of the collection view */
  var width: CGFloat {
    get {
        return collectionView!.bounds.width
    }
  }
  
  /* Returns the height of the collection view */
  var height: CGFloat {
    get {
        return collectionView!.bounds.height
    }
  }
  
  /* Returns the number of items in the collection view */
  var numberOfItems: Int {
    get {
        return collectionView!.numberOfItems(inSection: 0)
    }
  }
  
  // MARK: UICollectionViewLayout
  
  /* Return the size of all the content in the collection view */
    
    override var collectionViewContentSize: CGSize {
        let contentHeight = (CGFloat(numberOfItems) * dragOffset) + (height - dragOffset)
        return CGSize(width: width, height: contentHeight)
    }
  
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
    
        let standarHeight = UltravisualLayoutConstants.Cell.standardHeight
        let featureHeight = UltravisualLayoutConstants.Cell.featuredHeight
        
        var frame = CGRect.zero
        var y: CGFloat = 0
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            // Items with higher index values appear on top of items with lower values.
            attributes.zIndex = item
            var height = standarHeight
            if indexPath.item == featuredItemIndex {
                /*
                 standarHeight = 100
                 nextItemPercentageOffset = {-1, 1} (chạy từ -1 đến 1)
                 yOffset = {-100, 100}
                 */
                let yOffset = standarHeight * nextItemPercentageOffset
                /*
                 Có 3 cách kéo dài 1 cell or header của collection view
                 C1: increase height
                 C2: increase y theo contentOffset của collection view (vì khi kéo xuống, offset của content size tăng, mà cell nằm trong content size (cell 0, origin.y = 0), nên cell cũng bị kéo cùng với content size (thay đổi origin của cha thì view con bị di chuyển theo). Muốn cell vẫn giữ ở top thì increase y của cell = đúng với content offset
                 C3: increase height và increase y theo contentOffset của collection view
                 */
                y = collectionView!.contentOffset.y - yOffset
                height = featureHeight
            } else if indexPath.item == (featuredItemIndex + 1) && indexPath.item != numberOfItems {
                /*
                 standarHeight = const
                 maxY = ⬆️⬆️ y
                 */
                let maxY = y + standarHeight
                /*
                 height = { standarHeight, standarHeight + 280 }
                 */
                height = standarHeight + max((featureHeight - standarHeight) * nextItemPercentageOffset, 0)
                y = maxY - height
            }
            frame = CGRect(x: 0, y: y, width: width, height: height)
            attributes.frame = frame
            cache.append(attributes)
            y = frame.maxY
        }
  }
  
  /* Return all attributes in the cache whose frame intersects with the rect passed to the method */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
            layoutAttributes.append(attributes)
          }
        }
        return layoutAttributes
    }
  
  /* Return true so that the layout is continuously invalidated as the user scrolls */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
}
