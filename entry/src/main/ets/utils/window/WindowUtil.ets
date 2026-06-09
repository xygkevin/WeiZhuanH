/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : WindowUtil
 * @Author : KEVIN XU
 * @Time : 2026/5/29 18:52
 * @Description : 描述
 */
import window from "@ohos.window";

export class WindowUtil {
  private static wzWindowStage?: window.WindowStage

  private constructor() {
  }

  static init(windowStage: window.WindowStage) {
    WindowUtil.wzWindowStage = windowStage
  }

  static windowStage(): window.WindowStage {
    if (!WindowUtil.wzWindowStage) {
      throw new Error('请先初始化方法: static init(windowStage:)')
    }
    return WindowUtil.wzWindowStage
  }


  static async mainWindow(): Promise<window.Window> {
    try {
      return await WindowUtil.windowStage().getMainWindow()
    } catch (err) {
      throw new Error(err)
    }
  }

  static async uiContext(): Promise<UIContext> {
    try {
      const window = await WindowUtil.mainWindow()
      return window.getUIContext()
    } catch (err) {
      throw new Error(err)
    }
  }
}