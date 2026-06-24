/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : ToastUtil
 * @Author : KEVIN XU
 * @Time : 2026/5/29 18:52
 * @Description : 描述
 */
import { ComponentContent, LengthMetrics, LevelMode, UIContext } from "@kit.ArkUI"

export class ToastOptions {
  icon?: Resource
  title?: ResourceStr
  subtitle?: ResourceStr
  radius: number = 12
  backgroundColor: ResourceColor = Color.Black
  maskColor: ResourceColor = '#00000000'
  showClose: boolean = true
  showCloseDelay: number = 3000
  closeIcon: Resource = $r('app.media.toast_close')
  duration?: number = 3000
  position: 'center' | 'top' | 'bottom' = 'center'
  offsetX: number = 0
  offsetY: number = 0
  spacing: number = 5
  padding: number | Padding = {
    top: 10,
    bottom: 10,
    left: 10,
    right: 10
  }
  focusable: boolean = false
  minWidth?: number
  minHeight?: number
  iconWidth: number = 40
  iconHeight: number = 40
  titleSize: number = 14
  nodeId?: string = undefined
  titleColor: ResourceColor = Color.White
  titleWeight: FontWeight = FontWeight.Regular
  titleAlign: TextAlign = TextAlign.Center
  titleLineSpacing: number = 6
  subtitleSize: number = 12
  subtitleColor: ResourceColor = Color.White
  subtitleWeight: FontWeight = FontWeight.Regular
  subtitleAlign: TextAlign = TextAlign.Center
  subtitleLineSpacing: number = 6
  isLoading: boolean = false
  isProgress: boolean = false
  progress: number = 0
  total: number = 100
  autoCancel: boolean = false // 设置是否允许通过点击弹出框的蒙层（遮罩层）来关闭弹出框 仅在isModal === true的时候生效
  isModal: boolean = true // 定义弹出框是否为模态弹窗，即是否阻止与弹出框之外的其他组件交互。
  showInSubWindow: boolean = false
  onClose?: () => void
}

export class ToastUtil {
  private static uiContext?: UIContext
  private static timer?: number
  private static options?: ToastOptions
  private static contentNode?: ComponentContent<ToastOptions>

  /**
   * 初始化
   */
  static init(uiContext: UIContext) {
    ToastUtil.uiContext = uiContext
  }

  /**
   * 纯文本Toast
   * @param status
   * @param duration
   * @param onClose
   * @returns
   */
  static async showToast(status: string, duration?: number, onClose?: () => void): Promise<void> {
    let options = new ToastOptions()
    options.title = status
    options.onClose = onClose
    options.isModal = false
    options.showClose = false
    options.focusable = false
    if (duration !== undefined && duration > 0) {
      options.duration = duration
    }
    return ToastUtil.show(options)
  }

  /**
   * 成功Toast
   * @param status
   * @param duration
   * @param onClose
   * @returns
   */
  static async showSuccess(status?: string, duration?: number, onClose?: () => void): Promise<void> {
    let options = new ToastOptions()
    options.title = status
    options.onClose = onClose
    options.isModal = false
    options.showClose = false
    options.focusable = true
    options.icon = $r('app.media.toast_check')
    if (duration !== undefined && duration > 0) {
      options.duration = duration
    }
    return ToastUtil.show(options)
  }

  /**
   * 信息Toast
   * @param status
   * @param duration
   * @param onClose
   * @returns
   */
  static async showInfo(status: string, duration?: number, onClose?: () => void): Promise<void> {
    let options = new ToastOptions()
    options.title = status
    options.onClose = onClose
    options.isModal = false
    options.showClose = false
    options.focusable = true
    options.icon = $r('app.media.toast_info')
    if (duration !== undefined && duration > 0) {
      options.duration = duration
    }
    return ToastUtil.show(options)
  }

