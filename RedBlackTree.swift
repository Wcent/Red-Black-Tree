/************************************************************************

     Author: Cent
	 Date  : 2016.04.11
Description: Implementaion of left-leaning red-black tree with swift

************************************************************************/

import Foundation

/*
 left-leaning red-black tree: 左倾红黑树
 红黑树的变种，具有性质：
 1、根结点为黑色
 2、每个结点不是红色，就是黑色，与标准红黑树不同的是，左倾红黑树红色左倾，
    即不存在红色右子结点。
 3、不存在连续为红色的2个结点。
 4、叶子结点左右子树为nil链接，nil链接为黑色。
 5、所有从根结点到nil链接路径的黑色结点数量相等，或者说从任意结点起到此结点上
    nil链接所有路径上的黑色结点数量相等，即黑色平衡。

 红黑树实际上是2-3-4树的等价,而左倾红黑树是2-3树的等价
*/

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
			print("construct #\(WSNode.size): WSNode()")
    	}
    
    	init(value: Int, color: WSColor) {
        	left = nil
        	right = nil
        	self.value = value
        	self.color = color
			WSNode.size += 1
			print("construct #\(WSNode.size): WSNode(\(value))")
    	}

		deinit {
			print("deconstruct #\(WSNode.size): WSNode(\(value))")
			WSNode.size -= 1
		}
	}
    
    init() {
        root = nil
        size = 0
    } 

	init(items: [Int]) {
		root = nil
		size = 0
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
    
    private func insert(var head: WSNode?, value: Int) -> WSNode? {
		// 普通二叉树查找插入操作 
        if head == nil {
            size += 1
            head = WSNode(value: value, color: .Red)
            return head 
        }
        if head?.value > value {
            head?.left = insert(head?.left, value: value)
        }
        else if head?.value < value {
            head?.right = insert(head?.right, value: value)
        }
        
		// 通过旋转，颜色反转等操作自平衡，自下向上调整为2-3树 
		head = fixUp(head)
        return head 
    }

	func delete(value: Int) {
		root = delete(root, value: value)
		root?.color = .Black
	}

	// 简化版本，为下面理解版本的改写
	// 删除任意结点，与删除最大最小结点类似，当删除结点为红色时，可保持黑色平衡，
	// 当删除点不是叶子结点时，需要替换此结点为其左子树最大或右子树最小结点，最后
	// 最大或最小结点为需要删除的结点
	// 为调整最后删除结点为红色，自上向下查询过程时，根据需要左右移动红色链接，下传红色
	// 最后删除红色结点或者找不到待删除结点返回时，通过旋转、颜色反转等操作自下向上自平衡，
	// 调整为2－3树
	private func delete(var head: WSNode?, value: Int) -> WSNode? {
		// 待删除结点在左子树
		if let nodeValue = head?.value where value < nodeValue {
			if head?.left == nil { // 不存在更深层左子树递归时，查找结束，返回当前树结点
				return head
			}
			if isBlack(head?.left) && isBlack(head?.left?.left) { // 红色链接下传左子树
				head = moveRedLeft(head)
			}
			head?.left = delete(head?.left, value: value)
		}

		else {
			if isRed(head?.left) { // 红色链接右旋,以便下传，另外可以保证最后删除的结点左子树为nil
				head = rotateRight(head)
			}

			if let nodeValue = head?.value where value == nodeValue && head?.right == nil { // 当前结点为删除结点，并且其右子树为nil时，直接删除
				size -= 1
				return nil
			}
			else if head?.right == nil { // head为nil返回nil或者不存在更深层右子树递归时，查找结束，返回当前树结点
				return head
			}

			if isBlack(head?.right) && isBlack(head?.right?.left) { // 红色链接下传右子树
				head = moveRedRight(head)
			}

			if let nodeValue = head?.value where value > nodeValue {
				head?.right = delete(head?.right, value: value)
			}
			else {
				// 待删除结点与其右子树最小结点交换
				// 实际操作中，可以直接将返回最小结点value覆盖待删除结点value，
				// 而不需要交换，因为不管最小结点value为何值，最后会被删除，此处交换只为演示析构函数执行时，删除的为指定值
				size -= 1
				let tempNode = getMin(head?.right)
				let tempValue = head?.value
				head?.value = tempNode?.value
				tempNode?.value = tempValue
				// 替换后的右子树最小结点为真实删除结点
				head?.right = deleteMin(head?.right)
			}
		}
		// 自下向上旋转、颜色反转自平衡，调整为2－3树
		head = fixUp(head)
		return head
	}

/*
	// 方便理解版本
	// 删除任意结点，与删除最大最小结点类似，当删除结点为红色时，可保持黑色平衡，
	// 当删除点不是叶子结点时，需要替换此结点为其左子树最大或右子树最小结点，最后
	// 最大或最小结点为需要删除的结点
	// 为调整最后删除结点为红色，自上向下查询过程时，根据需要左右移动红色链接，下传红色
	// 最后删除红色结点或者找不到待删除结点返回时，通过旋转、颜色反转等操作自下向上自平衡，
	// 调整为2－3树
	private func delete(var head: WSNode?, value: Int) -> WSNode? {
		// 待删除结点在左子树
		if let nodeValue = head?.value where value < nodeValue {
			if head?.left == nil { // 不存在时，返回
				return head 
			}
			if isBlack(head?.left) && isBlack(head?.left?.left) { // 红色链接下传左子树
				head = moveRedLeft(head)
			}
			head?.left = delete(head?.left, value: value)
		}

		// 待删除结点在右子树
		else if let nodeValue = head?.value where value > nodeValue {
			if head?.right == nil { // 不存在时，返回
				return head 
			}
			if isRed(head?.left) { // 红色链接右旋,以便下传
				head = rotateRight(head)
			}
			if isBlack(head?.right) && isBlack(head?.right?.left) { // 红色链接下传右子树
				head = moveRedRight(head)
			}
			head?.right = delete(head?.right, value: value)
		}

		else {
			if head != nil {
				size -= 1
			}
			if head?.right == nil { // 当前结点即为叶子结点
				return head?.left // 右子树为nil链接时，左子树可能还有一个红色结点，故返回左子树
			}
			
			// 根结点即为删除点时
			if isRed(head?.left) {
				head = rotateRight(head)
			}
			if isBlack(head?.right) && isBlack(head?.right?.left) {
				head = moveRedRight(head)
			}

			// 待删除结点与其右子树最小结点交换
			var tempNode = getMin(head?.right)
			var tempValue = head?.value
			head?.value = tempNode?.value
			tempNode?.value = tempValue
			tempNode = nil
			tempValue = nil
			// 替换后的右子树最小结点为真实删除结点
			head?.right = deleteMin(head?.right)
		}
		// 自下向上旋转、颜色反转自平衡，调整为2－3树
		head = fixUp(head)
		return head
	}
	*/

	// 待删除结点在左子树，当删除结点为红色时，黑色可保持平衡
	// 右子树存在可用红色结点时，可通过颜色反转，旋转等操作借
	// 出红色结点，右子树没有多余红色结点时，则当前结点颜色反
	// 转向下左右子树传递红色链接，即结合为4结点
	private func moveRedLeft(var head: WSNode?) -> WSNode? {
		colorFlip(head)
		if isRed(head?.right?.left) { // 右子树可向左子树借出红色结点
			head?.right = rotateRight(head?.right)
			head = rotateLeft(head)
			colorFlip(head)
		}
		return head
	}

	// 待删除结点在右子树，当删除结点为红色时，黑色可保持平衡
	// 左子树存在可用红色结点时，可通过颜色反转，旋转等操作借
	// 出红色结点，左子树没有多余红色结点时，则当前结点颜色反
	// 转向下左右子树传递红色链接，即结合为4结点
	private func moveRedRight(var head: WSNode?) -> WSNode? {
		colorFlip(head)
		if isRed(head?.left?.left) { // 左子树可向右子树借出红色结点
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
		if head?.left == nil { // 删除结点为红色时，可保持黑色平衡
			return nil
		}

		// 自上向下判断是否需要从右子树移动红色链接到左子树，以便调整最后待删除结点为红色
		if isBlack(head?.left) && isBlack(head?.left?.left) {
			head = moveRedLeft(head)
		}
		head?.left = deleteMin(head?.left)
		
		// 删除结点后，自下向上，通过旋转、颜色反转等操作自平衡，调整为2-3树
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
		if isRed(head?.left) { // 右子树为nil链接时，左子树可能还有一个红色结点，故右旋，另外红色右旋，为右子树向下传递红色准备
			head = rotateRight(head)
		}

		if head?.right == nil { // 删除结点为红色时，可保持黑色平衡
			return nil
		}

		// 自上向下判断是否需要从左子树移动红色链接到右子树，以便调整最后待删除结点为红色
		if isBlack(head?.right) && isBlack(head?.right?.left) {
			head = moveRedRight(head)
		}
		head?.right = deleteMax(head?.right)

		// 删除结点后，自下向上，通过旋转、颜色反转等操作自平衡，调整为2-3树
		head = fixUp(head)
		return head
	}

	private func fixUp(var head: WSNode?) -> WSNode? {
		if isBlack(head?.left) && isRed(head?.right) { // 左子节点为黑色，右子节点为红色，则左旋，调整为左倾
			head = rotateLeft(head)
		}
		if isRed(head?.left) && isRed(head?.left?.left) { // 左子节点为红色，左子节点的左节点为红色，也就是连续的2个左节点，则右旋
			head = rotateRight(head)
		}
		if isRed(head?.left) && isRed(head?.right) { // 左子节点为红色，右子节点为红色，则颜色反转，4点向上分裂
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
		if node == nil { // 叶子结点左右子树nil链接也为黑色
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



// 层次遍历输出左倾红黑树
func printRedBlackTree(tree: WSRedBlackTree) {
	print("\noutput: red-black tree, size: \(tree.size)")
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


// 测试...


print("create red-black tree with items: 3, 2, 6, 8, 9, 0, 1, 7")
let redBlackTree = WSRedBlackTree(items: [3,2,6,8,9,0,1,7])
printRedBlackTree(redBlackTree)
var min = redBlackTree.getMin(redBlackTree.root)
var max = redBlackTree.getMax(redBlackTree.root)
print("\nmin node of tree: WSNode\(min?.value)", min?.color)
print("max node of tree: WSNode\(max?.value)", max?.color)
min = nil
max = nil
print("delete: 0, 9, -10, 10")
// redBlackTree.deleteMinValue()
// redBlackTree.deleteMaxValue()
redBlackTree.delete(0)
redBlackTree.delete(9)
// printRedBlackTree(redBlackTree)
redBlackTree.delete(-10)
redBlackTree.delete(10)
printRedBlackTree(redBlackTree)

// let redBlackTree = WSRedBlackTree()
	
// redBlackTree.clear()
print("\nadd: 8, 2, 5, 9, 7, 1, 0, 4, 10")
redBlackTree.add([8,2,5,9,7,1,0,4,10])
printRedBlackTree(redBlackTree)

print("delete: 4")
redBlackTree.delete(4)
printRedBlackTree(redBlackTree)
print("add: 4")
redBlackTree.add(4)
printRedBlackTree(redBlackTree)

print("delete: 1")
redBlackTree.delete(1)
printRedBlackTree(redBlackTree)
print("add: 1")
redBlackTree.add(1)
printRedBlackTree(redBlackTree)

/*
min = redBlackTree.getMin(redBlackTree.root)
max = redBlackTree.getMax(redBlackTree.root)
print("min node of tree: WSNode\(min?.value)", min?.color)
print("max node of tree: WSNode\(max?.value)", max?.color)
min = nil
max = nil
print("delete min & max value")
redBlackTree.deleteMinValue()
redBlackTree.deleteMaxValue()
printRedBlackTree(redBlackTree)
print("delete: 0")
redBlackTree.delete(0)
printRedBlackTree(redBlackTree)
print("delete: 10")
redBlackTree.delete(10)
printRedBlackTree(redBlackTree)
*/

print("\nadd: 12, 15, 19, 17, 11, 14, 18, 10")
redBlackTree.add([12,15,19,17,11,14,18,10])
printRedBlackTree(redBlackTree)
// print("delete: 17")
// redBlackTree.delete(17)
print("delete: 9")
redBlackTree.delete(9)
printRedBlackTree(redBlackTree)

// min = nil
// max = nil
print("\nis the red-black tree empty?\n\(redBlackTree.isEmpty)")
print("clear the red-black tree")
redBlackTree.clear()
print("is the red-black tree empty?\n\(redBlackTree.isEmpty)")
print("WSNode.size: \(WSRedBlackTree.WSNode.size)")
printRedBlackTree(redBlackTree)


/*
min = redBlackTree.getMin(redBlackTree.root)
max = redBlackTree.getMax(redBlackTree.root)
print("min node of tree: WSNode\(min?.value)", min?.color)
print("max node of tree: WSNode\(max?.value)", max?.color)
print("delete min & max value")
redBlackTree.deleteMinValue()
redBlackTree.deleteMaxValue()
*/

print("\ndelete: 10")
redBlackTree.delete(10)
print("add: 3")
redBlackTree.add(3)
print("add: 1")
redBlackTree.add(1)
// print("add: 10")
// redBlackTree.add(10)
printRedBlackTree(redBlackTree)

/*
min = redBlackTree.getMin(redBlackTree.root)
max = redBlackTree.getMax(redBlackTree.root)
print("min node of tree: WSNode\(min?.value)", min?.color)
print("max node of tree: WSNode\(max?.value)", max?.color)
min = nil
max = nil
print("delete min & max value")
// redBlackTree.deleteMinValue()
// redBlackTree.deleteMaxValue()
*/

print("delete: 10")
redBlackTree.delete(10)
// print("delete: 1")
// redBlackTree.delete(1)
print("delete: 3")
redBlackTree.delete(3)
printRedBlackTree(redBlackTree)



