extension Node {
  func access() {
    // self should be at bottom of prefered path
    self.splay()
    self.rightChild?.parent = .pathParent(self)
    self.rightChild = nil

    while case .pathParent(let pathParent) = self.parent {
      pathParent.splay()
      pathParent.rightChild?.parent = .pathParent(pathParent)
      pathParent.rightChild = self
      self.singleRotateUp()  // self is just auxiliary root pathParent
    }
  }

  public var rootNode: Node {
    self.access()
    var ancestor = self
    while let leftChild = ancestor.leftChild {
      ancestor = leftChild
    }
    ancestor.access()
    return ancestor
  }

  public func cut() {
    self.access()
    self.leftChild?.parent = .none
    self.leftChild = nil
  }

  public func linkTo(_ newDynTreeParent: Node) throws {
    self.access()
    newDynTreeParent.access()
    guard case .none = self.parent else {
      throw SameTreeError()
    }

    newDynTreeParent.parent = .auxiliaryParentLeftChild(self)
    self.leftChild = newDynTreeParent
  }

}

public struct SameTreeError: Error {}