  /**
   * 错误Toast
   * @param status
   * @param duration
   * @param onClose
   * @returns
   */
  static async showError(status?: string, duration?: number, onClose?: () => void): Promise<void> {
    let options = new ToastOptions()
    options.title = status
    options.onClose = onClose
    options.isModal = false
    options.showClose = false
    options.focusable = true
    options.icon = $r('app.media.toast_error')
    if (duration !== undefined && duration > 0) {
      options.duration = duration
    }
    return ToastUtil.show(options)
  }

  /**
   * 警告Toast
   * @param status
   * @param duration
   * @param onClose
   * @returns
   */
  static async showWarn(status?: string, duration?: number, onClose?: () => void): Promise<void> {
    let options = new ToastOptions()
    options.title = status
    options.onClose = onClose
    options.isModal = false
    options.showClose = false
    options.focusable = true
    options.icon = $r('app.media.toast_warn')
    if (duration !== undefined && duration > 0) {
      options.duration = duration
    }
    return ToastUtil.show(options)
  }

  /**
   * Loading Toast
   * @param status
   * @param duration
   * @param onClose
   * @returns
   */
  static async showLoading(status?: string, duration?: number, onClose?: () => void): Promise<void> {
    let options = new ToastOptions()
    options.title = status
    options.onClose = onClose
    options.icon = $r('app.media.toast_loading')
    options.isLoading = true
    options.isModal = true
    options.focusable = true
    options.duration = duration ?? -1
    return ToastUtil.show(options)
  }

  /**
   * 进度Taost
   * @param progress
   * @param status
   * @param onClose
   * @returns
   */
  static async showProgress(progress: number, status: string, onClose?: () => void): Promise<void> {
    let options: ToastOptions = new ToastOptions()
    options.title = status
    options.onClose = onClose
    options.isProgress = true
    options.duration = undefined
    options.progress = progress
    options.isModal = true
    options.showClose = false
    options.focusable = true
    ToastUtil.show(options)
  }

  /**
   * 消除
   * @param delay
   * @returns
   */
  static async dismiss(delay: number = 0): Promise<void> {
    if (delay > 0) {
      ToastUtil.startTimer(delay, async () => {
        return ToastUtil.close()
      })
    } else {
      ToastUtil.removeTimer()
      return ToastUtil.close()
    }
  }

  /**
   * 核心方法展示
   * @param options
   * @returns
   */
  private static async show(options: ToastOptions): Promise<void> {
    try {
      if (ToastUtil.options) {
        if (ToastUtil.options.isProgress && options.isProgress) {

        } else {
          await ToastUtil.dismiss()
        }
      }

      const uiContext = ToastUtil.uiContext
      if (!uiContext) {
        console.error('清先初始化uiContext')
        return
      }
      const ptAction = uiContext.getPromptAction()
      if (ToastUtil.contentNode) {
        ToastUtil.options = options
        ToastUtil.contentNode.update(options)
        if (options.progress >= 100) {
          ToastUtil.dismiss(1000)
        }
      } else {
        ToastUtil.contentNode = new ComponentContent<ToastOptions>(uiContext, wrapBuilder(buildToast), options)
        await ptAction.openCustomDialog<ToastOptions>(ToastUtil.contentNode, {
          maskColor: options.maskColor,
          isModal: options.isModal,
          autoCancel: options.autoCancel,
          focusable: options.focusable,
          alignment: DialogAlignment.Center,
          offset: {
            dx: options.offsetX,
            dy: options.offsetY
          },
          showInSubWindow: options.showInSubWindow,
          levelMode: LevelMode.EMBEDDED,
          levelUniqueId: options.nodeId ? uiContext.getFrameNodeById(options.nodeId)?.getUniqueId() : null,
          keyboardAvoidMode: KeyboardAvoidMode.DEFAULT,

          onWillDismiss: (reason) => {
            if (reason.reason === DismissReason.TOUCH_OUTSIDE) {
              reason.dismiss()
            }
          }
        })
        ToastUtil.options = options
        if (options.duration !== undefined && options.duration > 0) {
          ToastUtil.dismiss(options.duration)
        }
      }
    } catch (err) {
      throw new Error(err)
    }
  }

