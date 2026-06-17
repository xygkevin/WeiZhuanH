import { AlertUtil } from '../utils/alert/AlertUtil'
import { SheetUtil } from '../utils/alert/SheetUtil'
import { SignInAlert, SignInModel } from '../utils/alert/SignInAlert'
import { RouterUtil } from '../utils/router/RouterUtil'


@Entry
@ComponentV2
struct Index {
  build() {
    Stack() {
      Navigation(RouterUtil.navPathStack) {
        Column({ space: 30 }) {
          Button('CheckIn 1')
            .width(200)
            .height(36)
            .onClick(() => {
              SignInAlert.show(this.getUIContext(), { data: new SignInModel() })
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
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
      }
    }
  }
}

