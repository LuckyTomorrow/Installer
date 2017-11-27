'-----------------------------------------------------------------------'
'系统暂存器: VR(0)-VR(29) 不可更动
'-----------------------------------------------------------------------'

'SYSTEM Control[VR暂存器](不可更动）
'--------------------------------------
#Define C_RunMD     0					'Run-Mode of Control-System
#Define CS_RunSTA				1					'Status of Control-System
#Define CS_RunStepCount				3
#Define C_SubMD					4
#Define C_Cmd					5					'Command 
#Define H_BtnType				7					'Button Type When Button Click
#Define CS_WarnId				8					'Warning ID 
#Define CS_ErrId				9					'Error ID of Control-System

'控制系统旗标[VR暂存器](不可更动）
'--------------------------------------
#Define CF_Home					10
#Define CF_Stop					11
#Define CF_Pause				12
#Define CF_Step					13
#Define CF_Err					14
#Define CF_AutoOrg				15

'C_RunMD 模式定义 (不可更动）
'--------------------------------------
#Define N_MD_Idle				0
#Define N_MD_DbgRdy				1
#Define N_MD_Home				2
#Define N_MD_HomeRdy				3
#Define N_MD_Org				4
#Define N_MD_OrgRdy				5
#Define N_MD_Run				6
#Define N_MD_Stop				7
#Define N_MD_ErrB				8
#Define N_MD_ErrS				9
#Define N_MD_Stop_Insert		10
#Define N_MD_ErrB_Insert		11
#Define N_MD_ErrS_Insert		12
#Define N_MD_Dbg_SubActions		13
#Define N_MD_Home_SubActions		14
#Define N_MD_Org_SubActions		15
#Define N_MD_Run_SubActions		16

'CS_RunStatus 模式定义 (不可更动）
'--------------------------------------
#Define N_ST_Idle				0
#Define N_ST_DbgRdy				1
#Define N_ST_Home				2
#Define N_ST_HomeRdy				3
#Define N_ST_Org				4
#Define N_ST_OrgRdy				5
#Define N_ST_RunAuto				6
#Define N_ST_Stop				7
#Define N_ST_ErrB_Pause			8
#Define N_ST_ErrS_Pause			9
#Define N_ST_RunPause			10
#Define N_ST_Dbg_SubActions		13
#Define N_ST_Home_SubActions		14
#Define N_ST_Org_SubActions		15
#Define N_ST_Run_SubActions		16

'C_Cmd 定义命令(1-99:不可更动, 100-199:用户自定义...）
#define N_NO_CMD					0
#Define N_CMD_Home					1				'(不可更动）
#Define N_CMD_Org					2				'(不可更动）
#Define N_CMD_Run					3				'(不可更动）
#Define N_CMD_Stop					4				'(不可更动）
#Define N_CMD_Pause 					5			'(不可更动）
#Define N_CMD_Step					6				'(不可更动）
#Define N_CMD_Resume				7				'(不可更动）
#Define N_CMD_OnErrB				8				'(不可更动）
#Define N_CMD_OnErrS				9				'(不可更动）
#Define N_CMD_ResetErr				10				'(不可更动）
#Define N_CMD_DbgSub_Start  			100			'Debug_Ready 模式下动作定义范围Start
#Define N_CMD_DbgSub_End  			199				'Debug_Ready 模式下动作定义范围End
#Define N_CMD_HomeSub_Start  		200				'Home_Ready 模式下动作定义范围Start
#Define N_CMD_HomeSub_End  			299				'Home_Ready 模式下动作定义范围End
#Define N_CMD_OrgSub_Start  		300				'Org_Ready 模式下动作定义范围Start
#Define N_CMD_OrgSub_End  			399				'Org_Ready 模式下动作定义范围End
#Define N_CMD_RunSub_Start  		400				'Run 模式下动作定义范围Start
#Define N_CMD_RunSub_End  			499				'Run 模式下动作定义范围End

