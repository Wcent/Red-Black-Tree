import Foundation


class WSRedBlackTree {
    var root: WSNode?
    var size = 0
    
    var isEmpty: Bool {
        if size == 0 {
            return true
        }
        return false
    }


	class WSNode {
    	var left: WSNode?
    	var right: WSNode?
    	var value: Int?
    	var color: WSColor?
		static var size = 0
    

		enum WSColor {
    		case Red, Black
			mutating func colorFlip() {
				switch self {
					case .Red: self = .Black
					case .Black: self = .Red
				}
			}
		}

    	init() {
        	left = nil
        	right = nil
        	value = nil
        	color = nil
			WSNode.size += 1
			print("construct #\(WSNode.size) WSNode")
    	}
    
    	init(value: Int, color: WSColor) {
        	left = nil
        	right = nil
        	self.value = value
        	self.color = color
			WSNode.size += 1
			print("construct #\(WSNode.size) WSNode(\(value))")
    	}

		deinit {
			WSNode.size -= 1
			print("deconstruct WSNode(\(value))")
		}
	}
    
    init() {
        root = nil
        size = 0
    } 

	init(items: [Int]) {
		size = 0
		if items.isEmpty {
			root = nil
		}
		add(items)
	}

	func clear() {
		root = nil
		size = 0
	}
    
    func add(value: Int) {
        root = insert(root, value: value)
        root?.color = .Black // 根节点必须为黑色
    }

	func add(items: [Int]) {
		for value in items {
			add(value)
		}
	}
    
    private func insert(var node: WSNode?, value: Int) -> WSNode {
		// simply binary tree insert...
        if node == nil {
            size += 1
            node = WSNode(value: value, color: .Red)
            return node!
        }
        
        if node?.value > value {
            node?.left = insert(node?.left, value: value)
        }
        else if node?.value < value {
            node?.right = insert(node?.right, value: value)
        }
        
		// self-balancing process...
		node = fixUp(node)
		/*
        if isBlack(node?.left) && isRed(node?.right) { // 左子节点为黑色，右子节点为红色，则左旋
            node = rotateLeft(node)
        }
        if isRed(node?.left) && isRed(node?.left?.left) { // 左子节点为红色，左子节点的左节点为红色，也就是连续的2个左节点，则右旋
            node = rotateRight(node)
        }
        if isRed(node?.left) && isRed(node?.right) { // 左子节点为红色，右子节点为红色，则颜色反转
           colorFlip(node)
        }
		*/
        return node!
    }

	func delete(value: Int) {
		root = delete(root, value: value)
		root?.color = .Black
	}

	private func delete(var head: WSNode?, value: Int) -> WSNode? {
		if let nodeValue = head?.value where value < nodeValue {
			if head?.left == nil {
				return head 
			}
			if isBlack(head?.left) && isBlack(head?.left?.left) {
				head = moveRedLeft(head)
			}
			head?.left = delete(head?.left, value: value)
		}
		else if let nodeValue = head?.value where value > nodeValue {
			if head?.right == nil {
				return head 
			}
			if isRed(head?.left) {
				head = rotateRight(head)
			}
			if isBlack(head?.right) && isBlack(head?.right?.left) {
				head = moveRedRight(head)
			}
			head?.right = delete(head?.right, value: value)
		}
		else {
			if head != nil {
				size -= 1
			}
			if head?.right == nil {
				return nil 
			}
			if isRed(head?.left) {
				head = rotateRight(head)
			}
			if isBlack(head?.right) && isBlack(head?.right?.left) {
				head = moveRedRight(head)
			}
			var tempNode = getMin(head?.right)
			var tempValue = head?.value
			head?.value = tempNode?.value
			tempNode?.value = tempValue
			tempNode = nil
			tempValue = nil
			head?.right = deleteMin(head?.right)
		}
		head = fixUp(head)
		return head
	}

	private func moveRedLeft(var head: WSNode?) -> WSNode? {
		colorFlip(head)
		if isRed(head?.right?.left) {
			head?.right = rotateRight(head?.right)
			head = rotateLeft(head)
			colorFlip(head)
		}
		return head
	}

	private func moveRedRight(var head: WSNode?) -> WSNode? {
		colorFlip(head)
		if isRed(head?.left?.left) {
			head = rotateRight(head)
			colorFlip(head)
		}
		return head
	}
    
	func getMin(head: WSNode?) -> WSNode? {
		if head?.left == nil {
			return head
		}
		return getMin(head?.left)
	}
    
	func getMax(head: WSNode?) -> WSNode? {
		if head?.right == nil {
			return head
		}
		return getMax(head?.right)
	}
    
	func deleteMinValue() {
		if root != nil {
			size -= 1
		}
		root = deleteMin(root)
		root?.color = .Black
	}

	private func deleteMin(var head: WSNode?) -> WSNode? {
		if head?.left == nil {
			return nil
		}
		if isBlack(head?.left) && isBlack(head?.left?.left) {
			head = moveRedLeft(head)
		}
		head?.left = deleteMin(head?.left)
		head = fixUp(head)
		return head
	}
    
	func deleteMaxValue() {
		if root != nil {
			size -= 1
		}
		root = deleteMax(root)
		root?.color = .Black
	}

