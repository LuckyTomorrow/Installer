
DIM SHARED XYZ AS XYZ_TABLE					'聲明 XYZ 是 XYZ_TABLE 元件 
DIM SHARED FC AS FlowCtrl					'聲明 FC 是 FlowCtrl 元件 


'Purpose: 下停止命令
Function UserStop() As Integer
	'XYZ.Stop()								'1. 在 UserStop()，編寫如何停止妳的設備動作...
	Return Err_Success						'(不可移除)
End Function

'Purpose: 發生 Small Error
Function UserErrS() As Integer
	'XYZ.Stop()								'1. 在UserErrS(),編寫發生錯誤時妳要採取的動作...(Ex: 停止)
	Return Err_Success						'(不可移除)
End Function

'Purpose: 發生 Big Error
Function UserErrB() As Integer
	'XYZ.Stop()								'1. 在UserErrB(),編寫發生錯誤時妳要採取的動作...(Ex: 停止)
	Return Err_Success						'(不可移除)
End Function

'Purpose: 下重置錯誤命令
FUNCTION UserResetErr() As INTEGER
	'XYZ.ResetMotionErr()					'4. 請在UserResetErr(),編寫妳的清除錯誤動作
	Return Err_Success						'(不可移除)
End Function


'Purpose: 命令處理副函式
FUNCTION DoCmd() AS INTEGER
	DIM As INTEGER Ret = ERR_UnknowCommand
	
	SELECT CASE INT(VR(C_Cmd))
	CASE 0
		Ret=ERR_NoCommand
	CASE 1									' 系統"回Home"處理 (不可移除)
		Ret=FC.CmdHome()		
	CASE 2									' 系統"回工作原點"處理 (不可移除)
		Ret=FC.CmdOrg()		
	CASE 3  								' 系統"自動運行"處理 (不可移除)
		Ret=FC.CmdRun()
	CASE 4									' 系統"停止"處理(不可移除)
		FC.CmdStop()						' FC.CmdStop()需放在第壹行(不可移除)
		Ret=UserStop()						' 妳的停止處理函式...
	CASE 5									' 系統"暫停"處理(不可移除)
		Ret=FC.CmdPause()
	CASE 6									' 系統"單步運行"處理(不可移除)
		Ret=FC.CmdStep()		
	CASE 7									' 系統"恢復"處理(不可移除)
		Ret=FC.CmdResume()
	CASE 8									' 系統Big Error Occur(不可移除)
		FC.CmdStop_ErrB()					' 不可移除 FC.CmdStop()，且需放在第壹行
		Ret=UserErrB()						' 妳的重大錯誤處理函式...
	CASE 9									' Small Error Occur(不可移除)
		FC.CmdStop_ErrS()					' 不可移除 FC.CmdStop()，且需放在第壹行
		Ret=UserErrS()						' 妳的壹般錯誤處理函式...
	CASE 10									' Reset Error(不可移除)
		Ret=UserResetErr()					' 妳的重置錯誤處理函式...			
		FC.TrigErrTask()					' 不可移除且需放在最後第壹行
		
'+++++CASE 101-199:	Debug Ready狀態下的子動作模式下命令 (用戶自定義...）
	CASE 101								'示範動作
		VR(C_SubMD)=1						'設定"Servo On"子動作模式編號 = 1
		Ret=Err_Success

'+++++CASE 201-299:	Home_Ready狀態下的子動作模式下命令 (用戶自定義...）
	CASE 201								'示範動作
		VR(C_SubMD)=2						'設定"到A點"子動作模式編號 = 2
		Ret=Err_Success

'+++++CASE 301-399:	Org_Ready狀態下的子動作模式下命令 (用戶自定義...）
'	'CASE 301								'用戶自定義動作（命令）

'+++++CASE 401-499:	Run 狀態下的子動作模式下命令 (用戶自定義...）
'	'CASE 401								'用戶自定義動作（命令）

	END Select
	Return Ret
END FUNCTION


'Purpose: 掃描 Motion 端的輸入
'輸出： VR(C_Cmd), 函示 DoCmd() 會依 VR(C_Cmd) 內容, 執行動作
Function ScanMIO()As Integer
	DIM AxNo As Integer
	FOR AxNo=0 TO 2													'掃描3個軸是否有錯誤
		BASE AxNo
		IF STATE=3	And FC.IsErr=false	THEN	 					'3: 軸進入錯誤狀態
			VR(C_Cmd)=	N_CMD_OnErrS								'產生"發生錯誤"命令
		END IF
		
		IF STATE=3 THEN												'3: 軸進入錯誤狀態
			IF MIO.ALM=1 THEN Return ERR_AxisAlmError   			'軸Alarm報警
			IF MIO.PEL=1 THEN Return ERR_AxisPelError   			'軸正極限到位
			IF MIO.NEL=1 THEN Return ERR_AxisNelError   			'軸負極限到位
			IF MIO.EMG=1 THEN Return ERR_AxisEmgError   			'軸急停信號
		END IF
	Next AxNo		
	Return ERR_Success
End Function

'Purpose: 系統掃描迴圈(內容不可修改)
Dim As Integer Ret_1, Ret_2
WHILE(1)
	Ret_1 = ScanMIO()												'掃描 Motion 端的輸入
	Ret_2 = FC.CheckCmd()											'檢查命令是否合法
	IF Ret_2=ERR_Success THEN
		Ret_2=DoCmd()												'依 ScanMIO()掃描狀況, 執行指令
	END IF
	
	IF Ret_2<>ERR_UnknowCommand THEN VR(C_Cmd)=0					'如果命令已經處理過, 清除VR(C_Cmd), VR(C_SubMD)內容
	IF Ret_2<>ERR_NoCommand THEN VR(CS_WarnId)=Ret_2 				'更新	Warning	狀況
	VR(CS_ErrId)=Ret_1												'更新	Error	狀況
	SLEEP(10)
WEND





