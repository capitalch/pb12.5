if not exists(select column_name from syscolumn key join systable where 
    table_name =  'serv_main' and column_name = 'cgst') then
    alter table serv_main add cgst numeric(12,2) not null default 0
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'serv_main' and column_name = 'sgst') then
    alter table serv_main add sgst numeric(12,2) not null default 0
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'serv_main' and column_name = 'igst') then
    alter table serv_main add igst numeric(12,2) not null default 0
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'serv_main' and column_name = 'other_info') then
    alter table serv_main add other_info varchar(40) null
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'service_status' and column_name = 'cgst') then
    alter table service_status add cgst numeric(5,2) null
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'service_status' and column_name = 'sgst') then
    alter table service_status add sgst numeric(5,2) null
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'service_status' and column_name = 'igst') then
    alter table service_status add igst numeric(5,2) null
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'service_status' and column_name = 'gstin') then
    alter table service_status add gstin varchar(20) null
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'serv_main_part_details' and column_name = 'cgst') then
    alter table serv_main_part_details add cgst numeric(5,2) not null default 0
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'serv_main_part_details' and column_name = 'sgst') then
    alter table serv_main_part_details add sgst numeric(5,2) not null default 0
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'serv_main_part_details' and column_name = 'igst') then
    alter table serv_main_part_details add igst numeric(5,2) not null default 0
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'serv_cust_details' and column_name = 'gstin') then
    alter table serv_cust_details add gstin varchar(20) null
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'service_status' and column_name = 'cgst') then
    alter table service_status add cgst numeric(5,2) not null default 0
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'service_status' and column_name = 'sgst') then
    alter table service_status add sgst numeric(5,2) not null default 0
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'service_status' and column_name = 'igst') then
    alter table service_status add igst numeric(5,2) not null default 0
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'service_status' and column_name = 'gstin') then
    alter table service_status add gstin varchar(20) null
end if
go

if not exists(select column_name from syscolumn key join systable where 
    table_name =  'service_status' and column_name = 'website') then
    alter table service_status add website varchar(30) null
end if
go


ALTER TABLE serv_main
ALTER profit SET COMPUTE (amount-(cost_amount+transport+card_charges+job_work+cst+sales_tax+service_tax+surcharge+vat+tot+discount+gst+cgst+sgst+igst))
go

ALTER TABLE serv_main
ALTER amount SET COMPUTE (sale_amount
+serv_charge+sales_tax+service_tax+cst+surcharge+other_charges
+roundoff+card_charges+transport+handling+estimate+vat+tot
+job_work+gst-discount + cgst + sgst + igst);
go

ALTER TRIGGER "delete_serv_main_part_details" before delete order 2 on
DBA.serv_main_part_details
referencing old as old_name
for each row
begin
  declare @rec_type char(10);
  declare @claim_amt decimal(12,2);
  declare @status_id unsigned integer;
  select rec_type,status_id into @rec_type,
    @status_id from serv_main key join rec_master where job_id = old_name.job_id;
  if @status_id in(9,10,11) then //if set already delivered, entry not allowed
    raiserror 17089 'error';
    return
  end if;
  update serv_main set cost_amount = cost_amount-
    (old_name.cost_price*old_name.qty),sale_amount
     = sale_amount-(old_name.sale_price*old_name.qty),sales_tax
     = sales_tax-(old_name.sale_price*old_name.qty*old_name.sales_tax/100),
    cst = cst-(old_name.sale_price*old_name.qty*old_name.cst/100) 
    , cgst = cgst - (old_name.sale_price*old_name.qty*old_name.cgst/100)
    , sgst = sgst - (old_name.sale_price*old_name.qty*old_name.sgst/100)
    , igst = igst - (old_name.sale_price*old_name.qty*old_name.igst/100)
    where
    serv_main.job_id = old_name.job_id
end
go

