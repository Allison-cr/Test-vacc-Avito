//
//  Mansory.swift
//  Test-vacc-Avito
//
//  Created by Alexander Suprun on 11.09.2024.
//
// MasonryLayout.swift

import UIKit

// MARK: - Mansory Layout 

class MasonryLayout: UICollectionViewLayout {
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width
    }

    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 0
    private var cellSizes: [IndexPath: CGSize] = [:]

    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        cache.removeAll()
        contentHeight = 0
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffsets: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffsets.append(CGFloat(column) * columnWidth)
        }
        
        var yOffsets: [CGFloat] = Array(repeating: 0, count: numberOfColumns)

        var indexPath = IndexPath(item: 0, section: 0)
        
        while indexPath.item < collectionView.numberOfItems(inSection: 0) {
            let item = indexPath.item
            let column = item % numberOfColumns
            let xOffset = xOffsets[column]
            
            let height: CGFloat
            if let size = cellSizes[indexPath] {
                height = size.height * (columnWidth / size.width)
            } else {
                height = columnWidth
            }
            
            let frame = CGRect(x: xOffset, y: yOffsets[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffsets[column] = yOffsets[column] + height
            
            indexPath.item += 1
        }
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first(where: { $0.indexPath == indexPath })
    }

    func updateCellSize(for indexPath: IndexPath, size: CGSize) {
        cellSizes[indexPath] = size
        invalidateLayout()
    }
}
