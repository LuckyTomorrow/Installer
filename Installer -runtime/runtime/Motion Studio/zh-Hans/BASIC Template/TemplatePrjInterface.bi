'-----------------------------------------------------------------------'
'ϵͳ�ݴ���: VR(0)-VR(29) ���ɸ���
'-----------------------------------------------------------------------'

'SYSTEM Control[VR�ݴ���](���ɸ�����
'--------------------------------------
#Define C_RunMD     0					'Run-Mode of Control-System
#Define CS_RunSTA				1					'Status of Control-System
#Define CS_RunStepCount				3
#Define C_SubMD					4
#Define C_Cmd					5					'Command 
#Define H_BtnType				7					'Button Type When Button Click
#Define CS_WarnId				8					'Warning ID 
#Define CS_ErrId				9					'Error ID of Control-System

'����ϵͳ���[VR�ݴ���](���ɸ�����
'--------------------------------------
#Define CF_Home					10
#Define CF_Stop					11
#Define CF_Pause				12
#Define CF_Step					13
#Define CF_Err					14
#Define CF_AutoOrg				15

'C_RunMD ģʽ���� (���ɸ�����
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

'CS_RunStatus ģʽ���� (���ɸ�����
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

'C_Cmd ��������(1-99:���ɸ���, 100-199:�û��Զ���...��
#define N_NO_CMD					0
#Define N_CMD_Home					1				'(���ɸ�����
#Define N_CMD_Org					2				'(���ɸ�����
#Define N_CMD_Run					3				'(���ɸ�����
#Define N_CMD_Stop					4				'(���ɸ�����
#Define N_CMD_Pause 					5			'(���ɸ�����
#Define N_CMD_Step					6				'(���ɸ�����
#Define N_CMD_Resume				7				'(���ɸ�����
#Define N_CMD_OnErrB				8				'(���ɸ�����
#Define N_CMD_OnErrS				9				'(���ɸ�����
#Define N_CMD_ResetErr				10				'(���ɸ�����
#Define N_CMD_DbgSub_Start  			100			'Debug_Ready ģʽ�¶������巶ΧStart
#Define N_CMD_DbgSub_End  			199				'Debug_Ready ģʽ�¶������巶ΧEnd
#Define N_CMD_HomeSub_Start  		200				'Home_Ready ģʽ�¶������巶ΧStart
#Define N_CMD_HomeSub_End  			299				'Home_Ready ģʽ�¶������巶ΧEnd
#Define N_CMD_OrgSub_Start  		300				'Org_Ready ģʽ�¶������巶ΧStart
#Define N_CMD_OrgSub_End  			399				'Org_Ready ģʽ�¶������巶ΧEnd
#Define N_CMD_RunSub_Start  		400				'Run ģʽ�¶������巶ΧStart
#Define N_CMD_RunSub_End  			499				'Run ģʽ�¶������巶ΧEnd

#Define _ERR_Success				0
#Define _ERR_NoCommand				1
#Define _ERR_InvalidOperation		2
#Define _ERR_HomeNotFinish			3
#Define _ERR_NotFinish				4
#Define _ERR_UnknowCommand			5

'------------------------------------------------------------------------
TYPE FlowCtrl
	COUNT AS INTEGER=0										'�Զ���ṹ������Ҫ˵��һ������
	DECLARE SUB InitFlags
	DECLARE SUB ResetFlags_Home
	DECLARE SUB ResetFlags_Org
	DECLARE SUB CmdStop_ErrS
	DECLARE SUB CmdStop_ErrB
	DECLARE SUB CmdStop										'ֹͣ()
	DECLARE FUNCTION CmdPause() AS INTEGER					'��ͣ()
	DECLARE FUNCTION CmdResume() AS INTEGER					'�ظ�()
	DECLARE FUNCTION CmdStep() AS INTEGER					'����()
	DECLARE Function IsHomeDone() AS INTEGER
	DECLARE Function IsErr() AS INTEGER
	DECLARE SUB ChecknPause			
	DECLARE SUB PauseErrTask
	DECLARE SUB TrigErrTask									'�����Ѿ�����ֹͣ��Task
	DECLARE SUB I_PauseTask									'��ͣ
	DECLARE SUB I_TrigTask									'����
	DECLARE SUB SetPreMode
	DECLARE SUB SetNextMode									'Ŀǰģʽ������ɺ�, ������һ��ģʽ
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

