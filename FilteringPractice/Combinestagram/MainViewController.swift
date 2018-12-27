/*
 * Copyright (c) 2016-present Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var itemAdd: UIBarButtonItem!
    
    private var images = [UIImage]()
    private var imageCache = [Int]()
    private var imagesSubject = BehaviorSubject<[UIImage]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesSubject.asObservable()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] photos in
                self?.setupUI(photos: photos)
            }).disposed(by: disposeBag)
    }
    
    @IBAction func actionClear() {
        images = []
        imageCache = []
        imagesSubject.onNext(images)
    }
    
    @IBAction func actionSave() {
        guard let image = imagePreview.image else { return }
        PhotoWriter.save(image)
            .subscribe(onSuccess: { _ in
                self.showMessage("saved")
            }, onError: { error in
                self.showMessage(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    @IBAction func actionAdd() {
        guard let photosViewController = UIStoryboard.photoViewController() else { return }
        navigationController?.pushViewController(photosViewController, animated: true)
        
        photosViewController.selectedPhoto
            .takeWhile { _ in return self.images.count < 6 }
            .filter { newImage in return newImage.size.width > newImage.size.height }
            .filter { newImage in
                let len = UIImagePNGRepresentation(newImage)?.count ?? 0
                guard self.imageCache.contains(len) == false else { return false }
                self.imageCache.append(len)
                return true
            }
            .subscribe(onNext: { image in
                self.images.append(image)
                self.imagesSubject.onNext(self.images)
            }, onCompleted: {
                
            }).disposed(by: disposeBag)
        
        photosViewController.selectedPhoto
            .share()
            .ignoreElements()
            .subscribe(onCompleted: {
                self.updateNavigationIcon()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func updateNavigationIcon() {
        let icon = imagePreview.image?
            .scaled(CGSize(width: 22, height: 22))
            .withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: icon, style: .done, target: nil, action: nil)
    }
    
    private func setupUI(photos: [UIImage]) {
        buttonSave.isEnabled = photos.count > 0 && photos.count % 2 == 0
        buttonClear.isEnabled = photos.count > 0
        title = photos.count > 0 ? "\(photos.count) photos" : "collage"
        
        imagePreview.image = UIImage.collage(images: photos, size: imagePreview.frame.size)
    }
    
    func showMessage(_ title: String, description: String? = nil) {
        alert(title, description: description)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension UIStoryboard {
    static func main() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static func photoViewController() -> PhotosViewController? {
        return main().instantiateViewController(withIdentifier: "PhotosViewController") as? PhotosViewController
    }
}

extension UIViewController {
    func alert(_ title: String, description: String? = nil) -> Completable {
        return Completable.create(subscribe: { completable in
            let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
                    completable(.completed)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            return Disposables.create {
                self.dismiss(animated: true, completion: nil)
            }
        }).timeout(0.5, scheduler: MainScheduler.instance)
    }
}
