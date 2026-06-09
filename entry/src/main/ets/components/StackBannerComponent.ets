/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : StackBannerComponent
 * @Author : KEVIN XU
 * @Time : 2026/6/8 12:58
 * @Description : 描述
 */

import { ScreenUtil } from "../utils/screen/ScreenUtil"


export class StackBannerData {
  icon: string = ''
  title: string = ''
  time: string = ''

  constructor(icon: string, title: string, time: string) {
    this.icon = icon
    this.title = title
    this.time = time
  }
}

interface StackBannerOptions {
  index: number
  data: StackBannerData
}

@ComponentV2
export struct StackBannerComponent {
  @Param duration: number = 3000
  @Param list: StackBannerData[] = [
    new StackBannerData('https://q8.itc.cn/q_70/images03/20250926/f0ab625a996a47459bdfd9af84baff71.jpeg',
      '兑换了0堆奖品', '2026-12-02 12:32:00'),
    new StackBannerData('https://q8.itc.cn/q_70/images03/20250926/f0ab625a996a47459bdfd9af84baff71.jpeg',
      '兑换了1堆奖品', '2026-12-02 12:32:00'),
    new StackBannerData('https://q8.itc.cn/q_70/images03/20250926/f0ab625a996a47459bdfd9af84baff71.jpeg',
      '兑换了2堆奖品', '2026-12-02 12:32:00'),
    new StackBannerData('https://q8.itc.cn/q_70/images03/20250926/f0ab625a996a47459bdfd9af84baff71.jpeg',
      '兑换了3堆奖品', '2026-12-02 12:32:00'),
    new StackBannerData('https://q8.itc.cn/q_70/images03/20250926/f0ab625a996a47459bdfd9af84baff71.jpeg',
      '兑换了4堆奖品', '2026-12-02 12:32:00'),
    new StackBannerData('https://q8.itc.cn/q_70/images03/20250926/f0ab625a996a47459bdfd9af84baff71.jpeg',
      '兑换了5堆奖品', '2026-12-02 12:32:00'),
    new StackBannerData('https://q8.itc.cn/q_70/images03/20250926/f0ab625a996a47459bdfd9af84baff71.jpeg',
      '兑换了6堆奖品', '2026-12-02 12:32:00'),
  ]
  @Local index: number = 0
  @Local opacityList: number[] = [1, 0.1, 0.1, 0]
  @Local translateXList: number[] = [0, 0, 0, 0]
  @Local translateYList: number[] = [0, 20, 40, 60]
  @Local scaleList: number[] = [1, 0.9, 0.8, 0.7]
  @Local zIndexList: number[] = [30, 20, 10, 0]
  @Local dataList: StackBannerData[] = []

  aboutToAppear(): void {
    this.updateDisplayList()
    this.startTimer()
  }

  private screenW: number = ScreenUtil.width()
  private timeId?: number
  private currentIndex: number = 0

  /**
   * 重置数据
   */
  private updateDisplayList() {
    const count = this.list.length
    if (count === 0) {
      return
    }
    if (count <= 4) {
      this.dataList = Array.from<number, StackBannerData>(
        { length: 4 }, (_, i) => this.list[i]
      )
      return
    }

    if (this.dataList.length === 0) {
      this.dataList = this.list.slice(0, 4)
      this.currentIndex = 3
      return
    }

    this.currentIndex = (this.currentIndex + 1) % count
    const newList = [...this.dataList]
    newList[this.index] = this.list[this.currentIndex]
    this.dataList = newList
  }

  /**
   * 开启定时器
   */
  startTimer() {
    this.removeTimer()
    this.timeId = setInterval(() => {
      this.getUIContext().animateTo({
        duration: 500,
        onFinish: () => {
          this.resetEvent()
          this.updateDisplayList()
          if (this.index >= 3) {
            this.index = 0
          } else {
            this.index++
          }
        }
      }, () => {
        this.timerEvent()
      })
    }, this.duration)
  }

  /**
   * 移除定时器
   */
  removeTimer() {
    if (this.timeId) {
      clearInterval(this.timeId)
      this.timeId = undefined
    }
  }

