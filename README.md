# Unity-2D-Dynamic-Shadow-without-raycast-
参照知乎上一篇相关文章实现的，我认为通用性非常高，不需要去准备碰撞体相关的设置，特意分享给想要实现相似效果的。
知乎文章链接：https://zhuanlan.zhihu.com/p/30877199
值得注意的是，我是用Camera.RenderWithShader()来渲染出黑白图，但如果使用URP或HDRP，Camera.RenderWithShader()似乎没法正常运行，所以如果是使用URP或HDRP的项目，就只能用Camera.Render()替换了，而且障碍物的颜色不能太浅。

![tutieshi_640x330_14s](https://user-images.githubusercontent.com/49035490/188050291-3c273d01-0bb1-496b-8150-8029f72f5341.gif)
