//
//  CameraMediaPickerHelper.swift
//  workshop
//
//  Created by Twiscode on 21/07/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import TOCropViewController
import Photos

/**
 Handle Picker for Camera and Photos, and Permissions.
 */
class CameraPickerHandler: NSObject {
    static let shared = CameraPickerHandler()
    
    // MARK: Internal Properties
    fileprivate var currentViewController: UIViewController!
    fileprivate var cropCircular: Bool = false
    fileprivate var aspectRatioPreset: TOCropViewControllerAspectRatioPreset?
    fileprivate var aspectRatioLocked: Bool = false
    fileprivate var aspectRatioPickerHidden: Bool = false
    
    
    // MARK: - Closure
    var imagePickedBlock: ((UIImage) -> Void)?
    var imageCaptionPickedBlock: ((UIImage, String?, String) -> Void)?
    var videoCaptionPickedBlock: ((URL, UIImage, String?, String) -> Void)?
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            DispatchQueue.main.async {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self;
                pickerController.sourceType = .camera
                pickerController.mediaTypes = [kUTTypeImage as String]
                self.currentViewController.present(pickerController, animated: true, completion: nil)
            }
        }
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            DispatchQueue.main.async {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self;
                pickerController.sourceType = .photoLibrary
                pickerController.mediaTypes = [kUTTypeImage as String]
                self.currentViewController.present(pickerController, animated: true, completion: nil)
            }
        }
    }
    
    func checkCameraPermission() {
        let titleCameraPermission = Localify.get("alert.title.camera_permission")
        let titleMicrophonePermission = Localify.get("alert.title.microphone_permission")
        let messageCameraPermission = Localify.get("alert.message.camera_permission")
        let messageMicrophonePermission = Localify.get("alert.message.microphone_permission")
        
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            if AVCaptureDevice.authorizationStatus(for: .audio) == .authorized || AVCaptureDevice.authorizationStatus(for: .audio) == .notDetermined {
                camera()
            } else {
                alertToEncouragePermissionAccessInitially(title: titleMicrophonePermission, message: messageMicrophonePermission)
            }
        } else if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
            alertToEncouragePermissionAccessInitially(title: titleCameraPermission, message: messageCameraPermission)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.camera()
                } else {
                    self.alertToEncouragePermissionAccessInitially(title: titleCameraPermission, message: messageCameraPermission)
                }
            })
        }
    }
    
    func checkPhotosPermission() {
        let titlePermission = Localify.get("alert.title.photos_permission")
        let messagePermission = Localify.get("alert.message.photos_permission")
        
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            photoLibrary()
        } else if PHPhotoLibrary.authorizationStatus() == .denied {
            DispatchQueue.main.async {
                self.alertToEncouragePermissionAccessInitially(title: titlePermission, message: messagePermission)
            }
        } else {
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    self.photoLibrary()
                case .denied, .restricted:
                    DispatchQueue.main.async {
                        self.alertToEncouragePermissionAccessInitially(title: titlePermission, message: messagePermission)
                    }
                case .notDetermined: break
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    
    func alertToEncouragePermissionAccessInitially(title: String, message: String) {
        Alertify.displayConfirmationDialog(
            title: title,
            message: message,
            confirmTitle: Localify.get("alert.title.open_settings"),
            sender: currentViewController,
            isDestructive: false) {
                UIApplication.shared.open(
                    URL(string: UIApplication.openSettingsURLString)!,
                    options: [:],
                    completionHandler: nil)
        }
    }
    
    
    func showActionSheet(viewController: UIViewController, sourceView: UIView) {
        currentViewController = viewController
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: Localify.get("alert.title.camera"), style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.checkCameraPermission()
        }))
        actionSheet.addAction(UIAlertAction(title: Localify.get("alert.title.photos"), style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.checkPhotosPermission()
        }))
        actionSheet.addAction(UIAlertAction(title: Localify.get("toolbar.cancel"), style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            actionSheet.popoverPresentationController?.sourceView = sourceView
            actionSheet.popoverPresentationController?.sourceRect = sourceView.bounds
            actionSheet.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        currentViewController.present(actionSheet, animated: true, completion: nil)
    }
    
    func setCropController(aspectRatio: TOCropViewControllerAspectRatioPreset?, aspectRatioLocked: Bool, aspectRatioPickerHidden: Bool, cropCircular: Bool = false) {
        self.aspectRatioPreset = aspectRatio
        self.aspectRatioLocked = aspectRatioLocked
        self.aspectRatioPickerHidden = aspectRatioPickerHidden
        self.cropCircular = cropCircular
    }
    
    @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("error saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
            })
        }
    }
    
    func handleImageReceived(_ image: UIImage) {
        let cropViewController: TOCropViewController!
        if self.cropCircular {
            cropViewController = TOCropViewController(croppingStyle: .circular, image: image)
        } else {
            cropViewController = TOCropViewController(image: image)
        }
        cropViewController.aspectRatioPickerButtonHidden = self.aspectRatioPickerHidden
        cropViewController.aspectRatioLockEnabled = self.aspectRatioLocked
        if let preset = self.aspectRatioPreset {
            cropViewController.aspectRatioPreset = preset
        }
        cropViewController.delegate = self
        currentViewController.navigationController?.pushViewController(cropViewController, animated: true)
    }
}

// MARK: - UIIMagePicker Delegate, NavigationController Delegate
extension CameraPickerHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentViewController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            handleImageReceived(image)
        } else{
            print("Something went wrong")
        }
        currentViewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - TOCrop Delegate
extension CameraPickerHandler: TOCropViewControllerDelegate {
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        currentViewController.navigationController?.popViewController(animated: true)
        self.imagePickedBlock?(image)
    }
}