  /**
   * 定时任务
   */
  timerEvent() {
    switch (this.index) {
      case 0: {
        this.opacityList = [1, 1, 0.1, 0.1]
        this.zIndexList = [30, 30, 20, 10]
        this.scaleList = [1, 1, 0.9, 0.8]
        this.translateXList = [-this.screenW, 0, 0, 0]
        this.translateYList = [0, 0, 20, 40]
        break
      }
      case 1: {
        this.opacityList = [0.1, 1, 1, 0.1]
        this.zIndexList = [10, 30, 30, 20]
        this.scaleList = [0.8, 1, 1, 0.9]
        this.translateXList = [0, -this.screenW, 0, 0]
        this.translateYList = [40, 0, 0, 20]
        break
      }
      case 2: {
        this.opacityList = [0.1, 0.1, 1, 1]
        this.zIndexList = [20, 10, 30, 30]
        this.scaleList = [0.9, 0.8, 1, 1]
        this.translateXList = [0, 0, -this.screenW, 0]
        this.translateYList = [20, 40, 0, 0]
        break
      }
      case 3: {
        this.opacityList = [1, 0.1, 0.1, 1]
        this.zIndexList = [30, 20, 10, 30]
        this.scaleList = [1, 0.9, 0.8, 1]
        this.translateXList = [0, 0, 0, -this.screenW]
        this.translateYList = [0, 20, 40, 0]
        break
      }
      default: {
        console.info('超限')
      }
    }
  }

  /**
   * 重置任务
   */
  resetEvent() {
    switch (this.index) {
      case 0: {
        this.opacityList = [0, 1, 0.1, 0.1]
        this.zIndexList = [0, 30, 20, 10]
        this.scaleList = [0.7, 1, 0.9, 0.8]
        this.translateXList = [0, 0, 0, 0]
        this.translateYList = [60, 0, 20, 40]
        break
      }
      case 1: {
        this.opacityList = [0.1, 0, 1, 0.1]
        this.zIndexList = [10, 0, 30, 20]
        this.scaleList = [0.8, 0.7, 1, 0.9]
        this.translateXList = [0, 0, 0, 0]
        this.translateYList = [40, 60, 0, 20]
        break
      }
      case 2: {
        this.opacityList = [0.1, 0.1, 0, 1]
        this.zIndexList = [20, 10, 0, 30]
        this.scaleList = [0.9, 0.8, 0.7, 1]
        this.translateXList = [0, 0, 0, 0]
        this.translateYList = [20, 40, 60, 0]
        break
      }
      case 3: {
        this.opacityList = [1, 0.1, 0.1, 0]
        this.zIndexList = [30, 20, 10, 0]
        this.scaleList = [1, 0.9, 0.8, 0.7]
        this.translateXList = [0, 0, 0, 0]
        this.translateYList = [0, 20, 40, 60]
        break
      }
      default: {
        console.info('超限')
      }
    }
  }

  /**
   * UI
   */
  build() {
    Stack() {
      ForEach(this.dataList, (item: StackBannerData, index: number) => {
        this.buildCard({ index: index, data: item })
        this.buildCard({ index: index, data: item })
        this.buildCard({ index: index, data: item })
        this.buildCard({ index: index, data: item })
      })
    }
    .width('100%')
    .height(200)
    .backgroundColor('#F4F5F7')
    .alignContent(Alignment.Top)
    .padding(15)
  }

  @Builder
  buildCard(options: StackBannerOptions) {
    Row({ space: 15 }) {
      if (this.opacityList[options.index] === 1) {
        Image(options.data.icon)
          .width(40)
          .height(40)
          .objectFit(ImageFit.Contain)
        Column({ space: 10 }) {
          Text(options.data.title)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .textAlign(TextAlign.Start)
            .maxLines(1)
          Text(options.data.time)
            .fontSize(12)
            .fontWeight(FontWeight.Regular)
            .fontColor('#80FFFFFF')
            .textAlign(TextAlign.Start)
            .maxLines(1)
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height(88)
    .backgroundColor('#FE4E53')
    .padding(15)
    .borderRadius(8)
    // .shadow({
    //   color: '#1A000000',
    //   radius: 4,
    //   offsetX: 0,
    //   offsetY: 0
    // })
    .opacity(this.opacityList[options.index])
    .zIndex(this.zIndexList[options.index])
    .translate({
      x: this.translateXList[options.index],
      y: this.translateYList[options.index]
    })
    .scale({
      x: this.scaleList[options.index],
      y: this.scaleList[options.index]
    })
  }
}