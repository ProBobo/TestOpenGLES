//
//  TestGLView.m
//  TestOpenglES
//
//  Created by yulibo on 2019/3/13.
//  Copyright © 2019年 余礼钵. All rights reserved.
//

#import "TestGLView.h"
#import <OpenGLES/ES2/gl.h>

@interface TestGLView ()

@property(nonatomic , assign) GLuint frameBuffer;
@property(nonatomic , assign) GLuint renderbuffer;
@property(nonatomic , assign) GLint  backingWidth;
@property(nonatomic , assign) GLint  backingHeight;

@property (nonatomic , assign) GLuint       program;

@property(nonatomic, assign) GLuint texture1;
@property(nonatomic, assign) GLint  filterInputTextureUniform;

@property (nonatomic , strong) EAGLContext* context;

@end

@implementation TestGLView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
#pragma mark - 知识点
#pragma mark -- 函数说明
/*
 函数讲解 (用到的主要是C语法)
 
 GLUint glCreateShader(GLenum type);
 作用:创建着色器对象
 type 类型值两个: GL_VERTEX_SHADER(顶点做色器) 和 GL_VERTEX_SHADER(片段着色器) 返回一个非零的值，作为着色器的标记
 void glShaderSource(GLuint shader,GLsizei count,const GLchar**string,const Glint *length);
 作用:创建着色器对象后，需要把着色器的源代码和着色器对象关联
 参数1:shader 就是创建着色器成功返回的那个值
 参数2：count 包含多个字符串，一般就1个字符串
 参数3：字符串数组地址
 参数4：，可以为NULL 代表字符串为NULL 结尾的，否则，length就代表具有就有count个元素，每个元素指定了string中对应字符串的长度，如果length数组中的某个元素对应一个正整数，就代表string数组中对应字符串的长度，如果是负整数，对应的字符串就是以NULL 结尾的.
 void glCompileShader(GLuint shader)
 作用:编译着色器源代码
 参数 : shader 着色器标示
 glGetShaderiv (GLuint shader, GLenum pname, GLint* params)
 作用: 查询编译结果
 参数1：shader 着色器标识
 参数2：GL_COMPLE_STATUS
 参数3：查询结果返回
 void glGetShaderInfoLog(GLuint shader,GLsizei bufsize,GLsizei *length ,char *infoLog);
 作用: 获取编译相关日志,调试情况下使用
 参数1: shader 着色器对象标识
 参数2: bufsize 最大日志长度
 参数3: length 如果为NULL 不返回任何日志
 参数4：infoLog 保存在缓冲区中
 GLuint glCreateProgram()
 作用:创建空的着色器程序
 返回:非零，如果是0 则创建失败
 void AttachShader(GLuint program,GLuint shader);
 作用: 把着色器和程序相关联
 参数1：program 着色器程序标识
 参数2：shader 着色器对象标识
 void glDetachShader(GLuint program,Gluint shader);
 作用: 把着色器对象从着色器程序中分离出来，以更改着色器的操作。
 参数1：program 着色器程序标识
 参数2：shader 着色器对象标识
 void glLinkProgram()
 作用:在着色器对象都连接到着色器程序之后，就要把这些对象连接成一个可执行程序.
 void glGetProgramInfoLog(GLuint program,GLsizei bufsize,GLsize *length char *infoLog)
 作用:连接着色器程序也可能出现错误，我们需要进行查询，获取错误日志信息
 参数1: program 着色器程序标识
 参数2: bufsize 最大日志长度
 参数3: length 如果为NULL 不返回任何日志
 参数4：infoLog 保存在缓冲区中
 void glGetProgramiv (GLuint program, GLenum pname, GLint* params)
 作用:查询程序连接后的结果
 参数1:program 着色器程序标识
 参数2: GL_LINK_STATUS
 参数3：params 返回状态
 void glUserProgram(GLuint program)
 作用: 程序连接成功后，就可以调用这个函数，启动这个顶点或者片段着色器程序了，为了恢复使用固定功能的管线，可以向这个函数传递  0作为参数.
 void glDeleteShader(GLuint shader)
 作用:删除着色器对象，如果这个着色器对象被多个程序连接，一旦程序不再使用这个对象，那么它便会实际删除
 参数: shader 着色器对象标识
 void glDeleteProgram(GLuint program)
 作用: 删除着色器程序 ,如果这个着色器未在任何渲染环境中使用，它将立即删除。否则，会标记为删除，一旦它没不被使用了，便立即被删除
 void GLboolean glIsShader(GLuint shader)
 作用: 如果shader 是一个着色器对象名称，则返回GL_TRUE, 否则返回GL_FALSE
 
 
 void  GLboolean glIsProgram(GLuint program)
 作用: 如果program 是一个着色器程序，则返回GL_TRUE ,否则返回GL_FALSE
 void glValidateProgram(GLuint program)
 作用:用于验证一个着色器程序是否可以在当前OpenGL 环境下使用，验证结果查询，使用glGetProgramiv() 传入参数GL_VALIDATE_STATUS 为参数，查询程序验证结果
 
 参考链接：https://www.jianshu.com/p/ed0c617bcd67
 */