ALTER TRIGGER "insert_serv_main_part_details" before insert order 1 on
DBA.serv_main_part_details
referencing new as new_name
for each row
begin
  declare @status_id unsigned integer;
  declare @rec_type char(10);
  select status_id,rec_type into @status_id,
    @rec_type from serv_main key join rec_master where
    job_id = new_name.job_id;
  if @status_id in(9,10,11) then //if set already delivered, entry not allowed
    raiserror 17089 'error';
    return
  end if;
  if new_name.sales_tax is null then set new_name.sales_tax=0
  end if;
  if new_name.cst is null then set new_name.cst=0
  end if;
  if new_name.cost_price is null then //or new_name.cost_price = 0 then
    set new_name.cost_price=0
  end if;
  update serv_main set cost_amount = cost_amount+
    (new_name.cost_price*new_name.qty),sale_amount
     = sale_amount+(new_name.sale_price*new_name.qty),sales_tax
     = sales_tax+(new_name.sale_price*new_name.qty*new_name.sales_tax/100),
    cst = cst+(new_name.sale_price*new_name.qty*new_name.cst/100) 
    , cgst = cgst+(new_name.sale_price*new_name.qty*new_name.cgst/100)
    , sgst = sgst+(new_name.sale_price*new_name.qty*new_name.sgst/100)
    , igst = igst+(new_name.sale_price*new_name.qty*new_name.igst/100)
where
    serv_main.job_id = new_name.job_id
end
go

ALTER TRIGGER "update_serv_main_part_details" before update order 3 on
DBA.serv_main_part_details
referencing old as old_name new as new_name
for each row
begin
  declare @rec_type_old char(10);
  declare @rec_type_new char(10);
  declare @status_id unsigned integer;
  select rec_type,status_id into @rec_type_old,
    @status_id from serv_main key join rec_master where
    job_id = old_name.job_id;
  select rec_type into @rec_type_new from serv_main key join
    rec_master where job_id = new_name.job_id;
  if new_name.cost_price is null then
    set new_name.cost_price=0
  end if;
  if @status_id in(9,10,11) then //if set already delivered, entry not allowed
    raiserror 17089 'error';
    return
  end if;
  update serv_main set cost_amount = cost_amount+
    (new_name.cost_price*new_name.qty)-(old_name.cost_price*old_name.qty),
    sale_amount = sale_amount+(new_name.sale_price*new_name.qty)-
    (old_name.sale_price*old_name.qty),sales_tax
     = sales_tax+(new_name.sale_price*new_name.qty*new_name.sales_tax/100)-
    (old_name.sale_price*old_name.qty*old_name.sales_tax/100),
    cst = cst+(new_name.sale_price*new_name.qty*new_name.cst/100)-
    (old_name.sale_price*old_name.qty*old_name.cst/100) 
    , cgst = cgst+(new_name.sale_price*new_name.qty*new_name.cgst/100)-
            (old_name.sale_price*old_name.qty*old_name.cgst/100)
    , sgst = sgst+(new_name.sale_price*new_name.qty*new_name.sgst/100)-
            (old_name.sale_price*old_name.qty*old_name.sgst/100)
    , igst = igst+(new_name.sale_price*new_name.qty*new_name.igst/100)-
            (old_name.sale_price*old_name.qty*old_name.igst/100)

where
    serv_main.job_id = new_name.job_id
end
go

