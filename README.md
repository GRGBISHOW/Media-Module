# Media-Module

Media Module is a layer based RxSwift's extension of UIImagePickerViewController. It provides a complete solution for any tasks related to the Media (Images/Videos/gallery) for your application.

## Image Picker

Simple Image picker with source options (camera and gallery). 

```Swift
addImageBtn.rx.tap.flatMap{self.getImage()}.bind(to: self.showCaseImageView.rx.image).disposed(by: disposeBag)

```

# Enhancements
* Video Recoder
* Gallery

# License
[MIT](https://github.com/GRGBISHOW/Media-Module/blob/master/LICENSE)
