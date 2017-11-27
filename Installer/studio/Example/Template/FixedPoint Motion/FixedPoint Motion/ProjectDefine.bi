
'*********************************************************************************'
'User Define register: VR(30)-VR(9999)  (Customizable, user-defined...）
'*********************************************************************************'

'Work origin[VR register](User-defined...)
'--------------------------------------
#Define CR_OrgX					20
#Define CR_OrgY					CR_OrgX+1
#Define CR_OrgZ					CR_OrgX+2

'Moving coordinates[VR register](User-defined...)
#Define CR_USER					30
#Define CR_MoveX				CR_USER+0
#Define CR_MoveY				CR_USER+1
#Define CR_MoveZ				CR_USER+2

'JOG[VR register](User-defined...)
#Define CR_JogAxId				CR_USER+3

'Data register
#Define C_DataIndexBase			51
'*********************************************************************************'
'C_Cmd Command definition 
'1-99: System reserve command, do not modify (Attention!!)
'*********************************************************************************'
#Define Point_Num          		101					'Teach & PtP point
#Define Current_Point           102                 'The current point index
#Define AX0_SVON                111                 
#Define AX1_SVON                112

#Define Run_btn          		135					'Monitor whether Run button is available
#Define Pause_btn          		136					'Monitor whether Pause button is available
#Define Step_btn      			137					'Monitor whether Step button is available
#Define Resume_btn          	138					'Monitor whether Resume button is available
#Define Home_btn          		139					'Monitor whether Home button is available
#Define Teach_btn          		140					'Monitor whether Teach button is available
#Define Dbg_btn          		141					'Monitor whether Debug button is available
#Define ERR_Times          		142					'Used to prevent the issuing of multiple error commands
'100-199:	Command in Debug_Ready mode  (User-defined...）
'----------------------------------------------------------------------'
#Define N_CMD_DbgSub_Base    		100							'Debug_Ready mode's Start
#Define N_CMD_DbgSub_ServoOn		N_CMD_DbgSub_Base+1			'Debug_Ready mode's ServoOn
#Define N_CMD_DbgSub_ServoOff		N_CMD_DbgSub_Base+2			'Debug_Ready mode's ServoOff

'200-299:	Command in Home_Ready mode (User-defined...）
'----------------------------------------------------------------------'
#Define N_CMD_HomeSub_Base  		200							'Home_Ready mode's Start
#Define N_CMD_HomeSub_GoPointA		N_CMD_HomeSub_Base+1        'Home_Ready mode's Demonstration action...To Point A
#Define N_CMD_HomeSub_JogAx_P       N_CMD_HomeSub_Base+2		'Home_Ready mode's Jog P
#Define N_CMD_HomeSub_JogAx_N       N_CMD_HomeSub_Base+3	    'Home_Ready mode's Jog N
#Define N_CMD_HomeSub_JogAxStop     N_CMD_HomeSub_Base+4	    'Home_Ready mode's JogStop
#Define N_CMD_HomeSub_Teach  	    N_CMD_HomeSub_Base+10		'Home_Ready mode's point 1-4's position
#Define N_CMD_HomeSub_PtP  		    N_CMD_HomeSub_Base+20		'Home_Ready mode's point 1-4

'300-399:	Command in Org_Ready mode (User-defined...）
'----------------------------------------------------------------------'
#Define N_CMD_OrgSub_Base  			300							'Org_Ready mode's Start
'#Define N_CMD_OrgSub_xxx		  	N_CMD_OrgSub_Base+x			'Org_Ready mode's Demonstration action...(User define)

'400-499:	Command in Run mode (User-defined...）
'----------------------------------------------------------------------'
#Define N_CMD_RunSub_Base  			400							'Run mode's Start
'#Define N_CMD_RunSub_xxx		  	N_CMD_RunSub_Base+x			'Run mode's Demonstration action...(User define)

'--------------------------------------------------------------------------------'
'C_SubMD : Sub Mode definition (User-defined...）
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

#Define N_SMD_Teach  			10							'Home_Ready mode's Save point 1-4's position
#Define N_SMD_PtP  				11							'Home_Ready mode's Teach point 1-4

