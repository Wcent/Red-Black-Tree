# Left-Leaning Red-Black-Tree
An implementation of left-leaning red-black tree with Swift

红黑树是一种自平衡的二叉搜索树。每个节点都附带颜色信息，用来调整保持
树在插入或者删除操作后的平衡。

这里介绍的是红黑树的一个变种——左倾红黑树，即红色链接只可能出现在任意结节的左子树。

性质：
1、每个节点还是红色就是黑色。
2、根节点必须为黑色。
3、红色节点，如果它存在子节点，则它的子节点必须为黑色，这意味着不存在
   连续2个为红色的节点。
4、红色节点不能为某个节点的右子节点。
5、所有从根节点到叶子节点路径的黑色节点数量相等，或者说从任意给定的节
   点到它叶子节点路径上黑色节点数量相等。（我理解即所谓的平衡）

操作：查找、插入、删除
红黑树是一种特殊的二叉搜索树，而左倾红黑树只是在标准红黑树的基础上稍作变换处理，
因此只须在二叉搜索树插入、删除操作后加入平衡化来保证满足以上的性质，即可转换为左倾红黑树操作。
查找基本与二叉搜索树一样。
插入操作的平衡化主要通过旋转（左旋、右旋）或者颜色反转来实现。
删除操作则是通过删除代替节点（待删除结点左子树最大值或者右子树的最小值）后、再平衡实现，
其实相当于插入反过程，最关键实现左倾红黑树删除最小值或者最大值的方法，详细过程见于代码实现过程。


左倾红黑树是Robert Sedgewick在标准红黑树算法的基础上改进发明出来的，实现起来比标准红黑树简单，
并且易于理解，更多相关介绍可以查看维基https://en.wikipedia.org/wiki/Left-leaning_red%E2%80%93black_tree，
本文推荐读读Robert Sedgewick教授对左倾红黑树介绍的论文http://www.cs.princeton.edu/~rs/talks/LLRB/LLRB.pdf,
或者在线拜读http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.139.282。
建议要搞懂理解左倾红黑树的插入或者删除操作，可以结合Robert Sedgewick的论文，一步一步地画出节点的插入／删除过程。
有关左倾红黑树更多细节的中文介绍可以参考http://www.cnblogs.com/yangecnu/p/Introduce-Red-Black-Tree.html这篇博文，
看完一遍就基本理解红黑树的插入操作，注意文中作者在实现时，平衡化处有一处错误，仔细研读可发现。

实现
最近在学习swift语言，本文就是使用swift语言来实现的，环境基于ubuntu 14 LTS，
语言版本：Swift version 2.2-dev (LLVM 3ebdbb2c7e, Clang f66c5bb67b, Swift 1f2908b4f7)
代码实现保留了本人调试时的一些信息，可自行注释或去掉注释。

参考引用
https://en.wikipedia.org/wiki/Left-leaning_red%E2%80%93black_tree
https://en.wikipedia.org/wiki/Red%E2%80%93black_tree
http://www.cnblogs.com/yangecnu/p/Introduce-Red-Black-Tree.html
