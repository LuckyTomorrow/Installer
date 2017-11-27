
'*********************************************************************************'
'User Define暂存器: VR(100)-VR(9999)  (可更动, 用户自定义...）
'*********************************************************************************'

'工作原点[VR暂存器](用户自定义...）
'--------------------------------------
#Define CR_OrgX					20
#Define CR_OrgY					CR_OrgX+1
#Define CR_OrgZ					CR_OrgX+2

'移动座标[VR暂存器](user define...)
#Define CR_USER_BASE				100
'#Define CR_xxx				CR_USER_BASE+0


'*********************************************************************************'
'C_Cmd 命令定义 
'1-99: 系统保留命令,不可更动 (注意！)
'*********************************************************************************'

'100-199:	Debug_Ready 模式下命令 (用户自定义...）
'----------------------------------------------------------------------'
#Define N_CMD_DbgSub_Base    		100							'Debug_Ready 模式起始范围
'#Define N_CMD_DgbSub_xxx			N_CMD_DbgSub_Base+x			'Debug_Ready 模式下示范动作...(用户自定义)

'200-299:	Home_Ready 模式下命令 (用户自定义...）
'----------------------------------------------------------------------'
#Define N_CMD_HomeSub_Base  		200							'Home_Ready 模式起始范围
'#Define N_CMD_HomeSub_xxx		N_CMD_HomeSub_Base+x			'Home_Ready 模式下示范动作...(用户自定义)

'300-399:	Org_Ready 模式下命令 (用户自定义...）
'----------------------------------------------------------------------'
#Define N_CMD_OrgSub_Base  			300							'Org_Ready 模式起始范围
'#Define N_CMD_OrgSub_xxx		  	N_CMD_OrgSub_Base+x			'Org_Ready 模式下示范动作...(用户自定义)

'400-499:	Run 模式下命令 (用户自定义...）
'----------------------------------------------------------------------'
#Define N_CMD_RunSub_Base  			400							'Run 模式起始范围
'#Define N_CMD_RunSub_xxx		  	N_CMD_RunSub_Base+x			'Run 模式下示范动作...(用户自定义)



'*********************************************************************************'
'CS_WarnId & CS_ErrId		错误ID定义 (用户自定义...）
'*********************************************************************************'
'Warning Id: 警告讯息
'------------------------------------------------'
#Define ERR_Success					0			'系统错误,不可更动
#Define ERR_NoCommand				1			'系统错误,不可更动
#Define ERR_InvalidOperation		2			'系统错误,不可更动
#Define ERR_HomeNotFinish			3			'系统错误,不可更动
#Define ERR_NotFinish				4			'系统错误,不可更动
#Define ERR_UnknowCommand			5			'系统错误,不可更动

'Error Id: 错误讯息
'------------------------------------------------'
#Define ERR_AxisError				0
#Define ERR_AxisAlmError			1
#Define ERR_AxisPelError			2
#Define ERR_AxisNelError			3
#Define ERR_AxisEmgError			4

'*********************************************************************************'
'元件:XYZ_TABLE
'说明: 
' 1. TYPE指令可以将相关的Function, 变成一个群组 
' 2. 用户可自行增加/修改 Function内容, 但动作Function最开始必须有下面2行判断式:
'    XYZ_TABLE.FUNCTION xxx()
'     IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish    '必须有此行判断式
'  	IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish		'必须有此行判断式
'     ........
'    END FUNCTION
'*********************************************************************************'
TYPE XYZ_TABLE
	COUNT AS INTEGER=0									'自定义结构至少需要说明一个变量
	DECLARE FUNCTION MOVE_XYZ(X as INTEGER, Y as INTEGER, Z as INTEGER)As Integer
	DECLARE FUNCTION Home_XYZ()As Integer	
	DECLARE FUNCTION WaitDone() AS Integer
	DECLARE FUNCTION Stop() AS Integer
	DECLARE FUNCTION ResetMotionErr() AS Integer
END TYPE

'运行到某一点X、Y、Z坐标
'Note: WaitDone 不能放在Funtion里
FUNCTION XYZ_TABLE.MOVE_XYZ(X as INTEGER, Y as INTEGER, Z as INTEGER)As Integer			
	IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish
	IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish
	BASE 0,1,2
	LINEABS X,Y,Z
END FUNCTION

'运行XY Home
'Note: WaitDone 不能放在Funtion里
FUNCTION XYZ_TABLE.Home_XYZ()As Integer
	IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish
	IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish
	BASE 0,1
	' 输入您的Home动作...
	
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
'Note: WaitDone 不能放在Stop()里
FUNCTION XYZ_TABLE.Stop()As Integer
	BASE 0,1,2
	STOPDEC
	Return ERR_Success
END FUNCTION	

'XYZ Reset Error
FUNCTION XYZ_TABLE.ResetMotionErr()As Integer
	BASE 0,1,2
	RESETERR                 							'清除轴0、1、2的错误	
	Return ERR_Success
END FUNCTION	