ALTER PROCEDURE "DBA"."proc_insertrow_partdetails"(in @partname char(20),in @partcode char(20),in @costprice real,in @saleprice real,in @qty integer,in @jobno char(15),
in @mode char(1),in @database char(20),in @sales_tax real,in @cst real, in @cgst real, in @sgst real, in @igst real)
begin
  declare @jobid unsigned integer;
  declare @oldqty integer;
  declare @row integer;
  declare @fvalue decimal(10,2);
  declare @lvalue decimal(10,2);
  set @jobno=trim(@jobno);
  select job_id into @jobid from serv_main where job_no = @jobno;
  if @jobid is null then
    raiserror 17003;
    return
  end if;
  select qty into @oldqty from serv_main_part_details where
    job_id = @jobid and part_code = @partcode;
  set @row=@@rowcount;
  if @mode = 'I' then
    -- Insert mode
    --for currency conversion
    select value into @fvalue from currency_table key join
      company_database_table where database_name = @database;
    if @@rowcount = 0 then
      raiserror 17004 'error';
      return
    end if;
    select value into @lvalue from currency_table join service_status on
      service_status.currency_id = currency_table.currency_id;
    if @@rowcount = 0 then
      raiserror 17004 'error'
    end if;
    set @costprice=@costprice*@lvalue/@fvalue*1.0;
    set @saleprice="truncate"(@saleprice*@lvalue/@fvalue+10.0,-1.0);
    if @row = 0 then
      insert into serv_main_part_details(part_name,part_code,cost_price,
        sale_price,qty,job_id,sales_tax,cst,cgst,sgst,igst) values(@partname,@partcode,@costprice,
        @saleprice,@qty,@jobid,@sales_tax,@cst,@cgst,@sgst,@igst)
    else
      update serv_main_part_details set
        qty = qty+@qty where job_id = @jobid and part_code = @partcode
    end if
  else
    if @mode = 'D' then --delete mode
      if @row > 0 then
        if @oldqty > @qty then
          update serv_main_part_details set
            qty = qty-@qty where job_id = @jobid and part_code = @partcode
        else
          delete from serv_main_part_details where job_id = @jobid and part_code = @partcode
        end if
      end if
    end if
  end if end
go

ALTER PROCEDURE "DBA"."sp_insert_receiving_pb"(@job_date timestamp,@job_id unsigned integer,@sl_no char(40),@serv_charge numeric(10,2),@purchase_date date,@opening char(2),@rec_condition varchar(40),@remarks varchar(40),@rec_id unsigned integer,@defect_id unsigned integer,@rec_amt decimal(12,2),@rec_no unsigned integer,@item char(10),@company char(20),@model char(20),@addr1 varchar(70),@addr2 varchar(70),@city char(15),@email char(30),@fax char(15),@name varchar(60),@phone char(30),@pin char(10),@state char(2),@status_id unsigned integer,@accessory varchar(60),@complaint varchar(150),@phone_office varchar(30),@mobile varchar(15),@prev_job_no char(10),@local char(1),@job_no char(10)
,@imei numeric(20,0), @gstin varchar(20))
begin
  declare @product_id unsigned integer;
  declare @error integer;
  declare @cust_id unsigned integer;
  //declare @job_no_numeric decimal(10);
  declare @job_no_prefix char(3);
  if trim(@prev_job_no) <> '' and @prev_job_no is not null then
    if not exists(select job_no from serv_main where job_no = @prev_job_no) then
      raiserror 17091 'Error in previous job';
      return
    end if
  end if;
  //register product
  select product_id into @product_id from serv_product_table key join
    item_master key join company_master where item = @item and
    company = @company and model = @model;
  if @product_id is null then
    insert into serv_product_table(item_id,company_id,model,sync_key) values(
      (select item_id from item_master where item = @item),
      (select company_id from company_master where company = @company),
      @model,'I');
    select @@identity,@@error into @product_id,@error from dummy;
    if @error <> 0 then
      raiserror 17018 'error';
      return
    end if
  end if;
  //register customer
