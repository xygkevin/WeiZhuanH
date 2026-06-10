/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : Profile
 * @Author : KEVIN XU
 * @Time : 2026/6/10 17:41
 * @Description : 描述
 */

@Builder
export function PageProfileBuilder(name: string, param?: Object) {
  Profile()
}

@ComponentV2
export struct Profile {
  build() {
    NavDestination(){
      Column() {
        Text('我是详情页')
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