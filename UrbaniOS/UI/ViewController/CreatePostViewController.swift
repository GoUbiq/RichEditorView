//
//  CreatePostViewController.swift
//  UrbaniOS
//
//  Created by Bastien Ravalet on 2020-09-29.
//  Copyright © 2020 Bastien Ravalet. All rights reserved.
//

import UIKit
import RichEditorView

class CreatePostViewController: UIViewController {
    private static let identifier = "CreatePostViewController"
    
    //MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    class func newInstance() -> UINavigationController {
        let navigation = UINavigationController()
        let instance = createPostStoryboard.instantiateViewController(withIdentifier: self.identifier)
        navigation.modalPresentationStyle = .overFullScreen
        navigation.navigationBar.tintColor = .darkGray
        navigation.setViewControllers([instance], animated: false)
        return navigation
    }
    
    //MARK: - Properties
    private var critiqueManager: CritiqueManager {
        return .sharedInstance
    }
    private var selectingCell: PostBodyTableViewCell? = nil
    private var cells: [CellConfigurator] = []
    private var postingMedia: [PostMedia] = []
    private lazy var cameraVC: CameraViewController = {
        return CameraViewController.newInstance(delegate: self)
    }()
    private var mediaHolderCollectionView: UICollectionView? {
        return (self.tableView.cellForRow(at: .zero) as? CreatePostMediaHolderTableViewCell)?.collectionView
    }
    private var titleField: UITextField? {
        guard let idx = self.cells.firstIndex(where: { $0 is TitleCell }) else { return nil }
        return (self.tableView.cellForRow(at: IndexPath(row: idx, section: 0)) as? PostTitleTableViewCell)?.textField
    }
    private var richText: RichEditorView? {
        guard let idx = self.cells.firstIndex(where: { $0 is BodyCell }) else { return nil }
        return (self.tableView.cellForRow(at: .init(row: idx, section: 0)) as? PostBodyTableViewCell)?.richText
    }
    
    private var createButton: UIBarButtonItem? = nil
    
    //MARK: - VC Delegates
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Create Post"
        
        self.createButton = .init(title: "Post", style: .done, target: self, action: #selector(self.createPost))
        self.navigationItem.rightBarButtonItem = self.createButton
        self.navigationItem.leftBarButtonItem = .init(image: #imageLiteral(resourceName: "nav-close"), style: .plain, target: self, action: #selector(self.dismissView))
        
        self.configureCells()
        
        self.tableView.isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Private
    private func configuredMediaCell() -> MediaActionsCell {
        let holderType: [CreatePostMediaHolderTableViewCell.MediaHolderType] = [
            .action(.init(
                image: #imageLiteral(resourceName: "add-camera"),
                title: "Camera",
                action: { self.showCameraView() })),
            .action(.init(
                image: #imageLiteral(resourceName: "flashOn"),
                title: "Template",
                action: { self.showTemplate()}))
        ]

        return MediaActionsCell(
            item: holderType +
                self.postingMedia.map({ value -> (CreatePostMediaHolderTableViewCell.MediaHolderType) in .media(value, self) })
        )
    }
    
    private func configureCells() {
        self.cells = []

        self.cells = [self.configuredMediaCell()]
        
        self.cells.append(TitleCell(item: ""))
        self.cells.append(BodyCell(item: .init(delegate: self)))
        
        self.tableView.reloadData()
    }
    
    private func showCameraView() {
        self.present(self.cameraVC, animated: true)
    }
    
    private func showTemplate() {
        let vc = TemplateMediaPickerViewController.newInstance(delegate: self)
        self.present(vc, animated: true)
    }
    
    // MARK: Notification
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        if self.cells.first is MediaActionsCell {
            self.cells.remove(at: 0)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [.zero], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    @objc private func keyboardWillHideNotification(_ notification: NSNotification) {
        if !(self.cells.first is MediaActionsCell) {
            self.cells.insert(self.configuredMediaCell(), at: 0)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [.zero], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    @objc private func createPost() {
        guard let title = self.titleField?.text, !title.isEmpty, let body = self.richText?.contentHTML, !body.isEmpty else {
            self.showSimpleAlertPopup(message: "Atleast a title and body is required!")
            return
        }
        
        let hud = Utils.showMessageHud(onViewController: self)
        let group = DispatchGroup()
        var urls: [Int: String] = [:]
        
        for (idx, media) in self.postingMedia.enumerated() {
            group.enter()
            MediaManager.sharedInstance.upload(postMedia: media, completionHandler: { url in
                defer {
                    group.leave()
                    Utils.dismissMessageHud(hud)
                }
                
                guard let url = url else { return }
                
                urls[idx] = url
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            guard !urls.isEmpty else { return }

            let sortedDict = urls.sorted(by: { $0.0 < $1.0 }).map({ $0.value })

            self.critiqueManager.createCritique(title: title, descriptionHTML: body, mediaUrls: sortedDict, defaultMediaUrl: sortedDict.first!) { result in
                self.navigationController?.dismiss(animated: true)
            }
        }
    }
    
    @objc private func dismissView() {
        self.navigationController?.dismiss(animated: true)
    }
}

//MARK: - TableViewDelegate
extension CreatePostViewController: UITableViewDelegate, UITableViewDataSource {
    typealias MediaActionsCell = TableCellConfigurator<CreatePostMediaHolderTableViewCell, [CreatePostMediaHolderTableViewCell.MediaHolderType]>
    typealias TitleCell = TableCellConfigurator<PostTitleTableViewCell, String>
    typealias BodyCell = TableCellConfigurator<PostBodyTableViewCell, PostBodyTableViewCell.CellInfo>
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.cells[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: item).reuseId, for: indexPath)
        item.configure(cell: cell)
        
        return cell
    }
}

extension CreatePostViewController: PostBodyCellDelegate, ProductTagPickerDelegate {
    func didPressAddProductTag(cell: PostBodyTableViewCell) {
        self.selectingCell = cell
        let vc = ProductTagPickerViewController.newInstance(delegate: self)
        self.present(vc, animated: true)
    }
    
    func didSelect(product: Product) {
        self.selectingCell?.addProductTag(product: product)
    }
}

//MARK: - Camera Delegate
extension CreatePostViewController: MediaManagementDelegate {
    func didCreateMedia(media: PostMedia) {
        self.postingMedia.append(media)
        self.configureCells()
    }
    
    func didDeleteMedia(media: PostMedia) {
        self.postingMedia.removeAll(where: { $0 == media })
        self.configureCells()
    }
}