/*
  select cust_id,name,addr1,addr2,phone,email,mobile into #temp from serv_cust_details where
    name = @name;
  if @@rowcount <> 0 then //records with same name
    if @addr1 is null and @addr2 is null and @phone is null and @email is null and @mobile is null then
      select max(cust_id) into @cust_id from #temp where @addr1 is null and @addr2 is null and @phone is null and @email is null and @mobile is null
    elseif @mobile is not null then
      select max(cust_id) into @cust_id from #temp where mobile = @mobile
    elseif @email is not null then
      select max(cust_id) into @cust_id from #temp where email = @email
    elseif @phone is not null then
      select max(cust_id) into @cust_id from #temp where phone = @phone
    elseif @addr1 is not null then
      select max(cust_id) into @cust_id from #temp where addr1 = @addr1
    elseif @addr2 is not null then
      select max(cust_id) into @cust_id from #temp where addr2 = @addr2
    end if
  end if;
*/
//  if @cust_id is null then
    insert into serv_cust_details(addr1,addr2,city,email,fax,name,phone,pin,state,sync_key,
      phone_office,mobile, gstin) values(
      @addr1,@addr2,@city,@email,@fax,@name,@phone,@pin,@state,'I',@phone_office,@mobile, @gstin);
    select @@identity,@@error into @cust_id,@error from dummy;
    if @error <> 0 then
      raiserror 17019 'error';
      return
    end if;
//  end if;
  //insert in serv_main
  if @job_no is null or trim(@job_no) = '' then
    select func_getnewjobno(*) into @job_no from dummy;
    if @@error <> 0 then
      raiserror 17020 'error';
      return
    end if
  end if;
  insert into serv_main(advance,purchase_date,cost_amount,
    cust_id,defect_id,discount,job_date,job_no,last_tran_id,opening,
    other_charges,product_id,rec_condition,rec_id,remarks,
    sale_amount,serv_charge,sl_no,status_id,sync_key,final,
    accessory,complaint,junk,sales_tax,cst,surcharge,roundoff,card_charges,
    transport,handling,estimate,vat,tot,service_tax,job_work,gst,prev_job_no,local,imei) values(
    0,@purchase_date,0,@cust_id,@defect_id,0,@job_date,@job_no,0,@opening,0,
    @product_id,@rec_condition,@rec_id,@remarks,0,@serv_charge,@sl_no,1,'I','N',
    @accessory,@complaint,'N',0,0,0,0,0,0,0,0,0,0,0,0,0,@prev_job_no,@local,@imei);
  select @@identity,@@error into @job_id,@error from dummy;
  if @error <> 0 then
    raiserror 17021 'error';
    return
  end if;
  //advance
  if @rec_amt is not null and @rec_amt > 0 then
    insert into serv_main_receipt(job_id,rec_amt,rec_date,rec_no,rectype) values(
      @job_id,@rec_amt,@job_date,@rec_no,'Y');
    if @error <> 0 then
      raiserror 17022 'error';
      return
    end if
  end if
end
go

