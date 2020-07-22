//
//  CircleLayout.swift
//  CircularCollectionView
//
//  Created by Robert Ryan on 1/24/17.
//  Copyright © 2017 Robert Ryan. All rights reserved.
//
//  Made some modifications due to lint!

import UIKit

class CircleLayout: UICollectionViewLayout {

    private var center: CGPoint?
    private var itemSize: CGSize?
    private var radius: CGFloat?
    private var numberOfItems: Int?

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        center = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
        let shortestAxisLength = min(collectionView.bounds.width, collectionView.bounds.height)
        itemSize = CGSize(width: shortestAxisLength * 0.25, height: shortestAxisLength * 0.25)
        radius = shortestAxisLength * 0.4
        numberOfItems = collectionView.numberOfItems(inSection: 0)
    }

    override var collectionViewContentSize: CGSize {
        return collectionView?.bounds.size ?? .zero
    }

    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            guard let center = center,
                let numberOfItems = numberOfItems,
                let radius = radius,
                let itemSize = itemSize else {
                    return attributes
            }

            let angle = 2 * .pi * CGFloat(indexPath.item) / CGFloat(numberOfItems)

            attributes.center = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            attributes.size = itemSize

            return attributes
    }

    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            guard let collectionView = collectionView else {
                return nil
            }

            return (0..<collectionView.numberOfItems(inSection: 0)).compactMap { item -> UICollectionViewLayoutAttributes? in
                self.layoutAttributesForItem(at: IndexPath(item: item, section: 0))
            }
    }

    // MARK: - Handle insertion and deletion animation

    private var inserted: [IndexPath]?
    private var deleted: [IndexPath]?

    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)

        inserted =
            updateItems
                .filter { $0.updateAction == .insert }
                .compactMap { $0.indexPathAfterUpdate }
        deleted =
            updateItems
                .filter { $0.updateAction == .delete }
                .compactMap { $0.indexPathBeforeUpdate }
    }

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()

        inserted = nil
        deleted = nil
    }

    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            var attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
            guard inserted?.contains(itemIndexPath) ?? false else { return attributes }

            attributes = layoutAttributesForItem(at: itemIndexPath)
            attributes?.center = CGPoint(x: collectionView?.bounds.midX ?? 0, y: collectionView?.bounds.midY ?? 0)
            attributes?.alpha = 0
            return attributes
    }

    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            var attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)

            guard let deleted = deleted,
                deleted.contains(itemIndexPath),
                let collectionView = collectionView else {
                    return attributes
            }

            attributes = layoutAttributesForItem(at: itemIndexPath)
            attributes?.center = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
            attributes?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            return attributes
    }
}
