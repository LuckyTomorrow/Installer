DIM SHARED XY AS XY_TABLE					'Declare the XY is XY_TABLE components
DIM SHARED FC AS FlowCtrl					'Declare the FC is FlowCtrl components

DIM JOGFLAG AS INTEGER

'Purpose：Initialization mode
SUB Init
	'In this mode, please write the initialization action...
	BASE 0,1
	SVON
	VL=2000
	VH=8000
	ACC=20000
	DEC=ACC
	
	JOG_VLTIME=200
	JOG_VL=2000
	JOG_VH=8000
	JOG_ACC=20000
	JOG_DEC=JOG_ACC
	
	HOME_VL=2000
	HOME_VH=8000
	HOME_ACC=20000
	HOME_DEC=HOME_ACC
END SUB

'Purpose：Back to the mechanical origin
SUB ModeHome
	'In this mode, write your Org action...
	XY.Home_XY()
	XY.WaitDone()
END SUB

'Purpose：Approval for processing(Contains action: XY Table to work origin, 
'cylinder, peripheral equipment get into the preparation state)
SUB ModeOrg
	'In this mode, write your Org action...
	XY.MOVE_XY VR(CR_OrgX),VR(CR_OrgY)		            	'ORG	
	XY.WaitDone
	VR(CS_RunStepCount)=0
END SUB

'Purpose：Stop mode
SUB ModeStop
	WAIT DONE									'Wait Motion DONE for Stop Command(cmd.bas) 
	'....										'2. In ModeStop()，'write your action after Motion has stopped....
END SUB

'Purpose：Big Error mode
SUB ModeErrB
	WAIT DONE										'Wait Motion DONE for ErrStop Command(cmd.bas) 	
	'In this mode，write your action after Motion has stopped because of big error...
END SUB

'Purpose：Small Error mode
SUB ModeErrS
	WAIT DONE										'Wait Motion DONE for ErrStop Command(cmd.bas) 
	'In this mode，write your action after Motion has stopped because of small error...
	
END SUB
SUB CopyData2MoveReg(Id As Integer)
	DIM AS Integer Index = C_DataIndexBase + (Id-1)*2
	VR(CR_MoveX)= VR(Index+0)
	VR(CR_MoveY)= VR(Index+1)
END SUB

'Purpose：Run mode
SUB ModeRun
	'User custom action code, please write in this mode...
	VR(Current_Point) = 1
	CopyData2MoveReg(VR(Current_Point))
	XY.MOVE_XY VR(CR_MoveX),VR(CR_MoveY)    'point 1
	XY.WaitDone()
	FC.ChecknPause()
	
	VR(Current_Point) = 2
	CopyData2MoveReg(VR(Current_Point))
	XY.MOVE_XY VR(CR_MoveX),VR(CR_MoveY)    'point 2
	XY.WaitDone()	
	FC.ChecknPause()
	
	VR(Current_Point) = 3
	CopyData2MoveReg(VR(Current_Point))
	XY.MOVE_XY VR(CR_MoveX),VR(CR_MoveY)    'point 3
	XY.WaitDone()	
	FC.ChecknPause()
	
	VR(Current_Point) = 4
	CopyData2MoveReg(VR(Current_Point))
	XY.MOVE_XY VR(CR_MoveX),VR(CR_MoveY)    'point 4
	XY.WaitDone()	 
	FC.ChecknPause()
	
	VR(Current_Point) = 1
	CopyData2MoveReg(VR(Current_Point))
	XY.MOVE_XY VR(CR_MoveX),VR(CR_MoveY)    'point 1
	XY.WaitDone()	 
	FC.ChecknPause()
	VR(Current_Point) = 0
END SUB

'-------------------------------------------------------------------- 
'Debug mode:User-defined actions...
'-------------------------------------------------------------------- 
'Purpose: In Debug mode,Demonstration action...Servo On
SUB SubMode_ServoOn
	BASE 0,1
	SVON
END SUB
'Purpose: In Debug mode,Demonstration action...Servo Off
SUB SubMode_ServoOff
	BASE 0,1
	SVOFF
