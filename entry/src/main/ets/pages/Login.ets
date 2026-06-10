/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : Login
 * @Author : KEVIN XU
 * @Time : 2026/6/10 18:35
 * @Description : 描述
 */
import { TokenModel } from "../model/TokenModel"
import { kUserStatus } from "../status/UserStatus"
import { RouterUtil } from "../utils/router/RouterUtil"
import { ToastUtil } from "../utils/toast/ToastUtil"

@Builder
export function PageLoginBuilder(name: string, param?: Object) {
  Login()
}

@ComponentV2
export struct Login {
  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Column({ space: 30 }) {
          Text(kUserStatus.isLoggedIn() ? '已登录' : '未登录')
            .width(200)
            .height(36)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .backgroundColor(kUserStatus.isLoggedIn() ? Color.Green : Color.Red)

          Button('立即登录')
            .width(200)
            .height(36)
            .onClick(async () => {
              await ToastUtil.showLoading('正在登录中...', 2000, () => {
                let token = new TokenModel
                token.token = 'ddfsdf'
                token.refreshToken = 'dsf4fefs'
                token.expired = Date.now() + 1000000
                kUserStatus.updateToken(token)
                RouterUtil.pop()
              })
            })

          if (kUserStatus.isLoggedIn()) {
            Button('退出登录')
              .width(200)
              .height(36)
              .onClick(async () => {
                await ToastUtil.showLoading('正在退出登录...', 2000, () => {
                  kUserStatus.logout()
                  RouterUtil.pop()
                })
              })
          } else {
            Button('取消登录')
              .width(200)
              .height(36)
              .onClick(() => {
                RouterUtil.pop()
              })
          }

        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(Color.White)
      }
      .width('100%')
      .height('100%')
    }
  }
}