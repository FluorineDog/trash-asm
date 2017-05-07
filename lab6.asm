
.386
.model flat, stdcall
option casemap:none

include    richedit.inc                                          ;加载自定义的库

MessageBoxA PROTO :DWORD, :DWORD, :DWORD, :DWORD
ExitProcess PROTO :DWORD

include    windows.inc
include    user32.inc     ;MessageBoxA所在的头文件
include    kernel32.inc   ;ExitProcess所在的头文件
include    gdi32.inc
include    comctl32.inc
include    shell32.inc
includelib user32.lib         ;MessageBoxA所在的引入库
includelib kernel32.lib       ;ExitProcess所在的引入库
includelib gdi32.lib
includelib comctl32.lib
includelib shell32.lib

;#################################################################

;存放学生信息的结构
STU_INF STRUCT
        STUNAME DB 10 DUP(0)   ;姓名
        CHINESE DB 0        ;语文成绩
        MATH DB 0           ;数学成绩
        ENGLISH DB 0        ;英语成绩
        AVERAGE DB 0        ;平均成绩
        GRADE DB 0          ;等第
STU_INF ENDS
;存放输出信息的结构
STU_SHOW STRUCT
         show_STUNAME DB 10 DUP(0), 0     ;姓名输出
         show_CHINESE DB 3 DUP(0), 0   ;语文成绩输出
         show_MATH DB 3 DUP(0), 0      ;数学成绩输出
         show_ENGLISH DB 3 DUP(0), 0   ;英语成绩输出
         show_AVERAGE DB 3 DUP(0H), 0  ;平均成绩输出
         show_GRADE DB 0H, 0           ;等第输出
STU_SHOW ENDS

;#################################################################

.DATA
MB_OK equ 0
;对学生信息进行赋值
stu_inf_buf STU_INF <'zhangsan', 50, 50, 50, 0, 0>
            STU_INF <'lisi', 60, 60, 60, , >
            STU_INF <'wangwu', 70, 70, 70, , >
            STU_INF <'zhaoliu', 80, 80, 80, , >
            STU_INF <'dog', 100, 100, 100, , >
;对输出信息进行赋值
BUF STU_SHOW <'zhangsan', '50', '50', '50', , >
    STU_SHOW <'lisi', '60', '60', '60', , >
    STU_SHOW <'wangwu', '70', '70', '70', , >
    STU_SHOW <'zhaoliu', '80', '80', '80', , >
    STU_SHOW <'dog', '100', '100', '100', , >

;标题
szClassName DB 'MainWndClass', 0  ;主窗口的类名
szDisplayName DB 'Student Information Arrangement System', 0    ;主界面标题
szMenuName DB 'MyMenu', 0

;输出内容
szHelpAbout DB '我是ACM1501 dog', 0   ;Help中About的显示信息
szAverageMsg DB 'Calculated Successfully!', 0    ;Average成功计算后的提示信息
szTipMsg DB 'TIP', 0  ;Average成功计算后的提示信息的对话框标题
TitleR DB 'Name      Chinese   Math      English   Grade', 0  ;输出的表头
TitleLine DB '__________________________________________________',0
;重要的参数信息
CommandLine DD 0  ;命令行的位置
hWndMain DD 0     ;窗口句柄
hInstance DD 0    ;实例句柄

;#################################################################

.STACK 1000

;#################################################################

.CODE

;-----------------------------主程序------------------------------

START:
    invoke GetModuleHandle, NULL   ;获得实例句柄
    mov hInstance, eax
    invoke GetCommandLine          ;获得命令行地址(用于获得命令行参数)
    mov CommandLine, eax
    invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
                                   ;进入窗口主程序函数
    invoke ExitProcess, eax        ;退出并返回操作系统(退出码为WinMain的返回信息)

;-------------------------------------------------------------------


;---------------------------窗口主程序------------------------------