'Purpose: �»ػ�еԭ������
Function FlowCtrl.CmdHome() As Integer
	VR(C_RunMD)=N_MD_Home
	Return _Err_Success									'(�����Ƴ�)
End Function

'Purpose: �¸�λ(������ԭ��)����
Function FlowCtrl.CmdOrg() As Integer
	VR(C_RunMD)=N_MD_Org
	Return _Err_Success									'(�����Ƴ�)
End Function

'Purpose: ���豸��������
Function FlowCtrl.CmdRun() As Integer
	VR(C_RunMD)=N_MD_Run
	Return _Err_Success									'(�����Ƴ�)
End Function

'Purpose��һ�����ֹͣ()
SUB FlowCtrl.CmdStop_ErrS()		
	I_TrigTask()										''��������ͣ��TASK(����еĻ�), ��Task����������
	VR(CF_Pause)=FALSE
	VR(CF_Step)=FALSE
	VR(CF_Err)=TRUE
	VR(CF_AutoOrg)=FALSE
	VR(C_RunMD)=N_MD_ErrS_Insert						'(�����Ƴ�)
END SUB

'Purpose���ش����ֹͣ()
SUB FlowCtrl.CmdStop_ErrB()		
	I_TrigTask()										''��������ͣ��TASK(����еĻ�), ��Task����������
	VR(CF_Pause)=FALSE
	VR(CF_Step)=FALSE
	VR(CF_Err)=TRUE
	VR(CF_AutoOrg)=FALSE
	VR(C_RunMD)=N_MD_ErrB_Insert						'(�����Ƴ�)
END SUB

	
'Purpose��ֹͣ()
SUB FlowCtrl.CmdStop()		
	I_TrigTask()										''��������ͣ��TASK(����еĻ�), ��Task����������
	VR(CF_Pause)=FALSE
	VR(CF_Step)=FALSE
	VR(CF_Stop)=TRUE
	VR(CF_AutoOrg)=FALSE
	VR(C_RunMD)=N_MD_Stop_Insert
END SUB

'Purpose����ͣ()
FUNCTION FlowCtrl.CmdPause() As Integer				
	VR(CF_Pause)=TRUE
	Return _Err_Success									'(�����Ƴ�)
END FUNCTION

'Purpose���ظ�()
FUNCTION FlowCtrl.CmdResume() As Integer					
	I_TrigTask()
	VR(CF_Pause)=FALSE
	VR(CF_Step)=FALSE
	Return _Err_Success									'(�����Ƴ�)
END FUNCTION

'Purpose������() VR(CS_RunSTA)<>N_ST_RunPause AND
FUNCTION FlowCtrl.CmdStep() As Integer		
	If VR(CS_RunSTA)=N_ST_OrgRdy 	THEN	
		VR(C_RunMD)=N_MD_Run
		CmdPause()
	ELSE
		I_TrigTask()
	End If
	VR(CF_Step)=TRUE
	Return _Err_Success									'(�����Ƴ�)
END FUNCTION

'Purpose���Ƿ���ͣ��ǰTask()
SUB FlowCtrl.ChecknPause
	If VR(CF_Pause)=TRUE OR VR(CF_Step)=TRUE THEN		
		I_PauseTask()									'��ͣ���ȴ�TrigTask����
	End IF
	
END SUB			

'Purpose���Ƿ�ع���еԭ��
Function FlowCtrl.IsHomeDone AS INTEGER
	If VR(CF_Home)=TRUE  THEN		
		Return TRUE
	Else
		Return FALSE								
	End IF
END Function	

'Purpose���Ƿ����д���
Function FlowCtrl.IsErr AS INTEGER
	If VR(CF_Err)=TRUE  THEN		
		Return TRUE
	Else
		Return FALSE								
	End IF
END Function	

'Purpose���ڲ���ʾ, ��ͣ��ǰTask
SUB FlowCtrl.I_PauseTask				
	VR(CS_RunSTA)=N_ST_RunPause							'��������״̬=��ͣ
	TASK_PAUSE	
END SUB

'Purpose���ڲ���ʾ, �ظ�֮ǰ��I_PauseTask()��ͣ��Task
SUB FlowCtrl.I_TrigTask			
	TASK_RESUME
	VR(CS_RunSTA)=N_ST_RunAuto							'��������״̬=����
END SUB

'Purpose: ��������ʱ, ��ͣTask
SUB FlowCtrl.PauseErrTask				
	TASK_PAUSE
END SUB

SUB FlowCtrl.TrigErrTask				
	TASK_RESUME
	VR(CF_Err)=FALSE
