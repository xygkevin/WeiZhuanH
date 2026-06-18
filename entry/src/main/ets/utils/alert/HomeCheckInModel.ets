/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanHS
 * @FileName : HomeCheckInModel
 * @Author : KEVIN XU
 * @Time : 2026/4/10 14:04
 * @Description : 描述
 */

@ObservedV2
export class HomeCheckInTask {
  /**
   * 任务奖励
   */
  @Trace point: number = 0
  /**
   * 标题
   */
  @Trace title?: string
  /**
   * 提示语
   */
  @Trace tips: string = ''
  /**
   * 任务ID
   */
  @Trace taskId?: string

  constructor(data?: Partial<HomeCheckInTask>) {
    if (data) {
      this.point = data.point ?? 0
      this.title = data.title ?? ''
      this.tips = data.tips ?? ''
      this.taskId = data.taskId ?? ''
    }
  }

  static fromResponse(data?: Partial<HomeCheckInTask>): HomeCheckInTask {
    return new HomeCheckInTask(data)
  }
}

@ObservedV2
export class HomeCheckInItem {
  /**
   * 积分基数
   */
  @Trace point: number = 0
  /**
   * 积分总数
   */
  @Trace quantity?: number
  /**
   * 倍数 = quantity / point
   */
  @Trace multiple?: number
  /**
   * 第几天
   */
  @Trace rank: number = 0
  /**
   * 签到状态:0未签/1已签/2漏签
   */
  @Trace state: number = 0
  /**
   *
   */
  @Trace amount?: number

  constructor(data?: Partial<HomeCheckInItem>) {
    if (data) {
      this.point = data.point ?? 0
      this.quantity = data.quantity ?? 0
      this.multiple = data.multiple ?? 0
      this.rank = data.rank ?? 0
      this.state = data.state ?? 0
    }
  }

  static fromResponse(data?: Partial<HomeCheckInItem>): HomeCheckInItem {
    return new HomeCheckInItem(data)
  }

  static fromResponseArray(data?: Partial<HomeCheckInItem>[]): HomeCheckInItem[] {
    return (data ?? []).map(item => new HomeCheckInItem(item))
  }
}

@ObservedV2
export class HomeCheckInTalkTask {
  /**
   * 任务ID
   */
  @Trace talkTaskId: string = ''
  /**
   * Banner图片
   */
  @Trace talkTaskBanner: string = ''
  /**
   * Url
   */
  @Trace talkUrl: string = ''

  constructor(data?: Partial<HomeCheckInTalkTask>) {
    if (data) {
      this.talkTaskId = data.talkTaskId ?? ''
      this.talkTaskBanner = data.talkTaskBanner ?? ''
      this.talkUrl = data.talkUrl ?? ''
    }
  }

  static fromResponse(data?: Partial<HomeCheckInTalkTask>): HomeCheckInTalkTask {
    return new HomeCheckInTalkTask(data)
  }
}

@ObservedV2
export class HomeCheckInModel {
  /**
   * ID
   */
  @Trace id: number = 0
  /**
   * 是否是是首次签到
   */
  @Trace isNew: boolean = false
  /**
   * 提示语1
   */
  @Trace preTips: string = ''
  /**
   * 提示语2
   */
  @Trace tips: string = ''
  /**
   * 签到投票ID, 有值优先投票,投票之后再次请求签到数据
   */
  @Trace pollId?: string
  /**
   * 显示投票结果
   */
  @Trace result: boolean = false
  /**
   * 连续签到天数
   */
  @Trace day: number = 0
  /**
   * 积分增加
   */
  @Trace point: number = 0
  /**
   *
   */
  @Trace amount: number = 0
  /**
   * 签到每天的信息
   */
  @Trace checkinPointList: HomeCheckInItem[] = []
  /**
   * 信用值增加
   */
  @Trace credit?: number
  /**
   * 本次签到是第几天
   */
  @Trace pointDay: number = 0
  /**
   * 活动开始
   */
  @Trace startDate?: string
  /**
   * 活动结束
   */
  @Trace endDate?: string
  /**
   * 做任务赚金币
   */
  @Trace taskPoint?: number
  /**
   * 任务
   */
  @Trace task?: HomeCheckInTask
  /**
   * 话题联动任务
   */
  @Trace talkTask?: HomeCheckInTalkTask
  /**
   * 通知状态
   */
  @Trace checkinNotification: boolean = false
  /**
   * 激励视频使用
   */
  @Trace rewardBannerImageUrl: string = ''
  /**
   * 展示激励视频
   */
  @Trace showRewardAd: boolean = false



  constructor(data?: Partial<HomeCheckInModel>) {
    if (data) {
      this.id = data.id ?? 0
      this.isNew = data.isNew ?? false
      this.preTips = data.preTips ?? ''
      this.tips = data.tips ?? ''
      this.pollId = data.pollId ?? ''
      this.result = data.result ?? false
      this.day = data.day ?? 0
      this.point = data.point ?? 0
      this.amount = data.amount ?? 0
      this.credit = data.credit ?? 0
      this.pointDay = data.pointDay ?? 0
      this.startDate = data.startDate ?? ''
      this.endDate = data.endDate ?? ''
      this.taskPoint = data.taskPoint ?? 0
      this.checkinNotification = data.checkinNotification ?? false
      this.checkinPointList = HomeCheckInItem.fromResponseArray(data.checkinPointList)
      this.task = data.task ? HomeCheckInTask.fromResponse(data.task) : undefined
      this.talkTask = data.talkTask ? HomeCheckInTalkTask.fromResponse(data.talkTask) : undefined
    }
  }

  static fromResponse(data?: Partial<HomeCheckInModel>) {
    return new HomeCheckInModel(data)
  }
}