/**
 * 指尖造梦，精益求精
 * @ProjectName : WeiZhuanH
 * @FileName : RouterUtil
 * @Author : KEVIN XU
 * @Time : 2026/5/29 18:51
 * @Description : 描述
 */
import { kUserStatus } from "../../status/UserStatus"
import { LogUtil } from "../log/LogUtil"

/**
 * PUSH 参数
 */
export interface RouterPushOptions {
  /**
   * 页面
   */
  name: string
  /**
   * 参数
   */
  param?: Object
  /**
   * 跳过登录(默认false)
   */
  skipLogin?: boolean
  /**
   * 返回参数
   */
  onPop?: (info: PopInfo) => void
  /**
   * 是否动画
   */
  animated?: boolean
}

/**
 * REPLACE参数
 */
export interface RouterReplaceOptions {
  /**
   * 页面
   */
  name: string
  /**
   * 参数
   */
  param?: Object
  /**
   * 跳过登录(默认false)
   */
  skipLogin?: boolean
  /**
   * 是否动画
   */
  animated?: boolean
}

/**
 * POP参数
 */
export interface RouterPopOptions {
  /**
   * 页面(和index互斥,优先级高于index)
   */
  name?: string
  /**
   * 序号(和name互斥,优先级低于name)
   */
  index?: number
  /**
   * 返回参数
   */
  result?: Object
  /**
   * 是否动画
   */
  animated?: boolean
}

/**
 * 移除参数
 */
export interface RouterRemoveOptions {
  /**
   * 移除的页面
   */
  name?: string
  /**
   * 移除的下标集合
   */
  indexes?: number[]
  /**
   * 导航ID
   */
  navDestinationId?: string
}


/**
 * 移动到顶部
 */
export interface RouterMoveOptions {
  /**
   * 移除的页面
   */
  name?: string
  /**
   * 移除的下标
   */
  index?: number
  /**
   * 是否动画
   */
  animated?: boolean
}

export class RouterUtil {
  /**
   * 导航堆栈
   */
  static readonly navPathStack: NavPathStack = new NavPathStack()
  /**
   * 白名单, 白名单内的不检查
   */
  private static routeNameWhiteList: Set<string> = new Set()

  /**
   * 添加到白名单
   */
  public static addToWhiteList(name: string) {
    RouterUtil.routeNameWhiteList.add(name)
  }

  /**
   * 从白名单中移除
   */
  public static removeFromWhiteList(name: string) {
    if (RouterUtil.routeNameWhiteList.has(name)) {
      RouterUtil.routeNameWhiteList.delete(name)
    }
  }

  /**
   * 清理白名单
   */
  public static clearWhiteList() {
    RouterUtil.routeNameWhiteList.clear()
  }

  /**
   * Push跳转
   */
  public static async push(options: RouterPushOptions): Promise<void> {
    try {
      if (!(await RouterUtil.pushCheck(options))) {
        return
      }
      if (options.onPop) {
        await RouterUtil.navPathStack.pushDestinationByName(options.name, options.param, options.onPop,
          options.animated ?? true)
      } else {
        await RouterUtil.navPathStack.pushDestinationByName(options.name, options.param, options.animated ?? true)
      }
      console.log(`路由 跳转 ${options.name} 成功`)
    } catch (err) {
      console.error(`路由 跳转 ${options.name} 失败: ${JSON.stringify(err)}`)
    }
  }

  /**
   * Replace跳转
   */
  public static async replace(options: RouterReplaceOptions): Promise<void> {
    try {
      if (!(await RouterUtil.pushCheck(options))) {
        return
      }
      RouterUtil.navPathStack.replacePathByName(options.name, options.param, options.animated ?? true)
      console.log(`路由 替换 ${options.name} 成功`)
    } catch (err) {
      console.error(`路由 替换 ${options.name} 失败: ${JSON.stringify(err)}`)
    }
  }

  /**
   * Pop返回
   */
  public static async pop(options?: RouterPopOptions): Promise<void> {
    try {
      if (!options) {
        RouterUtil.navPathStack.pop(true)
        return
      }
      if (options.name) {
        if (options.result) {
          RouterUtil.navPathStack.popToName(options.name, options.result, options.animated ?? true)
        } else {
          RouterUtil.navPathStack.popToName(options.name, options.animated ?? true)
        }
      } else if (options.index !== undefined) {
        if (options.result) {
          RouterUtil.navPathStack.popToIndex(options.index, options.result, options.animated ?? true)
        } else {
          RouterUtil.navPathStack.popToIndex(options.index, options.animated ?? true)
        }
      } else {
        if (options.result) {
          RouterUtil.navPathStack.pop(options.result, options.animated ?? true)
        } else {
          RouterUtil.navPathStack.pop(options.animated)
        }
      }
      console.log(`路由 返回 ${options.name ?? ''} 成功`)
    } catch (err) {
      console.error(`路由 返回失败: ${JSON.stringify(err)}`)
    }
  }

  /**
   * 从导航堆栈中删除按名称、下标、ID指定的导航目标页
   */
  public static async remove(options: RouterRemoveOptions): Promise<void> {
    try {
      if (options.name) {
        RouterUtil.navPathStack.removeByName(options.name)
      }
      if (options.indexes) {
        RouterUtil.navPathStack.removeByIndexes(options.indexes)
      }
      if (options.navDestinationId) {
        RouterUtil.navPathStack.removeByNavDestinationId(options.navDestinationId)
      }
    } catch (err) {
      console.error(`路由 移除 ${options.name} 失败: ${JSON.stringify(err)}`)
    }
  }

  /**
   * 移动到顶部
   */
  public static async moveToTop(options: RouterMoveOptions): Promise<void> {
    try {
      if (options.name) {
        RouterUtil.navPathStack.moveToTop(options.name, options.animated ?? true)
      }
      if (options.index) {
        RouterUtil.navPathStack.moveIndexToTop(options.index, options.animated ?? true)
      }
    } catch (err) {
      console.error(`路由 移动到顶部 ${options.name} 失败: ${JSON.stringify(err)}`)
    }
  }

  /**
   * 清理堆栈
   */
  public static async clear(animated: boolean = false): Promise<void> {
    try {
      RouterUtil.navPathStack.clear(animated)
    } catch (err) {
      console.error(`路由 清理失败: ${JSON.stringify(err)}`)
    }
  }

  /**
   * 路由检查
   */
  private static async pushCheck(options: RouterPushOptions | RouterReplaceOptions): Promise<boolean> {
    try {
      // 参数遗漏
      if (!options.name) {
        return false
      }
      // 白名单内的放行
      if (RouterUtil.routeNameWhiteList.has(options.name)) {
        return true
      }
      // 跳过登录的
      if (options.skipLogin) {
        return true
      }

      // 登录检查:
      // 1.已登录: 放行
      // 2.未登录: 检查路由列表中是否存在登录页,已存在且在最顶层拦截当前跳转,未存在登录页重定向到登录页
      if (kUserStatus.isLoggedIn()) {
        return true
      }

      if (RouterUtil.navPathStack.getAllPathName().includes('Login')) {
        return false
      }

      // 跳转登录页
      LogUtil.info('RouterUtil', '路由拦截跳转至登录页')
      RouterUtil.push({
        name: 'Login',
        skipLogin: true,
      })

      return false
    } catch (err) {
      console.error(`路由 检查失败: ${err}`)
      return false
    }
  }
}