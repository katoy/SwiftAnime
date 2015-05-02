//
//  ViewController.swift
//  SwiftAnime
//
//  Created by katoy on 2015/04/29.
//  Copyright (c) 2015年 Youichi Kato. All rights reserved.
//
// See http://nanananande.helpfulness.jp/post-3403/
//     > Xcode6とSwiftで画面コンポーネント(UIコンポーネント)を配置して利用するための基本
//     http://nanananande.helpfulness.jp/post-3446/
//     > Xcode6とSwiftでイメージ(画像)やアニメーションを表示する方法

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate {

    // 画像ファイル名のための定数
    let droid = "ドロイドちゃん"
    let separator = "_"
    let directions = ["前へ", "左へ", "後へ", "右へ"]
    let animationDurations = ["0.3", "0.5", "1.0", "1.5", "2.0", "2.5", "3.0"]

    var imageListArraySet = Dictionary< String, Array<UIImage> >()

    // make sure to add this sound to your project
    var footstepsSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sound", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()

    var cx : CGFloat = 0
    var cy : CGFloat = 0
    var w0 : CGFloat = 0
    var h0 : CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        // アニメーションに利用するファイル群に対応する UIImage の配列を作成
        for direction in directions {
            var imageList : Array<UIImage> = []
            for index in 1...4 {
                // 現在のindexに対応するメディア名を生成して対応するUIImageを作成
                var droidImage = UIImage(named: "\(droid)\(separator)\(direction)\(separator)\(index).gif")
                imageList.append(droidImage!)
            }
            imageListArraySet[direction] = imageList
        }
        // 音楽再生のための設定
        audioPlayer = AVAudioPlayer(contentsOfURL: footstepsSound, error: nil)
        audioPlayer.prepareToPlay()

        // 画像の位置
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
        cx = myBoundSize.width / 2
        cy = imageView.frame.midY
        imageView.center = CGPointMake(cx, cy)
        w0 = imageView.frame.width
        h0 = imageView.frame.height

        // ピッカーの初期値
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.selectRow(2, inComponent: 1, animated: true)
    }

    @IBOutlet weak var pickerView: UIPickerView!

    @IBOutlet weak var imageView: UIImageView!


    @IBAction func btnStart(sender: UIButton) {
        // showAlert(sender.titleLabel!.text!)
        stopAnimation()
        startAnimation()
    }

    @IBAction func btnStop(sender: UIButton) {
        // showAlert(sender.titleLabel!.text!)
        stopAnimation()
    }

    @IBAction func doZoom(sender: AnyObject) {
        changeImageSize(2.0)
    }

    @IBAction func doPan(sender: AnyObject) {
        changeImageSize(0.5)
    }

    @IBAction func doReset(sender: AnyObject) {
        setImageSize(1.0)
    }

    // 停止しているときに表示する画像を現在の進行方向の画像に設定する。
    func setImage() {
        let direction = directions[pickerView.selectedRowInComponent(0)]
        imageView.image = imageListArraySet[direction]![0]
    }

    // 画像のサイズを相対的に変更する。
    func changeImageSize(scale : CGFloat){
        UIView.animateWithDuration(2.0, delay: 0.0, options: .CurveEaseOut, animations: {

            self.imageView.frame = CGRectMake(0, 0,
                self.imageView.frame.width * scale,
                self.imageView.frame.height * scale )
            self.imageView.center = CGPointMake(self.cx, self.cy)

            }, completion: nil)
    }
    // 画像のサイズを設定する。
    func setImageSize(scale : CGFloat) {
        self.imageView.frame = CGRectMake(0, 0,
            w0 * scale, h0 * scale)
        self.imageView.center = CGPointMake(self.cx, self.cy)
    }
    func stopAnimation() {
        // アニメーションが開始していれば停止
        if imageView.isAnimating() {
            imageView.stopAnimating()
            setImage()
        }
    }

    func startAnimation() {
        // アニメーションの一回りにかける秒をセット
        let speed = (animationDurations[pickerView.selectedRowInComponent(1)] as NSString).doubleValue
        imageView.animationDuration = 1.0 / speed

        // 繰り返しは無限にするため 0 をセット
        imageView.animationRepeatCount = 0

        // イメージリストをセット
        let direction = directions[pickerView.selectedRowInComponent(0)]
        imageView.animationImages = imageListArraySet[direction]!

        // アニメーションを開始
        imageView.startAnimating()
        audioPlayer.play()
    }

    func showAlert(name : String) {
        var alertView = UIAlertView()

        alertView.addButtonWithTitle("OK")
        alertView.title = "[\(name)] ボタンから表示"
        alertView.message = "方向：" + directions[pickerView.selectedRowInComponent(0)] +
            "\n速度：" + animationDurations[pickerView.selectedRowInComponent(1)]
        alertView.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return directions.count;  // 1 列目の選択肢の数
        } else {
            return animationDurations.count;  // 2 列目の選択肢の数
        }
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 0 {
            return directions[row]  // 1 列目の row 番目に表示する値
        } else {
            return animationDurations[row]  // 2 列目の row 番目に表示する値
        }
    }

    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {

        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()

            //color  and center the label's background
            let hue = CGFloat(row) / 5
            pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness:1.0, alpha: 1.0)
            pickerLabel.textAlignment = .Center

        }
        var titleData = ""
        if component == 0 {
            titleData = directions[row]  // 1 列目の row 番目に表示する値
        } else {
            titleData = animationDurations[row]  // 2 列目の row 番目に表示する値
        }
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle

        return pickerLabel
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if imageView.isAnimating() {
            startAnimation()
        } else {
            setImage()
        }
    }
}