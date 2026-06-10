import { TokenModel } from '../model/TokenModel'
import { StatusUtil } from '../status/StatusUtil'
import { kUserStatus } from '../status/UserStatus'
import { RouterUtil } from '../utils/router/RouterUtil'


@Entry
@ComponentV2
struct Index {
  build() {
    Stack() {
      Navigation(RouterUtil.navPathStack) {
        Column({ space: 30 }) {
          Text(StatusUtil.isLoggedIn ? '已登录' : '未登录')
            .width(200)
            .height(36)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .backgroundColor(StatusUtil.isLoggedIn ? Color.Green : Color.Red)
          Button('PUSH 详情页')
            .width(200)
            .height(36)
            .onClick(() => {
              RouterUtil.push({
                name: 'Profile',
                skipLogin: false
              })
            })
          Button('PUSH 登录页')
            .width(200)
            .height(36)
            .onClick(() => {
              RouterUtil.push({
                name: 'Login',
                skipLogin: true
              })
            })

          Button('立即登录')
            .width(200)
            .height(36)
            .onClick(() => {
              let token = new TokenModel
              token.token = 'ddfsdf'
              token.refreshToken = 'dsf4fefs'
              token.expired = Date.now() + 1000000
              kUserStatus.updateToken(token)
            })

          Button('退出登录')
            .width(200)
            .height(36)
            .onClick(() => {
              kUserStatus.logout()
            })
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
      }
    }
  }
}