#Define _ERR_Success				0
#Define _ERR_NoCommand				1
#Define _ERR_InvalidOperation		2
#Define _ERR_HomeNotFinish			3
#Define _ERR_NotFinish				4
#Define _ERR_UnknowCommand			5

'------------------------------------------------------------------------
TYPE FlowCtrl
	COUNT AS INTEGER=0										'自定义结构至少需要说明一个变量
	DECLARE SUB InitFlags
	DECLARE SUB ResetFlags_Home
	DECLARE SUB ResetFlags_Org
	DECLARE SUB CmdStop_ErrS
	DECLARE SUB CmdStop_ErrB
	DECLARE SUB CmdStop										'停止()
	DECLARE FUNCTION CmdPause() AS INTEGER					'暂停()
	DECLARE FUNCTION CmdResume() AS INTEGER					'回复()
	DECLARE FUNCTION CmdStep() AS INTEGER					'单步()
	DECLARE Function IsHomeDone() AS INTEGER
	DECLARE Function IsErr() AS INTEGER
	DECLARE SUB ChecknPause			
	DECLARE SUB PauseErrTask
	DECLARE SUB TrigErrTask									'触发已经错误停止的Task
	DECLARE SUB I_PauseTask									'暂停
	DECLARE SUB I_TrigTask									'运行
	DECLARE SUB SetPreMode
	DECLARE SUB SetNextMode									'目前模式动作完成后, 决定下一个模式
	DECLARE FUNCTION CheckCmd() AS INTEGER
	
	DECLARE Function CmdHome() As Integer
	DECLARE Function CmdOrg() As Integer
	DECLARE Function CmdRun() As Integer


END TYPE
'------------------------------------------------------------------------
SUB FlowCtrl.InitFlags
	VR(CF_Stop)=FALSE
	VR(CF_Pause)=FALSE
	VR(CF_Step)=FALSE
	VR(CF_Err)=FALSE
	VR(CF_Home)=FALSE
	VR(CF_AutoOrg)=TRUE
END SUB

SUB FlowCtrl.ResetFlags_Home
	VR(CF_Stop)=FALSE
	VR(CF_Pause)=FALSE
	VR(CF_Step)=FALSE
	VR(CF_Err)=FALSE
	VR(CF_Home)=TRUE
END SUB

SUB FlowCtrl.ResetFlags_Org
	VR(CF_Stop)=FALSE
	VR(CF_Pause)=FALSE
	VR(CF_Step)=FALSE
	VR(CF_Err)=FALSE
END SUB

'Purpose: 下回机械原点命令
Function FlowCtrl.CmdHome() As Integer
	VR(C_RunMD)=N_MD_Home
	Return _Err_Success									'(不可移除)
End Function

'Purpose: 下复位(到工作原点)命令
Function FlowCtrl.CmdOrg() As Integer
	VR(C_RunMD)=N_MD_Org
	Return _Err_Success									'(不可移除)
End Function

'Purpose: 下设备运行命令
Function FlowCtrl.CmdRun() As Integer
	VR(C_RunMD)=N_MD_Run
	Return _Err_Success									'(不可移除)
End Function

'Purpose：一般错误停止()
SUB FlowCtrl.CmdStop_ErrS()		
	I_TrigTask()										''触发被暂停的TASK(如果有的话), 让Task可以往下走
	VR(CF_Pause)=FALSE
	VR(CF_Step)=FALSE
	VR(CF_Err)=TRUE
	VR(CF_AutoOrg)=FALSE
	VR(C_RunMD)=N_MD_ErrS_Insert						'(不可移除)
END SUB

'Purpose：重大错误停止()
SUB FlowCtrl.CmdStop_ErrB()		
	I_TrigTask()										''触发被暂停的TASK(如果有的话), 让Task可以往下走
	VR(CF_Pause)=FALSE
	VR(CF_Step)=FALSE
	VR(CF_Err)=TRUE
	VR(CF_AutoOrg)=FALSE
	VR(C_RunMD)=N_MD_ErrB_Insert						'(不可移除)
