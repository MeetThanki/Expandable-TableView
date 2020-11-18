import UIKit

class AccordionView: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var selectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }

    private let titleColor: UIColor = {
        if #available(iOS 13.0, *) { return .label } else { return .black }
    }()

    private let childColor: UIColor = {
        if #available(iOS 13.0, *) { return .secondaryLabel } else { return .darkGray }
    }()

    private let data = [
        (title: "First Headline Cell",
         children: [
            "First Child Cell",
            "Second Child Cell",
            "Third Child Cell"
        ]),
        (title: "Second Headline Cell",
         children: [
            "First Child Cell",
            "Second Child Cell"
        ]),
        (title: "This is a\nTitle with multiple\nLines",
         children: [
            "And this is a\nChild Cell with multiple\nLines\n..."
        ]),
        (title: "...",
         children: [
            "..."
        ])
    ]
}

extension AccordionView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (selectedIndex ?? -1) == section ? data[selectedIndex!].children.count + 1 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accordionCell", for: indexPath) as! AccordionCell
        if indexPath.row == 0 {
            cell.imageField.image = UIImage(named: indexPath.section == selectedIndex ?? -1 ? "up" : "down")
            cell.titleLabel.text = data[indexPath.section].title
            cell.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            cell.titleLabel.textColor = titleColor
        } else {
            cell.imageField.image = nil
            cell.titleLabel.text = data[indexPath.section].children[indexPath.row - 1]
            cell.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            cell.titleLabel.textColor = childColor
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let index = selectedIndex, index != indexPath.section {
                selectedIndex = selectedIndex == indexPath.section ? nil : indexPath.section
                tableView.reloadSections(IndexSet([index, indexPath.section]), with: .fade)
            } else {
                selectedIndex = selectedIndex == indexPath.section ? nil : indexPath.section
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
            }
        }
    }
}

class AccordionCell: UITableViewCell {
    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}
