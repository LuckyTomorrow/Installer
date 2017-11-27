
'--------------------------------------------------------------------------------'
'User Define register: VR(30)-VR(9999)  (Customizable, User-defined...）
'--------------------------------------------------------------------------------'

'Work origin[VR register](User-defined...)
'--------------------------------------
#Define CR_OrgX					20
#Define CR_OrgY					CR_OrgX+1
#Define CR_OrgZ					CR_OrgX+2

'Moving coordinates[VR register](User-define...)
#Define CR_USER					30
#Define CR_MoveX				CR_USER+0
#Define CR_MoveY				CR_USER+1
#Define CR_MoveZ				CR_USER+2


#Define Cur_Index          		101					'The current string index
#Define Star_Char          		102					'The string's start character
#Define TotalNum_Char      		122					'Total string length
#Define CUR_KEY          		123					'Total string length
#Define CUR_KEY_NUM          	124					'The ASC value of the current character of the string
#Define Teach_Num          		147					'Teach digital
#Define AX0_SVON          		128					'Axis 0's SVON

#Define Run_btn          		135					'Monitor whether Run button is available
#Define Pause_btn          		136					'Monitor whether Pause button is available
#Define Step_btn      			137					'Monitor whether Step button is available
#Define Resume_btn          	138					'Monitor whether Resume button is available
#Define Home_btn          		139					'Monitor whether Home button is available
#Define Teach_btn          		140					'Monitor whether Teach button is available
#Define Dbg_btn          		141					'Monitor whether Debug button is available
#Define ERR_Times          		142					'Used to prevent the issuing of multiple error commands

'JOG[VR register](user define...)
#Define CR_JogAxId				CR_USER+3

'Data register
#Define C_DataIndexBase			51

'--------------------------------------------------------------------------------'
'C_Cmd Command definition 
'1-99: System reservation command,Do not change (Attention!)
'--------------------------------------------------------------------------------'

'100-199: Command in Debug_Ready mode (User difined...）
'---------------------------------------------------------------------------'
#Define N_CMD_DbgSub_Base    	100							'Debug_Ready mode's Start
#Define N_CMD_DbgSub_ServoOn    N_CMD_DbgSub_Base+1			'Debug_Ready mode's Servo On
#Define N_CMD_DbgSub_ServoOff   N_CMD_DbgSub_Base+2			'Debug_Ready mode's Servo Off

'#Define N_CMD_DgbSub_xxx		N_CMD_DbgSub_Base+x			'Debug_Ready mode's Demonstration action...(User difined)

'200-299: Command in Home_Ready mode (User difined...）
'---------------------------------------------------------------------------'
#Define N_CMD_HomeSub_Base  	200							'Home_Ready mode's Start
#Define N_CMD_HomeSub_GoPointA  N_CMD_HomeSub_Base+1		'Home_Ready mode's Demonstration action...To Point A
#Define N_CMD_HomeSub_JogAx_P   N_CMD_HomeSub_Base+2		'Home_Ready mode's Jog P
#Define N_CMD_HomeSub_JogAx_N   N_CMD_HomeSub_Base+3		'Home_Ready mode's Jog N
#Define N_CMD_HomeSub_JogAxStop N_CMD_HomeSub_Base+4		'Home_Ready mode's JogStop

#Define N_CMD_HomeSub_Teach  	N_CMD_HomeSub_Base+10		'Home_Ready mode's Save figure 0-9's position
#Define N_CMD_HomeSub_PtP  		N_CMD_HomeSub_Base+20		'Home_Ready mode's Teach figure 0-9

'#Define N_CMD_HomeSub_xxx		N_CMD_HomeSub_Base+x		'Home_Ready mode's Demonstration action...(User difined)

'300-399: Command in Org_Ready mode (User difined...）
'---------------------------------------------------------------------------'
#Define N_CMD_OrgSub_Base  		300							'Org_Ready mode's Start
'#Define N_CMD_OrgSub_xxx		N_CMD_OrgSub_Base+x			'Org_Ready mode's Demonstration action...(User difined)

'400-499:	Command in Run mode (User difined...）
'---------------------------------------------------------------------------'
#Define N_CMD_RunSub_Base  		400							'Run mode's Start
'#Define N_CMD_RunSub_xxx		N_CMD_RunSub_Base+x			'Run mode's Demonstration action...(User difined)

'--------------------------------------------------------------------------------'
'C_SubMD : Sub Mode definition (User difined...）
'State: When VR(C_RunMD) is the following pattern, VR(C_SubMD) needs to specify "sub patterns" in these modes
'			1. VR(C_RunMD) = N_MD_Dbg_SubActions
'			2. VR(C_RunMD) = N_MD_Home_SubActions
'			3. VR(C_RunMD) = N_MD_Org_SubActions
'			4. VR(C_RunMD) = N_MD_Run_SubActions
'--------------------------------------------------------------------------------'
#Define N_SMD_GoPointA			1
#Define N_SMD_JogAx_P     		2
#Define N_SMD_JogAx_N     		3
#Define N_SMD_JogAxStop  		4		
#Define N_SMD_ServoOn			5
#Define N_SMD_ServoOff			6

#Define N_SMD_Teach  			10							'Home_Ready mode's Save figure 0-9's position
#Define N_SMD_PtP  				11							'Home_Ready mode's Teach figure 0-9