END SUB

	
'Purpose：停止()
SUB FlowCtrl.CmdStop()		
	I_TrigTask()										''触发被暂停的TASK(如果有的话), 让Task可以往下走
	VR(CF_Pause)=FALSE
	VR(CF_Step)=FALSE
	VR(CF_Stop)=TRUE
	VR(CF_AutoOrg)=FALSE
	VR(C_RunMD)=N_MD_Stop_Insert
END SUB

'Purpose：暂停()
FUNCTION FlowCtrl.CmdPause() As Integer				
	VR(CF_Pause)=TRUE
	Return _Err_Success									'(不可移除)
END FUNCTION

'Purpose：回复()
FUNCTION FlowCtrl.CmdResume() As Integer					
	I_TrigTask()
	VR(CF_Pause)=FALSE
	VR(CF_Step)=FALSE
	Return _Err_Success									'(不可移除)
END FUNCTION

'Purpose：单步() VR(CS_RunSTA)<>N_ST_RunPause AND
FUNCTION FlowCtrl.CmdStep() As Integer		
	If VR(CS_RunSTA)=N_ST_OrgRdy 	THEN	
		VR(C_RunMD)=N_MD_Run
		CmdPause()
	ELSE
		I_TrigTask()
	End If
	VR(CF_Step)=TRUE
	Return _Err_Success									'(不可移除)
END FUNCTION

'Purpose：是否暂停当前Task()
SUB FlowCtrl.ChecknPause
	If VR(CF_Pause)=TRUE OR VR(CF_Step)=TRUE THEN		
		I_PauseTask()									'暂停，等待TrigTask命令
	End IF
	
END SUB			

'Purpose：是否回过机械原点
Function FlowCtrl.IsHomeDone AS INTEGER
	If VR(CF_Home)=TRUE  THEN		
		Return TRUE
	Else
		Return FALSE								
	End IF
END Function	

'Purpose：是否已有错误
Function FlowCtrl.IsErr AS INTEGER
	If VR(CF_Err)=TRUE  THEN		
		Return TRUE
	Else
		Return FALSE								
	End IF
END Function	

'Purpose：内部函示, 暂停当前Task
SUB FlowCtrl.I_PauseTask				
	VR(CS_RunSTA)=N_ST_RunPause							'更新运行状态=暂停
	TASK_PAUSE	
END SUB

'Purpose：内部函示, 回复之前被I_PauseTask()暂停的Task
SUB FlowCtrl.I_TrigTask			
	TASK_RESUME
	VR(CS_RunSTA)=N_ST_RunAuto							'更新运行状态=运行
END SUB

'Purpose: 发生错误时, 暂停Task
SUB FlowCtrl.PauseErrTask				
	TASK_PAUSE
END SUB

SUB FlowCtrl.TrigErrTask				
	TASK_RESUME
	VR(CF_Err)=FALSE
END SUB


