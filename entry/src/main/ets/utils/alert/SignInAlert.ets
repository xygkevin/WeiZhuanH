/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : SignInAlert
 * @Author : KEVIN XU
 * @Time : 2026/6/17 18:40
 * @Description : 描述
 */
import {
  AnimatedDrawableDescriptor,
  AnimationOptions,
  AnimationStopMode,
  ComponentContent,
  curves,
  LengthMetrics,
  LevelMode
} from "@kit.ArkUI"
import { PixelUtil } from "../pixel/PixelUtil"
import { HomeCheckInItem, HomeCheckInModel, HomeCheckInTalkTask, HomeCheckInTask } from "./HomeCheckInModel"
import { image } from "@kit.ImageKit"


/**
 * 签到弹窗参数
 */
export interface SignInData {
  /**
   * 数据
   */
  model: HomeCheckInModel
  /**
   * Banner任务点击事件
   */
  onBannerTaskClick: (task: HomeCheckInTask) => void
  /**
   * Banner趣谈点击事件
   */
  onBannerTopicClick: (task: HomeCheckInTalkTask) => void
  /**
   * Banner广告点击事件
   */
  onBannerRewardAdClick: (url: string) => void
  /**
   * 通知开关
   */
  onToggleChange: (isOn: boolean) => void
  /**
   * 弹窗关闭
   */
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
  @Local showClose: boolean = false
  @Local closeAngle: number = 0
  @Local closeOpacity: number = 0
  @Local tipText: string = ''
  @Local tipAngle: number = 0
  @Local showCredit: boolean = false
  @Local creditOffsetY: number = 100
  @Local creditOpacity: number = 0
  @Local ringAngle: number = 0
  private ringTimer?: number
  @Local animatedImages: Array<ImageFrameInfo> = []
  @Local animatedState: AnimationStatus = AnimationStatus.Initial

  async aboutToAppear(): Promise<void> {
    this.showCredit = (this.data.model.credit !== undefined && this.data.model.credit > 0)
    this.tipText = this.data.model.preTips
    if (!this.data.model.isNew) {
      this.animatedImages = []
      for (let index = 0; index < 40; index++) {
        let resource = $r(`app.media.sign_in_success_${index}`)
        if (resource) {
          this.animatedImages.push({ src: resource })
        }
      }
    }
  }

  aboutToDisappear(): void {
    this.clearRingTimer
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
            this.showBannerAnimation()
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
    if (this.data.model.talkTask || (this.data.model.showRewardAd && this.data.model.rewardBannerImageUrl) ||
      this.data.model.task) {
      this.getUIContext().animateTo({
        duration: 200,
        delay: 0,
        onFinish: () => {
          this.showCloseAnimation()
        }
      }, () => {
        this.showBanner = true
      })
    } else {
      this.showCloseAnimation()
    }
  }

  /**
   * 关闭按钮展示动画
   */
  showCloseAnimation() {
    this.getUIContext().animateTo({
      duration: 500,
      delay: 1000,
      onFinish: () => {

      }
    }, () => {
      this.showClose = true
    })
  }

  showCreditAnimation() {
    if (!this.showCredit) {
      return
    }

    this.getUIContext().animateTo({
      duration: 500,
      delay: 0,
      curve: curves.springCurve(0, 1, 300, 28),
      onFinish: () => {
        this.getUIContext().animateTo({
          duration: 500,
          delay: 1000,
          onFinish: () => {
            this.showCredit = false
          }
        }, () => {
          this.creditOffsetY = -100
          this.creditOpacity = 0
        })
      }
    }, () => {
      this.creditOffsetY = 0
      this.creditOpacity = 1
    })
  }

  /**
   * 摇铃动画
   */
  showRingAnimation() {
    this.clearRingTimer()
    this.ringTimer = setInterval(() => {
      [-15, 15, -8, 8, -2, 2, 0].forEach((value: number, index: number) => {
        this.getUIContext().animateTo({
          duration: 40,
          curve: index === 0 ? Curve.EaseOut : Curve.EaseInOut,
          delay: index * 40,
          iterations: 1
        }, () => {
          this.ringAngle = value
        })
      })
    }, 1000)
  }

  clearRingTimer() {
    clearInterval(this.ringTimer)
  }

