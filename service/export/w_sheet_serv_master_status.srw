$PBExportHeader$w_sheet_serv_master_status.srw
forward
global type w_sheet_serv_master_status from w_sheet_serv
end type
type dw_1 from u_dw_linkage_status within w_sheet_serv_master_status
end type
type cb_1 from u_cb within w_sheet_serv_master_status
end type
type cb_2 from u_cb within w_sheet_serv_master_status
end type
type st_1 from statictext within w_sheet_serv_master_status
end type
end forward

global type w_sheet_serv_master_status from w_sheet_serv
string tag = "1300"
integer x = 214
integer y = 221
integer width = 3547
integer height = 1660
string title = "Stock Master Status report"
dw_1 dw_1
cb_1 cb_1
cb_2 cb_2
st_1 st_1
end type
global w_sheet_serv_master_status w_sheet_serv_master_status

on w_sheet_serv_master_status.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.st_1
end on

on w_sheet_serv_master_status.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.st_1)
end on

event open;call super::open;dw_1.settransobject(casio_tr)
dw_1.width=gnvo_api.of_GetMaxScreenWidth();
end event

type cb_x from w_sheet_serv`cb_x within w_sheet_serv_master_status
integer x = 2802
integer y = 44
end type

type p_1 from w_sheet_serv`p_1 within w_sheet_serv_master_status
end type

type dw_1 from u_dw_linkage_status within w_sheet_serv_master_status
integer x = 27
integer y = 192
integer width = 2894
integer height = 1288
integer taborder = 10
boolean bringtotop = true
boolean titlebar = false
string dataobject = "d_master_status"
boolean minbox = true
boolean resizable = true
borderstyle borderstyle = styleraised!
end type

type cb_1 from u_cb within w_sheet_serv_master_status
string tag = "3"
integer x = 2208
integer y = 32
integer taborder = 10
boolean bringtotop = true
string text = "Retrieve"
end type

event clicked;call super::clicked;dw_1.retrieve(gnvo.gcompany.sname)
end event

type cb_2 from u_cb within w_sheet_serv_master_status
integer x = 1842
integer y = 32
integer taborder = 11
boolean bringtotop = true
string text = "Reset"
end type

event clicked;call super::clicked;dw_1.reset()
end event

type st_1 from statictext within w_sheet_serv_master_status
integer x = 37
integer y = 36
integer width = 1065
integer height = 76
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Master Spare Parts Status report"
boolean focusrectangle = false
end type