SUB FlowCtrl.SetPreMode
	SELECT CASE INT(VR(C_RunMD))	
	CASE N_MD_Idle										'(不可更动）
		VR(CS_RunSTA)=N_ST_Idle							'(不可更动）
	CASE N_MD_DbgRdy									'(不可更动）
		VR(CS_RunSTA)=N_ST_DbgRdy						'(不可更动）更新运行状态=N_ST_PRdy
	CASE N_MD_Home										'(不可更动）
		VR(CS_RunSTA)=N_ST_Home							'(不可更动）更新运行状态=回原点
	CASE N_MD_HomeRdy									'(不可更动）
		VR(CS_RunSTA)=N_ST_HomeRdy						'(不可更动）更新运行状态=回原点
	CASE N_MD_Org										'(不可更动）
		VR(CS_RunSTA)=N_ST_Org							'(不可更动）更新运行状态=到工作原点
	CASE N_MD_OrgRdy									'(不可更动）
		VR(CS_RunSTA)=N_ST_OrgRdy						'(不可更动）更新运行状态=N_ST_Rdy
	CASE N_MD_Run										'(不可更动）
		VR(CS_RunSTA)=N_ST_RunAuto						'(不可更动）更新运行状态=N_ST_RunAuto
	CASE N_MD_Stop  									'(不可更动）
		VR(CS_RunSTA)=N_ST_Stop							'(不可更动）更新运行状态=N_ST_Stop
	CASE N_MD_ErrS										'(不可更动）
		VR(CS_RunSTA)=N_ST_ErrS_Pause					'(不可更动）更新运行状态=N_ST_ErrS
	CASE N_MD_ErrB										'(不可更动）
		VR(CS_RunSTA)=N_ST_ErrB_Pause					'(不可更动）更新运行状态=N_ST_ErrS
	CASE N_MD_Home_SubActions							'(不可更动）
		VR(CS_RunSTA)=N_ST_Home_SubActions				'(不可更动）
	CASE N_MD_Dbg_SubActions							'(不可更动）
		VR(CS_RunSTA)=N_ST_Dbg_SubActions				'(不可更动）
	CASE N_MD_Org_SubActions							'(不可更动）
		VR(CS_RunSTA)=N_ST_Org_SubActions				'(不可更动）
	CASE N_MD_Run_SubActions							'(不可更动）
		VR(CS_RunSTA)=N_ST_Run_SubActions				'(不可更动）
	END SELECT

END SUB

'Purpose: 目前模式动作完成后, 依照目前模式, 决定下一个模式
SUB FlowCtrl.SetNextMode
	SELECT CASE INT(VR(C_RunMD))
	CASE N_MD_Idle
		VR(C_RunMD)=N_MD_DbgRdy
		
	CASE N_MD_DbgRdy
		InitFlags()										'(不可更动）
		VR(C_RunMD)=N_MD_DbgRdy
		
	CASE N_MD_Home
		VR(CF_AutoOrg)=TRUE
		VR(C_RunMD)=N_MD_HomeRdy
		
	CASE N_MD_HomeRdy
		ResetFlags_Home()								'(不可更动）
		IF VR(CF_AutoOrg)=TRUE THEN
			VR(C_RunMD)=N_MD_Org
		ELSE
			VR(C_RunMD)=N_MD_HomeRdy
		END IF
		
	CASE N_MD_Org
		VR(C_RunMD)=N_MD_OrgRdy
		
	CASE N_MD_OrgRdy
		ResetFlags_Org()								'(不可更动）	
		VR(C_RunMD)=N_MD_OrgRdy

	CASE N_MD_Run
		VR(C_RunMD)=N_MD_Org

	CASE N_MD_Stop_Insert								'过程中发生 STOP 命令
		VR(C_RunMD)=N_MD_Stop							'切换下一个模式为 N_MD_Stop
	
	CASE N_MD_Stop			
		If(IsHomeDone()) THEN 				
			VR(C_RunMD)=N_MD_HomeRdy
		Else
			VR(C_RunMD)=N_MD_DbgRdy
		End If
		
	CASE N_MD_ErrS_Insert								'过程中发生 Error 
		VR(C_RunMD)=N_MD_ErrS							'切换下一个模式为 N_MD_ERR
	
	CASE N_MD_ErrS
		PauseErrTask()									'(不可更动）	
		If(IsHomeDone()) THEN 				
			VR(C_RunMD)=N_MD_HomeRdy
		Else
			VR(C_RunMD)=N_MD_DbgRdy
		End If	
			
	CASE N_MD_ErrB_Insert								'过程中发生 Error 
		VR(C_RunMD)=N_MD_ErrB							'切换下一个模式为 N_MD_ERR
			
	CASE N_MD_ErrB  
		PauseErrTask()									'(不可更动）
		VR(C_RunMD)=N_MD_DbgRdy	
		
	CASE N_MD_Dbg_SubActions  							'Debug Ready 模式下的用户自定义动作...
		VR(C_RunMD)=N_MD_DbgRdy							'完成后-> 切回 N_MD_DbgRdy
	
	CASE N_MD_Home_SubActions  							'Home Ready模式下的用户自定义动作...
		VR(CF_AutoOrg)=FALSE
		VR(C_RunMD)=N_MD_HomeRdy						'完成后-> 切回 N_MD_HomeRdy
	
	CASE N_MD_Org_SubActions  							'Org Ready 模式下的用户自定义动作...
		VR(C_RunMD)=N_MD_OrgRdy							'完成后-> 切回 N_MD_OrgRdy

	CASE N_MD_Run_SubActions  							'Run 模式下的用户自定义动作...
		VR(C_RunMD)=N_MD_Run							'完成后-> 切回 N_MD_Run

	END SELECT
