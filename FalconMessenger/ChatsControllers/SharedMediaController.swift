//
//  SharedMediaController.swift
//  FalconMessenger
//
//  Created by Roman Mizin on 11/24/18.
//  Copyright © 2018 Roman Mizin. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit

private let sharedMediaCellID = "sharedMediaCellID"
private let sharedMediaSupplementaryID = "sharedMediaSupplementaryID"

class SharedMediaController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	fileprivate var sharedMedia = [[SharedMedia]]() {
		didSet {
			DispatchQueue.global(qos: .utility).async { [unowned self] in
				self.configureViewable()
			}
		}
	}

	fileprivate var isLoading = false
	fileprivate var viewable = [INSPhotoViewable]()
	fileprivate let sharedMediaHistoryFetcher = SharedMediaHistoryFetcher()
	fileprivate let viewPlaceholder = ViewPlaceholder()

	var fetchingData: (userID: String, chatID: String)? {
		didSet {
			fetchPhotos()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		collectionView?.register(SharedMediaCell.self, forCellWithReuseIdentifier: sharedMediaCellID)
		collectionView?.register(ChatLogViewControllerSupplementaryView.self,
														 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
														 withReuseIdentifier: sharedMediaSupplementaryID)
		configureController()
	}

	fileprivate func configureController() {
		navigationItem.title = "Shared Media"
		collectionView?.alwaysBounceVertical = true
		view.backgroundColor = ThemeManager.currentTheme().generalBackgroundColor
		collectionView?.backgroundColor = view.backgroundColor
		extendedLayoutIncludesOpaqueBars = true
		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}

		let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
		layout.minimumLineSpacing = 1
		layout.minimumInteritemSpacing = 1

		let collectionViewSize = collectionView!.frame.size
		let nrOfCellsPerRow: CGFloat = 4
		
		let itemWidth = collectionViewSize.width/nrOfCellsPerRow
		layout.itemSize = CGSize(width: itemWidth-2, height: itemWidth-2)

		if #available(iOS 11.0, *) {
			collectionView?.contentInsetAdjustmentBehavior = .always
		}

		collectionView?.addRefreshFooter { [weak self] (footer) in
			guard self?.isLoading == false else { return }
			self?.isLoading = true
			self?.sharedMediaHistoryFetcher.loadPreviousMedia(self?.fetchingData)
		}
	}

	fileprivate func configureViewable() {
		_ = sharedMedia.map({$0.map({ (element) in
			guard let urlString = element.imageURL else { return }

			var viewableElement: INSPhotoViewable!

			let cacheKey = SDWebImageManager.shared.cacheKey(for: URL(string: urlString))

			SDImageCache.shared.containsImage(forKey: cacheKey, cacheType: .disk) { (cacheType) in
				if cacheType == SDImageCacheType.disk {
					SDWebImageManager.shared.loadImage(with: URL(string: urlString),
																						 options: [.scaleDownLargeImages, .continueInBackground],
																						 progress: nil, completed:
						{ (image, _, _, _, _, _) in
							viewableElement = INSPhoto(image: image, thumbnailImage: image, messageUID: element.id)
							self.updateViewables(element: element, viewableElement: viewableElement)
					})
				} else {
					if let thumbnailURLString = element.thumbnailImageUrl {
						viewableElement = INSPhoto(imageURL: URL(string: urlString), thumbnailImageURL: URL(string: thumbnailURLString), messageUID: element.id)
					} else {
						viewableElement = INSPhoto(imageURL: URL(string: urlString), thumbnailImageURL: URL(string: urlString), messageUID: element.id)
					}
					self.updateViewables(element: element, viewableElement: viewableElement)
				}
			}
		})})
	}

	fileprivate func updateViewables(element: SharedMedia, viewableElement: INSPhotoViewable) {
		if !self.viewable.contains(where: { (viewable) -> Bool in
			return viewable.messageUID == viewableElement.messageUID
		}), element.videoURL == nil {
			let index = self.viewable.insertionIndexOf(elem: viewableElement, isOrderedBefore: { (viewable1, viewable2) -> Bool in
				return viewable1.messageUID! > viewable2.messageUID!
			})
			self.viewable.insert(viewableElement, at: index)
		}
	}

	fileprivate func fetchPhotos() {
		sharedMediaHistoryFetcher.delegate = self
		ARSLineProgress.ars_showOnView(view)
		sharedMediaHistoryFetcher.loadPreviousMedia(fetchingData)
	}

	// MARK: UICollectionViewDataSource
	override func collectionView(_ collectionView: UICollectionView,
															 viewForSupplementaryElementOfKind kind: String,
															 at indexPath: IndexPath) -> UICollectionReusableView {
		if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sharedMediaSupplementaryID,
																																		for: indexPath) as? ChatLogViewControllerSupplementaryView {
			header.label.text = sharedMedia[indexPath.section][indexPath.row].shortConvertedTimestamp
			return header
		}
		return UICollectionReusableView()
	}

	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return sharedMedia.count
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return sharedMedia[section].count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sharedMediaCellID,
																									for: indexPath) as? SharedMediaCell ?? SharedMediaCell()
		let sharedElement = sharedMedia[indexPath.section][indexPath.row]
		cell.configureCell(sharedElement: sharedElement)

		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: false)
		guard let cell = collectionView.cellForItem(at: indexPath) as? SharedMediaCell else {
			return
		}

		let currentElement = sharedMedia[indexPath.section][indexPath.row]
		if let videoURL = currentElement.videoURL, let url = URL(string: videoURL) {
			let viewController = viewControllerForVideo(with: url)
			present(viewController, animated: true, completion: nil)
			return
		}

		guard let initialPhotoIndex = viewable.index(where: {$0.messageUID == currentElement.id }) else { return }
		let currentPhoto = viewable[initialPhotoIndex]
		let galleryPreview = INSPhotosViewController(photos: viewable,
																								 initialPhoto: currentPhoto,
																								 referenceView: cell)
		galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
			guard let indexPath = SharedMedia.get(indexPathOf: photo,
																						in: self?.sharedMedia ?? [[SharedMedia]]()) else { return nil }
			guard let cellForDismiss = self?.collectionView?.cellForItem(at: indexPath) as? SharedMediaCell else { return nil }
			return cellForDismiss.sharedPhotoImageView
		}
		present(galleryPreview, animated: true, completion: nil)
	}

	func collectionView(_ collectionView: UICollectionView,
											layout collectionViewLayout: UICollectionViewLayout,
											referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: collectionView.bounds.width, height: 40)
	}

	fileprivate func viewControllerForVideo(with url: URL) -> UIViewController {
		let player = AVPlayer(url: url)

		let inBubblePlayerViewController = AVPlayerViewController()
		inBubblePlayerViewController.player = player
		inBubblePlayerViewController.modalTransitionStyle = .crossDissolve
		if DeviceType.isIPad {
			inBubblePlayerViewController.modalPresentationStyle = .overFullScreen
		} else {
			inBubblePlayerViewController.modalPresentationStyle = .overCurrentContext
		}
		player.play()
		return inBubblePlayerViewController
	}
}

