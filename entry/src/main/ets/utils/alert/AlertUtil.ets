/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : AlertUtil
 * @Author : KEVIN XU
 * @Time : 2026/6/17 15:51
 * @Description : 描述
 */
import { ComponentContent, CustomContentDialogV2, Frame, LengthMetrics, LevelMode } from "@kit.ArkUI"


/**
 * 弹窗按钮
 */
export interface AlertButton {
  title: string
  action: () => void
  fontSize?: number
  fontColor?: ResourceColor
  backgroundColor?: ResourceColor
  borderRadius?: number
  fontWeight?: FontWeight
}

/**
 * Alert弹窗参数
 */
export class AlertParam {
  title?: string = '温馨提示'
  message?: string = undefined
  buttons?: AlertButton[] = []
  nodeId?: string = undefined
  transition?: TransitionEffect = undefined
  dialogTransition?: TransitionEffect = undefined
  maskTransition?: TransitionEffect = undefined
  keyboardAvoidDistance?: number = 0
  autoCancel?: boolean = false
  onCancel?: () => void = undefined
}

/**
 * Alert弹窗工具类
 */
export class AlertUtil {
  static contentNode?: ComponentContent<AlertParam>
  static uiContext?: UIContext

  static async show(uiContext: UIContext, param: AlertParam): Promise<void> {
    try {
      AlertUtil.uiContext = uiContext
      AlertUtil.contentNode = new ComponentContent<AlertParam>(uiContext, wrapBuilder(buildAlert), param)
      const frameNode: FrameNode | null = param.nodeId ? uiContext.getFrameNodeById(param.nodeId) : null
      const uniqueId: number | null = frameNode ? frameNode.getUniqueId() : null
      const levelMode: LevelMode = uniqueId ? LevelMode.EMBEDDED : LevelMode.OVERLAY
      await uiContext.getPromptAction().openCustomDialog(AlertUtil.contentNode, {
        autoCancel: param.autoCancel,
        showInSubWindow: false,
        isModal: true,
        maskColor: '#4D000000',
        levelMode: levelMode,
        levelUniqueId: uniqueId,
        alignment: DialogAlignment.Center,
        keyboardAvoidMode: KeyboardAvoidMode.DEFAULT,
        keyboardAvoidDistance: LengthMetrics.vp(param.keyboardAvoidDistance),
        transition: param.transition,
        dialogTransition: param.dialogTransition,
        maskTransition: param.maskTransition,
        onWillDismiss: (action: DismissDialogAction) => {
          if (param.autoCancel === true &&
            (action.reason === DismissReason.TOUCH_OUTSIDE || action.reason === DismissReason.PRESS_BACK)) {
            action.dismiss()
            if (param.onCancel) {
              param.onCancel()
            }
          }
          return true
        }
      })
    } catch (err) {
      throw new Error((err as BusinessError).message)
    }
  }

  static async close(): Promise<void> {
    try {
      await AlertUtil.uiContext?.getPromptAction().closeCustomDialog(AlertUtil.contentNode)
      AlertUtil.contentNode?.dispose()
      AlertUtil.contentNode = undefined
    } catch (err) {
      throw new Error((err as BusinessError).message)
    }
  }
}

@Builder
function buildAlert(param: AlertParam) {
  Stack() {
    Column({ space: 20 }) {
      if (param.title) {
        Text(param.title)
          .width('100%')
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .lineSpacing(LengthMetrics.vp(6))
          .textAlign(TextAlign.Center)
          .fontColor(Color.Black)
      }
      if (param.message) {
        Text(param.message)
          .width('100%')
          .fontSize(15)
          .fontWeight(FontWeight.Regular)
          .lineSpacing(LengthMetrics.vp(6))
          .textAlign(TextAlign.Center)
          .fontColor(Color.Black)
      }
      if (param.buttons) {
        if (param.buttons.length <= 2) {
          Row({ space: 5 }) {
            ForEach(param.buttons, (item: AlertButton) => {
              Button(item.title)
                .layoutWeight(1)
                .type(ButtonType.Normal)
                .backgroundColor(item.backgroundColor ?? Color.Red)
                .borderRadius(item.borderRadius ?? 18)
                .fontSize(item.fontSize ?? 15)
                .fontColor(item.fontColor ?? Color.White)
                .fontWeight(item.fontWeight ?? FontWeight.Medium)
                .onClick(async () => {
                  await AlertUtil.close()
                  item.action()
                })
            })
          }
          .width('100%')
          .height(36)
        } else {
          Column({ space: 10 }) {
            ForEach(param.buttons, (item: AlertButton) => {
              Button(item.title)
                .width('100%')
                .height(36)
                .type(ButtonType.Normal)
                .backgroundColor(item.backgroundColor ?? Color.Red)
                .borderRadius(item.borderRadius ?? 18)
                .fontSize(item.fontSize ?? 15)
                .fontColor(item.fontColor ?? Color.White)
                .fontWeight(item.fontWeight ?? FontWeight.Medium)
                .onClick(async () => {
                  await AlertUtil.close()
                  item.action()
                })
            })
          }
          .width('100%')
        }
      }
    }
    .width('100%')
    .padding(20)
    .borderRadius(16)
    .backgroundColor(Color.White)
  }
  .width('80%')
}