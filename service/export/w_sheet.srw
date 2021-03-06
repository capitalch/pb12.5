$PBExportHeader$w_sheet.srw
$PBExportComments$Extension Sheet Window class
forward
global type w_sheet from pfc_w_sheet
end type
type p_1 from picture within w_sheet
end type
type cb_x from u_cb_close within w_sheet
end type
type p_2 from picture within w_sheet
end type
end forward

global type w_sheet from pfc_w_sheet
integer width = 2871
event ue_help ( )
p_1 p_1
cb_x cb_x
p_2 p_2
end type
global w_sheet w_sheet

forward prototypes
public subroutine wf_center ()
public subroutine wf_help ()
end prototypes

event ue_help;integer li_tag
li_tag = integer(tag)
	if li_tag <> 0 and not isnull(li_tag) then
		showhelp("service+.hlp",topic!,li_tag)
	else
		showhelp("service+.hlp",index!)
	end if
end event

public subroutine wf_center ();//Declarations:
Environment env
Integer li_RtnCode 
// Turn redraw off
This.SetRedraw(False) 
// Get the screen size
li_RtnCode = GetEnvironment(env) 
// Move window to center of screen
if windowtype = child! then 
	if this.parentwindow().windowtype = response! then return
end if
li_RtnCode = This.move((PixelsToUnits(env.ScreenWidth, XPixelsToUnits!) - This.Width)/2 , &
(PixelsToUnits(env.ScreenHeight, YPixelsToUnits!) - This.Height)/2  ) 
// Turn redraw on
This.SetRedraw(True) 

end subroutine

public subroutine wf_help ();integer li_tag
li_tag = integer(tag)
if li_tag <> 0 and not isnull(li_tag) then
	showhelp("service+.hlp",topic!,li_tag)
else
	showhelp("service+.hlp",index!)
end if
end subroutine

on w_sheet.create
int iCurrent
call super::create
this.p_1=create p_1
this.cb_x=create cb_x
this.p_2=create p_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.p_1
this.Control[iCurrent+2]=this.cb_x
this.Control[iCurrent+3]=this.p_2
end on

on w_sheet.destroy
call super::destroy
destroy(this.p_1)
destroy(this.cb_x)
destroy(this.p_2)
end on

event open;call super::open;if gexpired then open(w_sheet_evaluation)
gnvo.of_setapifunctions() //instantiates api functions gnvo_api
cb_x.x=gnvo_api.of_GetMaxScreenWidth()-70;

end event

event key;call super::key;integer li_tag
if key = keyenter! then
	gnvo_api.keybd_event( 9, 0, 0, 0 ) 
elseif key = keyuparrow! or key = keyuparrow! then
	gnvo_api.keybd_event(16,0,0,0)//shift pressed
	gnvo_api.keybd_event(9,0,0,0)//tab pressed
	gnvo_api.keybd_event(16,0,2,0)//shift released
elseif key = keydownarrow! or key = keydownarrow! then
	gnvo_api.keybd_event(9,0,0,0)//tab pressed
elseif key = keyf4! then
	gnvo_api.of_calc()
elseif key = keyf1! then
	wf_help() //context sensitive help
end if
end event

event closequery;//
end event

type p_1 from picture within w_sheet
integer x = 334
integer y = 1060
integer width = 73
integer height = 64
boolean originalsize = true
string picturename = "AR_LEFT.BMP"
boolean border = true
boolean focusrectangle = false
end type

type cb_x from u_cb_close within w_sheet
integer x = 759
integer y = 20
integer width = 119
integer height = 76
integer taborder = 10
end type

type p_2 from picture within w_sheet
boolean visible = false
integer x = 50
integer y = 1140
integer width = 73
integer height = 80
boolean bringtotop = true
string picturename = "rowind.bmp"
boolean border = true
boolean focusrectangle = false
end type