	private func deleteMax(var head: WSNode?) -> WSNode? {
		if isRed(head?.left) { // 注意左倾红黑树，最后右子树为空链接时，左子树仍然可能有红色链接，此处右旋，同时也方便合并为4链接结点
			head = rotateRight(head)
		}
		if head?.right == nil {
			return nil
		}
		if isBlack(head?.right) && isBlack(head?.right?.left) {
			head = moveRedRight(head)
		}
		head?.right = deleteMax(head?.right)
		head = fixUp(head)
		return head
	}

	private func fixUp(var head: WSNode?) -> WSNode? {
		if isBlack(head?.left) && isRed(head?.right) {
			head = rotateLeft(head)
		}
		if isRed(head?.left) && isRed(head?.left?.left) {
			head = rotateRight(head)
		}
		if isRed(head?.left) && isRed(head?.right) {
			colorFlip(head)
		}
		return head
	}
    
    private func rotateLeft(node: WSNode?) -> WSNode? {
        let temp = node?.right
        node?.right = temp?.left
        temp?.left = node 
        temp?.color = node?.color
        node?.color = .Red
        return temp
    }
    private func rotateRight(node: WSNode?) -> WSNode? {
    	let temp = node?.left
		node?.left = temp?.right
		temp?.right = node 
		temp?.color = node?.color
		node?.color = .Red
		return temp 
    }
    private func colorFlip(node: WSNode?) {
        node?.left?.color?.colorFlip()
		node?.right?.color?.colorFlip()
		node?.color?.colorFlip()
    }
	
	private func isRed(node: WSNode?) -> Bool {
		if node == nil { // 叶子nil链接为黑色
			return false
		}
		if node?.color == .Red {
			return true
		}
		return false
	}

	private func isBlack(node: WSNode?) -> Bool {
		if isRed(node) {
			return false
		}
		return true
	}
}



func printRedBlackTree(tree: WSRedBlackTree) {
	if tree.root == nil {
		return ;
	}
	var head = 0
	var tail = 0
	var queue = Array<WSRedBlackTree.WSNode>()
	var node: WSRedBlackTree.WSNode
	queue.append(tree.root!)
	tail += 1
	while head < tail {
		node = queue[head]
		print(node.value, node.color!)
		head += 1

		if node.left != nil {
			queue.append(node.left!)
			tail += 1
		}
		if node.right != nil {
			queue.append(node.right!)
			tail += 1
		}
	}
}


let redBlackTree = WSRedBlackTree(items: [3,2,6,8,9,0,1,7])
print(redBlackTree.size)
var min = redBlackTree.getMin(redBlackTree.root)
var max = redBlackTree.getMax(redBlackTree.root)
print(min?.value, min?.color!)
print(max?.value, max?.color!)
min = nil
max = nil
// redBlackTree.deleteMinValue()
// redBlackTree.deleteMaxValue()
redBlackTree.delete(0)
redBlackTree.delete(9)
// printRedBlackTree(redBlackTree)
redBlackTree.delete(-10)
redBlackTree.delete(10)
print(redBlackTree.size)
// printRedBlackTree(redBlackTree)
// let redBlackTree = WSRedBlackTree()
	
// redBlackTree.clear()
redBlackTree.add([8,2,5,9,7,1,0,4,10])
print(redBlackTree.size)

redBlackTree.delete(4)
printRedBlackTree(redBlackTree)
redBlackTree.add(4)
printRedBlackTree(redBlackTree)
print(redBlackTree.size)

redBlackTree.delete(1)
printRedBlackTree(redBlackTree)
redBlackTree.add(1)
printRedBlackTree(redBlackTree)
print(redBlackTree.size)

/*
min = redBlackTree.getMin(redBlackTree.root)
max = redBlackTree.getMax(redBlackTree.root)
print(min?.value, min?.color!)
print(max?.value, max?.color!)
min = nil
max = nil
// redBlackTree.deleteMinValue()
// redBlackTree.deleteMaxValue()
printRedBlackTree(redBlackTree)
redBlackTree.delete(0)
printRedBlackTree(redBlackTree)
redBlackTree.delete(10)
*/

redBlackTree.add([12,15,19,17,11,14,18,10])
printRedBlackTree(redBlackTree)
// redBlackTree.delete(17)
redBlackTree.delete(9)
print(redBlackTree.size)
printRedBlackTree(redBlackTree)
print(redBlackTree.isEmpty)

// min = nil
// max = nil
redBlackTree.clear()
print(redBlackTree.isEmpty)
print(WSRedBlackTree.WSNode.size)
print(redBlackTree.size)
/*
min = redBlackTree.getMin(redBlackTree.root)
max = redBlackTree.getMax(redBlackTree.root)
print(min?.value, min?.color!)
print(max?.value, max?.color!)
redBlackTree.deleteMinValue()
redBlackTree.deleteMaxValue()
*/
redBlackTree.delete(10)

redBlackTree.add(3)
/*
min = redBlackTree.getMin(redBlackTree.root)
max = redBlackTree.getMax(redBlackTree.root)
print(min?.value, min?.color!)
print(max?.value, max?.color!)
min = nil
max = nil
// redBlackTree.deleteMinValue()
// redBlackTree.deleteMaxValue()
*/
redBlackTree.delete(10)
redBlackTree.delete(3)
printRedBlackTree(redBlackTree)
print(redBlackTree.size)
