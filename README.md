WeiPulse-OpenSource
===================

微博软件WeiPulse开源项目

#关于软件
WeiPulse是我个人第一个iOS项目，关于制作和设计方面的内容可以查看这篇博客：http://blog.sina.com.cn/s/blog_63b33eb601017hgv.html
文章是2012年写的，那时候WeiPulse还没发布……文中有些槽你们就不同吐了……

#关于项目
原本我是计划把WeiPulse这个项目给修改升级到1.5版本的，后来由于种种原因（参见http://www.zhihu.com/question/21243305/answer/17631701 ）停止了开发，所以现在项目里面有很多东西看上去都是改了一半的，比如说ASIHttp和AFNetworking两个网络库……

#关于WeiPulse的发展
在上面提到的事情发生之后，我放弃了对于WeiPulse的开发
当时对于这个项目『杀意已决』，遂放弃了1.X版本所有代码，制作了一个全新的WeiPulse 2.0
WeiPulse2已发布：https://itunes.apple.com/cn/app/weipulse-xin-lang-ban/id551685241?ls=1&mt=8
试用地址：https://app.io/w4rmIJ

#还有啥？
接下来我应该会在知乎的专栏里面写一篇文章介绍WeiPulse 2.0版本的创作和设计思路
参见文章：http://zhuanlan.zhihu.com/so898/19570508

#使用注意
1. 你需要自行填充新浪的App Secret和App key
2. 此项目没有针对iPhone5进行匹配
3. 项目制作的时候确实使用了ARC，我也在一定程度上修正了由于ARC与非ARC代码混杂造成的内存问题，不过问题还是有的，剩下的你要自己修
4. 软件使用的某些图片资源有版权限制，不过我忘记是那些了……
5. 代码中有很多弱智的地方，比如说设置里面对于按钮的处理……
6. 就像我上面说的那样，这个项目我已经放弃维护了，需要改进相关代码的同学可以自行Fork，本人不接受任何代码修改的Pull Request，不过你要是有问题，可以开Issue，我会尽量解答
7. 应该没啥了吧……

#使用其他项目
WeiPulse使用的其他开源项目列表可以参见Resource文件夹里面的Lisence.html文件

#开源协议 (MIT-Lisence)

    WeiPulse-OpenSource-Version
    
    Copyright (c) 2012-2013  R³ Studio
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