END SUB

FUNCTION FlowCtrl.CheckCmd() AS INTEGER
	Dim As INTEGER Cmd = INT(VR(C_Cmd))
	Dim As INTEGER Sta = INT(VR(CS_RunSTA)) 
	Dim as Integer _C_Err = _ERR_UnknowCommand 
	SELECT CASE INT(Cmd)
		CASE N_NO_CMD
			_C_Err = _ERR_NoCommand
		CASE N_CMD_Home
			If Sta<>N_ST_DbgRdy AND Sta<>N_ST_HomeRdy AND Sta<>N_ST_OrgRdy THEN 
				_C_Err = _ERR_InvalidOperation
			Else
				_C_Err = _ERR_Success
			End IF
			
		CASE N_CMD_Org
			If Sta<>N_ST_HomeRdy THEN 
				_C_Err = _ERR_InvalidOperation
			Else
				_C_Err = _ERR_Success
			End IF
		CASE N_CMD_Run  									' Start to Run-Job
			If Sta<>N_ST_OrgRdy THEN 
				_C_Err = _ERR_InvalidOperation
			Else
				_C_Err = _ERR_Success
			End IF
		CASE N_CMD_Pause									' Pause the Run-Job
			If Sta<>N_ST_RunAuto THEN 
				_C_Err = _ERR_InvalidOperation
			Else
				_C_Err = _ERR_Success
			End IF	
		CASE N_CMD_Resume									' Resume the Run-Job
			If Sta<>N_ST_RunPause THEN 
				_C_Err = _ERR_InvalidOperation
			Else
				_C_Err = _ERR_Success
			End IF
		CASE N_CMD_Step										' Step the Run-Job	
			If Sta<>N_ST_RunPause AND Sta<>N_ST_OrgRdy THEN 
				_C_Err = _ERR_InvalidOperation
			Else
				_C_Err = _ERR_Success
			End IF
		CASE N_CMD_Stop										' Stop
			If Sta<>N_ST_ErrB_Pause AND Sta<>N_ST_ErrS_Pause THEN 
				_C_Err = _ERR_Success 
			Else
				_C_Err = _ERR_InvalidOperation
			End IF
			
		CASE N_CMD_OnErrB									' Big Error Occur
			_C_Err = _ERR_Success
		CASE N_CMD_OnErrS									' Small Error Occur
			_C_Err = _ERR_Success
		CASE N_CMD_ResetErr									' Reset Error
			If Sta<>N_ST_ErrB_Pause AND Sta<>N_ST_ErrS_Pause THEN 
				_C_Err = _ERR_InvalidOperation
			Else
				_C_Err = _ERR_Success
			End IF
		CASE N_CMD_DbgSub_Start to N_CMD_DbgSub_End
			If Sta<>N_ST_DbgRdy AND Sta<>N_ST_HomeRdy AND Sta<>N_ST_OrgRdy THEN		'不可移除
				_C_Err = _ERR_InvalidOperation	
			Else
				VR(C_RunMD)=N_MD_Dbg_SubActions					'设定C_RunMD的 DbgRdy下的子动作模式
				_C_Err = _ERR_Success
			End IF
		CASE N_CMD_HomeSub_Start to N_CMD_HomeSub_End
			If Sta<>N_ST_HomeRdy AND Sta<>N_ST_OrgRdy THEN		'不可移除
				_C_Err = _ERR_InvalidOperation	
			Else
				VR(C_RunMD)=N_MD_Home_SubActions				'设定C_RunMD的 HomeRdy下的子动作模式
				_C_Err = _ERR_Success
			End IF
		CASE N_CMD_OrgSub_Start to N_CMD_OrgSub_End
			If Sta<>N_ST_OrgRdy THEN							'不可移除
				_C_Err = _ERR_InvalidOperation	
			Else
				VR(C_RunMD)=N_MD_Org_SubActions					'设定C_RunMD的 HomeRdy下的子动作模式
				_C_Err = _ERR_Success
			End IF
		CASE N_CMD_RunSub_Start to N_CMD_RunSub_End
			If Sta<>N_ST_RunAuto AND Sta<>N_ST_RunPause THEN	'不可移除
				_C_Err = _ERR_InvalidOperation	
			Else
				VR(C_RunMD)=N_MD_Run_SubActions					'设定C_RunMD的 HomeRdy下的子动作模式
				_C_Err = _ERR_Success
			End IF
	END SELECT
	Return _C_Err	
