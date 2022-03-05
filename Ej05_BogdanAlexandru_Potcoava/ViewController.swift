//
//  ViewController.swift
//  Ej05_BogdanAlexandru_Potcoava
//
//  Created by Alexandru Bogdan Potcoava on 26/2/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //Creamos outlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    
    //Defino variables
    var player: AVAudioPlayer!
    var index: Int = 0
    var randomSong: Bool = false
    var timer: Timer?
    let songs = ["laSirenitaAudio", "reyLeonAudio", "tarzanAudio"]
    let images = [UIImage(imageLiteralResourceName: "laSirenita"), UIImage(imageLiteralResourceName: "reyLeon"),
                 UIImage(imageLiteralResourceName: "tarzan")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        initPlayer()
    }
    
    //Función que setea tanto la canción que va sonar como la imagen que aparecera
    func initPlayer() {
        var url = Bundle.main.url(forResource: songs[index], withExtension: "mp3")
        player = try? AVAudioPlayer(contentsOf: url!)
        player.prepareToPlay()
        imageView.image = images[index]
    }
    
    //Función para setear el indice para volver a la canción anterior
    func back() {
        if (index == 0){
            index = 2
        } else if (index == 2){
            index = 1
        } else {
            index = 0
        }
    }
    
    //Función para setear el indice para pasar a la siguiente canción o si esta activado el botón aleatorio pasar a una canción aleatoria
    func next() {
        //Condición que hara que si el botón random haya sido pulsado las canciones se pasaran de forma random y si no esta pulsado se pasaran en orden
        if (randomSong){
            index = Int.random(in: 0...2)
        } else {
            if (index == 0){
                index = 1
            } else if (index == 1){
                index = 2
            } else {
                index = 0
            }
        }
    }
    
    //Función que llamo timer para hacer un seguimiento del tiempo que pasa de la canción
    @objc func displayCurrentTime() {
        currentLabel.text = String(format: "%.2f", ((self.player.currentTime / 60)))
        progressBar.value = 1 / Float(player.duration / player.currentTime)
    }
    
    //Botón para volver hacia la canción anterior
    @IBAction func backSong(_ sender: UIButton) {
        //Condición para volver a la canción anterior y además iniciarla si el reproductor estaba sonando o pausarla si este esta pausado
        if (player.isPlaying){
            back()
            initPlayer()
            player.play()
        } else {
            back()
            initPlayer()
            player.pause()
        }
        durationLabel.text = String(format: "%.2f", ((player.duration / 60)))
    }
    
    //Botón del play/pause
    @IBAction func playSong(_ sender: UIButton) {
        //Condición para setear la imagen del botón del play y además iniciar y pausar las canciones
        if player.isPlaying{
            player.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        durationLabel.text = String(format: "%.2f", ((player.duration / 60)))
        //Variable que se actualziara cada poco tiempo para poder actualizar el tiempo que ha trascurrido de canción
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(displayCurrentTime), userInfo: nil, repeats: true)
    }
    
    //Botón que pasa a la siguiente canción
    @IBAction func nextSong(_ sender: UIButton) {
        //Condición para pasar de canción y pausar o iniciar la canción en función de la canción anterior
        if (player.isPlaying){
            next()
            initPlayer()
            player.play()
        } else {
            next()
            initPlayer()
            player.pause()
        }
        durationLabel.text = String(format: "%.2f", ((player.duration / 60)))
    }
    
    //Botón que activa que las canciones se pasen de forma aleatoria
    @IBAction func randomSong(_ sender: UIButton) {
        //Condición para cambiar de color si se ha apretado el botón y también para activar o no la posibilidad de escuchar canciones en aleatorio
        if (randomSong) {
            randomSong = false
            randomButton.tintColor = UIColor.black
        } else {
            randomSong = true
            randomButton.tintColor = UIColor.blue
        }
    }
}

