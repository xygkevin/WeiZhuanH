import { AlertUtil } from '../utils/alert/AlertUtil'
import { HomeCheckInItem, HomeCheckInModel } from '../utils/alert/HomeCheckInModel'
import { SheetUtil } from '../utils/alert/SheetUtil'
import { SignInAlert, SignInData } from '../utils/alert/SignInAlert'
import { RouterUtil } from '../utils/router/RouterUtil'


@Entry
@ComponentV2
struct Index {
  @Local offsetY: number = 0

  build() {
    Stack() {
      Navigation(RouterUtil.navPathStack) {
        Column({ space: 30 }) {
          Button('CheckIn 1')
            .width(200)
            .height(36)
            .onClick(() => {

              let item0 = new HomeCheckInItem()
              item0.rank = 1
              item0.state = 1
              item0.point = 1
              item0.amount = 10
              item0.quantity = 1
              item0.multiple = 10

              let item1 = new HomeCheckInItem()
              item1.rank = 2
              item1.state = 2
              item1.point = 1
              item1.amount = 10
              item1.quantity = 2
              item1.multiple = 10

              let item2 = new HomeCheckInItem()
              item2.rank = 3
              item2.state = 1
              item2.point = 1
              item2.amount = 10
              item2.quantity = 3
              item2.multiple = 10

              let item3 = new HomeCheckInItem()
              item3.rank = 4
              item3.state = 1
              item3.point = 1
              item3.amount = 10
              item3.quantity = 4
              item3.multiple = 10

              let item4 = new HomeCheckInItem()
              item4.rank = 5
              item4.state = 0
              item4.point = 1
              item4.amount = 10
              item4.quantity = 5
              item4.multiple = 10

              let item5 = new HomeCheckInItem()
              item5.rank = 6
              item5.state = 0
              item5.point = 1
              item5.amount = 10
              item5.quantity = 6
              item5.multiple = 10

              let item6 = new HomeCheckInItem()
              item6.rank = 7
              item6.state = 0
              item6.point = 1
              item6.amount = 10
              item6.quantity = 7
              item6.multiple = 10

              let model = new HomeCheckInModel()
              model.preTips = '再签到4天, 权益值+1哦'
              model.tips = '再签到3天, 权益值+1哦'
              model.id = 4354
              model.isNew = true
              model.pollId = 'fs4t'
              model.day = 1
              model.result = false
              model.point = 10
              model.amount = 12
              model.pointDay = 4
              model.credit = 1
              model.startDate = '06-01'
              model.endDate = '06-30'
              model.taskPoint = 100
              model.checkinNotification = true
              model.rewardBannerImageUrl =
                'https://pic.nximg.cn/file/20230816/13675713_095319364109_2.jpg'
              model.checkinPointList = [
                item0, item1, item2, item3, item4, item5, item6
              ]
              const data: SignInData = {
                model: model,
                onBannerClick: () => {
                },
                onToggleChange: () => {
                },
                onClosed: () => {
                }
              }
              SignInAlert.show(this.getUIContext(), { data: data })
            })
          Button('Alert 1')
            .width(200)
            .height(36)
            .onClick(() => {
              AlertUtil.show(this.getUIContext(), {
                title: '温馨提示',
                message: '哈哈啊哈哈啊哈哈哈哈啊哈哈哈',
                buttons: [
                  {
                    title: '取消',
                    backgroundColor: '#C7C7C7',
                    action: () => {

                    }
                  }
                ]
              })
            })
          Button('Alert 2')
            .width(200)
            .height(36)
            .onClick(() => {
              AlertUtil.show(this.getUIContext(), {
                title: '温馨提示',
                message: '哈哈啊哈哈啊哈哈哈哈啊哈哈哈',
                buttons: [
                  {
                    title: '取消',
                    backgroundColor: '#C7C7C7',
                    action: () => {

                    }
                  },
                  {
                    title: '确定',
                    backgroundColor: '#007AFF',
                    action: () => {

                    }
                  }
                ]
              })
            })

          Button('Alert 3')
            .width(200)
            .height(36)
            .onClick(() => {
              AlertUtil.show(this.getUIContext(), {
                title: '确定退出登录?',
                message: '退出登陆之后您将不在享受任何会员权益!确定退出登录?',
                buttons: [
                  {
                    title: '取消',
                    backgroundColor: '#C7C7C7',
                    borderRadius: 4,
                    action: () => {

                    }
                  },
                  {
                    title: '确定',
                    backgroundColor: '#FE4E53',
                    borderRadius: 4,
                    action: () => {

                    }
                  }
                ]
              })
            })
          Button('Alert 4')
            .width(200)
            .height(36)
            .onClick(() => {
              AlertUtil.show(this.getUIContext(), {
                title: '确定退出登录?',
                message: '退出登陆之后您将不在享受任何会员权益!确定退出登录?',
                buttons: [
                  {
                    title: '取消',
                    action: () => {

                    }
                  },
                  {
                    title: '确定',
                    action: () => {

                    }
                  },
                  {
                    title: '更换账号',
                    action: () => {

                    }
                  }
                ]
              })
            })

          Button('Sheet 1')
            .width(200)
            .height(36)
            .onClick(() => {
              SheetUtil.show(this.getUIContext(), {
                // title: '请选择照片',
                // message: '哈哈啊哈哈啊哈哈哈哈啊哈哈哈',
                autoCancel: true,
                actions: ['拍照', '从相册选择', '刷新页面', '截图反馈'],
                onSelect: (item: string, index: number) => {
                  console.info(`选择了:${item}`)
                },
                onCancel: () => {
                  console.info('取消了选择')
                }
              })
            })

          Button('数字滚动动画')
            .width(200)
            .height(36)
            .onClick(() => {
              this.getUIContext().animateTo({
                duration: 1000,
                delay: 0,
                curve: Curve.LinearOutSlowIn,
                onFinish: () => {

                }
              }, () => {
                this.offsetY = -20 * Math.ceil(Math.random() * 20)
              })
            })

          Column() {
            Column() {
              ForEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], (item: number) => {
                Text(`${item}`)
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(Color.Black)
                  .height(20)
              })
            }
            .translate({
              x: 0,
              y: this.offsetY
            })
          }
          .height(20)
          .clip(true)

        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
      }
    }
  }
}