WinMain proc hInst     : DWORD,
             hPrevInst : DWORD,
             CmdLine   : DWORD,
             CmdShow   : DWORD

        ;====================
        ; Put LOCALs on stack
        ;====================

        LOCAL wc   :WNDCLASSEX  ;创建主窗口时所需的信息有该结构说明
        LOCAL msg  :MSG         ;消息结构便令用于存放获取的消息
        LOCAL Wwd  :DWORD       ;这4个变量存放待创建的窗口的位置和大小信息
        LOCAL Wht  :DWORD
        LOCAL Wtx  :DWORD
        LOCAL Wty  :DWORD

        ;==================================================
        ; Fill WNDCLASSEX structure with required variables
        ;==================================================

        invoke RtlZeroMemory, ADDR wc, sizeof wc          ;将结构变量wc中的各项清零
        mov wc.cbSize,         sizeof WNDCLASSEX
        mov wc.style,          CS_HREDRAW or CS_VREDRAW   ;窗口风格
        mov wc.lpfnWndProc,    offset WndProc             ;窗口消息处理程序的入口地址(偏移地址)
        mov wc.cbClsExtra,     NULL
        mov wc.cbWndExtra,     NULL
        push                   hInst                      ;句柄
        pop                    hInstance
        mov wc.lpszClassName,  offset szClassName
        mov wc.hbrBackground,  COLOR_WINDOW+1
        mov wc.lpszMenuName,   offset szMenuName 
        invoke LoadIcon,NULL,IDI_APPLICATION
        mov wc.hIcon,          eax
        mov wc.hIconSm,        0
        invoke LoadCursor,NULL,IDC_ARROW
        mov wc.hCursor,        eax
        invoke RegisterClassEx, ADDR wc                    ;注册窗口类

        ;================================
        ; Centre window at following size
        ;================================

        mov Wwd, 600
        mov Wht, 400
        mov Wtx, 10
        mov Wty, 10
        invoke CreateWindowEx,WS_EX_LEFT,
                              ADDR szClassName,
                              ADDR szDisplayName,
                              WS_OVERLAPPEDWINDOW,
                              Wtx,Wty,Wwd,Wht,
                              NULL,NULL,
                              hInst,NULL
        mov    hWndMain, eax                               ;保存窗口句柄
        invoke ShowWindow,hWndMain,SW_SHOWNORMAL           ;显示窗口
        invoke UpdateWindow,hWndMain

      ;===================================
      ; Loop until PostQuitMessage is sent
      ;===================================

    StartLoop:
        invoke GetMessage,ADDR msg,NULL,0,0                ;获取消息
        cmp eax, 0                                         ;判断是否退出消息
        je ExitLoop
        invoke TranslateMessage, ADDR msg                  ;转换消息
        invoke DispatchMessage,  ADDR msg                  ;分发到窗口消息处理程序
        jmp StartLoop
    ExitLoop:
        mov eax, msg.wParam
        ret
WinMain endp

;------------------------------------------------------------------


;------------------------窗口消息处理程序--------------------------

WndProc proc hWnd   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD
        mov eax, uMsg
        .if eax==WM_DESTROY
            invoke PostQuitMessage,NULL
        .elseif eax==WM_COMMAND
            .if wParam == IDM_FILE_EXIT
                invoke SendMessage,hWnd,WM_CLOSE,0,0
                invoke DestroyWindow, hWnd
                invoke PostQuitMessage, NULL
            .elseif eax==IDM_ACTION_AVERAGE         ;计算平均分并弹出对话框
                invoke ActionAverage
            .elseif eax==IDM_ACTION_LIST            ;输出表格
                invoke ShowList,offset BUF
            .elseif eax==IDM_HELP_ABOUT             ;弹出信息对话框
                invoke MessageBoxA, hWndMain, addr szHelpAbout, addr szTipMsg, MB_OK
            .endif
        .else
            invoke DefWindowProc, hWnd, uMsg, wParam, lParam
            ret
        .endif
            xor eax, eax
            ret
        WndProc endp

;-------------------------------------------------------------------


;--------------------------用户处理程序------------------------------
;子程序名：DigitToASCII
;功能：将STU_INF中的平均分的数值信息转换成ASCII存入STU_SHWO中
;原型：DigitToASCII PROTO
;                   dScore : BYTE,    ;待转换的数值信息
;                   grade : BYTE,     ;待存储的等第信息
;                   pStu_show : DWORD ;结果存储的地址
;受影响的寄存器：ax, cx, esi，bx