#pragma mark -- 基本步骤
/*
 上下文环境搭建/OpenGL ES环境搭建
 第1步. 重写layerClass方法
 首先创建一个View类，继承自UIView，然后重写父类UIView的layerClass方法，并返回CAEAGLLayer类型。
 第2步. 在initWithFrame方法中获得layer并且强制类型转换为CAEAGLLayer类型的变量，同时为layer设置参数，其中包括色彩模式等属性
 第3步. 建立EAGL与Opengl ES的连接
 第4步. 建立EAGL与Layer（设备屏幕）的连接
 第5步. 绘制帧(包含：导入shader和render)
 第6步. 将绘制的结果显示到屏幕上
 [_context presentRenderbuffer:GL_RENDERBUFFER];
*/

/*
 创建着色器程序/导入shader的步骤
 第一步. 创建GLuint 类型的shader 标示
 第二步. 获取shader 文件所在的路径
 第三步. 获取文件的内容 并进行NSUTF8StringEncoding 编码
 第四步. 根据类型创建shader 着色器对象
 第五步. 关联shader源代码和着色器
 第六步. 编译shader着色器对象源代码
 第七步. 检查着色器源代码编译是否成功
 第八步. 创建着色器程序
 第九步. 将编译好的着色器目标文件链接到程序中去
 第十步. 链接程序
 第十一步. 检查着色器程序链接结果
*/

/*
 绘制帧/渲染(使用着色器渲染一张图片)
 核心步骤
 第（1）步. 创建着色器程序
 第（2）步. 设置窗口
 设置清除颜色/设置背景颜色
 glClearColor
 清除颜色缓冲区
 glClear
 设置窗口坐标
 glViewport
 第（3）步. 加载顶点坐标
 第（4）步. 加载纹理坐标
 第（5）步. 加载纹理
 第（6）步. 将绘制的结果显示到屏幕上
*/

#pragma mark - 建立EAGL与Opengl ES的连接
+ (Class)layerClass {
    // 第1步. 重写layerClass方法
    // 只有 [CAEAGLLayer class] 类型的 layer 才支持在其上描绘 OpenGL 内容。
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //第2步. 在initWithFrame方法中获得layer并且强制类型转换为CAEAGLLayer类型的变量，同时为layer设置参数，其中包括色彩模式等属性
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)[self layer];
        // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
        // CALayer 默认是透明的，必须将它设为不透明才能让其可见
        [eaglLayer setOpaque:YES];
        /// 放大倍数
