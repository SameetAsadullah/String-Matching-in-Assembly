dosseg
.model small
.stack 100h
.data
	str1 db 100 DUP('$')
	size1 db 0
	str2 db 100 DUP('$')
	size2 db 0
	str3 db "Enter String 1: $"
	str4 db "Enter String 2: $"
	str5 db "False$"
	str6 db "True$"
.code
main proc
	mov ax,@data
	mov ds,ax
	
	LEA dx, str3				;Printing String
	mov ah,09h
	int 21h
	
	mov si,0
	LEA di, str1
	
	J1:
		mov ah,01h				;Taking first string as an input
		int 21h
		
		CMP al,13
		JE convertString
		
		mov str1[si], al
		INC size1
		INC si
	JMP J1
	
	convertString:				;Converting string into Uppercase Letters
		J2:
			Continue:
			mov al,'$'
			CMP [di], al
			JE secondString
			
			mov al,96
			CMP [di],al
			JA Check_For_UpperCase
			
			INC di
		JNE J2
	
	Convert_Into_UpperCase:		;Converting string into Uppercase Letters
		mov al,32
		sub [di], al
		INC di
		JMP Continue
			
	Check_For_UpperCase:		;Checks for Uppercase Letters
		mov al,123
		CMP [di], al
		JB Convert_Into_UpperCase
		JMP Continue
	
	secondString:
		CMP size2,0
		JNE checkStrings
		
		LEA di, str2			
		mov si,0
			
		LEA dx, str4			;Printing string
		mov ah,09h
		int 21h
		
	
	J3:
		mov ah,01h				;Taking second string as an input
		int 21h
		
		CMP al,13
		JE convertString
		
		mov str2[si], al
		INC size2
		INC si
	JMP J3
		
	checkStrings:				;Checking if strings are equal or not
		mov al,size1
		CMP size2,al
		JNE notEqual
		
		mov ax,0
		PUSH ax
		
		LEA si, str1
		LEA di, str2
		mov dl, size1
		mov dh, size2
		CALL equalsIgnoreCase	;Calling func to checkStrings
		
		PUSH ax
		CMP ax,1
		JE equal
		JNE notEqual
	
	notEqual:					;Printing if strings are not equal
		LEA dx, str5
		mov ah,09h
		int 21h

		JMP endPrograme
	
	equal:						;Printing if strings are equal
		LEA dx, str6
		mov ah,09h
		int 21h
		
	endPrograme:				;Returning control
		mov ah,4ch
		int 21h

main ENDP

;========Procedure to check if strings are equal or not========;

equalsIgnoreCase proc

	mov cx,0
	mov cl,dl
	INC cx
	L1:
		mov al, '$'
		CMP [si], al
		JE returnTrue
		
		mov al, [si]
		CMP [di],al
		JNE return
		INC di
		INC si
	LOOP L1
	
	returnTrue:					;Returns value 1 in stack if strings are equal otherwise 0
		PUSH bp
		mov bp,sp
		add bp,4
		mov ax,1
		mov [bp], ax
		POP bp
	
	return:
		RET						;Returning from function

equalsIgnoreCase ENDP

end main