'--------------------------------------------------------------------------------'
'H_BtnType(User difined...）
'--------------------------------------------------------------------------------'
#Define N_HB_Run 				1							'Run
#Define N_HB_Pause 				2							'Pause
#Define N_HB_Resume 			3							'Resume
#Define N_HB_Step 				4							'Step
#Define N_HB_Stop 				5							'Stop
#Define N_HB_Home 				6							'Home
#Define N_HB_JogAx_P 			7  							'JOG+
#Define N_HB_JogAx_N 			8  							'JOG-
#Define N_HB_JogAxStop 			9  							'Jog Stop
#Define N_HB_ResetErr			10							'Reset error
#Define N_HB_ORG   				11							'Resume to work origin	
#Define N_HB_ServoOn			12							'SVON
#Define N_HB_ServoOff			13							'SVOFF

#Define N_HB_Teach0   			20							'Save position:figure 0
#Define N_HB_Teach1   			21							'Save position:figure 1
#Define N_HB_Teach2   			22							'Save position:figure 2
#Define N_HB_Teach3   			23							'Save position:figure 3
#Define N_HB_Teach4   			24							'Save position:figure 4
#Define N_HB_Teach5   			25							'Save position:figure 5
#Define N_HB_Teach6   			26							'Save position:figure 6
#Define N_HB_Teach7   			27							'Save position:figure 7
#Define N_HB_Teach8   			28							'Save position:figure 8
#Define N_HB_Teach9   			29							'Save position:figure 9

#Define N_HB_PtP0   			30							'Teach figure 0
#Define N_HB_PtP1   			31							'Teach figure 1
#Define N_HB_PtP2   			32							'Teach figure 2
#Define N_HB_PtP3   			33							'Teach figure 3
#Define N_HB_PtP4   			34							'Teach figure 4
#Define N_HB_PtP5   			35							'Teach figure 5
#Define N_HB_PtP6   			36							'Teach figure 6
#Define N_HB_PtP7   			37							'Teach figure 7
#Define N_HB_PtP8   			38							'Teach figure 8
#Define N_HB_PtP9   			39							'Teach figure 9

'--------------------------------------------------------------------------------'
'CS_WarnId & CS_ErrId		Wrong ID defined (User difined...）
'--------------------------------------------------------------------------------'
'Warning Id: 1-100        	Warning ID
'------------------------------------------------'
#Define ERR_Success				0							'System error, do not change
#Define ERR_NoCommand			1							'System error, do not change
#Define ERR_InvalidOperation	2							'System error, do not change
#Define ERR_HomeNotFinish		3							'System error, do not change
#Define ERR_NotFinish			4							'System error, do not change
#Define ERR_UnknowCommand		5							'System error, do not change

'Error Id: 100-500       	Wrong ID
'------------------------------------------------'

#Define ERR_AxisError			1
#Define ERR_AxisAlmError		2
#Define ERR_AxisPelError		3
#Define ERR_AxisNelError		4
#Define ERR_AxisEmgError		5

'*********************************************************************************'
'component:XYZ_TABLE
'State: 
' 1. TYPE can turn the relevant Function into a group
' 2. The user can add/modify the Function, but the action should begin with the following two lines of judgment:
'    XYZ_TABLE.FUNCTION xxx()
'     	IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish    	'Should have this line of judgment
'  		IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish		'Should have this line of judgment
'     ........
'    END FUNCTION
'*********************************************************************************'
TYPE XYZ_TABLE
	'A custom structure requires at least one variable
	COUNT AS INTEGER=0								
	DECLARE FUNCTION MOVE_XY(X as INTEGER, Y as INTEGER)As Integer
	DECLARE FUNCTION MOVE_Z(Z as INTEGER)As Integer
	DECLARE FUNCTION MOVE_Z0(Z0 as INTEGER)As Integer
	DECLARE FUNCTION Home_XYZ()As Integer	
	DECLARE FUNCTION WaitDone() AS Integer
	DECLARE FUNCTION Stop() AS Integer
	DECLARE FUNCTION ResetMotionErr() AS Integer
END TYPE

'Run to some point's X and Y coordinates
'Note: WaitDone cannot be put in Funtion
FUNCTION XYZ_TABLE.MOVE_XY(X as INTEGER, Y as INTEGER)As Integer		
	IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish
	IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish
	BASE 0,1
	LINEABS X,Y
	Return ERR_Success
END FUNCTION

'Run to some point's Z coordinates
'Note: WaitDone cannot be put in Funtion
FUNCTION XYZ_TABLE.MOVE_Z(Z as INTEGER)As Integer
	IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish
	IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish
	BASE 2
	MOVEABS Z
	Return ERR_Success
END FUNCTION

'Run XY Home
'Note: WaitDone cannot be put in Funtion
FUNCTION XYZ_TABLE.Home_XYZ()As Integer
	IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish
	IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish
	BASE 0,1
	' Write your Home action...
	
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
'Note: WaitDone cannot be put in Funtion
FUNCTION XYZ_TABLE.Stop()As Integer
	BASE 0,1,2
	STOPDEC
	Return ERR_Success
END FUNCTION	

'XYZ Reset Error
FUNCTION XYZ_TABLE.ResetMotionErr()As Integer
	BASE 0,1,2
	RESETERR                 					'Remove the errors of axis 0, 1, 2	
	CLEAR_ERROR
	Return ERR_Success
END FUNCTION	
