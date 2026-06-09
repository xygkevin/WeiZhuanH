import { LogUtil } from '../utils/log/LogUtil'
import { StackBannerComponent } from '../components/StackBannerComponent'
import { RouterUtil } from '../utils/router/RouterUtil'

@Entry
@ComponentV2
struct Index {
  aboutToAppear(): void {
    setInterval(() => {
      LogUtil.d('Index', '哈哈哈哈哈')
      LogUtil.i('Index', '哈哈哈哈哈')
      LogUtil.w('Index', '哈哈哈哈哈')
      LogUtil.e('Index', '哈哈哈哈哈')
      LogUtil.f('Index', '哈哈哈哈哈')
    }, 1000)
  }

  build() {
    Stack() {
      Navigation(RouterUtil.navPathStack) {
        Column() {
          StackBannerComponent({})
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
      }
    }
  }
}

