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
    	var color: WSColor
		static var size = 0
    

		enum WSColor {
    		case Red, Black
		}

    	init() {
        	left = nil
        	right = nil
        	value = nil
        	color = .Red
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
        if !isRed(node?.left) && isRed(node?.right) { // 左子节点为黑色，右子节点为红色，则左旋
            node = rotateLeft(node!)
        }
        if isRed(node?.left) && isRed(node?.left?.left) { // 左子节点为红色，左子节点的左节点为红色，也就是连续的2个左节点，则右旋
            node = rotateRight(node!)
        }
        if isRed(node?.left) && isRed(node?.right) { // 左子节点为红色，右子节点为红色，则颜色反转
           node = flipColor(node!)
        }
        return node!
    }
    
    private func rotateLeft(node: WSNode) -> WSNode {
        let temp = node.right!
        node.right = temp.left
        temp.left = node 
        temp.color = node.color
        node.color = .Red
        return temp
    }
    private func rotateRight(node: WSNode) -> WSNode {
    	let temp = node.left!
		node.left = temp.right
		temp.right = node 
		temp.color = node.color
		node.color = .Red
		return temp 
    }
    private func flipColor(node: WSNode) -> WSNode {
        node.left?.color = .Black
		node.right?.color = .Black
		node.color = .Red
		return node
    }
	
	private func isRed(node: WSNode?) -> Bool {
		if node == nil {
			return false
		}
		if node?.color == .Red {
			return true
		}
		return false
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
		print(node.value, node.color)
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
printRedBlackTree(redBlackTree)
// let redBlackTree = WSRedBlackTree()
	
// redBlackTree.clear()
redBlackTree.add([8,2,5,9,7,1,0,4,10])
print(redBlackTree.size)

redBlackTree.add(4)
print(redBlackTree.size)

redBlackTree.add(1)
print(redBlackTree.size)

printRedBlackTree(redBlackTree)
print(redBlackTree.isEmpty)

redBlackTree.clear()
print(redBlackTree.isEmpty)
print(WSRedBlackTree.WSNode.size)