ALTER PROCEDURE "DBA"."sp_update_receiving_pb"(@job_date timestamp,@job_id unsigned integer,@job_no char(10),@sl_no char(40),@serv_charge numeric(10,2)
,@purchase_date date,@cust_id unsigned integer,@opening char(2),@rec_condition varchar(40),@remarks varchar(40),@rec_id unsigned integer
,@defect_id unsigned integer,@rec_amt decimal(12,2),@rec_no unsigned integer,@item char(10),@company char(20),@model char(20)
,@addr1 varchar(70),@addr2 varchar(70),@city char(15),@email char(30),@fax char(15),@name varchar(60),@phone char(30),@pin char(10)
,@state char(2),@status_id unsigned integer,@accessory varchar(60),@complaint varchar(150),@phone_office varchar(30),@mobile varchar(15)
,@prev_job_no char(10),@local char(1),@imei numeric(20,0), @gstin varchar(20))
begin
  declare @product_id unsigned integer;
  declare @error integer;
  if trim(@prev_job_no) <> '' and @prev_job_no is not null then
    if not exists(select job_no from serv_main where job_no = @prev_job_no) then
      raiserror 17091 'Error in previous job';
      return
    end if
  end if;
  //register product
  select product_id into @product_id from serv_product_table key join
    item_master key join company_master where item = @item and
    company = @company and model = @model;
  if @product_id is null then
    insert into serv_product_table(item_id,company_id,model,sync_key) values(
      (select item_id from item_master where item = @item),
      (select company_id from company_master where company = @company),
      @model,'I');
    select @@identity,@@error into @product_id,@error from dummy;
    if @@error <> 0 then
      raiserror 17018 'error';
      return
    end if
  end if;
  //register customer
  if @cust_id is not null then
    update serv_cust_details set addr1 = @addr1,addr2 = @addr2,city = @city,
      email = @email,fax = @fax,name = @name,phone = @phone,pin = @pin,
      state = @state,sync_key = 'I',phone_office = @phone_office,mobile = @mobile, gstin = @gstin where
      cust_id = @cust_id;
    if @@error <> 0 then
      raiserror 17028 'error';
      return
    end if
  end if;
  //update in serv_main
  update serv_main set purchase_date = @purchase_date,defect_id
     = @defect_id,job_date = @job_date,job_no = @job_no,
    product_id = @product_id,rec_condition = @rec_condition,
    rec_id = @rec_id,serv_charge = @serv_charge,remarks = @remarks,
    accessory = @accessory,sl_no = @sl_no,
    sync_key = 'I',complaint = @complaint,prev_job_no = @prev_job_no,local = @local, imei = @imei where
    job_id = @job_id;
  if @@error <> 0 then
    raiserror 17029 'Error';
    return
  end if
end
go

ALTER FUNCTION "DBA"."func_deliverjob"(in @job_id unsigned integer,in @mech_id unsigned integer,in @mdate date, in @gstin varchar(20), in @other_info varchar(40))
returns integer
begin
  declare @lret integer;
  declare @dues numeric(12,2);
  declare @status_id unsigned integer;
  declare @recid unsigned integer;
  declare @mmech_id unsigned integer;
  declare @autoreceipt char(1);
  declare @cust_id unsigned integer;
  //first create receipt
  select dues,status_id,mech_id into @dues,@status_id,@mmech_id from serv_main where job_id = @job_id;
  if @status_id in(9,10) then
    return
  end if;
  // set gstin for customer
    if @gstin is not null and trim(@gstin) != '' then
        update serv_cust_details set gstin = @gstin where cust_id = (select cust_id from serv_main where job_id = @job_id);
    end if;
  // set parent company invoice
    if @other_info is not null and trim(@other_info) != '' then
        update serv_main set other_info = @other_info where job_id = @job_id;
    end if;
  //get autoreceipt
  select autoreceipt into @autoreceipt from service_status;
  if @autoreceipt is null then set @autoreceipt='N'
  end if;
  if @mech_id is null then
    if @mmech_id is null then
      raiserror 17086 'Error';
      return
    else
      set @mech_id=@mmech_id
    end if
  end if;
  if @dues is not null and @dues > 0 then
    //create receipts only when @autoreceipt = 'Y'
    if @autoreceipt = 'Y' then
      insert into serv_main_receipt(job_id,rec_amt,rec_date,rectype) values(
        @job_id,@dues,@mdate,'Y');
      set @recid=@@identity;
      //for job sheet receipt purpose
      update serv_main set job_sheet_rec_id = @recid where job_id = @job_id
    end if
  end if;
  //create delivery transaction
  //if status is ready then delivered ok else delivered not ok
  if @status_id = 5 then
    set @status_id=9
  else if @status_id = 6 then
      set @status_id=10
    end if
  end if;
  insert into serv_transaction(job_id,status_id,tran_date,mech_id) values(
    @job_id,@status_id,@mdate,@mech_id);
  return(@lret)
end
go

