' Launched by AutoHotKey script located at "Win+R" "shell:startup"
' Size is defined by both the -screen parameter for the XsrvProcess and the  --geometry parameter for terminator itself.
' https://medium.com/@bhupathy/install-terminator-on-windows-with-wsl-2826591d2156
set shell = CreateObject("Wscript.Shell")

xServerProcessName = "vcxsrv.exe"

RunXserverProcess( xServerProcessName )
RunTerminator()
KillXserverProcess( xServerProcessName )

function RunXserverProcess( strProcess )
	' Wscript.echo "RunXserverProcess"

	'https://gist.github.com/avinoamsn/495db3729d6b24ec065a710250657c16
	if getProcessObject(strProcess) is Nothing Then
		' https://gist.github.com/ctaggart/68ead4d0d942b240061086f4ba587f5f
		' Use -nodecoration instead of -multiwindow to hide the header bar. This turns the window to be un-resizable
		' shell.exec "C:\Program Files\VcXsrv\" & strProcess & " :0 -ac -terminate -lesspointer -multiwindow -resize=none -clipboard -wgl -dpi auto -screen 0 1920x500+0+0@1"
		shell.exec "C:\Program Files\VcXsrv\" & strProcess & " :0 -ac -terminate -lesspointer -nodecoration -resize=none -clipboard -wgl -dpi auto -screen 0 1920x700+0+0@1"
	end if
end function

function RunTerminator()
	' Wscript.echo "RunTerminator"

	'https://gist.github.com/GregRos/6d4ad376cebe7ce1c9e52deaf90171d3
	cdPath = "~"
	if WScript.Arguments.Length > 0 Then
		cdPath = "'$(wslpath -u '" & WScript.Arguments(0) & "')'"
	end if

	'https://stackoverflow.com/questions/38969503/shellexecute-and-wait
	'Wscript.Shell.Run instead of Wscript.Shell.Application.ShellExecute - avoid async shell run and allow execution of code bellow
	shell.run "C:\Windows\System32\wsl.exe bash -c ""cd " & cdPath & "; DISPLAY=:0 terminator --geometry 1920x700""", 0, true
end function

function KillXserverProcess ( strProcess )
	' Wscript.echo "KillXserverProcess"

	'Check if another bash process is running to avoid closing xServer
	' if Not getProcessObject("bash") is Nothing Then
	' 	Wscript.echo "No bash"
	' 	exit function
	' end if

	set Process = getProcessObject(strProcess)
	' Wscript.echo "Process " + Process.name
	if Not Process is Nothing Then
		' Wscript.echo "Nothing"
		Process.terminate
	end if
end function

function getProcessObject ( strProcess )
	' https://stackoverflow.com/questions/19794726/vb-script-how-to-tell-if-a-program-is-already-running
	Dim Process, strObject : strObject = "winmgmts://."
	For Each Process in GetObject( strObject ).InstancesOf( "win32_process" )
	if UCase( Process.name ) = UCase( strProcess ) Then
		set getProcessObject = Process
		exit Function
	end if
	Next
	set getProcessObject = Nothing
end function