import UIKit

class DeckSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DeckSelectionModelDelegate {
    
    @IBOutlet weak var decksTableView: UITableView!
    var deckModel: DeckSelectionModel!
    let decksPersistence = DecksPersistence(decksURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("decks.json"))

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animateTable()
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        self.deckModel = DeckSelectionModel(decksPersistence, client: DeckServiceClient())
        self.deckModel.delegate = self
	}

    func updateView() {
        DispatchQueue.main.async {
            self.decksTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deckModel.decks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let keyString = deckModel.decks[indexPath.row].title
        cell.textLabel?.text = keyString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        deckModel.deckSelected(at: indexPath.row)
        performSegue(withIdentifier: "showDeck", sender: nil)
    }
    
//animation for decksTableView
    func animateTable() {
        decksTableView.reloadData()
        
        let cells = decksTableView.visibleCells
        let tableHeight: CGFloat = decksTableView.bounds.size.height
        
        var index = 0
        
        for cell in cells {
            let cell: UITableViewCell = cell as UITableViewCell
            UIView.animate(withDuration: 2, delay: 0.05 * Double(index), options: [], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: -tableHeight)
            }, completion: nil)
        }
        
        index += 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let flashCardController as FlashCardViewController:
            if let deck = deckModel.deckForSelection() {
                flashCardController.model = FlashCardModel(deck: deck, persistence: decksPersistence)
            }
        default:
            break
        }
    }
    
    @IBAction func addDeck(_ sender: Any) {
        let addDeckAlert = UIAlertController(title: "Add new deck", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let addDeckAction = UIAlertAction(title: "Add Deck", style: UIAlertActionStyle.default) { [weak addDeckAlert] _ in
            if let textFields = addDeckAlert?.textFields {
                let deckNameTextField = textFields[0]
                let deckName = deckNameTextField.text
                
                self.deckModel.addDeck(withTitle: deckName ?? "")
                self.decksTableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        
        addDeckAlert.addTextField { textField in
            textField.placeholder = "Deck name"
        }
        
        addDeckAlert.addAction(addDeckAction)
        addDeckAlert.addAction(cancelAction)
        
        self.present(addDeckAlert, animated: true)
    }
}




















