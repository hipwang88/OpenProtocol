//
//  definition.h
//  SkyworthSCXPJ
//
//  Created by skyworth on 13-8-27.
//  Copyright (c) 2013年 skyworth. All rights reserved.
//

#ifndef SkyworthSCXPJ_definition_h
#define SkyworthSCXPJ_definition_h

// 锚点定位
typedef struct skyResizableAnchorPoint
{
    CGFloat adjustX;
    CGFloat adjustY;
    CGFloat adjustH;
    CGFloat adjustW;
    int     direction;
}skyResizableAnchorPoint;

// 位置与锚点对
typedef struct skyPointAndResizableAnchorPoint
{
    CGPoint point;
    skyResizableAnchorPoint anchor;
}skyPointAndResizableAnchorPoint;


// 协议类型定义
#define kSCXPROTOCOL            0                   // 混合开窗开发协议
#define kSCXOPENPROTOCOL        1                   // 混合开窗开放协议

//
// 命令延迟
#define SKY_SEND_DELAY          200

//
// 调试输出
#define DEBUG_LOG
#ifdef DEBUG_LOG
#define LOG_MESSAGE      NSLog
#else
#define LOG_MESSAGE
#endif

#endif
