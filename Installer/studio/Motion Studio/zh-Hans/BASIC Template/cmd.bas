
DIM SHARED XYZ AS XYZ_TABLE					'声明 XYZ 是 XYZ_TABLE 元件 
DIM SHARED FC AS FlowCtrl					'声明 FC 是 FlowCtrl 元件 


'Purpose: 下停止命令
Function UserStop() As Integer
	'XYZ.Stop()								'1. 在 UserStop()，编写如何停止你的设备动作...
	Return Err_Success						'(不可移除)
End Function

'Purpose: 发生 Small Error
Function UserErrS() As Integer
	'XYZ.Stop()								'1. 在UserErrS(),编写发生错误时你要採取的动作...(Ex: 停止)
	Return Err_Success						'(不可移除)
End Function

'Purpose: 发生 Big Error
Function UserErrB() As Integer
	'XYZ.Stop()								'1. 在UserErrB(),编写发生错误时你要採取的动作...(Ex: 停止)
	Return Err_Success						'(不可移除)
End Function

'Purpose: 下重置错误命令
FUNCTION UserResetErr() As INTEGER
	'XYZ.ResetMotionErr()					'4. 请在UserResetErr(),编写你的清除错误动作
	Return Err_Success						'(不可移除)
End Function


'Purpose: 命令处理副函式
FUNCTION DoCmd() AS INTEGER
	DIM As INTEGER Ret = ERR_UnknowCommand
	
	SELECT CASE INT(VR(C_Cmd))
	CASE 0
		Ret=ERR_NoCommand
	CASE 1									' 系统"回Home"处理 (不可移除)
		Ret=FC.CmdHome()		
	CASE 2									' 系统"回工作原点"处理 (不可移除)
		Ret=FC.CmdOrg()		
	CASE 3  								' 系统"自动运行"处理 (不可移除)
		Ret=FC.CmdRun()
	CASE 4									' 系统"停止"处理(不可移除)
		FC.CmdStop()						' FC.CmdStop()需放在第一行(不可移除)
		Ret=UserStop()						' 你的停止处理函式...
	CASE 5									' 系统"暂停"处理(不可移除)
		Ret=FC.CmdPause()
	CASE 6									' 系统"单步运行"处理(不可移除)
		Ret=FC.CmdStep()		
	CASE 7									' 系统"恢复"处理(不可移除)
		Ret=FC.CmdResume()
	CASE 8									' 系统Big Error Occur(不可移除)
		FC.CmdStop_ErrB()					' 不可移除 FC.CmdStop()，且需放在第一行
		Ret=UserErrB()						' 你的重大错误处理函式...
	CASE 9									' Small Error Occur(不可移除)
		FC.CmdStop_ErrS()					' 不可移除 FC.CmdStop()，且需放在第一行
		Ret=UserErrS()						' 你的一般错误处理函式...
	CASE 10									' Reset Error(不可移除)
		Ret=UserResetErr()					' 你的重置错误处理函式...			
		FC.TrigErrTask()					' 不可移除且需放在最后第一行
		
'+++++CASE 101-199:	Debug Ready状态下的子动作模式下命令 (用户自定义...）
	CASE 101								'示范动作
		VR(C_SubMD)=1						'设定"Servo On"子动作模式编号 = 1
		Ret=Err_Success

'+++++CASE 201-299:	Home_Ready状态下的子动作模式下命令 (用户自定义...）
	CASE 201								'示范动作
		VR(C_SubMD)=2						'设定"到A点"子动作模式编号 = 2
		Ret=Err_Success

'+++++CASE 301-399:	Org_Ready状态下的子动作模式下命令 (用户自定义...）
'	'CASE 301								'用户自定义动作（命令）

'+++++CASE 401-499:	Run 状态下的子动作模式下命令 (用户自定义...）
'	'CASE 401								'用户自定义动作（命令）

	END Select
	Return Ret
END FUNCTION


'Purpose: 扫描 Motion 端的输入
'输出： VR(C_Cmd), 函示 DoCmd() 会依 VR(C_Cmd) 内容, 执行动作
Function ScanMIO()As Integer
	DIM AxNo As Integer
	FOR AxNo=0 TO 2													'扫描3个轴是否有错误
		BASE AxNo
		IF STATE=3	And FC.IsErr=false	THEN	 					'3: 轴进入错误状态
			VR(C_Cmd)=	N_CMD_OnErrS								'产生"发生错误"命令
		END IF
		
		IF STATE=3 THEN												'3: 轴进入错误状态
			IF MIO.ALM=1 THEN Return ERR_AxisAlmError   			'轴Alarm报警
			IF MIO.PEL=1 THEN Return ERR_AxisPelError   			'轴正极限到位
			IF MIO.NEL=1 THEN Return ERR_AxisNelError   			'轴负极限到位
			IF MIO.EMG=1 THEN Return ERR_AxisEmgError   			'轴急停信号
		END IF
	Next AxNo		
	Return ERR_Success
End Function

'Purpose: 系统扫描迴圈(内容不可修改)
Dim As Integer Ret_1, Ret_2
WHILE(1)
	Ret_1 = ScanMIO()												'扫描 Motion 端的输入
	Ret_2 = FC.CheckCmd()											'检查命令是否合法
	IF Ret_2=ERR_Success THEN
		Ret_2=DoCmd()												'依 ScanMIO()扫描状况, 执行指令
	END IF
	
	IF Ret_2<>ERR_UnknowCommand THEN VR(C_Cmd)=0					'如果命令已经处理过, 清除VR(C_Cmd), VR(C_SubMD)内容
	IF Ret_2<>ERR_NoCommand THEN VR(CS_WarnId)=Ret_2 				'更新	Warning	状况
	VR(CS_ErrId)=Ret_1												'更新	Error	状况
	SLEEP(10)
WEND





