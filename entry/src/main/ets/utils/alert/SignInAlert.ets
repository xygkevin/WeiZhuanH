/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : SignInAlert
 * @Author : KEVIN XU
 * @Time : 2026/6/17 18:40
 * @Description : 描述
 */
import { ComponentContent, LevelMode } from "@kit.ArkUI"

/**
 * 签到数据
 */
export class SignInModel {
}

/**
 * 签到数据
 */
export interface SignInParam {
  data: SignInModel
  nodeId?: string
}

/**
 * 签到弹窗
 */
export class SignInAlert {
  static contentNode?: ComponentContent<SignInParam>
  static uiContext?: UIContext

  static async show(uiContext: UIContext, param: SignInParam): Promise<void> {
    try {
      SignInAlert.uiContext = uiContext
      SignInAlert.contentNode = new ComponentContent<SignInParam>(uiContext, wrapBuilder(buildSignInAlert), param)
      const frameNode: FrameNode | null = param.nodeId ? uiContext.getFrameNodeById(param.nodeId) : null
      const uniqueId: number | null = frameNode ? frameNode.getUniqueId() : null
      const levelMode: LevelMode = uniqueId ? LevelMode.EMBEDDED : LevelMode.OVERLAY
      await uiContext.getPromptAction().openCustomDialog(SignInAlert.contentNode, {
        autoCancel: false,
        showInSubWindow: false,
        isModal: true,
        maskColor: '#4D000000',
        levelMode: levelMode,
        levelUniqueId: uniqueId,
        alignment: DialogAlignment.Center,
        onWillDismiss: (action: DismissDialogAction) => {
          return true
        }
      })
    } catch (err) {
      throw new Error((err as BusinessError).message)
    }
  }

  static async close(): Promise<void> {
    try {
      await SignInAlert.uiContext?.getPromptAction().closeCustomDialog(SignInAlert.contentNode)
      SignInAlert.contentNode?.dispose()
      SignInAlert.contentNode = undefined
    } catch (err) {
      throw new Error((err as BusinessError).message)
    }
  }
}

@Builder
function buildSignInAlert(model: SignInModel) {
  SignInComponent({
    dataModel: model
  })
}

@ComponentV2
export struct SignInComponent {
  @Param @Require dataModel: SignInModel
  @Local showBanner: boolean = false
  @Local showClose: boolean = false

  aboutToAppear(): void {
    setTimeout(() => {
      this.showBannerAnimation()
    }, 1000)

  }

  showBannerAnimation() {
    this.getUIContext().animateTo({
      duration: 200,
      delay: 0,
      onFinish: () => {
        this.showCloseAnimation()
      }
    }, () => {
      this.showBanner = true
    })
  }

  showCloseAnimation() {
    this.getUIContext().animateTo({
      duration: 200,
      delay: 1000,
      onFinish: () => {

      }
    }, () => {
      this.showClose = true
    })
  }

  build() {
    Column({ space: 20 }) {
      // 签到数据
      Column() {

      }
      .width('100%')
      .height('400')
      .backgroundColor(Color.White)
      .borderRadius(12)
      .clip(true)

      // 扩展卡片
      if (this.showBanner) {
        Column() {

        }
        .width('100%')
        .height(100)
        .backgroundColor(Color.White)
        .borderRadius(12)
        .clip(true)
      }

      // 关闭按钮
      if (this.showClose) {
        Column() {
          Image($r('app.media.toast_close'))
            .width(32)
            .height(32)
            .onClick(() => {
              SignInAlert.close()
            })
        }
      }

    }
    .width('80%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}