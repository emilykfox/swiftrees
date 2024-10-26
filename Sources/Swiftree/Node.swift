public class Node {
	var parent: ParentNode = .none
	var leftChild: Node? = nil
	var rightChild: Node? = nil

	var auxiliaryParent: Node? {
		switch self.parent {
		case .auxiliaryParentLeftChild(let parent): return parent
		case .auxiliaryParentRightChild(let parent): return parent
		default: return nil
		}
	}

	var pathParent: Node? {
		switch self.parent {
		case .pathParent(let parent): return parent
		default: return nil
		}
	}

	// returns true if changes are made
	@discardableResult func singleRotateUp() -> Bool {
		let grandparent: ParentNode
		switch self.parent {
		case .auxiliaryParentLeftChild(let parent):
			grandparent = parent.parent
			parent.leftChild = self.rightChild
			parent.leftChild?.parent = .auxiliaryParentLeftChild(parent)
			self.rightChild = parent
			parent.parent = .auxiliaryParentRightChild(self)
		case .auxiliaryParentRightChild(let parent):
			grandparent = parent.parent
			parent.rightChild = self.leftChild
			parent.rightChild?.parent = .auxiliaryParentRightChild(parent)
			self.leftChild = parent
			parent.parent = .auxiliaryParentLeftChild(self)
		default: return false
		}

		switch grandparent {
		case .auxiliaryParentLeftChild(let grandparent): grandparent.leftChild = self
		case .auxiliaryParentRightChild(let grandparent): grandparent.rightChild = self
		default: ()
		}

		return true
	}

	// returns true if changes are made
	@discardableResult func doubleRotateUp() -> Bool {
		switch self.parent {
		case .auxiliaryParentLeftChild(let parent):
			switch parent.parent {
			case .auxiliaryParentLeftChild:
				// does redundant unwrapping
				parent.singleRotateUp()
				self.singleRotateUp()
			case .auxiliaryParentRightChild:
				self.singleRotateUp()
				self.singleRotateUp()
			default: self.singleRotateUp()
			}
			return true
		case .auxiliaryParentRightChild(let parent):
			switch parent.parent {
			case .auxiliaryParentLeftChild:
				self.singleRotateUp()
				self.singleRotateUp()
			case .auxiliaryParentRightChild:
				parent.singleRotateUp()
				self.singleRotateUp()
			default: self.singleRotateUp()
			}
			return true
		default: return false
		}
	}

	func splay() {
		while self.doubleRotateUp() {}
	}
}

enum ParentNode {
	case auxiliaryParentLeftChild(Node)
	case auxiliaryParentRightChild(Node)
	case pathParent(Node)
	case none
}
