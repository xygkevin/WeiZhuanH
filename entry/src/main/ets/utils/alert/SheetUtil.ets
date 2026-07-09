/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : SheetUtil
 * @Author : KEVIN XU
 * @Time : 2026/6/17 15:51
 * @Description : 描述
 */
import { ComponentContent, LengthMetrics, LevelMode } from "@kit.ArkUI"

export interface SheetParam {
  title?: string
  message?: string
  actions: string[]
  nodeId?: string
  autoCancel?: boolean
  onSelect: (action: string, index: number) => void
  onCancel?: () => void
}

export class SheetUtil {
  static contentNode?: ComponentContent<SheetParam>
  static uiContext?: UIContext

  static async show(uiContext: UIContext, param: SheetParam): Promise<void> {
    try {
      SheetUtil.uiContext = uiContext
      SheetUtil.contentNode = new ComponentContent<SheetParam>(uiContext, wrapBuilder(buildSheet), param)
      const frameNode: FrameNode | null = param.nodeId ? uiContext.getFrameNodeById(param.nodeId) : null
      const uniqueId: number | undefined = frameNode ? frameNode.getUniqueId() : undefined
      const levelMode: LevelMode = uniqueId ? LevelMode.EMBEDDED : LevelMode.OVERLAY
      await uiContext.getPromptAction().openCustomDialog(SheetUtil.contentNode, {
        autoCancel: param.autoCancel === undefined ? false : param.autoCancel,
        showInSubWindow: false,
        isModal: true,
        maskColor: '#4D000000',
        levelMode: levelMode,
        levelUniqueId: uniqueId,
        alignment: DialogAlignment.Bottom,
        keyboardAvoidMode: KeyboardAvoidMode.DEFAULT,
        dialogTransition: TransitionEffect.translate({ y: '100%' })
          .combine(TransitionEffect.opacity(0))
          .animation({ duration: 200 }),
        maskTransition: TransitionEffect.opacity(0).animation({ duration: 200 }),
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
      await SheetUtil.uiContext?.getPromptAction().closeCustomDialog(SheetUtil.contentNode!)
      SheetUtil.contentNode?.dispose()
      SheetUtil.contentNode = undefined
    } catch (err) {
      throw new Error((err as BusinessError).message)
    }
  }
}

@Builder
function buildSheet(param: SheetParam) {
  Column({ space: 0 }) {
    if (param.title || param.message) {
      Column({ space: 6 }) {
        if (param.title) {
          Text(param.title)
            .width('100%')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.Black)
            .textAlign(TextAlign.Center)
        }
        if (param.message) {
          Text(param.message)
            .width('100%')
            .fontSize(12)
            .fontWeight(FontWeight.Regular)
            .fontColor(Color.Gray)
            .textAlign(TextAlign.Center)
        }
      }
      .width('100%')
      .padding({
        left: 20,
        right: 20,
        top: 15,
        bottom: 15
      })
    }

    Column() {
      if (param.title || param.message) {
        Divider().vertical(false).width('100%').strokeWidth(2).color('#F4F5F7')
      }
      ForEach(param.actions, (item: string, index: number) => {
        Button(item)
          .type(ButtonType.Normal)
          .borderRadius(0)
          .backgroundColor(Color.White)
          .width('100%')
          .height(44)
          .fontSize(14)
          .fontWeight(FontWeight.Regular)
          .fontColor(Color.Black)
          .onClick(async () => {
            await SheetUtil.close()
            param.onSelect(item, index)
          })
        Divider()
          .vertical(false)
          .width('100%')
          .strokeWidth(index === param.actions.length - 1 ? 10 : 0.66)
          .color('#F4F5F7')
      })
    }
    .width('100%')

    Button('取消')
      .type(ButtonType.Normal)
      .borderRadius(0)
      .backgroundColor(Color.White)
      .fontWeight(FontWeight.Medium)
      .width('100%')
      .height(44)
      .fontSize(14)
      .fontColor(Color.Black)
      .onClick(async () => {
        await SheetUtil.close()
        if (param.onCancel) {
          param.onCancel()
        }
      })
  }
  .width('100%')
  .backgroundColor(Color.White)
  .borderRadius({
    topLeft: 20,
    topRight: 20
  })
  .clip(true)
  .safeAreaPadding({
    bottom: 34
  })
}