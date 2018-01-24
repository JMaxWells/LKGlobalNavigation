# LKGlobalNavigation

> LKGlobalNavigation可以一行代码实现页面跳转传值回调等一系列实用功能。直接使用URL Schemes进行跳转页面，同时支持传参和回调。支持Pop，Push，Present等各种跳转方式。

## 1.向LKGlobalNavigation注册当前页面的URL
My little name is URL_MAIN_VC.

```swift
+ (void)load {
    [LKGlobalNavigationController registerURLPattern:URL_MAIN_VC viewControllerClass:[self class]];
}

or
IMPLEMENT_LOAD(URL_MAIN_VC)

```

## 2 页面跳转方式
通过页面URL就能跳转到对应的页面，解决了页面之间的相互耦合，很好的解决了组件化页面相互引用的问题。

### 2.1 Push

```swift
    [self pushViewControllerWithURLPattern:URL_SECOND_VC];
```

### 2.2 Pop

```swift
    [self popToViewControllerWithURLPattern:URL_FIRST_VC animated:YES];
```



### 2.3 Present
```swift
   [self presentNavigationControllerWithURLPattern:URL_FOURTH_VC
                                        withParams:NULL
                                     completeReply:NULL
                                        completion:NULL];
```


## 3 页面传参
相对于普通的传参方法（需要在下一级页面创建属性来接收上个页面传下来的数据）来说，一代码就能搞定任何数据在页面之间的传输。

```swift
    [self pushViewControllerWithURLPattern:URL_SECOND_VC
                                withParams:@16];
```

等同于

```swift
 SecondViewController *mainView = [[SecondViewController alloc] initWithParams:@16 complete:nil];
 self.navigationController pushViewController:mainView animated:YES];

```


## 4 页面发起回调
1.再也不用为通知中心起什么名字而烦恼了；
2.再也不用写那么多代理的胶水代码了。

```swift
    if (self.completeBlock) {
        self.completeBlock(@"来自B页面的CallBack");
        }
```


## 5 页面接受回调
真正的一行代码实现页面跳转传值回调等一系列实用功能。

```swift
[self pushViewControllerWithURLPattern:URL_SECOND_VC
                            withParams:@16
                         completeReply:^(id result) {
                                     if (result) {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"PageA Alert"
                                                                                             message:[NSString stringWithFormat:@"收到PageB的回调：%@",result]
                                                                                            delegate:nil
                                                                                   cancelButtonTitle:@"确定"
                                                                                   otherButtonTitles:nil, nil];
                                         [alertView show];
                                     }
                                 }];
```



## 6 设置导航栏按钮
设置导航栏左右按钮，并支持多个、文字、图片。

```swift
    @weakify(self)
    [self setRightButtonItemWithTitle:@"回调"
                          actionBlock:^{
                              @normalize(self)
                                // Do SomeThing
        
    }];
```