ALTER TRIGGER "insert_serv_main_receipt" before insert order 1 on
DBA.serv_main_receipt
referencing new as new_name
for each row
begin
  declare @ref_no char(30);
  declare @job_no char(10);
  declare @amount numeric(12,2);
  declare @transferAmount numeric(12,2);
  declare @dues numeric(12,2);
  declare @cgst numeric(12,2);
  declare @sgst numeric(12,2);
  declare @igst numeric(12,2);
  declare @isAdvance char(1);
  declare @other_info varchar(40);
  declare @cust_id unsigned integer;
  declare @gstin varchar(20);
  //get default from service_status
  if new_name.prefix_id is null then
    set new_name.prefix_id=(select rec_prefix_id from
        service_status)
  end if;
  //default rec_date
  if new_name.rec_date is null then set new_name.rec_date=today(*)
  end if;
  //default last rec_no
  if new_name.rec_no is null or new_name.rec_no = 0 then
    set new_name.rec_no=(select last_no+1 from prefix_receipt where
        prefix_id = new_name.prefix_id);
    update prefix_receipt set last_no = last_no+1 where
      prefix_id = new_name.prefix_id
  end if;
  set @ref_no=trim((select prefix from prefix_receipt where prefix_id = 
      new_name.prefix_id))+'/'+string(new_name.rec_no);
  //update serv_main
  update serv_main set advance = advance+(if new_name.rectype = 'Y' then
      new_name.rec_amt else(-new_name.rec_amt) endif) where
    job_id = new_name.job_id;
  select cgst, sgst, igst, dues, trim(other_info), cust_id, amount into @cgst, @sgst, @igst, @dues, @other_info, @cust_id, @amount
    from serv_main where job_id = new_name.job_id;
  select gstin into @gstin from serv_cust_details where cust_id = @cust_id;
  if @dues > 10 then
    set @isAdvance = 'y';
    set @transferAmount = new_name.rec_amt;
  else
    set @isAdvance = 'n';
    set @transferAmount = @amount;
  end if;
  //update accounts package acc
  if(select updateacc from service_status) = 'Y' then
    select job_no into @job_no from serv_main where job_id = new_name.job_id;
    // other_info has neosis invoice no
    call remoteinsertacc(@ref_no, @transferAmount,string(new_name.rec_date),new_name.rectype,@job_no,'I', @cgst, @sgst, @igst, @isAdvance
    , @other_info
    , @gstin); //I for insert
  end if
end
go

ALTER TRIGGER "delete_serv_main_receipt" before delete order 1 on
DBA.serv_main_receipt
referencing old as old_name
for each row
begin
  declare @ref_no char(30);
  declare @job_no char(10);
  if(select status_id from serv_main where job_id = old_name.job_id) in(
    9,10) then
    raiserror 17098 'Cannot delete receipt of delivered jobs'
  end if;
  //update serv_main
  update serv_main set advance = advance-(if old_name.rectype = 'Y' then
      old_name.rec_amt else(-old_name.rec_amt) endif),job_sheet_rec_id = null where
    job_id = old_name.job_id;
  if(select updateacc from service_status) = 'Y' then
    set @ref_no=trim((select prefix from prefix_receipt where prefix_id = 
        old_name.prefix_id))+'/'+string(old_name.rec_no);

    call remoteinsertacc(@ref_no, 0,string(old_name.rec_date),old_name.rectype,'','D'); //D for delete

    //call remoteinsertacc(@ref_no,0,string(old_name.rec_date),old_name.rectype,'','D')
  end if
end
go

ALTER PROCEDURE "DBA"."remoteinsertacc"( in @rec_no char(30) default '',in @rec_amt real default 0,in @rec_date char(10) default '',in @rectype char(1) default 'Y',in @job_no char(10) default '',in @ptype char(1) default 'I'
,in @cgst real default 0,in @sgst real default 0,in @igst real default 0,in @isAdvance char(1) default 'n'
,in @other_info char(40) default null
,in @gstin char(20) default null
) 
at 'techsony2018..dba.remoteinsert'
go