//        [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
        CGFloat scale = [UIScreen mainScreen].scale;
        /*
         This value defines the mapping between the logical coordinate space of the layer (measured in points) and the physical coordinate space (measured in pixels). Higher scale factors indicate that each point in the layer is represented by more than one pixel at render time. For example, if the scale factor is 2.0 and the layer’s bounds are 50 x 50 points, the size of the bitmap used to present the layer’s content is 100 x 100 pixels.
         
         此值定义层的逻辑坐标空间(以点为度量单位)和物理坐标空间(以像素为度量单位)之间的映射。更高的比例因子表示层中的每个点在渲染时由多个像素表示。例如，如果缩放因子为2.0，层的边界为50 x 50个点，那么用于表示层内容的位图的大小为100 x 100像素(一个点表示的像素比原来多2.0倍)。
         
         The default value of this property is 1.0. For layers attached to a view, the view changes the scale factor automatically to a value that is appropriate for the current screen. For layers you create and manage yourself, you must set the value of this property yourself based on the resolution of the screen and the content you are providing. Core Animation uses the value you specify as a cue to determine how to render your content.
         
         此属性的默认值为1.0。对于附加到视图的层，视图自动将缩放因子更改为适合当前屏幕的值。对于您自己创建和管理的层，您必须根据屏幕的分辨率和提供的内容自行设置此属性的值。Core Animation使用指定的值作为提示来确定如何呈现内容。
         */
        [eaglLayer setContentsScale:scale];
        [eaglLayer setDrawableProperties:dict];
        
    }
    return self;
}
- (void)createContext {
    /*
     注意：OpengGL ES通过EAGL与layer建立了连接
     */
    
    //第3步. 建立EAGL与OpenGL ES的连接
    EAGLContext *_context;
    // 指定 OpenGL 渲染 API 的版本，在这里我们使用 OpenGL ES 2.0
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    // 设置为当前上下文
    [EAGLContext setCurrentContext:_context];
    self.context = _context;
    //第4步. 建立EAGL与Layer（设备屏幕）的连接
    /*
     渲染缓存:存储绘制结果的缓冲区
     帧缓存:接收渲染结果的缓冲区，为GPU指定存储渲染结果的区域。
     
     Frame Buffer和Render Buffer
     Frame Buffer Object（FBO）即为帧缓冲对象，用于离屏渲染缓冲。相对于其它同类技术，如数据拷贝或交换缓冲区等，使用FBO技术会更高效并且更容易实现。而且FBO不受窗口大小限制。FBO可以包含许多颜色缓冲区，可以同时从一个片元着色器写入。FBO是一个容器，自身不能用于渲染，需要与一些可渲染的缓冲区绑定在一起，像纹理或者渲染缓冲区。
     Render Buffer Object（RBO）即为渲染缓冲对象，分为color buffer(颜色)、depth buffer(深度)、stencil buffer(模板)。
     在使用FBO做离屏渲染时，可以只绑定纹理，也可以只绑定Render Buffer，也可以都绑定或者绑定多个，视使用场景而定。如只是对一个图像做变色处理等，只绑定纹理即可。如果需要往一个图像上增加3D的模型和贴纸，则一定还要绑定depth Render Buffer。
     */
    //创建帧缓冲区
    glGenFramebuffers(1, &_frameBuffer);
    //创建绘制缓冲区
    glGenRenderbuffers(1, &_renderbuffer);
    //绑定帧缓冲区到渲染管线
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    //绑定绘制缓冲区到渲染管线
    glBindRenderbuffer(GL_RENDERBUFFER, _renderbuffer);
    
    //为绘制缓冲区分配存储区，此处将CAEGLLayer的绘制存储区作为绘制缓冲区的存储区
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer];
    
    //获取绘制缓冲区的像素宽度
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    //获取绘制缓冲区的像素高度
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    
    //将绘制缓冲区绑定到帧缓冲区
    // 将 _renderbuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderbuffer);
    
    //检查FrameBuffer的status
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        //failed to make complete frame buffer object
        return;
    }
    //至此我们就将EAGL与Layer（设备屏幕）连接起来了
    /////////////////////////////////////////////////////////////////////////
    //导入shader
    [self setUpShader];
    /////////////
    //第5步. 绘制帧
    //[self render];
    /////////////
    
    /////////////////////////////////////////////////////////////////////////
    //第6步. 将绘制的结果显示到屏幕上
    //绘制完一帧以后，调用下面的代码：
    //[_context presentRenderbuffer:GL_RENDERBUFFER];
}
#pragma mark - 加载GLSL
- (void)setUpShader {
    /*
     创建着色器程序
     
     glCreateProgram
     函数原型：int glCreateProgram ()
     在连接着色器之前，应该先创建着色器接收程序的容器，该方法相当于就是创建一个容器。
     如果创建成功，返回一个正整数作为该着色器程序的id。
     
     glAttachShader
     函数原型：void glAttachShader (int program, int shader)
     绑定顶点着色器着色器和片元着色器，绑定到容器中。它们都是同一个方法。
     
     glLinkProgram
     函数原型：void glLinkProgram (int program)
     链接程序
     
     glGetProgramiv
     函数原型：void glGetProgramiv(int var0, int var1, int[] var2, int var3)
     获取program的连接情况
     在这里创建着色器程序的代码基本介绍完毕了，在CreateProgram方法中，返回一个int类型的变量，我暂时把这个int类型的变量叫做变量A，在使用时，还会用到glUseProgram。
     
     glUseProgram
     函数原型：void glUseProgram(int var0);
     它的作用就是使用某套share程序
     
     */
    
    /*
     使用着色器(shader)
     
     glGetAttribLocation
     函数原型：int glGetAttribLocation(int var0, String var1)
     这个方法主要是用来绑定属性的id，这里的id是顶点着色器中的id（位置，纹理，变换矩阵名称）
     
     
     glVertexAttribPointer
     画笔设置顶点、颜色、纹理数据
     函数原型：void glVertexAttribPointer(int indx, int size, int type, boolean normalized, int stride, Buffer ptr)
     indx：指定要修改的顶点属性的索引值
     size：指定每个顶点属性的组件数量。必须为1、2、3或者4。初始值为4。（如position是由3个（x,y,z）组成，而颜色是4个（r,g,b,a））
     type：指定数组中每个组件的数据类型。可用的符号常量有GL_BYTE, GL_UNSIGNED_BYTE, GL_SHORT,GL_UNSIGNED_SHORT, GL_FIXED, 和 GL_FLOAT，初始值为GL_FLOAT。
     normalized：指定当被访问时，固定点数据值是否应该被归一化（GL_TRUE）或者直接转换为固定点值（GL_FALSE）。
     stride：指定连续顶点属性之间的偏移量。如果为0，那么顶点属性会被理解为：它们是紧密排列在一起的。初始值为0。
     ptr：指定一个指针，指向数组中第一个顶点属性的第一个组件。初始值为0。
     glEnableVertexAttribArray
     开启顶点和纹理绘制（允许顶点着色器读取GPU（服务器端）数据。）
     函数原型：void glEnableVertexAttribArray(int var0)
     var0：着色器顶点数据
     
     glActiveTexture
     该函数选择一个纹理单元，线面的纹理函数将作用于该纹理单元上，参数为符号常量GL_TEXTUREi ，i的取值范围为0~K-1，K是OpenGL实现支持的最大纹理单元数，可以使用GL_MAX_TEXTURE_UNITS来调用函数glGetIntegerv()获取该值。
     
     glBindTexture
     绑定纹理数据
     函数原型：glBindTexture(int var0, int var1);
     var0:纹理类型
     var1:纹理数据
     
     glDrawArrays和glDrawElements
     
     glDrawArrays
     函数原型：GL_APICALL void GL_APIENTRY glDrawArrays (GLenum mode, GLint first, GLsizei count);
     mode：绘制方式，OpenGL2.0以后提供以下参数：GL_POINTS、GL_LINES、GL_LINE_LOOP、GL_LINE_STRIP、GL_TRIANGLES、GL_TRIANGLE_STRIP、GL_TRIANGLE_FAN。
     first：从数组缓存中的哪一位开始绘制，一般为0。
     count：数组中顶点的数量。
     
     glDrawElements
     函数原型：void glDrawElements( GLenum mode, GLsizei count,
     GLenum type, const GLvoid *indices）；
     mode指定绘制图元的类型，它应该是下列值之一，GL_POINTS, GL_LINE_STRIP, GL_LINE_LOOP, GL_LINES, GL_TRIANGLE_STRIP, GL_TRIANGLE_FAN, GL_TRIANGLES, GL_QUAD_STRIP, GL_QUADS, and GL_POLYGON.
     count为绘制图元的数量乘上一个图元的顶点数。
     type为索引值的类型，只能是下列值之一：GL_UNSIGNED_BYTE, GL_UNSIGNED_SHORT, or GL_UNSIGNED_INT。
     indices：指向索引存贮位置的指针。
     在这里着重讲解一下这几个方法：
     GL_LINES_STRIP（条带线）：按照顶点顺序连接顶点
     GL_TRIANGLES（循环线）：按照顶点顺序连接顶点，最后一个点连接第一点
     GL_TRIANGLES（三角形）：三个点一组，如果不够三个点就会舍弃 多余的点
     GL_TRIANGLE_STRIP（三角形带）：顶点按照顺序依次 组成三角形绘制，最后实际形成的是一个三角型带
     GL_TRIANGLE_FAN（三角形扇面）：将第一个点作为中心点，其他点作为边缘点，绘制一系列的组成扇形的三角形
     相同点：它们的作用都是矩阵数据渲染图元、进行绘制
     异同：（这是笔者自己的理解）在移动平台中，glDrawArrays绘制通过每三个点绘制一个三角形，在面点数据中，不会重用顶点数据。glDrawElements绘制也是通过每三个点绘制一个三角形，但是会重用顶点数据，也就是绘制相同的结果。glDrawElements需要的顶点数据会更少
     
     */
    
    //第二步. 获取shader 文件所在的路径
    NSString* vertFile = [[NSBundle mainBundle] pathForResource:@"shaderv" ofType:@"vsh"];
    NSString* fragFile = [[NSBundle mainBundle] pathForResource:@"shaderf" ofType:@"fsh"];
    
    //第（1）步. 创建着色器程序
    //加载shader
    self.program = [self loadShaders:vertFile frag:fragFile];
    if (self.program == 0) {
        return;
    }
    //第十步. 链接程序
    glLinkProgram(self.program);
    //第十一步. 检查着色器程序链接结果
    GLint status;
    glGetProgramiv(self.program, GL_LINK_STATUS, &status);
    if (status == 0) {
        return;
    }
}

