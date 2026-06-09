/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : PixelUtil
 * @Author : KEVIN XU
 * @Time : 2026/6/2 15:05
 * @Description : 描述
 */
import { UIContext } from "@kit.ArkUI"
import { ContextUtil } from '../context/ContextUtil';

export class PixelUtil {
  private static uiContext(): UIContext {
    return ContextUtil.uiContext()
  }

  static px2vp(value: number): number {
    return PixelUtil.uiContext().px2vp(value)
  }

  static vp2px(value: number): number {
    return PixelUtil.uiContext().vp2px(value)
  }

  static fp2px(value: number): number {
    return PixelUtil.uiContext().fp2px(value)
  }

  static px2fp(value: number): number {
    return PixelUtil.uiContext().px2fp(value)
  }

  static lpx2px(value: number): number {
    return PixelUtil.uiContext().lpx2px(value)
  }

  static px2lpx(value: number): number {
    return PixelUtil.uiContext().px2lpx(value)
  }
}