#Define N_HB_Run 				1							'Run
#Define N_HB_Pause 				2							'Pause
#Define N_HB_Resume 			3							'Resume
#Define N_HB_Step 				4							'Step
#Define N_HB_Stop 				5							'Stop
#Define N_HB_Home 				6							'Home
#Define N_HB_JogAx_P            7                           'JOG+
#Define N_HB_JogAx_N            8                           'JOG-
#Define N_HB_JogAxStop          9                           'JogStop
#Define N_HB_ResetErr			10							'Reset error
#Define N_HB_ORG   				11							'Resume to work origin	
#Define N_HB_ServoOn			12							'SVON
#Define N_HB_ServoOff			13							'SVOFF

#Define N_HB_Teach_P1   		20							'Save position:point 1
#Define N_HB_Teach_P2   		21							'Save position:point 2
#Define N_HB_Teach_P3   		22							'Save position:point 3
#Define N_HB_Teach_P4   		23							'Save position:point 4
#Define N_HB_PtP_P1  			24							'Teach P1
#Define N_HB_PtP_P2   			25							'Teach P2
#Define N_HB_PtP_P3   			26							'Teach P3
#Define N_HB_PtP_P4   			27							'Teach P4


'*********************************************************************************'
'CS_WarnId & CS_ErrId		Error ID defined (User-defined...）
'*********************************************************************************'
'Warning Id: Warning Infomation 
'------------------------------------------------'
#Define ERR_Success					0			'System Error,do not modify
#Define ERR_NoCommand				1			'System Error,do not modify
#Define ERR_InvalidOperation		2			'System Error,do not modify
#Define ERR_HomeNotFinish			3			'System Error,do not modify
#Define ERR_NotFinish				4			'System Error,do not modify
#Define ERR_UnknowCommand			5			'System Error,do not modify

'Error Id: Error infomation 
'------------------------------------------------'
#Define ERR_AxisError				1
#Define ERR_AxisAlmError			2
#Define ERR_AxisPelError			3
#Define ERR_AxisNelError			4
#Define ERR_AxisEmgError			5

'*********************************************************************************'
'component:XY_TABLE
'instructions: 
' 1. TYPE can turn the relevant Function into a group
' 2. The user can add/modify the Function, but the action should begin with the following two lines of judgment:
'    XYZ_TABLE.FUNCTION xxx()
'     	IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish    	'Should have this line of judgment
'  		IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish		'Should have this line of judgment
'     ........
'    END FUNCTION
'*********************************************************************************'
TYPE XY_TABLE
	COUNT AS INTEGER=0									'A custom structure requires at least one variable
	DECLARE FUNCTION MOVE_XY(X as INTEGER, Y as INTEGER)As Integer
	DECLARE FUNCTION Home_XY()As Integer	
	DECLARE FUNCTION WaitDone() AS Integer
	DECLARE FUNCTION Stop() AS Integer
	DECLARE FUNCTION ResetMotionErr() AS Integer
END TYPE

'Run to a point's X and Y coordinates
'Note: WaitDone cannot be put in Funtion
FUNCTION XY_TABLE.MOVE_XY(X as INTEGER, Y as INTEGER)As Integer			
	IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish
	IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish
	BASE 0,1
	LINEABS X,Y
END FUNCTION

'Move to XY home
'Note: WaitDone cannot be put in Funtion
FUNCTION XY_TABLE.Home_XY()As Integer
	IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish
	IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish
	BASE 0,1
	HOME_MODE=1
	HOMEN
	Return ERR_Success
END FUNCTION	

'Wait Done
FUNCTION XY_TABLE.WaitDone() AS INTEGER
	IF VR(CF_Stop)=TRUE THEN Return ERR_NotFinish
	IF VR(CF_Err)=TRUE THEN Return ERR_NotFinish
	VR(CS_RunStepCount) += 1
	WAIT DONE
	Return ERR_Success
End FUNCTION

'XY Stop
'Note: WaitDone cannot be put in Funtion
FUNCTION XY_TABLE.Stop()As Integer
	BASE 0,1
	STOPDEC
	Return ERR_Success
END FUNCTION	

'XYZ Reset Error
FUNCTION XY_TABLE.ResetMotionErr()As Integer
	BASE 0,1
	RESETERR                 							'Clear the errors of axis 0,1
	CLEAR_ERROR
	Return ERR_Success
END FUNCTION	
