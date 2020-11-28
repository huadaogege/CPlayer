//
//  PlayerViewController.swift
//  CCPlayer
//
//  Created by 崔玉冠 on 2020/11/21.
//

import Foundation
import UIKit
import AVKit

class PlayerViewController: UIViewController {
    
    var screenObject = UIScreen.main.bounds
    
    var model:PlayModel!
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    
    func initModel(_ model:PlayModel) {
        self.model = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player.pause()
    }
    
    override var shouldAutorotate:Bool {
        return false
    }
    
    func initView() {
        self.view.backgroundColor = UIColor.white
        self.title = self.model.name
        
        initPlayer(filePath: self.model.path, superView: self.view)
        self.player.play()
        
        self.view.addSubview(self.controlView)
        
        let guesture = UITapGestureRecognizer(target:self,action:#selector(self.singleTap))
        guesture.numberOfTapsRequired = 2
            //将创建的手势指定给图像视图
        self.view.addGestureRecognizer(guesture)
    }
    
    lazy var controlView = {() -> UIView in
        let controlView = UIView.init(frame: CGRect(x: 0, y: screenObject.width - 80, width: screenObject.height, height: 60))
        controlView.addSubview(self.slider)
        controlView.addSubview(self.loadTimeLabel)
        controlView.addSubview(self.totalTimeLabel)
        controlView.addSubview(self.pasueButton)
        return controlView
    }()
    
    lazy var slider : UISlider = { [weak self] in
        let slider  = UISlider(frame: CGRect(x: 120,
                                             y: 0,
                                             width:screenObject.height - 240,
                                             height: 10))
        slider.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
        return slider
    }()
    
    lazy var loadTimeLabel : UILabel = { [weak self] in
        let loadTimeLabel = UILabel(frame: CGRect(x: 20,
                                                  y: (self?.slider.frame.maxY)!,
                                                  width: 100,
                                                  height: 20))
        loadTimeLabel.center.y = (self?.slider.center.y)!
        loadTimeLabel.textAlignment = NSTextAlignment.center
        loadTimeLabel.text = "00:00:00"
        return loadTimeLabel
    }()
    
    lazy var totalTimeLabel : UILabel = { [weak self] in
        let totalTimeLabel =  UILabel(frame: CGRect(x:screenObject.height - 100 - 20,
                                                    y: (self?.slider.frame.maxY)!,
                                                    width: 100,
                                                    height: 20))
        totalTimeLabel.text = "00:00:00"
        totalTimeLabel.center.y = (self?.slider.center.y)!
        totalTimeLabel.textAlignment = NSTextAlignment.center
        return totalTimeLabel
    }()
    
    lazy var pasueButton : UIButton = { [weak self] in
        let button = UIButton(frame: CGRect(x: (screenObject.height - 60)/2.0,
                                            y: 25,
                                            width: 50,
                                            height: 25))
        button.setTitle("暂停", for: .normal)
        button.setTitle("播放", for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(pauseButtonSelected(sender:)), for: .touchUpInside)
        return button
    }()
    
    @objc func singleTap() {
        let hidden = self.controlView.isHidden
        self.controlView.isHidden = !hidden
        self.navigationController?.navigationBar.isHidden = !hidden
    }
    
    func initPlayer(filePath:String, superView:UIView) {
        let url = NSURL(fileURLWithPath: filePath)
        
        let playItem = AVPlayerItem(url: url as URL)
        self.player = AVPlayer.init(playerItem: playItem)
        self.player.rate = 1.0
        
        self.playerLayer = AVPlayerLayer.init(player: self.player)
        self.playerLayer.backgroundColor = UIColor.red.cgColor
        self.playerLayer.videoGravity = .resizeAspectFill
        self.playerLayer.frame = CGRect(x: 0,
                                        y: 0,
                                        width: superView.frame.size.height,
                                        height: superView.frame.size.width)
        superView.layer.addSublayer(self.playerLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)

        self.player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main) { [weak self](time) in
            //当前正在播放的时间
            let loadTime = CMTimeGetSeconds(time)
            //视频总时间
            let totalTime = CMTimeGetSeconds((self?.player.currentItem?.asset.duration)!)
            //滑块进度
            self?.slider.value = Float(loadTime/totalTime)
            self?.loadTimeLabel.text = self?.changeTimeFormat(timeInterval: loadTime)
            self?.totalTimeLabel.text = self?.changeTimeFormat(timeInterval: CMTimeGetSeconds((self?.player.currentItem?.asset.duration)!))
        }
    }
    
    func play(){
        self.player.play()
    }
    
    //播放进度
    @objc func sliderValueChange(sender:UISlider){
        if self.player.status == .readyToPlay {
            let time = Float64(sender.value) * CMTimeGetSeconds((self.player.currentItem?.duration)!)
            let seekTime = CMTimeMake(value: Int64(time), timescale: 1)
            self.player.seek(to: seekTime)
        }
    }
    
    //转时间格式
    func changeTimeFormat(timeInterval:TimeInterval) -> String{
        return String(format: "%02d:%02d:%02d",(Int(timeInterval) % 3600) / 60, Int(timeInterval) / 3600,Int(timeInterval) % 60)
    }
    
    //暂停
    @objc func pauseButtonSelected(sender:UIButton)  {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.player.pause()
        }else{
            self.player.play()
        }
    }
    
    @objc func playToEndTime(){
        print("播放完成")
    }
}