End Function


'-----------------------------------------------------------------------'
'元件: DInput
'说明: 
' 1. TYPE指令可以将相关的Function, 变成一个群组 
'------------------------------------------------------------------------
TYPE DInput	
	DIM AS Integer DiNo			    							'DI
	DIM As INTEGER CurCount										'Di Filter
	DIM As INTEGER DiFilterMaxCount								'Di Filter
	DIM As INTEGER Start_Filter_Flag							'
	DIM AS Integer DiState, DiState_Pre    						'DI状态, DI前一状态
	Declare Function Init(di As Integer, filter_Count As Integer) AS Integer
	Declare Function IsEdge_R() AS BOOLEAN
	Declare Function IsEdge_F() AS BOOLEAN
	Declare FUNCTION I_CheckEdge( _1or0 AS INTEGER) AS BOOLEAN

END TYPE

Function DInput.Init(di As Integer, filter_Count As Integer) AS Integer
   DiNo = di
   DiFilterMaxCount = filter_Count
   CurCount = 0
   Start_Filter_Flag = FALSE
   DiState = DIN(DiNo)
   DiState_Pre = DiState
	RETURN 0
End Function

FUNCTION DInput.I_CheckEdge( _1or0 AS INTEGER) AS BOOLEAN
	Dim AS Integer Ret = FALSE
	DiState = DIN(DiNo)
	IF DiState<>DiState_Pre AND DiState=_1or0  THEN	
		Start_Filter_Flag = TRUE
	END IF

	IF Start_Filter_Flag=TRUE AND DiState=_1or0 THEN	
		CurCount+=1
	ELSE
		CurCount=0
		Start_Filter_Flag=FALSE
	END IF
	
	IF CurCount>DiFilterMaxCount THEN	
		Ret = TRUE
		CurCount=0
		Start_Filter_Flag=FALSE
	END IF
	
	DiState_Pre = DiState
	return Ret
END FUNCTION

' DI是否有上升缘发生
Function DInput.IsEdge_R() AS BOOLEAN
	Dim AS Integer Ret
	Ret = I_CheckEdge(1)
	return Ret
END Function

' DI是否有下降缘发生
Function DInput.IsEdge_F() AS BOOLEAN
	Dim AS Integer Ret
	Ret = I_CheckEdge(0)
	return Ret
END Function