END SUB


SUB FlowCtrl.SetPreMode
	SELECT CASE INT(VR(C_RunMD))	
	CASE N_MD_Idle										'(���ɸ�����
		VR(CS_RunSTA)=N_ST_Idle							'(���ɸ�����
	CASE N_MD_DbgRdy									'(���ɸ�����
		VR(CS_RunSTA)=N_ST_DbgRdy						'(���ɸ�������������״̬=N_ST_PRdy
	CASE N_MD_Home										'(���ɸ�����
		VR(CS_RunSTA)=N_ST_Home							'(���ɸ�������������״̬=��ԭ��
	CASE N_MD_HomeRdy									'(���ɸ�����
		VR(CS_RunSTA)=N_ST_HomeRdy						'(���ɸ�������������״̬=��ԭ��
	CASE N_MD_Org										'(���ɸ�����
		VR(CS_RunSTA)=N_ST_Org							'(���ɸ�������������״̬=������ԭ��
	CASE N_MD_OrgRdy									'(���ɸ�����
		VR(CS_RunSTA)=N_ST_OrgRdy						'(���ɸ�������������״̬=N_ST_Rdy
	CASE N_MD_Run										'(���ɸ�����
		VR(CS_RunSTA)=N_ST_RunAuto						'(���ɸ�������������״̬=N_ST_RunAuto
	CASE N_MD_Stop  									'(���ɸ�����
		VR(CS_RunSTA)=N_ST_Stop							'(���ɸ�������������״̬=N_ST_Stop
	CASE N_MD_ErrS										'(���ɸ�����
		VR(CS_RunSTA)=N_ST_ErrS_Pause					'(���ɸ�������������״̬=N_ST_ErrS
	CASE N_MD_ErrB										'(���ɸ�����
		VR(CS_RunSTA)=N_ST_ErrB_Pause					'(���ɸ�������������״̬=N_ST_ErrS
	CASE N_MD_Home_SubActions							'(���ɸ�����
		VR(CS_RunSTA)=N_ST_Home_SubActions				'(���ɸ�����
	CASE N_MD_Dbg_SubActions							'(���ɸ�����
		VR(CS_RunSTA)=N_ST_Dbg_SubActions				'(���ɸ�����
	CASE N_MD_Org_SubActions							'(���ɸ�����
		VR(CS_RunSTA)=N_ST_Org_SubActions				'(���ɸ�����
	CASE N_MD_Run_SubActions							'(���ɸ�����
		VR(CS_RunSTA)=N_ST_Run_SubActions				'(���ɸ�����
	END SELECT

END SUB

