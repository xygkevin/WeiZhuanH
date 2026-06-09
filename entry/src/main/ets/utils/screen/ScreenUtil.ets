/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : ScreenUtil
 * @Author : KEVIN XU
 * @Time : 2026/5/29 18:51
 * @Description : 描述
 */
import { display } from "@kit.ArkUI"

export class ScreenUtil {
  public static width(): number {
    try {
      return display.getDefaultDisplaySync().width
    } catch (error) {
      return 0
    }
  }

  public static height(): number {
    try {
      return display.getDefaultDisplaySync().height
    } catch (error) {
      return 0
    }
  }
}