/**
 *  c语言编译流程：预编译、编译、汇编、链接
 *  glsl的编译过程主要有glCompileShader、glAttachShader、glLinkProgram三步；
 *  @param vert 顶点着色器
 *  @param frag 片元着色器
 *
 *  @return 编译成功的shaders
 */
- (GLuint)loadShaders:(NSString *)vert frag:(NSString *)frag {
    /*
     导入shader的步骤
     第一步. 创建GLuint 类型的shader 标示
     第二步. 获取shader 文件所在的路径
     第三步. 获取文件的内容 并进行NSUTF8StringEncoding 编码
     第四步. 根据类型创建shader 着色器对象
     第五步. 关联shader源代码和着色器
     第六步. 编译shader着色器对象源代码
     第七步. 检查着色器源代码编译是否成功
     第八步. 创建着色器程序
     第九步. 将编译好的着色器目标文件链接到程序中去
     第十步. 链接程序
     第十一步. 检查着色器程序链接结果
     */
    
    //第一步. 创建GLuint 类型的shader 标示
    GLuint verShader, fragShader;
    
    //编译
    BOOL isVerShaderCompile = [self compileShader:&verShader type:GL_VERTEX_SHADER file:vert];
    BOOL isFragShaderCompile = [self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:frag];
    if (!isVerShaderCompile || !isFragShaderCompile) {
        return 0;
    }
    //第八步. 创建着色器程序
    GLint program = glCreateProgram();
    
    //第九步. 将编译好的着色器目标文件链接到程序中去
    //将顶点着色器链接到程序中
    glAttachShader(program, verShader);
    //将片段着色器链接到程序中
    glAttachShader(program, fragShader);
    
    
    return program;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file {
    //读取字符串
    //第三步. 获取文件的内容 并进行NSUTF8StringEncoding 编码
    NSString* content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    const GLchar* source = (GLchar *)[content UTF8String];
    /*
     glCreateShader创建一个空的着色器对象，并返回一个可以引用的非零值（shader ID）。着色器对象用于维护定义着色器的源代码字符串。shaderType指示要创建的着色器的类型。 支持两种类型的着色器。 GL_VERTEX_SHADER类型的着色器是一个用于在可编程顶点处理器上运行的着色器。 GL_FRAGMENT_SHADER类型的着色器是一个着色器，旨在在可编程片段处理器上运行。
     
     创建时，着色器对象的GL_SHADER_TYPE参数设置为GL_VERTEX_SHADER或GL_FRAGMENT_SHADER，具体取决于shaderType的值。
     */
    //第四步. 根据类型创建shader 着色器对象
    *shader = glCreateShader(type);
    /*
     装载 shader
     函数 glShaderSource 用来给指定 shader 提供 shader 源码。第一个参数是 shader 对象的句柄；第二个参数表示 shader 源码字符串的个数；第三个参数是 shader 源码字符串数组；第四个参数一个 int 数组，表示每个源码字符串应该取用的长度，如果该参数为 NULL，表示假定源码字符串是 \0 结尾的，读取该字符串的内容指定 \0 为止作为源码，如果该参数不是 NULL，则读取每个源码字符串中前 length（与每个字符串对应的 length）长度个字符作为源码。
     */
    //第五步. 关联shader源代码和着色器
    glShaderSource(*shader, 1, &source, NULL);
    //第六步. 编译shader着色器对象源代码
    glCompileShader(*shader);
    //第七步. 检查着色器源代码编译是否成功
    GLint status;
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    return YES;
}
#pragma mark - render渲染
- (GLuint)setupTexture:(NSString *)fileName {
    
    UIImage *originalImage = [UIImage imageNamed:fileName];
    float width = originalImage.size.width;
    float height = originalImage.size.height;
    GLubyte *spriteData = [self getImageData:originalImage];
    
    
    //通常做法：glGenTextures
    //glGenTextures：glGenTextures是用来生成纹理的函数。函数根据纹理参数返回n个纹理索引。纹理名称集合不必是一个连续的整数集合。
    /*
     glGenTextures(GLsizei n, GLuint *textures)函数说明
     n：用来生成纹理的数量
     textures：存储纹理索引的第一个元素指针
     （glGenTextures就是用来产生你要操作的纹理对象的索引的，比如你告诉OpenGL，我需要5个纹理对象，它会从没有用到的整数里返回5个给你）
     glBindTexture实际上是改变了OpenGL的这个状态，它告诉OpenGL下面对纹理的任何操作都是对它所绑定的纹理对象的，比如glBindTexture(GL_TEXTURE_2D,1)告诉OpenGL下面代码中对2D纹理的任何设置都是针对索引为1的纹理的。
     产生纹理函数假定目标纹理的面积是由glBindTexture函数限制的。先前调用glGenTextures产生的纹理索引集不会由后面调用的glGenTextures得到，除非他们首先被glDeleteTextures删除。你不可以在显示列表中包含glGenTextures。
     */
    
   
    /*
     绑定纹理到默认的纹理ID（这里只有一张图片，故而相当于默认于片元着色器里面的colorMap，如果有多张图不可以这么做）
     glBindTexture(GL_TEXTURE_2D, 0);
     */
    
    /*
     GLuint _textures[3];
     if (0 == _textures[0])
     glGenTextures(3, _textures);//生成三个纹理
     */
    
    if (0 == _texture1) {
        //使用glGenTextures函数生成一个纹理ID
        glGenTextures(1, &_texture1);
    }
    
    //激活纹理单元
    glActiveTexture(GL_TEXTURE0);
    //绑定纹理texture1到当前激活的纹理单元
    glBindTexture(GL_TEXTURE_2D, _texture1);
    /*
     glUniform1i( (GLint)tex1_location, 0);//对应0号纹理单元
     glUniform1i( (GLint)tex2_location, 1);//对应1号纹理单元
     glUniform1i( (GLint)tex3_location, 2);//对应2号纹理单元
     */
    //定义哪个uniform采样器对应哪个纹理单元
    /*
     for (int i = 0; i < 3; ++i) {
     glActiveTexture(GL_TEXTURE0 + i);
     glBindTexture(GL_TEXTURE_2D, _textures[i]);
     glUniform1i(_uniformSamplers[i], i);
     }
     */
    glUniform1i(_filterInputTextureUniform, 0);
    //设置纹理缩放模式
    /*
     GL_TEXTURE_MAG_FILTER和GL_TEXTURE_MIN_FILTER这两个参数指定纹理在映射到物体表面上时的缩放效果。GL_TEXTURE_MIN_FILTER是缩小情况；GL_TEXTURE_MAG_FILTER是放大情况。
     */
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    //设置纹理环绕模式
    /*
     参数GL_TEXTURE_WRAP_S与GL_TEXTURE_WRAP_T。这两个参数分别设置纹理s方向（水平方向）和t方向（垂直方向）的包裹方式
     */
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    //使用glTexImage2D函数将CPU内存图像数据传输到GPU内存中同时也设置当前纹理的纹理id为刚刚生成的纹理id。此步完成了纹理图片在GPU内存中的载入
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    //释放数据
    free(spriteData);
    return 0;
}

- (void)render {
    //第（2）步. 设置窗口
    //    CGFloat scale = [[UIScreen mainScreen] scale]; //获取视图放大倍数，可以把scale设置为1试试
    //    glViewport(self.frame.origin.x * scale, self.frame.origin.y * scale, self.frame.size.width * scale, self.frame.size.height * scale); //设置视口大小
    // 设置窗口坐标
    glViewport(0, 0, _backingWidth, _backingHeight);
    
    // 设置清除颜色/设置背景颜色
    glClearColor(0, 1.0, 0, 1.0);//rgba
    // 清除颜色缓冲区
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    GLint linkSuccess;
    glGetProgramiv(self.program, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) { //连接错误
        GLchar messages[256];
        glGetProgramInfoLog(self.program, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"error%@", messageString);
        return ;
    }
    else {
        NSLog(@"link ok");
        glUseProgram(self.program); //成功便使用，避免由于未使用导致的的bug
    }
    //顶点坐标
        GLfloat pointArr[] = {
            0.5f, -0.5f,
            -0.5f, 0.5f,
            -0.5f, -0.5f,
            0.5f, 0.5f,
            -0.5f, 0.5f,
            0.5f, -0.5f,
        };
    //    GLuint position = glGetAttribLocation(self.program, "position");
    //    glVertexAttribPointer(position, 2, GL_FLOAT, GL_FALSE, 0, pointArr);
    //    glEnableVertexAttribArray(position);
    //    GLfloat pointArr[] = {
    //        0.5f, -0.5f, -1.0f,1.0f,
    //        -0.5f, 0.5f, -1.0f,1.0f,
    //        -0.5f, -0.5f, -1.0f,1.0f,
    //        0.5f, 0.5f, -1.0f,1.0f,
    //        -0.5f, 0.5f, -1.0f,1.0f,
    //        0.5f, -0.5f, -1.0f,1.0f,
    //    };//测试：默认顶点坐标的空值填充为1
    //    GLuint position = glGetAttribLocation(self.program, "position");
    //    glVertexAttribPointer(position, 4, GL_FLOAT, GL_FALSE, 0, pointArr);
    //    glEnableVertexAttribArray(position);
    
//    GLfloat pointArr[] = {
//        0.5f, -0.5f, -1.0f,
//        -0.5f, 0.5f, -1.0f,
//        -0.5f, -0.5f, -1.0f,
//        0.5f, 0.5f, -1.0f,
//        -0.5f, 0.5f, -1.0f,
//        0.5f, -0.5f, -1.0f,
//    };
    
//    GLfloat pointArr[] = {
//        0.5f, -0.5f, -1.0f,1.0f,
//        -0.5f, 0.5f, -1.0f,1.0f,
//        -0.5f, -0.5f, -1.0f,1.0f,
//        0.5f, 0.5f, -1.0f,1.0f,
//        -0.5f, 0.5f, -1.0f,1.0f,
//        0.5f, -0.5f, -1.0f,1.0f,
//    };//测试：默认顶点坐标的空值填充为1
    
//    GLfloat pointArr[] = {
//        1.0f, -1.0f, -1.0f,1.0f,
//        -1.0f, 1.0f, -1.0f,1.0f,
//        -1.0f, -1.0f, -1.0f,1.0f,
//        1.0f, 1.0f, -1.0f,1.0f,
//        -1.0f, 1.0f, -1.0f,1.0f,
//        1.0f, -1.0f, -1.0f,1.0f,
//    };//测试：默认顶点坐标的空值填充为1
    
    //第（3）步. 加载顶点坐标
    //通过OpenGL程序句柄查找获取顶点着色器中的顶点坐标句柄
    GLuint position = glGetAttribLocation(self.program, "position");
    //绑定渲染图形所处的顶点数据
    glVertexAttribPointer(position, 2, GL_FLOAT, GL_FALSE, 0, pointArr);
    //启用指向渲染图形所处的顶点数据的句柄
    glEnableVertexAttribArray(position);
    
    //纹理坐标
    GLfloat textArr[] = {
        1.0f, 0.0f,
        0.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 1.0f,
        1.0f, 0.0f,
    };
    //第（4）步. 加载纹理坐标
    //通过OpenGL程序句柄查找获取顶点着色器中的纹理坐标句柄
    GLuint textCoor = glGetAttribLocation(self.program, "textCoordinate");
    //绑定纹理坐标数据
    glVertexAttribPointer(textCoor, 2, GL_FLOAT, GL_FALSE, 0, textArr);
    //启用指向纹理坐标数据的句柄
    glEnableVertexAttribArray(textCoor);
    
    //第（5）步. 加载纹理
    _filterInputTextureUniform = glGetUniformLocation(self.program, "colorMap");
    [self setupTexture:@"for_test"];
    
    //获取shader里面的变量，这里记得要在glLinkProgram后面，后面，后面！
    GLuint rotate = glGetUniformLocation(self.program, "rotateMatrix");
    
    float radians = 300 * 3.14159f / 180.0f;
    float s = sin(radians);
    float c = cos(radians);
    
    /*
     细心的开发者会发现，这里的z轴旋转矩阵和上面给出来的旋转矩阵并不一致。
     究其原因就是OpenGLES是列主序矩阵，对于一个一维数组表示的二维矩阵，会先填满每一列（a[0][0]、a[1][0]、a[2][0]、a[3][0]）。
     把矩阵赋值给glsl对应的变量，然后就可以在glsl里面计算出旋转后的矩阵。
     */
    
    //z轴旋转矩阵
    GLfloat zRotation[16] = { //
        c, -s, 0, 0.0, //
        s, c, 0, 0,//
        0, 0, 1.0, 0,//
        0.0, 0, 0, 1.0//
    };
    
    //设置旋转矩阵/绑定旋转矩阵
    glUniformMatrix4fv(rotate, 1, GL_FALSE, (GLfloat *)&zRotation[0]);
    
    //使用GL_TRIANGLES方式绘制纹理
    glDrawArrays(GL_TRIANGLES, 0, 6);//三种绘制方式：GL_TRIANGLES、GL_TRIANGLE_STRIP、GL_TRIANGLE_FAN
    
    
    //第6步. 将绘制的结果显示到屏幕上
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void*)getImageData:(UIImage*)image{
    //获取图片的像素数据
    CGImageRef imageRef = [image CGImage];
    size_t imageWidth = CGImageGetWidth(imageRef);
    size_t imageHeight = CGImageGetHeight(imageRef);
    GLubyte *imageData = (GLubyte *)malloc(imageWidth*imageHeight*4);
    memset(imageData, 0,imageWidth *imageHeight*4);
    CGContextRef imageContextRef = CGBitmapContextCreate(imageData, imageWidth, imageHeight, 8, imageWidth*4, CGImageGetColorSpace(imageRef), kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(imageContextRef, 0, imageHeight);
    CGContextScaleCTM(imageContextRef, 1.0, -1.0);
    CGContextDrawImage(imageContextRef, CGRectMake(0.0, 0.0, (CGFloat)imageWidth, (CGFloat)imageHeight), imageRef);
    CGContextRelease(imageContextRef);
    return  imageData;
}

#pragma mark - dealloc

- (void)dealloc {
    if (_texture1) {
        glDeleteTextures(1, &_texture1);
        _texture1 = 0;
    }
    
    if (_frameBuffer) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    
    if (_renderbuffer) {
        glDeleteRenderbuffers(1, &_renderbuffer);
        _renderbuffer = 0;
    }
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
    
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    _context = nil;
}

@end
