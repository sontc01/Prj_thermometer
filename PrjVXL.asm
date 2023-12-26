start bit p1.6
eoc bit p1.4
ale bit p1.5
clk bit P1.7
	
led1 bit p1.0
led2 bit p1.1
led3 bit p1.2
led4 bit p1.3
	
org 000h
	jmp MAIN
org 000bh 
	timer0_interrupt: cpl clk
	reti
org 0030h
main: mov tmod,#02H
	  mov TH0,#0ech
	  setb TR0
	  mov IE,#82H ; thiết lập bit et0 và bit ea
	  lcall setup
	  lcall hex_bcd
	  lcall bcd_7seg
	  lcall hienthi
	  jmp main
	  
	  
setup:	setb ale
		clr ale ; Chân ale cần được kích trong khoảng thời gian ngắn
		setb start
		jb eoc,$ 
		clr start
		mov r7,#150
		de: lcall hienthi
			djnz r7,de
		mov a,p3
		ret
		
hex_bcd:	mov b,#10 ; Lấy 2 phần (Phần chục và phần đơn vị)
			div ab
			mov 10h,b 
			mov 11h,a 
			ret
			
bcd_7seg:	mov dptr,#900h
			mov a,10h
			movc a,@a + dptr ; Phép cộng địa chỉ
			mov 20h,a
			mov a,11h
			movc a,@a + dptr
			mov 21h,a
			ret
			
hienthi:	mov p0,21h
			setb led1
			lcall delay
			anl p1,#0f0h ; p1=----1111, khởi động lại các chân eoc, start, ale

			mov p0,20h
			setb led2
			lcall delay
			anl p1,#0f0h

			mov p0,#09ch
			setb led3
			lcall delay
			anl p1,#0f0h

			mov p0,#0c6h
			setb led4
			lcall delay
			anl p1,#0f0h
			ret
delay: 		mov 7fh,#100
			djnz 7fh,$
			ret
org 900h
db 0C0h,0f9h,0a4h,0b0h,099h,092h,082h,0f8h,080h,090h ; Cho trường hợp anode chung
; db 03fh,006h,05bh,04fh,066h,06dh,07dh,007h,07fh,06fh ; Cho trường hợp Cathode chung
END
