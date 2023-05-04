// *****************************************************************************************************************
// Filename    : OsCfg.h
// 
// Author      : Chalandi Amine
//
// Owner       : Chalandi Amine
// 
// Date        : 27.12.2017
// 
// Description : OSEK based application config
// 
// *****************************************************************************************************************

#include"OsGenMac.h"

//#define PI_SPIGOT_USE_COOP_MULTITASK

//=============================================================================
//  OS Configuration
//=============================================================================

OS_CONFIG_BEGIN

  OS_TASK_BEGIN
  #if defined(PI_SPIGOT_USE_COOP_MULTITASK)
    OS_TASK_DEF(Idle ,0 ,2048 ,1 ,OS_AUTOSTART    ,EXTENDED ,NONE_PREEMPT)
    OS_TASK_DEF(T1   ,1 ,2048 ,1 ,OS_AUTOSTART    ,EXTENDED ,NONE_PREEMPT)
  #else
    OS_TASK_DEF(Idle ,0 ,2048 ,1 ,OS_AUTOSTART    ,EXTENDED ,FULL_PREEMPT)
    OS_TASK_DEF(T1   ,1 ,2048 ,1 ,OS_AUTOSTART    ,EXTENDED ,FULL_PREEMPT)
  #endif
  OS_TASK_END

  OS_EVENT_BEGIN
   OS_EVENT_DEF(EVT_WAKE_UP               , (1UL<<0))
  OS_EVENT_END
  
  OS_ALARM_BEGIN
    OS_ALARM_DEF(ALARM_WAKE_UP         ,ALARM_SET_EVENT   ,EVT_WAKE_UP          ,T1   ,0)
  OS_ALARM_END

  OS_RESOURCE_BEGIN
    OS_RESOURCE_DEF(RES_SCHEDULER ,RES_SCHEDULER_PRIO , {1,1})
  OS_RESOURCE_END

  OS_INTERRUPT_BEGIN
    OS_INTERRUPT_CAT2_DEF(15,SysTickTimer)
  OS_INTERRUPT_END

OS_CONFIG_END