;DigitToASCII PROTO
;             dScore : BYTE,    ;待转换的数值信息
;             grade : BYTE,     ;待存储的等第信息
;             pStu_show : DWORD ;结果存储的地址
;        mov esi, pStu_show  ;将地址赋给esi寄存器
;        mov ch, grade       ;将成绩等第赋给ch寄存器
;        mov ax, 0
;        mov al, dScore    ;将平均分赋给ax
;        mov bl, 10          ;将高位和个位分开
;        idiv bl
;        cmp ah, 10          ;判断成绩是否为三位数
;        jz  FULL
;        add ah, 30H         ;三位以下成绩的ASCII转换
;        add al, 30H
;        mov [esi], al
;        mov [esi+1], ah
;        jmp GRAG
;FULL:   mov [esi], '1'      ;满分成绩的转换
;        mov [esi+1], '0'
;        mov [esi+2], '0'
;GRAG:   mov [esi+4], ch
;        ret
;DigitToASCII endp

;-----------------------------------------------------------------
;子程序名：CalAverage
;功能：将STU_INF中存储的分数算出平均成绩后，存进STU_INF中的AVERGEE
;原型：CalAverage proc
;                 pstu_inf : dword ;当前要算的平均成绩的指针
;受影响寄存器：id，si，ax，cx，bx

CalAverage proc near stdcall USES edi esi cx ax bx,
           pstu_inf  : dword,  ;stu_inf_buf的首址传入
           pstu_show : dword   ;BUF的首址传入

        mov edi, pstu_inf
        mov esi, pstu_show
        add edi, 10
        add esi, 23
        mov cl, 5
    LOP:
        mov ax, 0
        mov al, [edi]
        add ax, ax
        mov dl, [edi+1]
        mov ax, dx
        mov dl, [edi+2]
        sar dl, 1
        add ax, dx
        sal ax, 1
        mov dl, 7
        idiv dl
        mov [edi+3], al      ;计算平均成绩并存储
        cmp al, 60          ;判断等第
        jb INPF
        cmp al, 70
        jb INPD
        cmp al, 80
        jb INPC
        cmp al, 90
        jb INPB
        mov ch, 'A'
    INPF:
        mov ch, 'F'
    INPD:
        mov ch, 'D'
    INPC:
        mov ch, 'C'
    INPB:
        mov ch, 'B'
        mov [edi+4], ch      ;在数字信息中存储等第
        movzx ax, al        ;将平均分高地位分离
        mov bl, 10
        idiv bl
        cmp al, 10          ;如果是满分，就直接赋值
        jz FULL
        add ah, 30H         ;非满分成绩分离高低位后分别转换成ASCII后储存
        add al, 30H
        mov [esi], al
        mov [esi+1], ah
        jmp GRAG
    FULL:
        mov ah, '0'
        mov al, '1'
        mov [esi], al       ;满分成绩的转换
        mov [esi+1], ah
        mov [esi+2], ah
    GRAG:
        mov [esi+4], ch
        add di, 15
        add si, 29
        dec cl
        jnz LOP
        ret
CalAverage ENDP

;-----------------------------------------------------------------
;子程序名：ActionAverage
;功能：调用一系列计算平均分和赋值操作的函数，并弹出提示窗口
;原型：ActionAverage proc
;受影响寄存器：

ActionAverage proc
        lea di, stu_inf_buf
        lea si, BUF
        invoke CalAverage, edi, esi   ;调用程序计算并存储成绩信息
        invoke MessageBox, hWndMain, addr szAverageMsg, addr szTipMsg, MB_OK  ;输出提示信息
        ret
ActionAverage endp

;-----------------------------------------------------------------
;子程序名：ShowList
;功能：将存储在STU_SHOW型结构变量中的内容输出
;原型：ShowList proc 
;               pStu_show : dword,
;受影响的寄存器：

