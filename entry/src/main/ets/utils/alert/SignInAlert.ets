/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : SignInAlert
 * @Author : KEVIN XU
 * @Time : 2026/6/17 18:40
 * @Description : 描述
 */
import { ComponentContent, curves, LengthMetrics, LevelMode } from "@kit.ArkUI"
import { HomeCheckInItem, HomeCheckInModel } from "./HomeCheckInModel"


/**
 * 签到数据
 */
export interface SignInData {
  model: HomeCheckInModel
  onBannerClick: () => void
  onToggleChange: (isOn: boolean) => void
  onClosed: () => void
}

/**
 * 签到数据
 */
export interface SignInAlertParam {
  data: SignInData
  nodeId?: string
}

/**
 * 签到弹窗
 */
export class SignInAlert {
  static contentNode?: ComponentContent<SignInAlertParam>
  static uiContext?: UIContext

  static async show(uiContext: UIContext, param: SignInAlertParam): Promise<void> {
    try {
      SignInAlert.uiContext = uiContext
      SignInAlert.contentNode = new ComponentContent<SignInAlertParam>(uiContext, wrapBuilder(buildSignInAlert), param)
      const frameNode: FrameNode | null = param.nodeId ? uiContext.getFrameNodeById(param.nodeId) : null
      const uniqueId: number | null = frameNode ? frameNode.getUniqueId() : null
      const levelMode: LevelMode = uniqueId ? LevelMode.EMBEDDED : LevelMode.OVERLAY
      await uiContext.getPromptAction().openCustomDialog(SignInAlert.contentNode, {
        autoCancel: false,
        showInSubWindow: false,
        isModal: true,
        maskColor: '#66000000',
        levelMode: levelMode,
        levelUniqueId: uniqueId,
        alignment: DialogAlignment.Center,
        maskTransition: TransitionEffect.opacity(0).animation({ duration: 200 }),
        dialogTransition: TransitionEffect.translate({ y: -100 })
          .combine(TransitionEffect.opacity(0))
          .combine(TransitionEffect.scale({ x: 1, y: 1 }))
          .animation({ duration: 500, delay: 0, curve: curves.springCurve(0, 1, 300, 28) }),
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
function buildSignInAlert(param: SignInAlertParam) {
  SignInComponent({
    data: param.data
  })
}

@ComponentV2
export struct SignInComponent {
  @Param @Require data: SignInData
  @Local showBanner: boolean = false
  @Local showClose: boolean = true
  @Local closeAngle: number = 0
  @Local closeOpacity: number = 0
  @Local tipText: string = ''
  @Local tipAngle: number = 0

  aboutToAppear(): void {
    this.tipText = this.data.model.preTips
    setTimeout(() => {
      this.showTipsAnimation()
    }, 1000)

  }

  /**
   * 提示语展示动画
   */
  showTipsAnimation() {
    this.getUIContext().animateTo({
      duration: 200,
      delay: 0,
      onFinish: () => {
        this.tipAngle = -90
        this.tipText = this.data.model.tips
        this.getUIContext().animateTo({
          duration: 200,
          delay: 0,
          onFinish: () => {
            // this.showBannerAnimation()
            this.showCloseAnimation()
          }
        }, () => {
          this.tipAngle = 0
        })
      }
    }, () => {
      this.tipAngle = 90
    })
  }

  /**
   * Banner展示动画
   */
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

  /**
   * 关闭按钮展示动画
   */
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
      Column({ space: 15 }) {
        if (this.data.model.isNew) {
          Image($r('app.media.check_in_success_new'))
            .width(105)
            .height(62)
            .objectFit(ImageFit.Auto)
        } else {
          Image($r('app.media.check_in_success_normal'))
            .width(40)
            .height(40)
            .objectFit(ImageFit.Fill)
        }
        Text(this.data.model.isNew ? '新人7天签到大翻倍' : '今日签到成功')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.Black)
          .textAlign(TextAlign.Center)

        Text(this.tipText)
          .fontSize(11)
          .fontWeight(FontWeight.Regular)
          .fontColor(Color.Red)
          .backgroundColor('#1AFF0000')
          .textAlign(TextAlign.Center)
          .borderRadius(100)
          .rotate({
            x: 1,
            y: 0,
            z: 0,
            angle: this.tipAngle,
            perspective: 1200
          })
          .padding({
            left: 20,
            right: 20,
            top: 4,
            bottom: 4
          })
        Flex({
          direction: FlexDirection.Row,
          wrap: FlexWrap.Wrap,
          justifyContent: FlexAlign.Center,
          alignContent: FlexAlign.Center,
          alignItems: ItemAlign.Center,
          space: {
            main: LengthMetrics.vp(5),
            cross: LengthMetrics.vp(5)
          }
        }) {
          ForEach(this.data.model.checkinPointList, (item: HomeCheckInItem, index: number) => {
            SignInCard({
              data: item,
              isNewUser: this.data.model.isNew,
              shouldAnimation: ((item.state === 1) && (item.rank === this.data.model.pointDay)),
              onAnimationFinish: () => {
                this.showBannerAnimation()
              }
            })
          })
        }
        .width('100%')

        Column({ space: 8 }) {
          Divider().vertical(false).color('#F4F5F7').strokeWidth(1)
          Row() {
            Text('06-12 至 6-19')
              .fontSize(12)
              .fontColor(Color.Black)
              .textAlign(TextAlign.Start)
            Row({ space: 5 }) {
              Text('签到提醒')
                .fontSize(12)
                .fontColor(Color.Black)
                .textAlign(TextAlign.Start)
              Toggle({
                isOn: true,
                type: ToggleType.Switch
              }).width(32).height(16).selectedColor('#52C41A')
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%')
      }
      .width('100%')
      .backgroundColor(Color.White)
      .borderRadius(12)
      .padding({
        left: 15,
        right: 15,
        top: 20,
        bottom: 8
      })
      .clip(true)

      // 扩展卡片
      if (this.showBanner) {
        Column() {
          Image(this.data.model.rewardBannerImageUrl)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Fill)
            .clip(true)
        }
        .width('100%')
        .aspectRatio(15 / 4)
        .backgroundColor(Color.White)
        .borderRadius(12)
        .clip(true)
        .transition(TransitionEffect.translate({ y: -100 })
          .combine(TransitionEffect.opacity(0))
          .animation({ duration: 200, delay: 0 }))
        .onClick(() => {
          this.data.onBannerClick()
        })
      }

      // 关闭按钮
      if (this.showClose) {
        Column() {
          Image($r('app.media.check_in_close'))
            .width(28)
            .height(28)
            .opacity(0.6)
            .onClick(() => {
              SignInAlert.close()
            })
        }
        .transition(
          TransitionEffect.OPACITY
            .combine(TransitionEffect.rotate({ angle: 90 }))
            .combine(TransitionEffect.opacity(0))
            .animation({ duration: 500, delay: 2000 })
        )
      }

    }
    .width('80%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}

@ComponentV2
export struct SignInCard {
  @Event onAnimationFinish: () => void = () => {
  }
  @Param @Require data: HomeCheckInItem
  @Param @Require isNewUser: boolean
  @Param @Require shouldAnimation: boolean
  @Local textColor: ResourceColor = '#FF9C54'
  @Local bgImage: Resource = $r('app.media.check_in_card_bg_2')
  @Local icon: Resource = $r('app.media.check_in_card_coin')
  @Local point: string = ''
  @Local mark?: Resource = undefined
  @Local iconAngle: number = 0
  @Local bgOpacity: number = 0
  @Local cardScale: number = 1

  aboutToAppear(): void {
    if (this.data.state === 0) {
      this.textColor = '#FF9C54'
      this.bgImage = $r('app.media.check_in_card_bg_2')
      this.icon = $r('app.media.check_in_card_coin')
      this.point = this.isNewUser ? `${this.data.point}x?` : `${this.data.quantity}`
      this.mark = undefined
      this.bgOpacity = 0
    } else if (this.data.state === 1) {
      if (this.shouldAnimation) {
        this.textColor = '#A6ADC1'
        this.bgImage = $r('app.media.check_in_card_bg_3')
        this.icon = $r('app.media.check_in_card_coin')
        this.point = this.isNewUser ? `${this.data.point}x?` : `${this.data.quantity}`
        this.mark = undefined
        this.bgOpacity = 0
      } else {
        this.textColor = '#FFFFFF'
        this.bgImage = $r('app.media.check_in_card_bg_3')
        this.icon = $r('app.media.check_in_card_success')
        this.point = `${this.data.quantity}`
        this.mark = $r('app.media.check_in_mark_reward')
        this.bgOpacity = 1
      }
    } else if (this.data.state === 2) {
      this.textColor = '#A6ADC1'
      this.bgImage = $r('app.media.check_in_card_bg_1')
      this.icon = $r('app.media.check_in_card_failed')
      this.point = this.isNewUser ? `${this.data.point}x?` : `${this.data.quantity}`
      this.mark = $r('app.media.check_in_mark_loss')
      this.bgOpacity = 1
    }
  }

  startAnimation() {
    if (this.data.state === 1 && this.shouldAnimation) {
      if (this.isNewUser) {
        this.runAnimation()
      } else {
        this.bgAnimation()
        this.iconAnimation()
      }
    }
  }

  runAnimation() {
    this.getUIContext().animateTo({
      duration: 2000,
      delay: 500,
      onFinish: () => {
        this.bgAnimation()
        this.iconAnimation()
      }
    }, () => {

    })
  }

  iconAnimation() {
    this.getUIContext().animateTo({
      duration: 200,
      delay: 1000,
      onFinish: () => {
        this.iconAngle = -90
        this.icon = $r('app.media.check_in_card_success')
        this.getUIContext().animateTo({
          duration: 200,
          delay: 0
        }, () => {
          this.iconAngle = 0
        })
      }
    }, () => {
      this.iconAngle = 90
    })
  }

  bgAnimation() {
    this.getUIContext().animateTo({
      duration: 400,
      delay: 1000,
      onFinish: () => {
        this.mark = $r('app.media.check_in_mark_reward')
        this.cardScaleAnimation()
      }
    }, () => {
      this.textColor = '#FFFFFF'
      this.point = `${this.data.quantity}`
      this.bgOpacity = 1
    })
  }

  cardScaleAnimation() {
    this.getUIContext().animateTo({
      duration: 100,
      delay: 0,
      onFinish: () => {
        this.getUIContext().animateTo({
          duration: 100,
          delay: 0,
          onFinish: () => {
            this.onAnimationFinish()
          }
        }, () => {
          this.cardScale = 1
        })
      }
    }, () => {
      this.cardScale = 0.94
    })
  }

  build() {
    Stack() {
      Stack() {
        Image($r('app.media.check_in_card_bg_2'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Fill)
          .opacity(1 - this.bgOpacity)
        Image(this.bgImage)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Fill)
          .opacity(this.bgOpacity)
      }

      Column() {
        Text() {
          Span('第')
          Span(`${this.data.rank}`)
            .fontWeight(FontWeight.Bold)
          Span('天')
        }
        .width('100%')
        .fontSize(12)
        .fontColor(this.textColor)
        .textAlign(TextAlign.Center)

        Image(this.icon)
          .width(18)
          .height(18)
          .objectFit(ImageFit.Fill)
          .rotate({
            x: 0,
            y: 1,
            z: 0,
            angle: this.iconAngle
          })
          .onAppear(() => {
            this.startAnimation()
          })
        Text(this.point)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.textColor)
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({
        top: 10,
        bottom: 10,
        left: 0,
        right: 0
      })

      if (this.mark) {
        Image(this.mark)
          .width(40)
          .height(40)
          .objectFit(ImageFit.Fill)
          .position({
            bottom: -14,
            right: -10
          })
          .transition(TransitionEffect.OPACITY.combine(TransitionEffect.scale({ x: 1.2, y: 1.2 }))
            .animation({ duration: 500, delay: 0, curve: curves.springCurve(0, 1, 400, 18) }))
      }
    }
    .clip(true)
    .width('calc((100% - 15vp) / 4)')
    .aspectRatio(6 / 7)
    .borderRadius(4)
    .scale({
      x: this.cardScale,
      y: this.cardScale
    })
    .onAppear(() => {

    })
  }
}