  build() {
    Stack() {
      Column({ space: 20 }) {
        // 签到数据
        Column({ space: 15 }) {
          if (this.data.model.isNew) {
            Image($r('app.media.check_in_success_new'))
              .width(105)
              .height(62)
              .objectFit(ImageFit.Auto)
          } else {
            if (this.animatedImages.length > 0) {
              ImageAnimator()
                .images(this.animatedImages)
                .state(this.animatedState)
                .duration(1000)
                .reverse(false)
                .fillMode(FillMode.Forwards)
                .iterations(1)
                .width(32)
                .height(32)
                .monitorInvisibleArea(true)
                .onAppear(() => {
                  this.animatedState = AnimationStatus.Running
                })
                .onFinish(() => {
                  this.animatedState = AnimationStatus.Stopped
                })
            } else {
              Image($r('app.media.check_in_success_normal'))
                .width(32)
                .height(32)
                .objectFit(ImageFit.Fill)
            }
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
              main: LengthMetrics.vp(8),
              cross: LengthMetrics.vp(8)
            }
          }) {
            ForEach(this.data.model.checkinPointList, (item: HomeCheckInItem, index: number) => {
              SignInCard({
                data: item,
                isNewUser: this.data.model.isNew,
                shouldAnimation: ((item.state === 1) && (item.rank === this.data.model.pointDay)),
                onAnimationFinish: () => {
                  this.showTipsAnimation()
                  this.showCreditAnimation()
                }
              })
            })
          }
          .width('100%')

          Column({ space: 8 }) {
            Divider().vertical(false).color('#F4F5F7').strokeWidth(1)
            Row() {
              Text(this.data.model.isNew ? `${this.data.model.startDate}-${this.data.model.endDate}` : '')
                .fontSize(12)
                .fontColor(Color.Black)
                .textAlign(TextAlign.Start)
              Row({ space: 5 }) {
                Text('签到提醒')
                  .fontSize(12)
                  .fontColor(Color.Black)
                  .textAlign(TextAlign.Start)
                Toggle({
                  isOn: this.data.model.checkinNotification,
                  type: ToggleType.Switch,
                }).width(32)
                  .height(16)
                  .selectedColor('#52C41A')
                  .onChange((isOn: boolean) => {
                    this.data.onToggleChange(isOn)
                  })
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
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
            // 优先级: 趣谈任务 > 广告 > 任务推荐
            if (this.data.model.talkTask) {
              Image(this.data.model.talkTask.talkTaskBanner)
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Fill)
                .clip(true)
                .onClick(() => {
                  SignInAlert.close()
                  this.data.onBannerTopicClick(this.data.model.talkTask!)
                })
            } else if (this.data.model.rewardBannerImageUrl) {
              Image(this.data.model.rewardBannerImageUrl)
                .width('100%')
                .height('100%')
                .objectFit(ImageFit.Fill)
                .clip(true)
                .onClick(() => {
                  SignInAlert.close()
                  this.data.onBannerRewardAdClick(this.data.model.rewardBannerImageUrl)
                })
            } else if (this.data.model.task) {
              Row({ space: 5 }) {
                Column({ space: 5 }) {
                  Text(this.data.model.task.title ?? `今日还能再赚${this.data.model.task.point}金币!`)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#FE4E53')
                  Text(this.data.model.task.tips ?? '配额甄别又如何，水滴不亦化成河？')
                    .fontSize(12)
                    .fontColor('#A6ADC1')
                }
                .height('100%')
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Center)

                Image($r('app.media.check_in_banner_go'))
                  .height('60%')
                  .aspectRatio(1)
                  .objectFit(ImageFit.Contain)
                  .rotate({
                    x: 0,
                    y: 0,
                    z: 1,
                    angle: this.ringAngle
                  })
                  .onAppear(() => {
                    this.showRingAnimation()
                  })
                  .onClick(() => {
                    SignInAlert.close()
                    this.data.onBannerTaskClick(this.data.model.task!)
                  })

              }
              .padding({
                left: 15,
                right: 15
              })
            }
          }
          .width('100%')
          .aspectRatio(15 / 4)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .clip(true)
          .transition(TransitionEffect.opacity(0)
            .animation({ duration: 200, delay: 0 }))
        }

        // 关闭按钮
        if (this.showClose) {
          Column() {
            Image($r('app.media.check_in_close'))
              .width(28)
              .height(28)
              .onClick(() => {
                SignInAlert.close()
                this.data.onClosed()
              })
          }
          .margin({
            top: 10
          })
          .transition(
            TransitionEffect.OPACITY
              .combine(TransitionEffect.rotate({ angle: 180 }))
              .combine(TransitionEffect.opacity(0))
              .animation({ duration: 500, delay: 1000 })
          )
        }

      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      if (this.showCredit) {
        Text(`权益值+${this.data.model.credit}`)
          .fontSize(12)
          .fontWeight(FontWeight.Regular)
          .fontColor(Color.White)
          .height(24)
          .padding({
            left: 15,
            right: 15
          })
          .translate({
            y: this.creditOffsetY
          })
          .opacity(this.creditOpacity)
          .borderRadius(12)
          .backgroundColor(Color.Black)
      }
    }
    .width('80%')
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
  @Local scrollOffsetY: number = 0
  private numberHeight: number = PixelUtil.px2vp(
    Number(this.getUIContext().getMeasureUtils().measureTextSize({ fontSize: 12, textContent: '123' }).height))
  @Local scrollFinish: boolean = false

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
        this.point = this.isNewUser ? `${this.data.point}x` : `${this.data.quantity}`
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

  /**
   * 开启动画
   */
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

  /**
   * 数字滚动动画
   */
  runAnimation() {
    this.getUIContext().animateTo({
      duration: 2000,
      delay: 500,
      onFinish: () => {
        this.scrollFinish = true
        this.bgAnimation()
        this.iconAnimation()
      }
    }, () => {
      this.scrollOffsetY = -this.numberHeight * ((this.data.multiple ?? 1) - 1 + 9)
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
        this.point = `${this.data.quantity}`
        this.mark = $r('app.media.check_in_mark_reward')
        this.cardScaleAnimation()
      }
    }, () => {
      this.textColor = '#FFFFFF'
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
        Row() {
          Text(this.point)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.textColor)
          if (this.isNewUser && this.shouldAnimation && !this.scrollFinish) {
            Column() {
              Column() {
                ForEach(['?', '2', '3', '4', '5', '6', '7', '8', '9', '10', '2', '3', '4', '6', '7', '8', '9', '10'],
                  (item: string) => {
                    Text(item)
                      .fontSize(12)
                      .fontColor(this.textColor)
                      .fontWeight(FontWeight.Bold)
                      .textAlign(TextAlign.Start)
                      .height(this.numberHeight)
                  })
              }
              .alignItems(HorizontalAlign.Start)
              .translate({
                x: 0,
                y: this.scrollOffsetY
              })
            }
            .height(this.numberHeight)
            .clip(true)
          }
        }
        .offset({
          x: (!this.shouldAnimation || this.scrollFinish || !this.isNewUser) ? 0 : this.numberHeight / 3
        })
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
    .width('calc((100% - 24vp) / 4)')
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