  /**
   * 核心方法关闭
   * @returns
   */
  private static async close(): Promise<void> {
    try {
      const uiContext = ToastUtil.uiContext
      if (!uiContext) {
        console.error('清先初始化uiContext')
        return
      }
      const ptAction = uiContext.getPromptAction()
      await ptAction.closeCustomDialog(ToastUtil.contentNode)
      ToastUtil.contentNode?.dispose()
      ToastUtil.contentNode = undefined
      if (ToastUtil.options?.onClose) {
        ToastUtil.options.onClose()
      }
      ToastUtil.options = undefined
    } catch (err) {
      throw new Error(err)
    }
  }

  /**
   * 开启定时任务
   * @param delay
   * @param callback
   */
  private static startTimer(delay: number, callback: () => void) {
    ToastUtil.removeTimer()
    ToastUtil.timer = setTimeout(callback, delay)
  }

  /**
   * 移除定时任务
   */
  private static removeTimer() {
    if (ToastUtil.timer) {
      clearTimeout(ToastUtil.timer)
    }
  }
}

@Builder
function buildToast(options: ToastOptions) {
  ToastView({
    options: options,
    onClose: () => {
      ToastUtil.dismiss()
    }
  })
}

@ComponentV2
struct ToastView {
  @Param options: ToastOptions = new ToastOptions()
  @Local private angle: number = 0
  @Local showClose: boolean = false
  @Event onClose: () => void = () => {
  }
  private closeTimeId?: number = undefined

  aboutToDisappear(): void {
    if (this.closeTimeId !== undefined) {
      clearTimeout(this.closeTimeId)
      this.closeTimeId = undefined
    }
  }

  build() {
    Stack() {
      Column({ space: this.options.spacing }) {
        if (this.options.icon) {
          Image(this.options.icon)
            .width(44)
            .height(44)
            .objectFit(ImageFit.Fill)
            .rotate({
              angle: this.angle
            })
        }
        if (this.options.isProgress) {
          Stack() {
            Progress({
              value: this.options.progress,
              total: this.options.total,
              type: ProgressType.Ring,
            })
              .color(Color.White)
              .backgroundColor('#333333')
              .width(44)
              .height(44)
              .style({
                strokeWidth: 3,
                status: ProgressStatus.PROGRESSING
              })
            Text(
              `${Math.floor(Math.min(100, Math.max(0, Math.abs(this.options.progress / this.options.total * 100))))}%`)
              .fontSize(12)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
          }
        }
        if (this.options.title) {
          Text(this.options.title)
            .fontSize(this.options.titleSize)
            .fontColor(this.options.titleColor)
            .textAlign(this.options.titleAlign)
            .lineSpacing(LengthMetrics.vp(this.options.titleLineSpacing))
        }
        if (this.options.subtitle) {
          Text(this.options.subtitle)
            .fontSize(this.options.subtitleSize)
            .fontColor(this.options.subtitleColor)
            .textAlign(this.options.subtitleAlign)
            .lineSpacing(LengthMetrics.vp(this.options.subtitleLineSpacing))
        }
      }
      .padding(this.options.padding)
      .backgroundColor(this.options.backgroundColor)
      .borderRadius(this.options.radius)
      .onAppear(() => {
        if (this.options.isLoading && this.options.icon) {
          this.getUIContext().animateTo({
            duration: 1000,
            iterations: -1,
            curve: Curve.Linear,
          }, () => {
            this.angle = 360
          })
        }
        if (this.options.showClose && this.options.showCloseDelay < (this.options.duration ?? Number.MAX_VALUE)) {
          this.closeTimeId = setTimeout(() => {
            this.showClose = true
          }, this.options.showCloseDelay)
        }
      })

      if (this.showClose) {
        Image(this.options.closeIcon)
          .width(20)
          .height(20)
          .position({
            top: 0,
            right: 0
          })
          .onClick(() => {
            this.onClose()
          })
      }
    }
    .padding(20)
    .hitTestBehavior(HitTestMode.None)
  }
}