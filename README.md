# Red-Black-Tree
An implementation of red-black tree with Swift

红黑树是一种自平衡的二叉搜索树。每个节点都附带颜色信息，用来调整保持
树在插入或者删除操作后的平衡。

性质：
1、每个节点还是红色就是黑色。
2、根节点必须为黑色。
3、红色节点，如果它存在子节点，则它的子节点必须为黑色，这意味着不存在
   连续2个为红色的节点。
4、红色节点不能为某个节点的右子节点。
5、所有从根节点到叶子节点路径的黑色节点数量相等，或者说从任意给定的节
   点到它叶子节点路径上黑色节点数量相等。（我理解即所谓的平衡）

操作：查找、插入、删除
红黑树是一种特殊的二叉搜索树，因此只须在二叉搜索树插入、删除操作后加入
平衡化来保证满足以上的性质，即可转换为红黑树操作。
查找基本与二叉搜索树一样。
插入操作的平衡化主要通过旋转（左旋、右旋）或者颜色反转来实现。
删除操作则是通过删除代替节点后、再平衡实现。

有关红黑树更多细节推荐参考http://www.cnblogs.com/yangecnu/p/Introduce-Red-Black-Tree.html这篇博文，很赞！！！
本人看完一遍就基本理解红黑树的插入操作，另外我看的时候原文作者在实现时，平衡化处有一处错误，仔细研读可发现。

实现
最近在学习swift语言，本文就是使用swift语言来实现的，环境基于ubuntu 14 LTS，
语言版本：Swift version 2.2-dev (LLVM 3ebdbb2c7e, Clang f66c5bb67b, Swift 1f2908b4f7)
代码实现保留了本人调试时的一些信息，可自行注释或去掉注释。

参考引用
https://en.wikipedia.org/wiki/Red%E2%80%93black_tree
http://www.cnblogs.com/yangecnu/p/Introduce-Red-Black-Tree.html
