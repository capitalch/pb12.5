$PBExportHeader$w_sheet_serv_status_ageing.srw
forward
global type w_sheet_serv_status_ageing from w_sheet_serv_status
end type
type rb_1 from u_rb within w_sheet_serv_status_ageing
end type
type rb_2 from u_rb within w_sheet_serv_status_ageing
end type
type rb_3 from u_rb within w_sheet_serv_status_ageing
end type
type rb_4 from u_rb within w_sheet_serv_status_ageing
end type
type rb_5 from u_rb within w_sheet_serv_status_ageing
end type
type rb_6 from u_rb within w_sheet_serv_status_ageing
end type
type rb_7 from u_rb within w_sheet_serv_status_ageing
end type
type rb_8 from u_rb within w_sheet_serv_status_ageing
end type
type rb_9 from u_rb within w_sheet_serv_status_ageing
end type
type gb_4 from groupbox within w_sheet_serv_status_ageing
end type
end forward

global type w_sheet_serv_status_ageing from w_sheet_serv_status
string tag = "1230"
integer width = 3465
integer height = 1612
string title = "Spare Parts Ageing Report"
date iedate = Date("2099-12-30")
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
rb_7 rb_7
rb_8 rb_8
rb_9 rb_9
gb_4 gb_4
end type
global w_sheet_serv_status_ageing w_sheet_serv_status_ageing

type variables
date is_date = date('1900-01-01'),ie_date = date('2099-12-30')
end variables

on w_sheet_serv_status_ageing.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_6=create rb_6
this.rb_7=create rb_7
this.rb_8=create rb_8
this.rb_9=create rb_9
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.rb_5
this.Control[iCurrent+6]=this.rb_6
this.Control[iCurrent+7]=this.rb_7
this.Control[iCurrent+8]=this.rb_8
this.Control[iCurrent+9]=this.rb_9
this.Control[iCurrent+10]=this.gb_4
end on

on w_sheet_serv_status_ageing.destroy
call super::destroy
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.rb_7)
destroy(this.rb_8)
destroy(this.rb_9)
destroy(this.gb_4)
end on

event open;call super::open;wf_setheading('Ageing Report')
end event

type cb_x from w_sheet_serv_status`cb_x within w_sheet_serv_status_ageing
end type

type p_1 from w_sheet_serv_status`p_1 within w_sheet_serv_status_ageing
end type

type uo_1 from w_sheet_serv_status`uo_1 within w_sheet_serv_status_ageing
end type

type dw_4 from w_sheet_serv_status`dw_4 within w_sheet_serv_status_ageing
integer x = 5
integer y = 736
integer width = 3319
integer height = 732
string dataobject = "d_ageing"
boolean resizable = true
borderstyle borderstyle = styleraised!
end type

type cb_2 from w_sheet_serv_status`cb_2 within w_sheet_serv_status_ageing
string tag = "4"
integer x = 2971
integer y = 472
end type

event cb_2::clicked;dw_4.retrieve(is_date,ie_date,gnvo.gcompany.sname)
end event

type cb_3 from w_sheet_serv_status`cb_3 within w_sheet_serv_status_ageing
integer x = 2971
integer y = 616
end type

type st_head from w_sheet_serv_status`st_head within w_sheet_serv_status_ageing
integer y = 524
integer width = 594
end type

type rb_1 from u_rb within w_sheet_serv_status_ageing
integer x = 704
integer y = 480
integer width = 498
boolean bringtotop = true
string text = "All Dates"
boolean checked = true
end type

event clicked;call super::clicked;is_date = date('1900-01-01');ie_date = date('2099-12-30')
dw_4.reset()
end event

type rb_2 from u_rb within w_sheet_serv_status_ageing
integer x = 704
integer y = 556
integer width = 498
boolean bringtotop = true
string text = "Less Than 90 Days"
end type

event clicked;call super::clicked;is_date = relativedate(today(),-90);ie_date = today()
dw_4.reset()
end event

type rb_3 from u_rb within w_sheet_serv_status_ageing
integer x = 704
integer y = 628
integer width = 498
boolean bringtotop = true
string text = "More Than 90 Days"
end type

event clicked;call super::clicked;is_date = date('1900-01-01');ie_date = relativedate(today(),-90)
dw_4.reset()
end event

type rb_4 from u_rb within w_sheet_serv_status_ageing
integer x = 1463
integer y = 480
integer width = 530
boolean bringtotop = true
string text = "More Than 180 Days"
end type

event clicked;call super::clicked;is_date = date('1900-01-01');ie_date = relativedate(today(),-180)
dw_4.reset()
end event

type rb_5 from u_rb within w_sheet_serv_status_ageing
integer x = 1463
integer y = 556
integer width = 530
boolean bringtotop = true
string text = "More Than 360 Days"
end type

event clicked;call super::clicked;is_date = date('1900-01-01');ie_date = relativedate(today(),-360)
dw_4.reset()
end event

type rb_6 from u_rb within w_sheet_serv_status_ageing
integer x = 1463
integer y = 628
integer width = 503
boolean bringtotop = true
string text = "More than 700 days"
end type

event clicked;call super::clicked;is_date = date('1900-01-01');ie_date = relativedate(today(),-700)
dw_4.reset()
end event

type rb_7 from u_rb within w_sheet_serv_status_ageing
integer x = 2231
integer y = 480
integer width = 530
boolean bringtotop = true
string text = "More than 1000 days"
end type

event clicked;call super::clicked;is_date = date('1900-01-01');ie_date = relativedate(today(),-1000)
dw_4.reset()
end event

type rb_8 from u_rb within w_sheet_serv_status_ageing
integer x = 2231
integer y = 556
integer width = 535
boolean bringtotop = true
string text = "More than 2000 Days"
end type

event clicked;call super::clicked;is_date = date('1900-01-01');ie_date = relativedate(today(),-2000)
dw_4.reset()
end event

type rb_9 from u_rb within w_sheet_serv_status_ageing
integer x = 2231
integer y = 628
integer width = 535
boolean bringtotop = true
string text = "More than 3000 Days"
end type

event clicked;call super::clicked;is_date = date('1900-01-01');ie_date = relativedate(today(),-3000)
dw_4.reset()
end event

type gb_4 from groupbox within w_sheet_serv_status_ageing
integer x = 649
integer y = 432
integer width = 2245
integer height = 284
integer taborder = 21
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 80263581
borderstyle borderstyle = styleraised!
end type