ShowList proc near stdcall USES cx ax,
         pStu_show : dword    ;BUF的地址
         
         XX_GAP equ 100
         YY_GAP equ 30
         XX equ 10
         YY equ 10
         LOCAL  hdc:HDC
         LOCAL  STU_NUM : BYTE
         
        invoke GetDC,hWndMain
        mov hdc,eax
        mov cx, 0
        invoke TextOut,hdc,XX+0*XX_GAP,YY+0*YY_GAP,offset TitleR,45
        invoke TextOut,hdc,XX+0*XX_GAP,YY+1*YY_GAP,offset TitleLine,50
        ;输出成绩信息
        invoke TextOut,hdc,XX+0*XX_GAP,YY+1*YY_GAP,offset BUF[0*15],10
        invoke TextOut,hdc,XX+1*XX_GAP,YY+1*YY_GAP,offset BUF[0*15+11],3
        invoke TextOut,hdc,XX+2*XX_GAP,YY+1*YY_GAP,offset BUF[0*15+15],3
        invoke TextOut,hdc,XX+3*XX_GAP,YY+1*YY_GAP,offset BUF[0*15+19],3
        invoke TextOut,hdc,XX+4*XX_GAP,YY+1*YY_GAP,offset BUF[0*15+23],3
        invoke TextOut,hdc,XX+5*XX_GAP,YY+1*YY_GAP,offset BUF[0*15+27],1
        
        invoke TextOut,hdc,XX+0*XX_GAP,YY+2*YY_GAP,offset BUF[1*15],10
        invoke TextOut,hdc,XX+1*XX_GAP,YY+2*YY_GAP,offset BUF[1*15+11],3
        invoke TextOut,hdc,XX+2*XX_GAP,YY+2*YY_GAP,offset BUF[1*15+15],3
        invoke TextOut,hdc,XX+3*XX_GAP,YY+2*YY_GAP,offset BUF[1*15+19],3
        invoke TextOut,hdc,XX+4*XX_GAP,YY+2*YY_GAP,offset BUF[1*15+23],3
        invoke TextOut,hdc,XX+5*XX_GAP,YY+2*YY_GAP,offset BUF[1*15+27],1
        
        invoke TextOut,hdc,XX+0*XX_GAP,YY+3*YY_GAP,offset BUF[2*15],10
        invoke TextOut,hdc,XX+1*XX_GAP,YY+3*YY_GAP,offset BUF[2*15+11],3
        invoke TextOut,hdc,XX+2*XX_GAP,YY+3*YY_GAP,offset BUF[2*15+15],3
        invoke TextOut,hdc,XX+3*XX_GAP,YY+3*YY_GAP,offset BUF[2*15+19],3
        invoke TextOut,hdc,XX+4*XX_GAP,YY+3*YY_GAP,offset BUF[2*15+23],3
        invoke TextOut,hdc,XX+5*XX_GAP,YY+3*YY_GAP,offset BUF[2*15+27],1

        invoke TextOut,hdc,XX+0*XX_GAP,YY+4*YY_GAP,offset BUF[3*15],10
        invoke TextOut,hdc,XX+1*XX_GAP,YY+4*YY_GAP,offset BUF[3*15+11],3
        invoke TextOut,hdc,XX+2*XX_GAP,YY+4*YY_GAP,offset BUF[3*15+15],3
        invoke TextOut,hdc,XX+3*XX_GAP,YY+4*YY_GAP,offset BUF[3*15+19],3
        invoke TextOut,hdc,XX+4*XX_GAP,YY+4*YY_GAP,offset BUF[3*15+23],3
        invoke TextOut,hdc,XX+5*XX_GAP,YY+4*YY_GAP,offset BUF[3*15+27],1

        invoke TextOut,hdc,XX+0*XX_GAP,YY+5*YY_GAP,offset BUF[4*15],10
        invoke TextOut,hdc,XX+1*XX_GAP,YY+5*YY_GAP,offset BUF[4*15+11],3
        invoke TextOut,hdc,XX+2*XX_GAP,YY+5*YY_GAP,offset BUF[4*15+15],3
        invoke TextOut,hdc,XX+3*XX_GAP,YY+5*YY_GAP,offset BUF[4*15+19],3
        invoke TextOut,hdc,XX+4*XX_GAP,YY+5*YY_GAP,offset BUF[4*15+23],3
        invoke TextOut,hdc,XX+5*XX_GAP,YY+5*YY_GAP,offset BUF[4*15+27],1
        ret
ShowList endp

END START