extension SharedMediaController: SharedMediaHistoryDelegate {

	func sharedMediaHistory(allLoaded: Bool) {
		DispatchQueue.main.async {
			self.collectionView?.removeRefreshFooter()
		}
		isLoading = false
		ARSLineProgress.hide()
	}

	func sharedMediaHistory(isEmpty: Bool) {
		if isEmpty {
			viewPlaceholder.add(for: view, title: .emptySharedMedia, subtitle: .emptyString, priority: .medium, position: .center)
			ARSLineProgress.hide()
			return
		} else {
			viewPlaceholder.remove(from: view, priority: .medium)
		}
	}

	func sharedMediaHistory(updated sharedMedia: [SharedMedia]) {
		let oldSectionsIndexes = self.sharedMedia.count > 0 ? self.sharedMedia.count-1 : 0

		var flattenArray = Array(self.sharedMedia.joined())
		flattenArray.append(contentsOf: sharedMedia)

		let newSharedMedia = SharedMedia.groupedSharedMedia(flattenArray)
		let numberOfSectionsForReload = newSharedMedia.count - self.sharedMedia.count

		self.sharedMedia = newSharedMedia
		self.collectionView?.refreshFooter?.stopLoading()
		isLoading = false

		UIView.performWithoutAnimation {
			collectionView?.performBatchUpdates({
				var indexSet = IndexSet()

				if numberOfSectionsForReload >= 1 {
					for index in 1...numberOfSectionsForReload {
						let indexSetElement = self.sharedMedia.count - index
						indexSet.insert(indexSetElement)
					}
				}

				if self.sharedMedia.count == 1 && self.collectionView?.numberOfSections == 1 {
					collectionView?.reloadSections([0])
					return
				}

				if oldSectionsIndexes > 0 {
					collectionView?.reloadSections([oldSectionsIndexes])
				}

				collectionView?.insertSections(indexSet)
			}, completion: { (_) in
				ARSLineProgress.hide()
			})
		}
	}
}