

/*******************************************************************************************************************
** Includes
*******************************************************************************************************************/
#include"TCB.h"
#include"OsAPIs.h"

extern void mcal_led_toggle(void);
extern void pi_spigot_output_count_write(void);

//===============================================================================================================================
// OS TASK : T1
//===============================================================================================================================
TASK(T1)
{
  mcal_led_toggle();
  pi_spigot_output_count_write();

  (void) OS_SetRelAlarm(ALARM_WAKE_UP, 0, 1000);

  for(;;)
  {
    const OsEventMaskType OsWaitEventMask = EVT_WAKE_UP;

    OsEventMaskType Events = (OsEventMaskType) 0U;

    if(E_OK == OS_WaitEvent(OsWaitEventMask))
    {
      (void) OS_GetEvent((OsTaskType) T1, &Events);

      if((Events & EVT_WAKE_UP) == EVT_WAKE_UP)
      {
        OS_ClearEvent(EVT_WAKE_UP);

        pi_spigot_output_count_write();

        mcal_led_toggle();
      }
    }
    else
    {
      /* In case of error we switch off the task */
      OS_TerminateTask();
    }
  }
}

extern int pi_spigot_main(void);

//===============================================================================================================================
// OS TASK : Idle
//===============================================================================================================================
TASK(Idle)
{
  uint32 new_timeout     = 0;
  const uint32 timeout   = 1000u;
  uint32 prescaler       = 2u;

  for(;;)
  {
    const int pi_spigot_result = pi_spigot_main();

    if(pi_spigot_result != 0)
    {
      (void)OS_CancelAlarm(ALARM_WAKE_UP);
    }
    else
    {
      (void)OS_CancelAlarm(ALARM_WAKE_UP);
      prescaler  ^= 2u;
      new_timeout = (prescaler != 0) ? (timeout/prescaler): timeout;
      (void) OS_SetRelAlarm(ALARM_WAKE_UP, 0, new_timeout);
    }

    #if defined(PI_SPIGOT_USE_COOP_MULTITASK)
    OS_Schedule();
    #endif
  }
}
