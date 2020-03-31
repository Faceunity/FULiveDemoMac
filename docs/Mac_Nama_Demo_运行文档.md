# Demo运行说明文档-Mac  

级别：Public   
更新日期：2020-03-19   
SDK版本: 6.7.0  

------

**FaceUnity Nama SDK v6.7.0 (2020-03-19 )**

1. 美颜效果
   -新增去黑眼圈、去法令纹功能
   -优化磨皮效果，新增只磨皮人脸区域接口功能
   -优化原有美型效果
2. 优化表情跟踪效果，解决了6.6.0版表情系数表情灵活度问题——FaceProcessor模块优化
   -解决Animoji表情灵活度问题，基本与原有SDK v6.4.0效果相近
   -解决优化了表情动图的鼻子跟踪效果问题
3. 优化美妆效果，人脸点位优化，提高准确性
   -优化口红点位与效果，解决张嘴、正脸、低抬头、左右转头、抿嘴动作的口红溢色
   -优化美瞳点位效果，是美瞳效果稳定
   -腮红效果优化，解决了仰头角度下腮红强拉扯问题
4. 新增接口支持图像裁剪，解决瘦脸边缘变形问题（边缘变形剪裁）
5. 新增接口判断初始化完成状态
6. 移动端Demo优化曝光聚焦效果，效果达到市面上最优效果

------
### 目录：
本文档内容目录：

[TOC]

------
### 1. 简介 
本文档旨在说明如何将Faceunity Nama SDK的Mac Demo运行起来，体验Faceunity Nama SDK的功能。FULiveDemoMac 是集成了 Faceunity 面部跟踪、美颜、Animoji、道具贴纸、AR面具、换脸、表情识别、音乐滤镜、背景分割、手势识别、哈哈镜以及人像驱动功能的Demo。Demo将根据客户证书权限来控制用户可以使用哪些产品。

------
### 2. Mac Demo文件结构
本小节，描述Mac Demo文件结构，各个目录，以及重要文件的功能。

```
+FULiveDemo
  +FULiveDemo 			  	//原代码目录
    +Controller             //控制器文件夹
      -FUCameraSetController.h.m   //相机视图控制器
      -FUBeautyViewController.h.m  //美颜视图控制器
      ...
    +Model                  //数据模型文件夹
      -FUBeautyModel        //美颜数据模型
      -FUMakeupModle        //质感美妆数据模型
      ...
    +Views                  //视图文件夹  
      -FUBeautyTableView              //美颜列表
      +OpenGLView           //0penGLView 
      ...  
    +Managers				//业务类文件夹
      -FUManager             //nama 业务类
      -FUAppDataCenter       	  //数据管理类
      -FUConstManager       //常量管理类
      ...
    +Lib                    //nama SDK  
      +Faceunity
        -authpack.h		       	//鉴权文件
        +Nama.framework				//nama 动态库    
        +Resources
          +AI_modle           //ai 资源
            -ai_facelandmarks239.bundle  // 人脸nn239 点位
            -tougue.bundle               // 舌头
            -ai_bgseg.bundle             // 背景分割能力
            ...
         -face_beautification.bundle     //美颜资源
         -fxaa.bundle                    //抗锯齿
         -v3.bundle                      //SDK的数据文件，缺少该文件会导致初始化失败
        +items                   //个个模块道具资源 
  +Other						//其他
    +Category               //分类
    +PrefixHeader           //全局头  
```

------
### 3. 运行Demo 

#### 3.1 开发环境
##### 3.1.1 支持平台
```
macOS 10.6以上系统
```
##### 3.1.2 开发环境
```
Xcode 8或更高版本
```

#### 3.2 准备工作 
- [下载FULiveDemoMac](https://github.com/Faceunity/FULiveDemoMac)
- 替换证书文件 **authpack.h**，获取证书 见 **3.3.1**

#### 3.3 相关配置
##### 3.3.1 导入证书
您需要拥有我司颁发的证书才能使用我们的SDK的功能，获取证书方法：

1、拨打电话 **0571-89774660** 

2、发送邮件至 **marketing@faceunity.com** 进行咨询。

iOS端发放的证书为包含在authpack.h中的g_auth_package数组，如果您已经获取到鉴权证书，将authpack.h导入工程中即可。根据应用需求，鉴权数据也可以在运行时提供(如网络下载)，不过要注意证书泄露风险，防止证书被滥用。

#### 3.4 编译运行
![](./imgs/runDemo.jpg)

------
### 4. 常见问题 

#### 4.1 运行报错

第一运行Demo会报缺少证书的 error ,如果您已拥有我司颁发的证书，将证书替换到工程中重新运行即可。

