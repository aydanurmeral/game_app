import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var süreEtiketi: UILabel!
    @IBOutlet weak var skorEtiketi: UILabel!
    @IBOutlet weak var enYüksekSkorEtiketi: UILabel!
    @IBOutlet weak var kayyu1: UIImageView!
    @IBOutlet weak var kayyu2: UIImageView!
    @IBOutlet weak var kayyu3: UIImageView!
    @IBOutlet weak var kayyu4: UIImageView!
    @IBOutlet weak var kayyu5: UIImageView!
    @IBOutlet weak var kayyu6: UIImageView!
    @IBOutlet weak var kayyu7: UIImageView!
    @IBOutlet weak var kayyu8: UIImageView!
    @IBOutlet weak var kayyu9: UIImageView!
    
    var skor = 0
    var yüksekSkor = 0
    var sayaç = 30
    var zamanlayıcı: Timer?
    var görüntüZamanlayıcı: Timer?
    var kayyuDizisi: [UIImageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kayyuDizisi = [kayyu1, kayyu2, kayyu3, kayyu4, kayyu5, kayyu6, kayyu7, kayyu8, kayyu9]
        
        for kayyu in kayyuDizisi {
            let jestAlgılayıcı = UITapGestureRecognizer(target: self, action: #selector(kayyuTıklandı(_:)))
            kayyu.addGestureRecognizer(jestAlgılayıcı)
            kayyu.isUserInteractionEnabled = true
        }
        
        süreEtiketi.text = String(sayaç)
        zamanlayıcı = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(geriyeSay), userInfo: nil, repeats: true)
        görüntüZamanlayıcı = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(görüntüDeğiştir), userInfo: nil, repeats: true)
        
        let saklananEnYüksekSkor = UserDefaults.standard.integer(forKey: "yüksekSkor")
        
        if saklananEnYüksekSkor != 0 {
            yüksekSkor = saklananEnYüksekSkor
            enYüksekSkorEtiketi.text = "En yüksek skor: \(yüksekSkor)"
        }
    }
    
    @objc func kayyuTıklandı(_ sender: UITapGestureRecognizer) {
        if let kayyu = sender.view as? UIImageView {
            kayyu.isHidden = true
            skor += 1
            skorEtiketi.text = "Skor: \(skor)"
        }
    }
    
    @objc func geriyeSay() {
        sayaç -= 1
        süreEtiketi.text = String(sayaç)
        
        if sayaç == 0 {
            zamanlayıcı?.invalidate()
            görüntüZamanlayıcı?.invalidate()
            
            let uyarı = UIAlertController(title: "Süre doldu", message: "Tekrar denemek ister misin?", preferredStyle: .alert)
            let tamamButonu = UIAlertAction(title: "Tamam", style: .default)
            let tekrarOyna = UIAlertAction(title: "Tekrar oyna", style: .default) { _ in
                self.skor = 0
                self.skorEtiketi.text = "Skor: \(self.skor)"
                self.sayaç = 20
                self.süreEtiketi.text = String(self.sayaç)
                self.zamanlayıcı = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.geriyeSay), userInfo: nil, repeats: true)
                self.görüntüZamanlayıcı = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.görüntüDeğiştir), userInfo: nil, repeats: true)
            }
            
            uyarı.addAction(tamamButonu)
            uyarı.addAction(tekrarOyna)
            present(uyarı, animated: true)
            
            if skor > yüksekSkor {
                yüksekSkor = skor
                enYüksekSkorEtiketi.text = "En yüksek skor: \(yüksekSkor)"
                UserDefaults.standard.set(yüksekSkor, forKey: "yüksekSkor")
            }
        }
    }
    
    @objc func görüntüDeğiştir() {
        let randomNumber = Int(arc4random_uniform(UInt32(kayyuDizisi.count)))
        
        for (index, kayyu) in kayyuDizisi.enumerated() {
            kayyu.isHidden = index != randomNumber
        }
    }
}