'Purpose: Ŀǰģʽ������ɺ�, ����Ŀǰģʽ, ������һ��ģʽ
SUB FlowCtrl.SetNextMode
	SELECT CASE INT(VR(C_RunMD))
	CASE N_MD_Idle
		VR(C_RunMD)=N_MD_DbgRdy
		
	CASE N_MD_DbgRdy
		InitFlags()										'(���ɸ�����
		VR(C_RunMD)=N_MD_DbgRdy
		
	CASE N_MD_Home
		VR(CF_AutoOrg)=TRUE
		VR(C_RunMD)=N_MD_HomeRdy
		
	CASE N_MD_HomeRdy
		ResetFlags_Home()								'(���ɸ�����
		IF VR(CF_AutoOrg)=TRUE THEN
			VR(C_RunMD)=N_MD_Org
		ELSE
			VR(C_RunMD)=N_MD_HomeRdy
		END IF
		
	CASE N_MD_Org
		VR(C_RunMD)=N_MD_OrgRdy
		
	CASE N_MD_OrgRdy
		ResetFlags_Org()								'(���ɸ�����	
		VR(C_RunMD)=N_MD_OrgRdy

	CASE N_MD_Run
		VR(C_RunMD)=N_MD_Org

	CASE N_MD_Stop_Insert								'�����з��� STOP ����
		VR(C_RunMD)=N_MD_Stop							'�л���һ��ģʽΪ N_MD_Stop
	
	CASE N_MD_Stop			
		If(IsHomeDone()) THEN 				
			VR(C_RunMD)=N_MD_HomeRdy
		Else
			VR(C_RunMD)=N_MD_DbgRdy
		End If
		
	CASE N_MD_ErrS_Insert								'�����з��� Error 
		VR(C_RunMD)=N_MD_ErrS							'�л���һ��ģʽΪ N_MD_ERR
	
	CASE N_MD_ErrS
		PauseErrTask()									'(���ɸ�����	
		If(IsHomeDone()) THEN 				
			VR(C_RunMD)=N_MD_HomeRdy
		Else
			VR(C_RunMD)=N_MD_DbgRdy
		End If	
			
	CASE N_MD_ErrB_Insert								'�����з��� Error 
		VR(C_RunMD)=N_MD_ErrB							'�л���һ��ģʽΪ N_MD_ERR
			
	CASE N_MD_ErrB  
		PauseErrTask()									'(���ɸ�����
		VR(C_RunMD)=N_MD_DbgRdy	
		
	CASE N_MD_Dbg_SubActions  							'Debug Ready ģʽ�µ��û��Զ��嶯��...
		VR(C_RunMD)=N_MD_DbgRdy							'��ɺ�-> �л� N_MD_DbgRdy
	
	CASE N_MD_Home_SubActions  							'Home Readyģʽ�µ��û��Զ��嶯��...
		VR(CF_AutoOrg)=FALSE
		VR(C_RunMD)=N_MD_HomeRdy						'��ɺ�-> �л� N_MD_HomeRdy
	
	CASE N_MD_Org_SubActions  							'Org Ready ģʽ�µ��û��Զ��嶯��...
		VR(C_RunMD)=N_MD_OrgRdy							'��ɺ�-> �л� N_MD_OrgRdy

	CASE N_MD_Run_SubActions  							'Run ģʽ�µ��û��Զ��嶯��...
		VR(C_RunMD)=N_MD_Run							'��ɺ�-> �л� N_MD_Run

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
			If Sta<>N_ST_DbgRdy AND Sta<>N_ST_HomeRdy AND Sta<>N_ST_OrgRdy THEN		'�����Ƴ�
				_C_Err = _ERR_InvalidOperation	
			Else
				VR(C_RunMD)=N_MD_Dbg_SubActions					'�趨C_RunMD�� DbgRdy�µ��Ӷ���ģʽ
				_C_Err = _ERR_Success
			End IF
		CASE N_CMD_HomeSub_Start to N_CMD_HomeSub_End
			If Sta<>N_ST_HomeRdy AND Sta<>N_ST_OrgRdy THEN		'�����Ƴ�
				_C_Err = _ERR_InvalidOperation	
			Else
				VR(C_RunMD)=N_MD_Home_SubActions				'�趨C_RunMD�� HomeRdy�µ��Ӷ���ģʽ
				_C_Err = _ERR_Success
			End IF
		CASE N_CMD_OrgSub_Start to N_CMD_OrgSub_End
			If Sta<>N_ST_OrgRdy THEN							'�����Ƴ�
				_C_Err = _ERR_InvalidOperation	
			Else
				VR(C_RunMD)=N_MD_Org_SubActions					'�趨C_RunMD�� HomeRdy�µ��Ӷ���ģʽ
				_C_Err = _ERR_Success
			End IF
		CASE N_CMD_RunSub_Start to N_CMD_RunSub_End
			If Sta<>N_ST_RunAuto AND Sta<>N_ST_RunPause THEN	'�����Ƴ�
				_C_Err = _ERR_InvalidOperation	
			Else
				VR(C_RunMD)=N_MD_Run_SubActions					'�趨C_RunMD�� HomeRdy�µ��Ӷ���ģʽ
				_C_Err = _ERR_Success
			End IF
	END SELECT
	Return _C_Err	
End Function


'-----------------------------------------------------------------------'
'Ԫ��: DInput
'˵��: 
' 1. TYPEָ����Խ���ص�Function, ���һ��Ⱥ�� 
'------------------------------------------------------------------------
TYPE DInput	
	DIM AS Integer DiNo			    							'DI
	DIM As INTEGER CurCount										'Di Filter
	DIM As INTEGER DiFilterMaxCount								'Di Filter
	DIM As INTEGER Start_Filter_Flag							'
	DIM AS Integer DiState, DiState_Pre    						'DI״̬, DIǰһ״̬
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

' DI�Ƿ�������Ե����
Function DInput.IsEdge_R() AS BOOLEAN
	Dim AS Integer Ret
	Ret = I_CheckEdge(1)
	return Ret
END Function

' DI�Ƿ����½�Ե����
Function DInput.IsEdge_F() AS BOOLEAN
	Dim AS Integer Ret
	Ret = I_CheckEdge(0)
	return Ret
END Function