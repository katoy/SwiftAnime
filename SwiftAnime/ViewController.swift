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

class ViewController: UIViewController, UIPickerViewDelegate {

    // 画像ファイル名のための定数
    let droid = "ドロイドちゃん"
    let separator = "_"
    let directions = ["前へ", "後へ", "左へ", "右へ"]
    let animationDurations = ["0.2", "0.5", "1.0", "1.5", "2.0", "2.5", "3.0"]

    var imageListArraySet = Dictionary< String, Array<UIImage> >()

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

    func stopAnimation() {
        // アニメーションが開始していれば停止
        if imageView.isAnimating() {
            imageView.stopAnimating()
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
        }
    }
}