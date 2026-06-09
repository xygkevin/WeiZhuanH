/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : AnimationUtil
 * @Author : KEVIN XU
 * @Time : 2026/5/29 18:49
 * @Description : 描述
 */

export class AnimationShakeOptions {
  /**
   * 起始延迟
   */
  delay: number = 0
  /**
   * 单次动画时长(单位:毫秒)
   */
  duration: number = 30
  /**
   * 晃动轨迹(vp)
   */
  offsets: number[] = [-6, 6, -4, 4, -2, 2, 0]
  /**
   * 转动角度
   */
  angles: number[] = [-6, 6, -4, 4, -2, 2, 0]
  /**
   * 缩放倍数
   */
  scales: number[] = [-6, 6, -4, 4, -2, 2, 0]
}

export class AnimationUtil {
  /**
   * X 轴晃动
   */
  public static shakeX(uiContext: UIContext, onChanged: (offset: number) => void, options: AnimationShakeOptions = new AnimationShakeOptions()) {
    options.offsets.forEach((value: number, index: number) => {
      uiContext.animateTo({
        duration: options.duration,
        curve: index === 0 ? Curve.EaseOut : Curve.EaseInOut,
        delay: options.delay + index * options.duration,
      }, () => {
        onChanged(value)
      })
    })
  }

  /**
   * Y 轴晃动
   */
  public static shakeY(uiContext: UIContext, onChanged: (offset: number) => void, options: AnimationShakeOptions = new AnimationShakeOptions()) {
    options.offsets.forEach((value: number, index: number) => {
      uiContext.animateTo({
        duration: options.duration,
        curve: index === 0 ? Curve.EaseOut : Curve.EaseInOut,
        delay: options.delay + index * options.duration,
      }, () => {
        onChanged(value)
      })
    })
  }

  /**
   * 缩放动画
   */
  public static shakeS(uiContext: UIContext, onChanged: (offset: number) => void, options: AnimationShakeOptions = new AnimationShakeOptions()) {
    options.scales.forEach((value: number, index: number) => {
      uiContext.animateTo({
        duration: options.duration,
        curve: index === 0 ? Curve.EaseOut : Curve.EaseInOut,
        delay: options.delay + index * options.duration,
      }, () => {
        onChanged(value)
      })
    })
  }

  /**
   * Z 轴晃动(角度)
   */
  public static shakeR(uiContext: UIContext, onChanged: (offset: number) => void, options: AnimationShakeOptions = new AnimationShakeOptions()) {
    options.angles.forEach((value: number, index: number) => {
      uiContext.animateTo({
        duration: options.duration,
        curve: index === 0 ? Curve.EaseOut : Curve.EaseInOut,
        delay: options.delay + index * options.duration,
      }, () => {
        onChanged(value)
      })
    })
  }
}