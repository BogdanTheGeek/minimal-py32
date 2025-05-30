//------------------------------------------------------------------------------
//       Filename: main.c
//------------------------------------------------------------------------------
//       Bogdan Ionescu (c) 2025
//------------------------------------------------------------------------------
//       Purpose : Application entry point
//------------------------------------------------------------------------------
//       Notes : None
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Module includes
//------------------------------------------------------------------------------
#include "gpio.h"
#include "log.h"
#include "semihost.h"
#include "system.h"

//------------------------------------------------------------------------------
// Module constant defines
//------------------------------------------------------------------------------
#define TAG "main"

#define SYSTICK_ONE_MILLISECOND ((uint32_t)F_CPU / 1000)
#define SYSTICK_ONE_MICROSECOND ((uint32_t)F_CPU / 1000000)
#define millis()                (SysTick->VAL / SYSTICK_ONE_MILLISECOND)

//------------------------------------------------------------------------------
// External variables
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// External functions
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Module type definitions
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Module static variables
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Module static function prototypes
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Module externally exported functions
//------------------------------------------------------------------------------

/**
 * @brief  Read a character from standard input (stdin).
 * @param  None
 * @return The character read from stdin, or -1 if no character is available.
 * @note   This function blocks until a character is available.
 */
int getchar(void)
{
    return SEMIHOST_SysCall(SYS_READC, NULL);
}

/**
 * @brief  Main application entry point.
 * @param  None
 * @return 0 on success, or a non-zero value on error.
 */
int main(void)
{
    PIN_output(PB0);

    LOG_Init(eLOG_LEVEL_DEBUG, (const uint32_t *)&SysTick->VAL);

    LOGI(TAG, "Hello, PY32F0xx!");

    int count = 0;
    while (1)
    {
#if 0
        // read stdin
        int c = getchar();
        switch (c)
        {
            case 'q':
            case 'Q':
                LOGW(TAG, "Goodbye!");
                return 0; // Exit the program
            case -1:
                break;
            case '\r':
            case '\n':
                break; // Ignore Enter key
            default:
                LOGW(TAG, "You pressed: '%c'", (char)c);
                break; // Ignore other characters
        }
#endif

        LOGI(TAG, "Count: %d", count++);
        PIN_toggle(PB0);
        DLY_ms(1000);
    }
}

//------------------------------------------------------------------------------
// Module static functions
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