END SUB

'Purpose：Handle the allowed custom actions in Org mode...
SUB ModeDbg_SubActions
	SELECT CASE INT(VR(C_SubMD))
	CASE N_SMD_ServoOn									'Demonstration action...Servo On
		SubMode_ServoOn()
	CASE N_SMD_ServoOff									'Demonstration action...Servo Off
		SubMode_ServoOff()		
	'CASE N_SMD_xxx										'User difined...
	END SELECT
END SUB

'-------------------------------------------------------------------- 
'Org mode:User-defined actions...
'-------------------------------------------------------------------- 
'Purpose: In Org mode,Demonstration action...To Point A
SUB SubMode_GoPointA

END SUB 

'Purpose: JOG P
SUB SubMode_JogAx_P()	 								'JOG+ mod
	BASE VR(CR_JogAxId)
	JOGP
END SUB
'Purpose: JOG N
SUB SubMode_JogAx_N()	 								'JOG- mode
	BASE VR(CR_JogAxId)
	JOGN
END SUB
'Purpose: JogStop
SUB SubMode_JogAxStop()	 								'JOG Stop mode
	BASE VR(CR_JogAxId)
	STOPDEC
END SUB

'Purpose: Save point 1-4's position
SUB SubMode_Teach()	 									'Save Position
	DIM AS Integer Index = C_DataIndexBase + VR(Point_Num)*2
	BASE 0
	VR(Index+0) = DPOS
	BASE 1
	VR(Index+1) = DPOS
END SUB

'Purpose: Teach point 1-4
SUB SubMode_PtP()	 									'Teach
	DIM AS Integer Index = C_DataIndexBase + VR(Point_Num)*2
	VR(CR_MoveX)= VR(Index+0)
	VR(CR_MoveY)= VR(Index+1)

	XY.MOVE_XY VR(CR_MoveX),VR(CR_MoveY)
	XY.WaitDone()
END SUB

'Purpose：Handle the allowed custom actions in Org mode...
SUB ModeHome_SubActions
	SELECT CASE INT(VR(C_SubMD))				        'In accordance with the value of VR(C_SubMD) in SubMode, decided to hanlde the action
	CASE N_SMD_GoPointA									'Demonstration action...To Point A
		SubMode_GoPointA()
	CASE N_SMD_JogAx_P									'JOG P
		SubMode_JogAx_P()
	CASE N_SMD_JogAx_N									'JOG N
		SubMode_JogAx_N()		
	CASE N_SMD_JogAxStop								'Stop JOG
		SubMode_JogAxStop()
	CASE N_SMD_Teach									'Save point 1-4's position
		SubMode_Teach()
	CASE N_SMD_PtP										'Teach
		SubMode_PtP()
	
	'CASE N_SMD_xxx								'User-defined...
	END SELECT
END SUB

'Main control program (Do not modify)
VR(C_RunMD)=N_MD_Idle
WHILE(1)
	FC.SetPreMode()								'(Do not modify)
	SELECT CASE INT(VR(C_RunMD))
	CASE N_MD_Idle								'(Do not modify)
		Init()
	CASE N_MD_Home								'(Do not modify)
		ModeHome()
	CASE N_MD_Org								'(Do not modify)
		ModeORG()
	CASE N_MD_Run								'(Do not modify)
		ModeRun()
	CASE N_MD_Stop  							'(Do not modify)
		ModeStop()
	CASE N_MD_ErrS								'(Do not modify)
		ModeErrS()
	CASE N_MD_ErrB								'(Do not modify)
		ModeErrB()
	CASE N_MD_Home_SubActions					'(Do not modify)
		ModeHome_SubActions()				
	CASE N_MD_Dbg_SubActions					'(Do not modify)
		ModeDbg_SubActions()
	'CASE N_MD_Org_SubActions					'(Do not modify)
	'CASE N_MD_Run_SubActions					'(Do not modify)
	END SELECT
	FC.SetNextMode()							'(Do not modify)
	SLEEP(10)
WEND


