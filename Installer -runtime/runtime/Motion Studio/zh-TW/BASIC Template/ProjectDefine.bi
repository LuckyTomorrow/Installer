
'*********************************************************************************'
'User Define暫存器: VR(100)-VR(9999)  (可更動, 用戶自定義...）
'*********************************************************************************'

'工作原點[VR暫存器](用戶自定義...）
'--------------------------------------
#Define CR_OrgX					20
#Define CR_OrgY					CR_OrgX+1
#Define CR_OrgZ					CR_OrgX+2

'移動座標[VR暫存器](user define...)
#Define CR_USER_BASE				100
'#Define CR_xxx				CR_USER_BASE+0


'*********************************************************************************'
'C_Cmd 命令定義 
'1-99: 系統保留命令,不可更動 (註意！)
'*********************************************************************************'

'100-199:	Debug_Ready 模式下命令 (用戶自定義...）
'----------------------------------------------------------------------'
#Define N_CMD_DbgSub_Base    		100							'Debug_Ready 模式起始範圍
'#Define N_CMD_DgbSub_xxx			N_CMD_DbgSub_Base+x			'Debug_Ready 模式下示範動作...(用戶自定義)

'200-299:	Home_Ready 模式下命令 (用戶自定義...）
'----------------------------------------------------------------------'
#Define N_CMD_HomeSub_Base  		200							'Home_Ready 模式起始範圍
'#Define N_CMD_HomeSub_xxx		N_CMD_HomeSub_Base+x			'Home_Ready 模式下示範動作...(用戶自定義)

'300-399:	Org_Ready 模式下命令 (用戶自定義...）
'----------------------------------------------------------------------'
#Define N_CMD_OrgSub_Base  			300							'Org_Ready 模式起始範圍
'#Define N_CMD_OrgSub_xxx		  	N_CMD_OrgSub_Base+x			'Org_Ready 模式下示範動作...(用戶自定義)

'400-499:	Run 模式下命令 (用戶自定義...）
'----------------------------------------------------------------------'
#Define N_CMD_RunSub_Base  			400							'Run 模式起始範圍
'#Define N_CMD_RunSub_xxx		  	N_CMD_RunSub_Base+x			'Run 模式下示範動作...(用戶自定義)



'*********************************************************************************'
'CS_WarnId & CS_ErrId		錯誤ID定義 (用戶自定義...）
'*********************************************************************************'
'Warning Id: 警告訊息
'------------------------------------------------'
#Define ERR_Success					0			'系統錯誤,不可更動
#Define ERR_NoCommand				1			'系統錯誤,不可更動
#Define ERR_InvalidOperation		2			'系統錯誤,不可更動
#Define ERR_HomeNotFinish			3			'系統錯誤,不可更動
#Define ERR_NotFinish				4			'系統錯誤,不可更動
#Define ERR_UnknowCommand			5			'系統錯誤,不可更動

'Error Id: 錯誤訊息
'------------------------------------------------'
#Define ERR_AxisError				0
#Define ERR_AxisAlmError			1
#Define ERR_AxisPelError			2
#Define ERR_AxisNelError			3
#Define ERR_AxisEmgError			4

'*********************************************************************************'
'元件:XYZ_TABLE
'說明: 
' 1. TYPE指令可以將相關的Function, 變成壹個群組 
' 2. 用戶可自行增加/修改 Function內容, 但動作Function最開始必須有下面2行判斷式:
'    XYZ_TABLE.FUNCTION xxx()
'     IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish    '必須有此行判斷式
'  	IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish		'必須有此行判斷式
'     ........
'    END FUNCTION
'*********************************************************************************'
TYPE XYZ_TABLE
	COUNT AS INTEGER=0									'自定義結構至少需要說明壹個變量
	DECLARE FUNCTION MOVE_XYZ(X as INTEGER, Y as INTEGER, Z as INTEGER)As Integer
	DECLARE FUNCTION Home_XYZ()As Integer	
	DECLARE FUNCTION WaitDone() AS Integer
	DECLARE FUNCTION Stop() AS Integer
	DECLARE FUNCTION ResetMotionErr() AS Integer
END TYPE

'運行到某壹點X、Y、Z坐標
'Note: WaitDone 不能放在Funtion裏
FUNCTION XYZ_TABLE.MOVE_XYZ(X as INTEGER, Y as INTEGER, Z as INTEGER)As Integer			
	IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish
	IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish
	BASE 0,1,2
	LINEABS X,Y,Z
END FUNCTION

'運行XY Home
'Note: WaitDone 不能放在Funtion裏
FUNCTION XYZ_TABLE.Home_XYZ()As Integer
	IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish
	IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish
	BASE 0,1
	' 輸入您的Home動作...
	
	Return ERR_Success
END FUNCTION	

'Wait Done
FUNCTION XYZ_TABLE.WaitDone() AS INTEGER
	IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish
	IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish
	VR(CS_RunStepCount) += 1
	WAIT DONE
	Return ERR_Success
End FUNCTION

'XYZ Stop
'Note: WaitDone 不能放在Stop()裏
FUNCTION XYZ_TABLE.Stop()As Integer
	BASE 0,1,2
	STOPDEC
	Return ERR_Success
END FUNCTION	

'XYZ Reset Error
FUNCTION XYZ_TABLE.ResetMotionErr()As Integer
	BASE 0,1,2
	RESETERR                 							'清除軸0、1、2的錯誤	
	Return ERR_Success
END FUNCTION	
