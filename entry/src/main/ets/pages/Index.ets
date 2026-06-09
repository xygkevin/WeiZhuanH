import { LogUtil } from '../utils/log/LogUtil'
import { StackBannerComponent } from '../components/StackBannerComponent'
import { RouterUtil } from '../utils/router/RouterUtil'
import { RcpUtil } from '../utils/network/RcpUtil'
import { RcpError } from '../utils/network/RcpError'

@Entry
@ComponentV2
struct Index {
  build() {
    Stack() {
      Navigation(RouterUtil.navPathStack) {
        Column({ space: 30 }) {
          Button('打印DEBUG')
            .width(200)
            .height(36)
            .onClick(() => {
              LogUtil.debug('Index', '哈哈哈哈')
            })
          Button('打印INFO')
            .width(200)
            .height(36)
            .onClick(() => {
              LogUtil.info('Index', '哈哈哈哈')
            })
          Button('打印ERROR')
            .width(200)
            .height(36)
            .onClick(() => {
              LogUtil.error('Index', '哈哈哈哈')
            })
          Button('打印WARN')
            .width(200)
            .height(36)
            .onClick(() => {
              LogUtil.warn('Index',
                '哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈')
            })
          Button('打印FATAL')
            .width(200)
            .height(36)
            .onClick(() => {
              LogUtil.fatal('Index', '哈哈哈哈')
            })
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
      }
    }
  }
}

