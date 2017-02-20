
#if defined( __PLATFORM__WINDOWS ) .OR. defined( __HBSCRIPT__HBSHELL )

STATIC nStart

PROCEDURE Main()

   CLS
   MsgBox( "Example;Message;Time remaining: %1$s second(s)", { "Ok", "Cancel" }, , 12 )

RETURN

INIT PROCEDURE MyInit()

   nStart := Hb_Milliseconds()

RETURN

EXIT PROCEDURE MyExit()

   ? "passed ", Hb_Milliseconds() - nStart, "Milliseconds"

RETURN

#endif