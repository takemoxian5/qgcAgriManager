
macro CY_InsertMatchAuto(hbuf,symbol_record)
{
       
       if(symbol_record.Type!="Function")
	{	
	return 0
	}
    ln=symbol_record.lnFirst   //数组概念第一行 为0
    lnMax=symbol_record.lnLim   //计量，1行 为1
    lnLast=lnMax-1
    symbol_fun_flag=0               //函数尾处理标志
    match_num=0
    match_lnFirst=""  
    ln_First=symbol_record.lnFirst
  //  match_lnLast= "                                                                                                                               " 
   
    //行判断      
    //ln是实际行-1，lnMax 是实际行
         if(ln>=File_lnLast)   //最后一行    ln+1容易出错
         {
         isym=isym+1
         continue
         }
       ////////////////////       
            while(ln<lnLast) 
            {
                szLine2=GetBufLine( hbuf, ln+1)
                szLine2=Trimleft(szLine2)
                szLine2_len=strlen(szLine2)
                //确定是函数或条件语句 开头
                if(szLine2[0]=="{")
                {
                    if(symbol_fun_flag==0)
                    {
                     if(lnLast-ln_First<10)
                    delMatchTitle(hbuf,ln,lnLast)
                    else
                    InsertMatchTitle(hbuf,ln,lnLast)
          
                    symbol_fun_flag=1
                    }
                    //if,for,while的处理
                    else if(symbol_fun_flag==1)
                   {

                    //  1，if,for,while的条件注释
                   szLine_first=GetBufLine( hbuf, ln) 
                   gg_start=strstr(szLine_first,"//")
                       //条件注释，没有就加
                       if(gg_start==0xffffffff)
                       { 
                    buf_title="//$"
                    szLine_first=Trimright(szLine_first)
                    szLine_first_len=strlen(szLine_first)
                    if(szLine_first_len>20)
                    szLine_first_len2=(szLine_first_len/pitch_len+1)*pitch_len
                    else szLine_first_len2=20
                    blank_len=szLine_first_len2-szLine_first_len
                    BlankString=CreateBlankString(blank_len-1)
                    buf_title=cat(BlankString, buf_title )
                    end_title=cat(szLine_first, buf_title )
                    PutBufLine ( hbuf, ln, end_title ) 
                       }
                    //  2，if,for,while的结尾注释，起始行堆栈
                          
                    //整型数组 比较麻烦
                    //低地址 存低位		
                    ln_temp=ln  
                    //ln_temp=ln%1000
                   //  msg(ln)
					if(strlen(match_lnFirst)<(match_num+1)*2)
					{
					match_lnFirst=cat(match_lnFirst,CharFromAscii (32+ln_temp-(ln_temp/100)*100))	//字符串最小字符为32
					match_lnFirst=cat(match_lnFirst,CharFromAscii (32+ln_temp/100))
					}
					else 
					{
					match_lnFirst[match_num*2]=CharFromAscii (32+ln_temp-(ln_temp/100)*100)	//字符串最小字符为32
					match_lnFirst[match_num*2+1]=CharFromAscii (32+ln_temp/100)
					}
					// msg("入@match_num@=@ln@")
                   		match_num=match_num+1  //入栈
                   
					
                   }        
  
                }
                //确定是条件语句 结尾,且不是函数结尾
             else  if(szLine2[0]=="}"&&symbol_fun_flag==1&&match_num>0)
             {
               //  2，if,for,while的结尾注释，结尾行堆栈
               match_lnLast_num=ln+1   //szLine2在ln+1 
            //参数提取，出栈
             match_num=match_num-1  ////出栈 
		    buf_tempp=AsciiFromChar(match_lnFirst[match_num*2])-32+(AsciiFromChar(match_lnFirst[match_num*2+1])-32)*100
	        match_lnFirst_num=buf_tempp
	        //复合语句长度判断,10句
           if(match_lnLast_num-match_lnFirst_num>9)
            InsertMatchTitle(hbuf,match_lnFirst_num,match_lnLast_num)
          else 
           delMatchTitle(hbuf,match_lnFirst_num,match_lnLast_num)
           
          //  msg("出@match_num@=@match_lnFirst_num@")
           //  msg(match_lnFirst_num)
  
             }
             
             ln=ln+1   
            }
 
}
 macro CY_InsertMatch()
{
	hwnd = GetCurrentWnd()
	hbuf = GetCurrentBuf() 
	File_lnMax = GetBufLineCount (hbuf)  //1~
	File_lnLast=File_lnMax-1
	if (hwnd == 0 || buff == 0 )
	return 0
//当前文件 符号(函数名和endif,include等)遍历
    isymMax = GetBufSymCount (hbuf)
    isym = 0
        pitch_len=15
    while(isym<isymMax)
    {        
    symname = GetBufSymName (hbuf, isym)
    symbol_record =GetBufSymLocation(hbuf, isym)
       if(symbol_record.Type!="Function")
	{	
    isym=isym+1
	continue
	}
    ln=symbol_record.lnFirst   //数组概念第一行 为0
    lnMax=symbol_record.lnLim   //计量，1行 为1
    lnLast=lnMax-1
    symbol_fun_flag=0               //函数尾处理标志
    match_num=0
    match_lnFirst=""  
    ln_First=symbol_record.lnFirst
  //  match_lnLast= "                                                                                                                               " 
   
    //行判断      
    //ln是实际行-1，lnMax 是实际行
         if(ln>=File_lnLast)   //最后一行    ln+1容易出错
         {
         isym=isym+1
         continue
         }
       ////////////////////       
            while(ln<lnLast) 
            {
                szLine2=GetBufLine( hbuf, ln+1)
                szLine2=Trimleft(szLine2)
                szLine2_len=strlen(szLine2)
                //确定是函数或条件语句 开头
                if(szLine2[0]=="{")
                {
                    if(symbol_fun_flag==0)
                    {
                     if(lnLast-ln_First<10)
                    delMatchTitle(hbuf,ln,lnLast)
                    else
                    InsertMatchTitle(hbuf,ln,lnLast)
          
                    symbol_fun_flag=1
                    }
                    //if,for,while的处理
                    else if(symbol_fun_flag==1)
                   {

                    //  1，if,for,while的条件注释
                    ln_find=ln
                   while(1)
                  	{
                  	 szLine_first=GetBufLine( hbuf, ln_find) 
                  	this_type =  GetFirstWord(szLine_first)
                  	if(this_type=="for"||this_type=="if"||this_type=="while")break                  	
                  	ln=ln-1
                  	if(ln<ln_find-3)
                  	{
                  	ln=ln_find
					break
                  	}
               		}

                   gg_start=strstr(szLine_first,"//")
                       //条件注释，没有就加
                       if(gg_start==0xffffffff)
                       { 
                    buf_title="//$"
                    szLine_first=Trimright(szLine_first)
                    szLine_first_len=strlen(szLine_first)
                    if(szLine_first_len>20)
                    szLine_first_len2=(szLine_first_len/pitch_len+1)*pitch_len
                    else szLine_first_len2=20
                    blank_len=szLine_first_len2-szLine_first_len
                    BlankString=CreateBlankString(blank_len-1)
                    buf_title=cat(BlankString, buf_title )
                    end_title=cat(szLine_first, buf_title )
                    PutBufLine ( hbuf, ln, end_title ) 
                       }
                    //  2，if,for,while的结尾注释，起始行堆栈
                          
                    //整型数组 比较麻烦
                    //低地址 存低位		
                    ln_temp=ln  
                    //ln_temp=ln%1000
                   //  msg(ln)
					if(strlen(match_lnFirst)<(match_num+1)*2)
					{
					match_lnFirst=cat(match_lnFirst,CharFromAscii (32+ln_temp-(ln_temp/100)*100))	//字符串最小字符为32
					match_lnFirst=cat(match_lnFirst,CharFromAscii (32+ln_temp/100))
					}
					else 
					{
					match_lnFirst[match_num*2]=CharFromAscii (32+ln_temp-(ln_temp/100)*100)	//字符串最小字符为32
					match_lnFirst[match_num*2+1]=CharFromAscii (32+ln_temp/100)
					}
					// msg("入@match_num@=@ln@")
                   		match_num=match_num+1  //入栈
                   
					ln=ln_find
                   }        
  
                }
                //确定是条件语句 结尾,且不是函数结尾
             else  if(szLine2[0]=="}"&&symbol_fun_flag==1&&match_num>0)
             {
               //  2，if,for,while的结尾注释，结尾行堆栈
               match_lnLast_num=ln+1   //szLine2在ln+1 
            //参数提取，出栈
             match_num=match_num-1  ////出栈 
		    buf_tempp=AsciiFromChar(match_lnFirst[match_num*2])-32+(AsciiFromChar(match_lnFirst[match_num*2+1])-32)*100
	        match_lnFirst_num=buf_tempp
	        //复合语句长度判断,10句
           if(match_lnLast_num-match_lnFirst_num>9)
            InsertMatchTitle(hbuf,match_lnFirst_num,match_lnLast_num)
          else 
           delMatchTitle(hbuf,match_lnFirst_num,match_lnLast_num)
           
          //  msg("出@match_num@=@match_lnFirst_num@")
           //  msg(match_lnFirst_num)
  
             }
             
             ln=ln+1   
            }
    isym=isym+1
    }
    /*
	{
        //参数初始化，确定开始的行，和字符串
		sel = GetWndSel(hwnd)
        cur_line = GetBufLine( buff, sel.lnFirst )
        //当前光标后，或者选中的第一个字符
        cur_char = cur_line[sel.ichFirst]
        match_sel = 0

        
	}*/
}

macro InsertLineTitleCY(hbuf,lnfirst,lnLast)
{
ln=lnfirst

	while(ln<=lnLast)
	{
	                   szLine_first=GetBufLine( hbuf, ln) 
	                   gg_start=strstr(szLine_first,"//")
	                       //条件注释，没有就加
	                       if(gg_start==0xffffffff)
	                       { 
	                    buf_title="//$"
	                    szLine_first=Trimright(szLine_first)
	                    szLine_first_len=strlen(szLine_first)
	                    if(szLine_first_len>20)
	                    szLine_first_len2=(szLine_first_len/pitch_len+1)*pitch_len
	                    else szLine_first_len2=20
	                    blank_len=szLine_first_len2-szLine_first_len
	                    BlankString=CreateBlankString(blank_len-1)
	                    buf_title=cat(BlankString, buf_title )
	                    end_title=cat(szLine_first, buf_title )
	                    PutBufLine ( hbuf, ln, end_title ) 
	                       }
	ln=ln+1                  
	}
}
macro InsertMatchForTitle(hbuf,ln,lnLast)
{
        szLine_last=GetBufLine( hbuf, lnLast)
        szLine_last_temp=Trimright(szLine_last)
        szLine_last_len=strlen(szLine_last_temp)
        if(szLine_last_temp[szLine_last_len-1]!="}")
        return 0
      //  msg(ln)
        szLine_first=GetBufLine( hbuf, ln)
        szLine_first=Trimleft(szLine_first)
        gg_start=strstr(szLine_first,"//")
        gg_start=strstr(szLine_first,"//")
        //去条件注释
        if(gg_start!=0xffffffff)
        szLine_first=strmid( szLine_first, 0,gg_start )
        szLine_first=Trimright(szLine_first)
        buf_title="}/*end of @szLine_first@*/"
        BlankString=CreateBlankString(szLine_last_len-1)
        buf_title=cat(BlankString, buf_title )
        PutBufLine ( hbuf, lnLast, buf_title ) 
   
}
//复合语句注释
macro InsertMatchTitle(hbuf,ln,lnLast)
{      
        szLine_last=GetBufLine( hbuf, lnLast)         
        kh_start=strstr(szLine_last,"}")
        if(kh_start==0xffffffff)
        return 0
        szLine_last_len=strlen(szLine_last)
        
    //    gx_start=strstr(szLine_last,"/*")				//极端情况
     //    if(gx_start!=0xffffffff) return 0  
          gx_start=strstr(szLine_last,"*/")  
         if(gx_start!=0xffffffff) return 0
                     
	        //szLine_last_temp=Trimright(szLine_last)
	       // szLine_last_len=strlen(szLine_last_temp)
        
       
      //  msg(ln)
        szLine_first=GetBufLine( hbuf, ln)
        
      	gx_start=strstr(szLine_first,"/*")
         if(gx_start!=0xffffffff) return 0
      //    gx_start=strstr(szLine_first,"*/")  		//极端情况
       //  if(gx_start!=0xffffffff) return 0
         
        szLine_first=Trimleft(szLine_first)
        gg_start=strstr(szLine_first,"//")
       // 
        //去条件注释
        if(gg_start!=0xffffffff)
        {
        //个别条件语句过长
        if(gg_start+szLine_last_len>=120)
        {
		xkh_start=strstr(szLine_first,"(")
		if(xkh_start!=0xffffffff)
		gg_start=xkh_start
        }
     
        szLine_first=strmid( szLine_first, 0,gg_start )
        }
        //去条件注释
        if(gg_start!=0xffffffff)
        szLine_first=strmid( szLine_first, 0,gg_start )
        szLine_first=Trimright(szLine_first)
        buf_title="}//end of @szLine_first@"
        BlankString=CreateBlankString(kh_start)
        buf_title=cat(BlankString, buf_title )
        PutBufLine ( hbuf, lnLast, buf_title ) 
   
}
macro delMatchTitle(hbuf,ln,lnLast)
{      
        szLine_last=GetBufLine( hbuf, lnLast)
        
        kh_start=strstr(szLine_last,"}")
         if(kh_start==0xffffffff)
        return 0
        //szLine_last_temp=Trimright(szLine_last)
       // szLine_last_len=strlen(szLine_last_temp)
            gx1_start=strstr(szLine_last,"/*")  
          gx2_start=strstr(szLine_last,"*/") 
 {
        if(gx1_start!=0xffffffff&&gx2_start==0xffffffff) return 0
        if(gx1_start==0xffffffff&&gx2_start!=0xffffffff) return 0

 }
          gx_start=strstr(szLine_last,"while")  
         if(gx_start!=0xffffffff) return 0
        buf_title="}"//删除注释

        //kh_start=0
        BlankString=CreateBlankString(kh_start)
        buf_title=cat(BlankString, buf_title )
        PutBufLine ( hbuf, lnLast, buf_title ) 
   
}
macro siMatchDelim2()
{
	hwnd = GetCurrentWnd()
	buff = GetCurrentBuf()
    if (hwnd != 0 && buff != 0 )
	{
        //参数初始化，确定开始的行，和字符串
		sel = GetWndSel(hwnd)
        cur_line = GetBufLine( buff, sel.lnFirst )
        //当前光标后，或者选中的第一个字符
        cur_char = cur_line[sel.ichFirst]
        match_sel = 0

        
		if( siIsLeftDelim( cur_line, sel.ichFirst ) )
            match_sel = siMatchLeftDelim( cur_char, buff, sel, hwnd )
		else if( siIsRightDelim( cur_line, sel.ichFirst ) )
  		    match_sel = siMatchRightDelim( cur_char, buff, sel, hwnd )
		else
            match_sel = siFindFirstLeftDelim(buff, sel, hwnd )

		if( match_sel )
		{
    	    match_sel.lnLast = match_sel.lnFirst
    	    match_sel.ichLim = match_sel.ichFirst
		    SetWndSel( hwnd, match_sel )

		    // If the new selection is not visible scroll to it
			_tsUpdateInsertion(hwnd, match_sel)
		}
	}
}
macro _tsUpdateInsertion(hwnd, sel)
{
	lnTop = GetWndVertScroll(hwnd);
	cLines = GetWndLineCount(hwnd);

	if (lnTop > sel.lnFirst)
	{
		ScrollWndToLine(hwnd, sel.lnFirst); 
	}

	if (lnTop + cLines <= sel.lnFirst)
	{
		lnTop = sel.lnLast - cLines + 1;
		ScrollWndToLine(hwnd, lnTop); 
	}
}



macro siMatchLeftDelim( left_delim, buff, sel, hwnd )
{
    // Special case paren because the built in stuff is much faster
    if( cur_char == "(" )
    {
        Paren_Right
		return GetWndSel(hwnd)
    }
    
    right_delim = siGetRightDelim( left_delim )
    nest = 1
    
    cur_line = sel.lnFirst
    cur_pos = sel.ichFirst + 1
    
    buff_lines = GetBufLineCount(buff) 
    while( cur_line < buff_lines )
    {
        line = GetBufLine( buff, cur_line )
        line_len = GetBufLineLength( buff, cur_line )
        while( cur_pos < line_len )
        {
            if( line[cur_pos] == left_delim )
                nest = nest + 1
            else if( line[cur_pos] == right_delim )
            {
                nest = nest - 1
                if( nest == 0 )
                {
                    sel.lnFirst = cur_line
                    sel.ichFirst = cur_pos
                    return sel
                }
            }

            cur_pos = cur_pos + 1
        }

        cur_line = cur_line + 1
        cur_pos = 0;
    }

    return 0
}

macro siMatchRightDelim( right_delim, buff, sel, hwnd )
{
    // Special case paren because the built in stuff is much faster
    if( cur_char == ")" )
    {
        Paren_Left
		return GetWndSel(hwnd)
    }
            
    left_delim = siGetLeftDelim( right_delim )
    nest = 1
    
    cur_line = sel.lnFirst
    cur_pos = sel.ichFirst - 1
    
    while( cur_line >= 0 )
    {
        line = GetBufLine( buff, cur_line )
        while( cur_pos >= 0 )
        {
            if( line[cur_pos] == right_delim )
                nest = nest + 1
            else if( line[cur_pos] == left_delim )
            {
                nest = nest - 1
                if( nest == 0 )
                {
                    sel.lnFirst = cur_line
                    sel.ichFirst = cur_pos
                    return sel
                }
            }

            cur_pos = cur_pos - 1
        }

        cur_line = cur_line - 1
        if( cur_line >= 0 )
            cur_pos = GetBufLineLength( buff, cur_line )
    }

    return 0
}

macro siFindFirstLeftDelim( buff, sel, hwnd )
{
    while( sel.lnFirst >= 0 )
    {
        line = GetBufLine( buff, sel.lnFirst )
        while( sel.ichFirst >= 0 )
        {
            if( siIsRightDelim( line, sel.ichFirst ) )
            {
                jump_sel = siMatchRightDelim( line[sel.ichFirst], buff, sel, hwnd )
                if( jump_sel )
                {
                    sel = jump_sel
                    line = GetBufLine( buff, sel.lnFirst )
                }
            }
            else if( siIsLeftDelim( line, sel.ichFirst) )
            {
                return sel
            }

            sel.ichFirst = sel.ichFirst - 1
        }

        sel.lnFirst = sel.lnFirst - 1
        if( sel.lnFirst >= 0 )
            sel.ichFirst = GetBufLineLength( buff, sel.lnFirst )
    }

    return 0
}


macro siIsLeftDelim( line, pos )
{
    if( line[pos] == "(" ||
        line[pos] == "{" ||
        line[pos] == "[" ||
        line[pos] == "<"    )
        return 1
    else
        return 0
}

macro siIsRightDelim( line, pos )
{
    back_pos = 0
    if( pos > 0 )
        back_pos = pos - 1

    if( line[pos] == ")" ||
        line[pos] == "}" ||
        line[pos] == "]" ||
        // The account for C-style pointer->member
        (line[pos] == ">" && (pos == 0 || line[back_pos] != "-")   )
        return 1
    else
        return 0
}

macro siGetRightDelim( left_delim )
{
    if( left_delim == "(" )
        return ")"
    else if( left_delim == "{" )
        return  "}"
    else if( left_delim == "[" )
        return  "]"
    else if( left_delim == "<" )
        return  ">"
    else
        return "-"
}

macro siGetLeftDelim( right_delim )
{
    if( right_delim == ")" )
        return "("
    else if( right_delim == "}" )
        return  "{"
    else if( right_delim == "]" )
        return  "["
    else if( right_delim == ">" )
        return  "<"
    else
        return "-"
}


// SI does not include \n in buffer
macro siNormSel(hbuf, sel)
{
	if (sel.ichLim >= GetBufLineLength(hbuf, sel.lnLast))
	{
		sel.lnLast = sel.lnLast + 1
		sel.ichLim = 0
    }

	return sel
}



/////////
//辅助编辑函数  				alt  系列
/////////////////////
///对选中字符段 临近添加括号
macro CY_Add_sign(sign_left,sign_right)
{
  hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    if(sel.lnFirst > 0)
    {
        ln = sel.lnFirst 
    }
    else
    {
        stop
    }
    szLine = GetBufLine(hbuf,ln)
    len=strlen(szLine)
    Sel_ichFirst=sel.ichFirst
    Sel_ichLim=sel.ichLim   //下一段字符起始位置
    Sel_lnFirst =sel.lnFirst
    Sel_lnLast =sel.lnLast
    if(Sel_ichFirst==Sel_ichLim)
    {
	return 0
    }      
//msg(szLine[Sel_ichFirst-1])
 //msg( szLine[Sel_ichLim])

        if(Sel_ichLim<len&&Sel_ichFirst>0)  
        {  
		 if(szLine[Sel_ichFirst-1]==sign_left&&szLine[Sel_ichLim]==sign_right )
		 {
 changeSign_buf1=strmid(szLine,0,Sel_ichFirst-1)
 changeSign_buf2=strmid(szLine,Sel_ichFirst,Sel_ichLim)
 //msg(changeSign_buf2)
 changeSign_buf3=strmid(szLine,Sel_ichLim+1,strlen(szLine))
  changeSign_buf="@changeSign_buf1@@changeSign_buf2@@changeSign_buf3@"
 PutBufLine(hbuf, ln,changeSign_buf)
 return 0
		 }

        }  
       
 if(sel.lnLast ==sel.lnFirst)
 {
     changeSign_buf1=strmid(szLine,0,Sel_ichFirst)

 changeSign_buf2=strmid(szLine,Sel_ichFirst,Sel_ichLim)
 changeSign_buf3=strmid(szLine,Sel_ichLim,strlen(szLine))

 changeSign_buf="@changeSign_buf1@@sign_left@@changeSign_buf2@@sign_right@@changeSign_buf3@"
 PutBufLine(hbuf, ln,changeSign_buf)
 }
 else
 {
 changeSign_buf=InserCharInString_cy(szLine,sign_left,Sel_ichFirst)
 PutBufLine(hbuf, Sel_lnFirst,changeSign_buf)
 szLine2 = GetBufLine(hbuf,Sel_lnLast )
 changeSign_buf2=InserCharInString_cy(szLine2,sign_right,Sel_ichLim)
  PutBufLine(hbuf, Sel_lnLast,changeSign_buf2)	
 } 	   
}
///添加()alt+()
macro CY_Addkuohao()
{
CY_Add_sign("(",")");
}
///添加""alt+""   ascii=42
macro CY_AddYinghao()
{
//sign_left = CharFromAscii (34)
//sign_right = CharFromAscii (34)
CY_Add_sign("\"","\"") ;

//CY_Add_sign(sign_left,sign_right);
}
///添加{}   alt+{}
macro CY_AddBigKuohao()
{
 hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    if(sel.lnFirst > 0)
    {
        ln = sel.lnFirst 
    }
    else
    {
        stop
    }
    szLine = GetBufLine(hbuf,ln)
    Sel_ichFirst=sel.ichFirst
    Sel_ichLim=sel.ichLim
    Sel_lnFirst =sel.lnFirst
    Sel_lnLast =sel.lnLast     
 InsBufLine(hbuf, sel.lnLast+1,"}")  //先添加最后一行，InsBufLine 插入当前行
 InsBufLine(hbuf, sel.lnFirst,"{")		
//CY_Add_sign("{","}");
}
///添加<>alt+""
macro CY_AddShuMinghao()
{
CY_Add_sign("<",">");
} 
//对选中行   移行添加  "/*"
//屏蔽选中代码
macro CY_add_close_key()  
{   
 hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    if(sel.lnFirst > 0)
    {
        ln = sel.lnFirst 
    }
    else
    {
        stop
    }
    szLine = GetBufLine(hbuf,ln)
    Sel_ichFirst=sel.ichFirst
    Sel_ichLim=sel.ichLim
    Sel_lnFirst =sel.lnFirst
    Sel_lnLast =sel.lnLast     
 InsBufLine(hbuf, sel.lnLast+1,"*/")  //先添加最后一行，InsBufLine 插入当前行
 InsBufLine(hbuf, sel.lnFirst,"/*")		 
}

/////////
//待开发函数
/////////////////////
///手动替换模式alt+V
macro CY_ChangeVarBySel()
{

    hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
    hbuf = GetCurrentBuf() 
    iTotalLn = GetBufLineCount (hbuf)
    ln=lnFirst
	symbol = GetSymbolLocationFromLn(hbuf, ln)
	//转换类型判断，结构体 还是变量，还是宏定义
	struct_mode=0
	var_mode=0
	macro_mode=0
	while(symbol.Type=="")
	{
	ln=ln+1
	symbol = GetSymbolLocationFromLn(hbuf, ln)
	}
	if(symbol.Type=="Function")
	{
	ProjctOrFunc=0
	var_mode=1
	}
	else if(symbol.Type=="Variable"||symbol.Type=="External Variable")
	{
	ProjctOrFunc=1
		var_mode=1

	}
	else if(symbol.Type=="Structure")struct_mode=1
//msg(symbol.Type)
    while( ln <= lnLast )  
    {  
    symbol = GetSymbolLocationFromLn(hbuf, ln)
    //this_line = GetBufLine( hbuf, ln )
    InsertMode = 1
    if(var_mode==1)
    Get_var_type(hbuf,ln,ProjctOrFunc,InsertMode,symbol)
   // if(	struct_mode==1)
   // Get_struct_type()
    ln=ln+1
    }
}
//成员变量，小写
macro Get_struct_type(this_var,this_type)
{
ich_len=strlen(this_var)
ich_index=0
new_var=this_var
new_type=""
//仅第一个字符为小写，识别为类型
if(islower(new_var[1])==0)
{
if(new_var[0]=="f")new_type="f_"
else if(new_var[0]=="b")new_type="b_"
else if(new_var[0]=="w")new_type="w_"
else if(new_var[0]=="_")return new_var
}

if(new_type!="")
{
new_var=strmid(new_var,1,ich_len)
ich_len=ich_len-1
}
while(ich_index<ich_len)
{

    if(islower(new_var[ich_index])==0) //判断不是小写
    {
     new_var[ich_index]=tolower(new_var[ich_index])   //转换为小写
    }
ich_index=ich_index+1
}
new_var=cat(new_type,new_var)
return new_var
}
/////////////////////
///局部变量自动替换模式alt+ctrl+V
macro CY_ChangeVarAuto()
{
	hwnd = GetCurrentWnd()
	hbuf = GetCurrentBuf() 
	File_lnMax = GetBufLineCount (hbuf)  //1~
	File_lnLast=File_lnMax-1
	if (hwnd == 0 || buff == 0 )
	return 0
//当前文件 符号(函数名和endif,include等)遍历
    isymMax = GetBufSymCount (hbuf)
    isym = 0
        pitch_len=15
    while(isym<isymMax)
    {        
    symname = GetBufSymName (hbuf, isym)
    symbol_record =GetBufSymLocation(hbuf, isym)
    	if(symbol_record.Type=="Function")
	{
	ProjctOrFunc=0
	var_mode=1
	}
	else if(symbol_record.Type=="Variable"||symbol_record.Type=="External Variable")
	{
	//msg("OK")
	ProjctOrFunc=1
		var_mode=1

	}
   else // if(symbol_record.Type!="Function")
    {
    isym=isym+1
    continue
    }
    InsertMode = 2
 // msg(symname)
    //函数内部处理 变量
    ln=symbol_record.lnFirst   //数组概念第一行 为0
    lnMax=symbol_record.lnLim   //计量，1行 为1
    lnLast=lnMax-1

	if(	ProjctOrFunc==1)
	{
		Get_var_type(hbuf,ln,ProjctOrFunc,InsertMode,symbol_record)	
		isym=isym+1
	    continue
	}
	    
    ln=ln+2
    len_of_var=(lnLast-ln)/2+ln  //初步 确定局部变量结束位置
    flag_check_error=0
		while(ln <= len_of_var)
		{
	 	symbol_record =GetBufSymLocation(hbuf, isym)

	    this_line = GetBufLine( hbuf, ln )
	 //   msg(this_line)
	 	this_type =  GetFirstWord(this_line)
	 	
	 	if(this_type[0]=="u"||this_type[0]=="s"||this_type[0]=="b"||this_type[0]=="B"||this_type[0]==" ") 
		{
		flag_check_ok=1
		Get_var_type(hbuf,ln,ProjctOrFunc,InsertMode,symbol_record)	
		}
		else 
		{
		flag_check_error=flag_check_error+1
		}
		if(flag_check_error>5)break
	    //局部变量，生成局部变量 改变记录表模式
	    ln=ln+1
		}

    isym=isym+1
    }
    	if(InsertMode == 2)
	    {
	    ///获取被修改文件信息
	    	//hbuf = GetCurrentBuf() 
	   // hbuf_change=hbuf
		   szpathName = GetBufName(hbuf)
		hbuf_file_name = GetFileName(szpathName)
		//msg(hbuf_file_name)
	    symbol_name=symbol_record.symbol
	    //////////////

	    	filename_text="局部命名变更映射表.txt"
	        temp=OpenMiscFile (filename_text)
			if(temp==FALSE )msg("打不开@filename_text@文件!")
		hbuf_txt  =  OpenBuf (filename_text)
	    iTotalLn_txt =GetBufLineCount (hbuf_txt)
	    	txt_buf= "         @hbuf_file_name@"  
		InsBufLine(hbuf_txt, iTotalLn_txt,txt_buf)
		//	InsBufLine(hbuf, iTotalLn_txt,"// @buf_file_name@    //")
	    }
}
/////////////////////
///
macro InserCharInString_cy(szLine,in_char,in_ich_num)
{

 changeSign_buf1=strmid(szLine,0,in_ich_num)
 changeSign_buf2=strmid(szLine,in_ich_num,strlen(szLine))

 changeSign_buf3="@changeSign_buf1@@in_char@@changeSign_buf2@"
 return changeSign_buf3
}
/////////////////////
///自动替换结构体成员模式alt+Ctrl+s
//结构成员用全部小写的单词组成，单词之间使用下划线分割
macro CY_ChangeStructAuto(hbuf,symbol)
{
	if(symbol.Type!="Structure")
	{
	return 0
	}
	//filename_temp=GetBufName (hbuf)
    ln=symbol.lnFirst+2   //数组概念第一行 为0
    lnMax=symbol.lnLim   //计量，1行 为1    
    lnLast=lnMax-1		//lnLast 转化为  ln 同样的取值范围
while(ln<lnLast)		//最后一行 跳过
{
	SetBufIns(hbuf,ln, 0)
    hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    szLine = GetBufLine(hbuf,ln)
    if(strlen(szLine)==0)	
    {
	ln=ln+1
	continue
	}
	struct_word=GetAnyWord(szLine,2,1)
	while(1)
	 {
	if(struct_word=="")
	{
	break
	}
	//msg(selection.lnFirst)
	
	
	SetBufIns (hbuf, ln, struct_word.start+1)
	//ASK("go?")
	Jump_To_Base_Type
	//stop
 	
  	hwnd2 = GetCurrentWnd()
	sel2 = GetWndSel(hwnd2)
	hbuf2 = GetWndBuf(hwnd2)
//	msg(sel2.lnFirst)
    //symbol = GetSymbolLocationFromLn(hbuf2, sel2.lnFirst)
	szLine2 = GetBufLine(hbuf2,sel2.lnFirst)
      buf_struct_type=strmid(szLine2,sel2.ichFirst,sel2.ichLim)
     
     
  if(buf_struct_type=="struct")  
  {
  szLine2=szLine
  sel2=selection
  sel2.ichFirst=struct_word.start
  sel2.ichLim=struct_word.end
Go_Back
  }
	//函数调用参数 判断	,结构体不会多个地方定义，定义位置可以用来判断是否为变量
	
	 if(selection.lnFirst==sel2.lnFirst&&hbuf2==hbuf||buf_struct_type=="struct")
    {
 if(buf_struct_type=="struct") 
	buf_struct_var=struct_word.buf
	 else 
	buf_struct_var=strmid(szLine,sel2.ichFirst,sel2.ichLim)
	new_buf_struct_var=Get_struct_type(buf_struct_var,this_type)
		if(new_buf_struct_var!=buf_struct_var)
		{
		szLine_tlen=strlen(szLine2)
		szLine_temp1=strmid(szLine2,0,sel2.ichFirst)
		szLine_temp2=strmid(szLine2,sel2.ichLim,szLine_tlen)
		szLine_temp_end="@szLine_temp1@@new_buf_struct_var@@szLine_temp2@"
		//filename_temp=GetBufName (hbuf2)
		//hbuf_temp   =  OpenBuf (filename)
		//msg(filename)
		//ASK("替换@buf_struct_var@为@new_buf_struct_var@?")
		ReplaceInProj_forStruct_cy(buf_struct_var,new_buf_struct_var)
/**/				
		//hbuf_temp2   =  OpenBuf (filename_temp)
		//hbuf_temp2= GetCurrentBuf() 
		// SetCurrentBuf  (hbuf_temp2)
		SetBufIns(hbuf,ln, 0)
		PutBufLine ( hbuf, ln, szLine_temp_end ) 
		
		//SaveBuf(hbuf)
		}	break
    }
    else
    {
    Go_Back
    CloseBuf (hbuf2)
      buf_struct_type=strmid(szLine2,sel2.ichFirst,sel2.ichLim)
   //   if(buf_struct_type=="struct")
//	continue
    
      
 	//msg(selection)
	//msg(buf_struct_type)

	struct_word=GetAnyWord(szLine,3,1)
	if(finish_flag==1)
	break
	finish_flag=1	
    }
    
	}
	
ln=ln+1
}

//
}

/////////////////////
///手动替换结构体成员模式alt+s
//结构成员用全部小写的单词组成，单词之间使用下划线分割
macro CY_ChangeStructBySel()
{

    hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
    hbuf = GetCurrentBuf() 
    iTotalLn = GetBufLineCount (hbuf)
    ln=lnFirst
	symbol = GetSymbolLocationFromLn(hbuf, ln)
    szLine = GetBufLine(hbuf,ln)
if(symbol.Type!="Structure")return 0
struct_word=GetAnyWord(szLine,2,1)
finish_flag=0

while(1)
{
if(struct_word=="")
{
msg("err")
return 0
}
	//msg(selection.lnFirst)
	
	
	SetBufIns (hbuf, ln, struct_word.start+1)
	//ASK("go?")
	Jump_To_Base_Type
	//stop
 	
  	hwnd2 = GetCurrentWnd()
	sel2 = GetWndSel(hwnd2)
	hbuf2 = GetWndBuf(hwnd2)
//	msg(sel2.lnFirst)
    //symbol = GetSymbolLocationFromLn(hbuf2, sel2.lnFirst)
	szLine2 = GetBufLine(hbuf2,sel2.lnFirst)
      buf_struct_type=strmid(szLine2,sel2.ichFirst,sel2.ichLim)
     
  if(buf_struct_type=="struct")  
  {
  szLine2=szLine
  sel2=selection
  sel2.ichFirst=struct_word.start
  sel2.ichLim=struct_word.end
Go_Back
  }
	//函数调用参数 判断	,结构体不会多个地方定义，定义位置可以用来判断是否为变量
	
	 if(selection.lnFirst==sel2.lnFirst&&hbuf2==hbuf||buf_struct_type=="struct")
    {
    	  if(buf_struct_type=="struct") 
	buf_struct_var=struct_word.buf
	 else 
	buf_struct_var=strmid(szLine,sel2.ichFirst,sel2.ichLim)
	new_buf_struct_var=Get_struct_type(buf_struct_var,this_type)
		if(new_buf_struct_var!=buf_struct_var)
		{
		szLine_tlen=strlen(szLine2)
		szLine_temp1=strmid(szLine2,0,sel2.ichFirst)
		szLine_temp2=strmid(szLine2,sel2.ichLim,szLine_tlen)
		szLine_temp_end="@szLine_temp1@@new_buf_struct_var@@szLine_temp2@"
		filename=GetBufName (hbuf2)
		hbuf_temp   =  OpenBuf (filename)
		//msg(filename)
		ASK("替换@buf_struct_var@为@new_buf_struct_var@?")
		ReplaceInProj_forStruct_cy(buf_struct_var,new_buf_struct_var)
/**/				
		temp=OpenMiscFile (filename)
		hbuf_temp2= GetCurrentBuf() 
		if(temp==FALSE )msg("打不开该文件!")
		// SetCurrentBuf  (hbuf_temp2)
		SetBufIns(hbuf2,ln, 0)
		PutBufLine ( hbuf2, ln, szLine_temp_end ) 
		
		//SaveBuf(hbuf)
		}	break
    }
    else
    {
    Go_Back
      buf_struct_type=strmid(szLine2,sel2.ichFirst,sel2.ichLim)
   //   if(buf_struct_type=="struct")
//	continue
    
      
 	//msg(selection)
	//msg(buf_struct_type)

	struct_word=GetAnyWord(szLine,3,1)
	if(finish_flag==1)
	break
	finish_flag=1	
    }
    
}
//加_去大写 

}
/////////////////////
///手动添加赋值转换模式 alt+=
macro CY_ChangeAssignSignBySel()
{
  hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    if(sel.lnFirst > 0)
    {
        ln = sel.lnFirst 
    }
    else
    {
        stop
    }
    szLine = GetBufLine(hbuf,ln)
    Sel_ichFirst=sel.ichFirst
    Sel_ichLim=sel.ichLim
    Sel_lnFirst =sel.lnFirst
    Sel_lnLast =sel.lnLast
    if(Sel_ichFirst==Sel_ichLim)
    {

    }
    
    Sign_type="$"
    type_check_mode=1

    
    //类型判断，u8,u16?
	gx_start=strstr(szLine," = ")  
      if(gx_start!=0xffffffff)
      SetBufIns (hbuf, ln, gx_start-1) //光标选中搜索位置
    Jump_To_Base_Type
    
  	hwnd2 = GetCurrentWnd()
	sel2 = GetWndSel(hwnd2)
	hbuf2 = GetWndBuf(hwnd2)
    symbol = GetSymbolLocationFromLn(hbuf2, sel2.lnFirst)
	szLine2 = GetBufLine(hbuf2,sel2.lnFirst)
	//函数调用参数 判断	
	 if(symbol.Type=="Function"&&symbol.lnFirst==sel2.lnFirst)
    {
    
    sign_type_temp=GetNearWord_cy(szLine2,sel2.ichFirst,0)
  //  msg(sign_type_temp)
    Sign_type=sign_type_temp
	//Sign_type="$"
    }
    else
	Sign_type =  GetFirstWord(szLine2)
	if(Sign_type=="#define")Sign_type="$"
	//msg(Sign_type)
	Go_Back
  /*  
	if(type_check_mode==1)
	{
      gx_start=strstr(szLine," = ")  
      if(gx_start!=0xffffffff)
      {
		this_var =  GetFirstWord(szLine)
		szFunc = GetCurSymbol()
		ln_func = GetSymbolLine(szFunc)
    	lnMax=symbol_record.lnLim   //计量，1行 为1
		while(ln_func)
      }
     
	}
	*/
    
 if(sel.lnLast ==sel.lnFirst)
 {
     changeSign_buf1=strmid(szLine,0,Sel_ichFirst)

 changeSign_buf2=strmid(szLine,Sel_ichFirst,Sel_ichLim)
 changeSign_buf3=strmid(szLine,Sel_ichLim,strlen(szLine))

 changeSign_buf="@changeSign_buf1@(@Sign_type@)(@changeSign_buf2@)@changeSign_buf3@"
 PutBufLine(hbuf, ln,changeSign_buf)
 }
 else
 {
 changeSign_buf=InserCharInString_cy(szLine,"(@Sign_type@)(",Sel_ichFirst)
 PutBufLine(hbuf, Sel_lnFirst,changeSign_buf)
 szLine2 = GetBufLine(hbuf,Sel_lnLast )
 changeSign_buf2=InserCharInString_cy(szLine2,")",Sel_ichLim)
  PutBufLine(hbuf, Sel_lnLast,changeSign_buf2)	
 }
 		

    
}
macro find_type(szLine)
{
//type=""
gx_start=strstr(szLine,"bool ")
if(gx_start!=0xffffffff)return "bool"
gx_start=strstr(szLine,"u16 ")
if(gx_start!=0xffffffff)return "u16"
gx_start=strstr(szLine,"u8 ")
if(gx_start!=0xffffffff)return "u8"
gx_start=strstr(szLine,"s16 ")
if(gx_start!=0xffffffff)return "s16"
gx_start=strstr(szLine,"s8 ")
if(gx_start!=0xffffffff)return "s8"
gx_start=strstr(szLine,"u32 ")
if(gx_start!=0xffffffff)return "u32"
gx_start=strstr(szLine,"s32 ")
if(gx_start!=0xffffffff)return "s32"
gx_start=strstr(szLine,"Bool ")
if(gx_start!=0xffffffff)return "Bool"
return ""
}
/////////////////////
///手动添加立即数		alt+N
macro CY_ChangeNumTitleBySel()

{
  hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    if(sel.lnFirst > 0)
    {
        ln = sel.lnFirst 
    }
    else
    {
        stop
    }
    szLine = GetBufLine(hbuf,ln)
    Sel_ichFirst=sel.ichFirst
    Sel_ichLim=sel.ichLim
    Sel_lnFirst =sel.lnFirst
    Sel_lnLast =sel.lnLast
    if(Sel_ichFirst==Sel_ichLim)
    {
	return 0
    }      
    
 if(sel.lnLast ==sel.lnFirst)
 {
 num_buf=strmid(szLine,Sel_ichFirst,Sel_ichLim)
 //msg(num_buf)
 pitch_len=15
 avg_len=strlen(szLine)
 norm_len=(avg_len/pitch_len+1)*pitch_len
 nBlankCount=norm_len-avg_len
	blank_buf=CreateBlankString(nBlankCount)
	txt_buf= "@szLine@@blank_buf@//@num_buf@:$"
 PutBufLine(hbuf, ln,txt_buf)
 }
 else
	return 0

}
//set problem num
macro Set_ID()
{
   SetReg (Test_Pro_ID, szTest_pro_ID)
}
 //C++ Test ,跟随模式  只限当前文件
macro CY_goto_result_onefile()
{
	hbuf_change_file = GetCurrentBuf() 
	name=GetBufName (hbuf_change_file)
	name_end=strmid(name,strlen(name)-10,strlen(name))
		filename_text="result.txt"
		//temp=OpenMiscFile (filename_text)
		hbuf_txt =  OpenBuf (filename_text)	
			if(name_end==filename_text)
			{
			hwnd = GetCurrentWnd()  
			//hbuf_txt = = GetCurrentBuf() 
    		sel_lnFirst = GetWndSelLnFirst( hwnd )  
    		//szLine_txt = GetBufLine(hbuf_txt,sel_lnFirst)
			/*
	    		while(szLine_txt[sel_lnFirst]!="M")
	    		{
	    		sel_lnFirst=sel_lnFirst-1
	    		}
			ln_txt_start=sel_lnFirst
			*/
			SetReg (Test_Pro_ID, sel_lnFirst/8)
			}
			else 
			{
			szfile_last=getreg(file_last)
			szFile_flag=getreg(File_flag)
			if(szfile_last!=name_end)
			{
			//if(szFile_flag==0)
			//msg("szfile_last" is not finish)
			SetReg (Test_Pro_ID, 0)
			}
			SetReg (file_last, name_end)

			
			szTest_pro_ID = getreg(Test_Pro_ID)
			sel_search = SearchInBuf(hbuf_txt, name_end, szTest_pro_ID*8, 0, TRUE, FALSE, FALSE)
			if(sel_search=="")
			{
			msg("finish @name_end@")
			SetReg (File_flag, 1)
			return 0
			}
			else 			SetReg (File_flag, 0)

			SetReg (Test_Pro_ID, sel_search.lnFirst/8)
			//SetBufIns(hbuf_txt,sel.lnFirst, 0)
			//Select_Line
			}
			/*
				if(name_end==filename_onefile)
			{
			hwnd = GetCurrentWnd()  
    		sel_lnFirst = GetWndSelLnFirst( hwnd )  
			SetReg (Test_Pro_ID, sel_lnFirst/8)
			}
			*/

		/*
		iTotalLn_txt =GetBufLineCount (hbuf_txt)
		szLine_txt_config = GetBufLine(hbuf_txt,0)
		szLine_txt_config = TrimLeft(szLine_txt_config)
		if(szLine_txt_config[0]=="M")
		*/
		//txt 一组信息提取
					szTest_pro_ID = getreg(Test_Pro_ID)
		while(1)
		{
			if(szTest_pro_ID=="")szTest_pro_ID=0
			iTotalLn_txt =GetBufLineCount (hbuf_txt)
			ln_txt=szTest_pro_ID*8
			if(ln_txt+7>iTotalLn_txt)
			{
			msg("finish")
			return 0
			}
			//Rule ID 判断
			szLine_Rule_ID = GetBufLine(hbuf_txt,ln_txt+4)
			gx_start=strstr(szLine_Rule_ID,"FW-")  
	      	if(gx_start==0xffffffff)return 0
			Rule_ID=strmid(szLine_Rule_ID,gx_start,strlen(szLine_Rule_ID))
			//msg(Rule_ID)
			if(Rule_ID=="FW-NAMING-MST.28"||Rule_ID=="FW-NAMING-MST.28-3"||Rule_ID=="FW-NAMING-MST.28_1-3"||Rule_ID=="FW-NAMING-MST.57_1-3"||Rule_ID=="FW-NAMING-MST.57_1")//结构体
			{
			szTest_pro_ID=szTest_pro_ID+1
			//msg("pass")
			}
			else break
		}
		SetReg (Test_Pro_ID, szTest_pro_ID+1)
		//路径提取，打开文件
		szLine_txt = GetBufLine(hbuf_txt,ln_txt+1)
		buf_char=CharFromAscii (92)
		filename_head="@buf_char@src@buf_char@"
		gx_start=strstr(szLine_txt,filename_head)  
      	if(gx_start==0xffffffff)return 0
      	filename_this=strmid(szLine_txt,gx_start,strlen(szLine_txt))
      	temp=OpenMiscFile (filename_this)
		hbuf_cfile   =  OpenBuf (filename_this)


		
		//行号提取，跳转到行
		szLine_line_num = GetBufLine(hbuf_txt,ln_txt+3)
		ln_cfile=strmid(szLine_line_num,6,strlen(szLine_line_num))-1
		SetBufIns(hbuf_cfile,ln_cfile, 0)
		Select_Line
		
		//错误信息提取，并显示
		szLine_msg = GetBufLine(hbuf_txt,ln_txt)
      	msg(szLine_msg) 		
}
//C++ Test ,跟随模式
macro CY_goto_result()
{
	hbuf_change_file = GetCurrentBuf() 
	name=GetBufName (hbuf_change_file)
	name_end=strmid(name,strlen(name)-10,strlen(name))
		filename_text="result.txt"
		temp=OpenMiscFile (filename_text)
		hbuf_txt =  OpenBuf (filename_text)	
			if(name_end==filename_text)
			{
			hwnd = GetCurrentWnd()  
			//hbuf_txt = = GetCurrentBuf() 
    		sel_lnFirst = GetWndSelLnFirst( hwnd )  
    		//szLine_txt = GetBufLine(hbuf_txt,sel_lnFirst)
			/*
	    		while(szLine_txt[sel_lnFirst]!="M")
	    		{
	    		sel_lnFirst=sel_lnFirst-1
	    		}
			ln_txt_start=sel_lnFirst
			*/
			SetReg (Test_Pro_ID, sel_lnFirst/8)
			}

		/*
		iTotalLn_txt =GetBufLineCount (hbuf_txt)
		szLine_txt_config = GetBufLine(hbuf_txt,0)
		szLine_txt_config = TrimLeft(szLine_txt_config)
		if(szLine_txt_config[0]=="M")
		*/
		//txt 一组信息提取
					szTest_pro_ID = getreg(Test_Pro_ID)
		/*while(1)
		{
			if(szTest_pro_ID=="")szTest_pro_ID=0
			iTotalLn_txt =GetBufLineCount (hbuf_txt)
			ln_txt=szTest_pro_ID*8
			if(ln_txt+7>iTotalLn_txt)
			{
			msg("finish")
			return 0
			}
			//Rule ID 判断
			szLine_Rule_ID = GetBufLine(hbuf_txt,ln_txt+4)
			gx_start=strstr(szLine_Rule_ID,"FW-")  
	      	if(gx_start==0xffffffff)return 0
			Rule_ID=strmid(szLine_Rule_ID,gx_start,strlen(szLine_Rule_ID))
			
		
		//msg(Rule_ID)
			if(Rule_ID=="FW-NAMING-MST.28-3"||Rule_ID=="FW-NAMING-MST.28_1-3"||Rule_ID=="FW-NAMING-MST.57_1-3"||Rule_ID=="FW-NAMING-MST.57_1")//结构体
			{
			
			szTest_pro_ID=szTest_pro_ID+1
			//msg("pass")
			}
			else break
			
			
		}*/
		ln_txt=szTest_pro_ID*8
		SetReg (Test_Pro_ID, szTest_pro_ID+1)

		//路径提取，打开文件
		szLine_txt = GetBufLine(hbuf_txt,ln_txt+1)
		buf_char=CharFromAscii (92)
		filename_head="@buf_char@src@buf_char@"
		gx_start=strstr(szLine_txt,filename_head)  
      	if(gx_start==0xffffffff)return 0
      	filename_this=strmid(szLine_txt,gx_start,strlen(szLine_txt))
      	temp=OpenMiscFile (filename_this)
		hbuf_cfile   =  OpenBuf (filename_this)


		
		//行号提取，跳转到行

		SetBufIns(hbuf_txt,ln_txt, 0)
		Select_Line
		szLine_line_num = GetBufLine(hbuf_txt,ln_txt+3)
		ln_cfile=strmid(szLine_line_num,6,strlen(szLine_line_num))-1
		SetBufIns(hbuf_cfile,ln_cfile, 0)
		Select_Line
		
		//错误信息提取，并显示
		szLine_msg = GetBufLine(hbuf_txt,ln_txt)
      	msg(szLine_msg) 		
}
/////////////////////
///手动替换模式
macro CY_test_ONE_FIEL()
{
	hwnd = GetCurrentWnd()
	hbuf = GetCurrentBuf() 
	File_lnMax = GetBufLineCount (hbuf)  //1~
	File_lnLast=File_lnMax-1
	if (hwnd == 0 || buff == 0 )
	return 0
//当前文件 符号(函数名和endif,include等)遍历
    isymMax = GetBufSymCount (hbuf)
    isym = 0
    while(isym<isymMax)
    {
    //hbuf = GetCurrentBuf() 
    symname = GetBufSymName (hbuf, isym)
    symbol_record =GetBufSymLocation(hbuf, isym)
	       if(symbol_record.Type!="Structure")
		{	
	    isym=isym+1
		continue
		}
    ln=symbol_record.lnFirst   //数组概念第一行 为0
    lnMax=symbol_record.lnLim   //计量，1行 为1
    lnLast=lnMax-1    //ln是实际行-1，lnMax 是实际行
         if(ln>=File_lnLast)   //最后一行    ln+1容易出错
         {
         isym=isym+1
         continue
         }

		 CY_ChangeStructAuto(hbuf,symbol_record)
		//stop
      isym=isym+1      
	 }
}
//局部变量替换 添加	lub_
/*
g/l      全局变量/局部变量					
p      数组或指针 			
s/u    有符号/无符号整形 			                 s/u			bool
b/w/i  单字节/双字节/四字节整形						8/16/32
f/d    浮点型、双精度浮点型           			//不考虑
fg/bo  bit/bool         						//bit  不考虑

*/
//InsertMode  是否生成修改记录
macro Get_var_type(hbuf,ln,ProjctOrFunc,InsertMode,symbol)
{

myVar=return_var_type(hbuf,ln,ProjctOrFunc)
if(myVar=="")return 0
      new_var=myVar.new
     this_var=myVar.old  
	//if(ProjctOrFunc==1)
   // ASK("替换@this_var@为@new_var@?")
    if(ProjctOrFunc==0)  //局部
    {
   // ReplaceInBuf(hbuf,this_var,new_var,0, iTotalLn, 1, 0, 1, 0)
   	ln = symbol.lnFirst
	iTotalLn=symbol.lnLim
  Replacefile_cy(this_var,new_var,hbuf,ln,iTotalLn)
   //Replacefile_cy(this_var,new_var,symbol)
    }
    else if(ProjctOrFunc==1)  //全局
   { 
  //  ASK("替换@this_var@为@new_var@?")	
    ReplaceInProj_cy(this_var,new_var)
	}
	//输出 修改命名列表到工程内txt文件
    if(InsertMode==1)
    {
///show last txt
		secon_word_start=30			//对齐位置
		filename_text="命名变更映射表.txt"
		temp=OpenMiscFile (filename_text)
		if(temp==FALSE )msg("打不开@filename_text@文件!")
		hbuf   =  OpenBuf (filename_text)
		iTotalLn_txt =GetBufLineCount (hbuf)
		nBlankCount=secon_word_start-strlen(this_var)
		blank_buf=CreateBlankString(nBlankCount)
		txt_buf= "@this_var@@blank_buf@@new_var@"
		InsBufLine(hbuf, iTotalLn_txt,txt_buf)
	
    }
   else  if(InsertMode==2)
    {

	//	SetCurrentBuf(hbuf)
///show last txt
		secon_word_start=30			//对齐位置
		filename_text="局部命名变更映射表.txt"
		temp=OpenMiscFile (filename_text)
		if(temp==FALSE )msg("打不开@filename_text@文件!")
		hbuf_txt   =  OpenBuf (filename_text)
		iTotalLn_txt =GetBufLineCount (hbuf_txt)
		nBlankCount=secon_word_start-strlen(this_var)
		blank_buf=CreateBlankString(nBlankCount)
		txt_buf= "@this_var@@blank_buf@@new_var@"
		InsBufLine(hbuf_txt, iTotalLn_txt,txt_buf)
//	 ASK("替换@this_var@为@new_var@?")		
    }
    
}

macro return_var_type(hbuf,ln,ProjctOrFunc)
{
this_line = GetBufLine( hbuf, ln )
this_line_temp=this_line
this_type =  GetFirstWord(this_line)
this_line_temp_len=strlen(this_line)
if(this_type=="extern"||this_type=="const"||this_type=="_GLOBAL_VAR_DEF_")
{
this_line=strmid(this_line,strlen(this_type),this_line_temp_len)
this_type =  GetFirstWord(this_line)
//msg(this_line)
}
if(strlen(this_type)>4||strlen(this_type)<2)return "" ; //u8,bool
//msg(this_type[0])
//局部判断
type_32_mode=0
if(ProjctOrFunc==0)  //局部
{
new_type="l" 
if(type_32_mode==1)
if(this_type=="u8"||this_type=="s8"||this_type=="u16"||this_type=="s16")
{
//msg(symbol)
type_start=strstr(this_line_temp,this_type)
		SetBufIns(hbuf,ln, type_start)
		Select_Word
		SetBufSelText(hbuf, "s32")
		//PutBufLine ( hbuf_temp2, ln, szLine_temp_end ) 
this_type="s32"
}

}
else if(ProjctOrFunc==1)  //局部
new_type="g" 
//hbuf = GetCurrentBuf()
iTotalLn =GetBufLineCount (hbuf)
this_var  = GetSecondWord(this_line)

if(this_var=="xdata"||this_var=="pdata"||this_var=="data"||this_var=="const")
{
      xdate_start=strstr(this_line,this_var)  
	if(xdate_start!=0xffffffff )
	{
	
	this_var= GetNearWord_cy(this_line,xdate_start,1)
	//msg(this_var)
	}
}
//跳过类型
if(this_var=="i"||this_var=="j"||this_var=="k")return "";

zkh_start=strstr(this_var,"[")//数组识别                       
if(this_var_len==0)return ""                       
//指针或数组检测   u8 *p=xx;  u8 p[] =;
if(this_var[0]=="*")  //指针
{
new_type="@new_type@p"
this_var=strmid(this_var,1,strlen(this_var))  		//指针替换，替换*后面
}
 else if(zkh_start!=0xffffffff)//数组识别
 {
	new_type="@new_type@p"
	this_var=strmid(this_var,0,zkh_start)    //数组替换，只替换[]前面
 }
 this_var_len=strlen(this_var)

    if(this_type=="bool"||this_type=="BOOL")         //
	new_type="@new_type@bo" //前缀
	else
	{
	if(this_type[0]=="u")         //
    new_type="@new_type@u" //前缀
    else if(this_type[0]=="s")         //
    new_type="@new_type@s" //前缀
	else  return ""
	
	if(this_type[1]=="8")         //u8,s8
    new_type="@new_type@b" //前缀    
	else if(this_type[1]=="1")         //u16
    new_type="@new_type@w" //前缀   
    else if(this_type[1]=="3")         //u32
    new_type="@new_type@i" //前缀   
    else  return ""
	}	
type_len=strlen(new_type)
/*
if(this_var_len>type_len)   
old_type=strmid(this_var,0,type_len)
else old_type=strmid(this_var,0,this_var_len)
old_type_len=strlen(old_type)
*/
ich_temp=0
old_type_len=0

	while(ich_temp<this_var_len)
	{
	if(isupper(this_var[ich_temp])==1)
	{
	old_type_len=ich_temp
	break
	}
	ich_temp=ich_temp+1
	}

else old_type_len=0
old_type=strmid(this_var,0,old_type_len)
    //判断符合
    if(old_type==new_type)return ""
    //帮助切换全局变量符号类型，长度类型
  //  msg(var_firstUPword)
  if(old_type_len>0&&old_type[0]==new_type[0]&&old_type_len<=type_len)
  {
  
  new_var = strmid(this_var,old_type_len,this_var_len) //数组长度和取数组最后一个数一定注意 减1 对齐
//msg(new_var)
 }

  else if(old_type=="_b"||old_type[0]=="_p")
  {
	new_var = strmid(this_var,old_type_len,this_var_len)
  }
	else
	{
	new_var=this_var
    var_firstword=this_var[0]
    if(isupper(var_firstword)==0) //判断不是大写
    {
   // msg(var_firstword)
     var_firstword=toupper (var_firstword)   //转换为大写
     
	new_var=this_var
    new_var[0]=var_firstword
     //   msg(new_var)

    }

	}
//	msg(old_type)
//msg(new_var)
//去下划线,换大写
	new_var_len=strlen(new_var)
      xhx_start=strstr(new_var,"_")  
     while(xhx_start!=0xffffffff )
     {	
     	//msg(xhx_start)
     	 if(isupper(new_var[xhx_start+1])==0) //判断不是大写
	    {
	     new_var[xhx_start+1]= toupper(new_var[xhx_start+1])   //转换为大写
	    }
	 	new_var_temp1=strmid(new_var,0,xhx_start)
	 	new_var_temp2=strmid(new_var,xhx_start+1,new_var_len)

	 	//更新 新变量
	 	new_var=cat(new_var_temp1,new_var_temp2)
	 	new_var_len=strlen(new_var)
	 	xhx_start=strstr(new_var,"_")  
	 	if(xhx_start!=0xffffffff )
	 	{if(xhx_start>=new_var_len)
		break
	 	}
     }
    new_var	=	cat(new_type,new_var)  //前缀连接
    myVar=""
    myVar.new=new_var
     myVar.old=this_var
    return myVar
}
macro Replacefile_cy(this_var,new_var,hbuf,ln,iTotalLn)
{
	//hbuf = GetCurrentBuf()
	//szFunc=symbol
	//msg(szFunc)
	// DoReplaceInFunc(hbuf, this_var, new_var,ln+2, iTotalLn)
	//ASK("替换@this_var@为@new_var@?")	
 ReplaceInBuf(hbuf,this_var,new_var,ln, iTotalLn, 1, 0, 1, 0)
// SetCurrentBuf  (hbuf)
//InsBufLine(hbuf, 4, " Function List:  ")

}
macro ReplaceInProj_forStruct_cy(this_var,new_var)
{
		 hprj=GetCurrentProj ()
		ifileMax = GetProjFileCount (hprj)
		ifile=0
		cReplace = 0
	while (ifile < ifileMax)
	{
		filename = GetProjFileName (hprj, ifile)
		filename_len = strlen( filename)  
    	if(filename[filename_len-1]!="h"&&filename[filename_len-1]!="c")
    	{
        ifile = ifile + 1
		continue
    	}
		hbuf   =  OpenBuf (filename)
       // temp   =  OpenMiscFile (filename)
		//if(temp==FALSE )msg("打不开@filename@文件!")
		change_flag=0
        if(hbuf != 0)
        {
            iTotalLn = GetBufLineCount (hbuf)	
			count = DoReplace_forStruct(hbuf, this_var, new_var)
			if (count != 0	)	
			{
			cReplace = cReplace + count  
			change_flag=1
			SaveBuf(hbuf)
			//msg(cReplace)
			}
			else      
			CloseBuf(hbuf)
        }
        ifile = ifile + 1
    }
}

macro DelInProj_cy(this_var,new_var)
{
		 hprj=GetCurrentProj ()
		ifileMax = GetProjFileCount (hprj)
		ifile=0
		cReplace = 0
	while (ifile < ifileMax)
	{
		filename = GetProjFileName (hprj, ifile)
		hbuf   =  OpenBuf (filename)
	   buf =TrimRight(filename)
   		 len = strlen( buf)    
    if(buf[len-1]!="c")
    {
     ifile = ifile + 1
	continue
    }
       // temp=OpenMiscFile (filename)
		//if(temp==FALSE )msg("打不开@filename@文件!")
		change_flag=0
		//msg(hbuf)
        if(hbuf != 0)
        {
            iTotalLn = GetBufLineCount (hbuf)
    		//ReplaceInBuf(hbuf,this_var,new_var,0, iTotalLn, 1, 0, 1, 0)
			// do replace operation in the buffer
			count = delReplace(hbuf, this_var, new_var)
			//msg(count)
			// Save and close the file
			if (count != 0)	//SaveBuf(hbuf)
			{
			cReplace = cReplace + count
			change_flag=1
			 temp=OpenMiscFile (filename)
			SaveBuf(hbuf)
			}
    		
        }
       // if( IsBufDirty (hbuf) )
       // {
           // SaveBuf (hbuf)
       // }
       if(change_flag==0&&hbuf!=0)//msg("find")'  
	//if(hbuf!=0)
        CloseBuf(hbuf)
        ifile = ifile + 1
    }
}

macro ReplaceInProj_cy(this_var,new_var)
{
		 hprj=GetCurrentProj ()
		ifileMax = GetProjFileCount (hprj)
		ifile=0
		cReplace = 0
	while (ifile < ifileMax)
	{
		filename = GetProjFileName (hprj, ifile)
		hbuf   =  OpenBuf (filename)
       // temp=OpenMiscFile (filename)
		//if(temp==FALSE )msg("打不开@filename@文件!")
		change_flag=0
		//msg(hbuf)
        if(hbuf != 0)
        {
            iTotalLn = GetBufLineCount (hbuf)
    		//ReplaceInBuf(hbuf,this_var,new_var,0, iTotalLn, 1, 0, 1, 0)
			// do replace operation in the buffer
			count = DoReplace(hbuf, this_var, new_var)
			// Save and close the file
			if (count != 0)	//SaveBuf(hbuf)
			{
			cReplace = cReplace + count
			change_flag=1
			SaveBuf(hbuf)
			}
    		
        }
       // if( IsBufDirty (hbuf) )
       // {
           // SaveBuf (hbuf)
       // }
       if(change_flag!=1&&hbuf!=0)//msg("find")'  
	//if(hbuf!=0)
        CloseBuf(hbuf)
        ifile = ifile + 1
    }
}

/*   R E P L A C E   F R O M   L I S T   */
/*-------------------------------------------------------------------------
    Replace a list of strings across the whole project.
	Warning: Changes are automatically saved and are permanent!
	Note: this only works for whole word replacements.

    Outputs a replacement-log to a Results file
    
    The current window should contain a list of strings, one per line, 
    with a comma separating the old and new string.
    Example:

    oldword1,newword1
    oldword2,newword2
	... etc ...
-------------------------------------------------------------------------*/
macro ReplaceFromList()
{
	hbufList = GetCurrentBuf();
	lnMax = GetBufLineCount(hbufList)

	// create result log file
	hbufResult = NewBuf("Results")
	if (hbufResult == 0)
		stop
	
	countTot = 0
	
	// process each item in the list
	ln = 0
	while (ln < lnMax)
		{
		// get list item; parse out old and new string
		line = GetBufLine(hbufList, ln)
		ichComma = IchInString(line, ",")
		if (ichComma > 0)
			{
			szOld = strmid(line, 0, ichComma)
			szNew = strmid(line, ichComma + 1, strlen(line))
			
			// use one the next 2 lines to do replaces.
			count = ReplaceSzWordInProject(szOld, szNew, hbufList)
			// count = ReplaceSzAnyInProject(szOld, szNew, hbufList)
			
			AppendBufLine(hbufResult, "@szOld@=>@szNew@ : @count@ replacements")
			countTot = countTot + count
			}
		ln = ln + 1
		}
	
	SetCurrentBuf(hbufResult)
	Msg("@countTot@ total replacements were made.");
}


/*   R E P L A C E   S Z   W O R D   I N   P R O J E C T   */
/*-------------------------------------------------------------------------
    Replace whole word szOld with szNew across the whole project.
    Note: this only works for whole word replacements.
    
	hbufSkip is skipped over.  This is handy because
	we don't want to replace in the replacement-list file

	Returns the number of replacements performed
-------------------------------------------------------------------------*/
macro ReplaceSzWordInProject(szOld, szNew, hbufSkip)
{
	TRUE = 1; FALSE = 0;
	
	// create source link buffer
	hbufLinks = NewBuf("Links") 
	if (hbufLinks == 0)
		stop
	
	// search across project for szOld
	SearchForRefs(hbufLinks, szOld, 0)
	
	// step thru each source link
	ilinkMac = GetBufLineCount(hbufLinks)
	ilink = 0;
	fileLast = ""
	cReplace = 0
	while (ilink < ilinkMac)
		{
		link = GetSourceLink(hbufLinks, ilink)
		if (link != "" && link.file != fileLast)
			{
			// open the file and search for each occurence
			fileLast = link.file
			hbuf = OpenBuf(link.file)
			if (hbuf != 0 && hbuf != hbufSkip)
				{
				// do replace operation in the buffer
				count = DoReplace(hbuf, szOld, szNew)
				cReplace = cReplace + count
				
				// Save and close the file
				// SaveBuf(hbuf)
				if (count != 0)
					SaveBuf(hbuf)
				CloseBuf(hbuf)
				}
			}
		
		// next source link
		ilink = ilink + 1
		}

	CloseBuf(hbufLinks)
	return cReplace
}


/*   R E P L A C E   S Z   A N Y   I N   P R O J E C T   */
/*-------------------------------------------------------------------------
    Replace any szOld with szNew across the whole project.
    Note: this works for any szOld string, not just whole words
    
	hbufSkip is skipped over.  This is handy because
	we don't want to replace in the replacement-list file

	Returns the number of replacements performed
-------------------------------------------------------------------------*/
macro ReplaceSzAnyInProject(szOld, szNew, hbufSkip)
{
	TRUE = 1; FALSE = 0;
	
	hprj = GetCurrentProj()
	if (hprj == 0)
		{
		Msg ("You must have a project open.")
		stop
		}
	
	// for each project file...
	ifileMac = GetProjFileCount(hprj)
	ifile = 0
	cReplace = 0
	while (ifile < ifileMac)
		{
		// open each project file and search for each occurence
		filename = GetProjFileName(hprj, ifile)
		
		hbuf = OpenBuf(filename)
		if (hbuf != 0 && hbuf != hbufSkip)
			{
			// do replace operation in the buffer
			count = DoReplace(hbuf, szOld, szNew)
			cReplace = cReplace + count
			
			// Save and close the file
			if (count != 0)
				SaveBuf(hbuf)
			else if (count == 0)
			CloseBuf(hbuf)
			}
		
		// next source link
		ifile = ifile + 1
		}

	return cReplace
}
macro delReplace(hbuf, szOld, szNew)
{
	TRUE = 1
	// find each occurence and replace each one
	ln = 0
	ich = 0
	cReplace = 0
	hwnd = 0
	while (1)
		{
		sel = SearchInBuf(hbuf, szOld, ln, ich, TRUE, FALSE, TRUE)
		//msg(sel)
		if (sel == "")
			break;
		if (hwnd == 0)
			{
			// put buffer in a window
			SetCurrentBuf(hbuf)
			hwnd = GetCurrentWnd()
			}			
		cReplace = cReplace + 1
		SetWndSel(hwnd, sel)
		Delete_Line
		//DelBufLine	 (hbuf, sel.lnFirst)
		SaveBuf(hbuf)
		//msg(sel.lnFirst)
		ln = sel.lnFirst;
		ich = sel.ichLim;
		}	
	return cReplace
}

/*   R E P L A C E   */
/*-------------------------------------------------------------------------
    Do a replace operation in the given buffer.
    Returns the number of replacements
-------------------------------------------------------------------------*/
macro DoReplace(hbuf, szOld, szNew)
{
	TRUE = 1
	
	// find each occurence and replace each one
	ln = 0
	ich = 0
	cReplace = 0
	hwnd = 0
	while (TRUE)
		{
		sel = SearchInBuf(hbuf, szOld, ln, ich, TRUE, FALSE, TRUE)
		if (sel == "")
			break;
		if (hwnd == 0)
			{
			// put buffer in a window
			SetCurrentBuf(hbuf)
			hwnd = GetCurrentWnd()
			}
		cReplace = cReplace + 1
		SetWndSel(hwnd, sel)
		SetBufSelText(hbuf, szNew)
		ln = sel.lnLast;
		ich = sel.ichLim;
		}
	
	return cReplace
}


/*   R E P L A C E   */
/*-------------------------------------------------------------------------
    Do a replace operation in the given buffer.
    Returns the number of replacements
-------------------------------------------------------------------------*/
macro DoReplace_ADDkh(hbuf, szOld, szNew,ln_start,ln_end)
{
	TRUE = 1
	
	// find each occurence and replace each one
	ln = ln_start
	ich = 0
	cReplace = 0
	hwnd = 0
	while (ln<=ln_end)
		{
		sel = SearchInBuf(hbuf, szOld, ln, ich, FALSE, FALSE, FALSE)
		if (sel == "")
			break;
		if ( sel.lnFirst>ln_end)
			break;	
		if (hwnd == 0)
			{
			SetCurrentBuf(hbuf)
			hwnd = GetCurrentWnd()
			}
		cReplace = cReplace + 1
		SetWndSel(hwnd, sel)
		//msg(sel)
		szLine = GetBufLine(hbuf, sel.lnFirst )
		//new_word="(@err_word@)"	
		if(sel.ichFirst>2)
		if((szLine[sel.ichFirst-1]=="("&&szLine[sel.ichLim]==")")||(szLine[sel.ichFirst-2]=="("&&szLine[sel.ichLim+1]==")"))
		{
		}
		else
		SetBufSelText(hbuf, szNew)				
		ln = sel.lnLast;
		ich = sel.ichLim;
		}
	
	return cReplace
}


/*   R E P L A C E   */
/*-------------------------------------------------------------------------
    Do a replace operation in the given buffer.
    Returns the number of replacements
-------------------------------------------------------------------------*/
macro DoReplace_forStruct(hbuf, szOld, szNew)
{
	TRUE = 1
	
	// find each occurence and replace each one
	ln = 0
	ich = 0
	cReplace = 0
	hwnd = 0
	while (TRUE)
		{
		sel = SearchInBuf(hbuf, szOld, ln, ich, FALSE, FALSE, FALSE)
		if (sel == "")
			break;
		if (hwnd == 0)
			{
			SetCurrentBuf(hbuf)
			hwnd = GetCurrentWnd()
			}
		cReplace = cReplace + 1
		SetWndSel(hwnd, sel)
		//msg(sel)
		szLine = GetBufLine(hbuf, sel.lnFirst )
		if(sel.ichFirst>2)
		if(szLine[sel.ichFirst-1]=="."||(szLine[sel.ichFirst-1]==">"&&szLine[sel.ichFirst-2]=="-"))
		SetBufSelText(hbuf, szNew)
					
		ln = sel.lnLast;
		ich = sel.ichLim;
		}
	
	return cReplace
}

/*   I C H   I N   S T R I N G   */
/*-------------------------------------------------------------------------
    Return index of character ch in string s;
    Return -1 if ch is not found
-------------------------------------------------------------------------*/
macro IchInString(s, ch)
{
	i = 0
	cch = strlen(s)
	while (i < cch)
		{
		if (s[i] == ch)
			return i
		i = i + 1
		}

	return (0-1)
}
//alt+p
 macro Project_OK()
{

//工程文件遍历模块
 hprj=GetCurrentProj ()
ifileMax = GetProjFileCount (hprj)
ifile=0
while (ifile < ifileMax)
    {
filename = GetProjFileName (hprj, ifile)
hbuf   =  OpenBuf (filename)
temp=OpenMiscFile (filename)
if(temp==FALSE )
{
//msg("打不开该文件!")
ifile=ifile+1
continue
}
    buf =TrimRight(filename)
    len = strlen( buf)  
        iTotalLn = GetBufLineCount (hbuf)
    if(buf[len-1]=="h")
    {
   /// CY_ChangFileHeader()
 //  CY_InsertAnyLineNote2( hbuf, 0,iTotalLn-1,0)  
     //hbuf   =  OpenBuf (filename)
    // SaveBuf (hbuf)  
    }
		 else if(buf[len-1]=="c")
	     {
	      ifdef_match()
	//  CY_ChangeVarAuto()
	///CY_ChangFileHeader()
	///CY_InsertMatch()
	isymMax = GetBufSymCount (hbuf)
    isym = 0
    while(isym<isymMax)
    {        
  
    symbol_record =GetBufSymLocation(hbuf, isym)
    symname = symbol_record.symbol//GetBufSymName (hbuf, isym)
    
	    if(symbol_record.Type == "Function") 
		{
		//msg(symname)
		//ln=symbol_record.lnFirst   //数组概念第一行 为0
	  	//  lnMax=symbol_record.lnLim   //计量，1行 为1
	    // lnLast=lnMax-1
	   // ln_input=ln	   
	  //  CY_ChangeFunHeader2(hbuf,isym,ln_input,symname)
	 	//SetCurrentBuf  (hbuf) //处理完一个函数，页面信息更新
		}
		
    	isym=isym+1
    }
	     }
	     //
	    SaveBuf (hbuf)    //保存  方便退出
	    CloseBuf (hbuf)
    ifile = ifile + 1
    }

}
macro ifdef_match()
{
   /* hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    hbuf = GetCurrentBuf() 
   // iTotalLn = GetBufLineCount (hbuf)
    ln=lnFirst
	symbol = GetSymbolLocationFromLn(hbuf, ln)*/
	hwnd = GetCurrentWnd()
	hbuf = GetCurrentBuf() 
	//if (hwnd == 0 || hbuf == 0 )
	//return 0
    isymMax = GetBufSymCount (hbuf)
    isym = 0
while(isym<isymMax)
{ 	    symbol =GetBufSymLocation(hbuf, isym)
	lnFirst=symbol.lnFirst
	if( symbol.Type!="#-Directive" ) 
	{
	isym=isym+1	
	continue	 
	} 
	//msg(symbol.symbol)
	szLine_first=GetBufLine(hbuf,lnFirst)
	//msg(szLine)
	word_def=GetAnyWord(szLine_first,1,0)
	/**/
	if(word_def!="#ifndef"&&word_def!="#ifdef"&&word_def!="#if")
	       {
			isym=isym+1	
			continue	 
			}
			
	word=GetAnyWord(szLine_first,2,0)
	SetBufIns(hbuf,lnFirst, 0)
	Select_Match
	lnLast = GetWndSelLnLast( hwnd ) 
	szLine_last=GetBufLine(hbuf,lnLast)
	szLine_last=TrimRight(szLine_last)
	      gx_start=strstr(szLine_last,"/*")
	       if(gx_start!=0xffffffff)
	       {
			isym=isym+1	
			continue	 
			} 
	       gx_start=strstr(szLine_last,"//")
	       if(gx_start!=0xffffffff)
	       {
	       szLine_last=strmid(szLine_last,0,gx_start)
			//isym=isym+1	
			//continue	 
			}
	word_def=strmid(word_def,1,strlen(word_def))
	if(szLine_last=="")
	{
	msg("error")
	return;
	}
	end_title="@szLine_last@  //end of @word@"
	//end_title="@szLine_last@  //end of @word_def@ @word@"
	if(lnLast-lnFirst>8)
	PutBufLine ( hbuf, lnLast, end_title ) 
	isym=isym+1	

}
 SaveBuf (hbuf) 
}

macro change_arryline_num()
{   
hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
    hbuf = GetCurrentBuf() 
    iTotalLn = GetBufLineCount (hbuf)
    ln=lnFirst
szLine = GetBufLine(hbuf,ln)
line_wide=ask("输入每行列数")
str1=szLine 
ln_temp=lnLast
msg(ln_temp)
while(1)
{
findLine = GetBufLine(hbuf,ln_temp)
//msg(strlen(findline))
if(strlen(findline)<2)DelBufLine (hbuf, ln_temp)


else break
ln_temp=ln_temp-1
}

deal_line_num=0
	while(1)
	{
	i=1
	j=0
	deal_line=GetBufLine(hbuf,deal_line_num)	
	//deal_line=GetFirstWord(deal_line)
	//msg(deal_line)
					 while(j<strlen(str1))
					 {
					 deal_line_next=GetBufLine(hbuf,deal_line_num+1)
					// deal_line_next=GetFirstWord(deal_line_next)
					 deal_line=cat(deal_line,"\t")
					 deal_line=cat(deal_line,deal_line_next)
					
					 DelBufLine (hbuf, deal_line_num+1)
					i=i+1
					if(i==line_wide)
					{ 
					//deal_line=cat(deal_line,"\r")
					PutBufLine (hbuf, deal_line_num, deal_line)
					
					break
					}
					 }
		deal_line_num=deal_line_num+1			 
	 }
}
//对选中行添加  宏开关
macro CY_add_macro_key()
{   
 hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    if(sel.lnFirst > 0)
    {
        ln = sel.lnFirst 
    }
    else
    {
        stop
    }
    szLine = GetBufLine(hbuf,ln)
    Sel_ichFirst=sel.ichFirst
    Sel_ichLim=sel.ichLim
    Sel_lnFirst =sel.lnFirst
    Sel_lnLast =sel.lnLast     
	szMacro_Name = getreg(Macro_Name)
	    if(Sel_ichFirst==Sel_ichLim&&strlen(szLine)==0)
    {
    szMacro_Name=ask("当前默认值为@szMacro_Name@,请输入新的宏开关名")
    SetReg (Macro_Name,szMacro_Name )
	return 0
    }
		if (strlen(szMacro_Name) <= 0)
	{
		szMacro_Name = "$"
	}
 if(sel.lnLast ==sel.lnFirst)
 {
 if(Sel_ichLim>strlen(szLine)-1)
 Sel_ichLim=strlen(szLine)
 sel_word=strmid(szLine,Sel_ichFirst,Sel_ichLim)
  find_start=strstr(sel_word," ")
  if(find_start==0xffffffff&&strlen(sel_word)>0) 
  {
	// msg("设置@sel_word@ 为新的宏开关")
	key_make=ask("输入空格，确定设置@sel_word@ 为新的宏开关")
	 SetReg (Macro_Name,sel_word )
	 return 0
  }

 }
 
 InsBufLine(hbuf, sel.lnLast+1,"#endif  //end of @szMacro_Name@")
 InsBufLine(hbuf, sel.lnFirst,"#ifdef @szMacro_Name@")
 
 		 
}

macro CY_test_line()
{   
hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
    hbuf = GetCurrentBuf() 
    iTotalLn = GetBufLineCount (hbuf)
    ln=lnFirst
szLine = GetBufLine(hbuf,ln)
line_wide=ask("输入每行列数")
str1=szLine 
	while(1)
	{
	i=0
	j=0
		
			
					 while(j<strlen(str1))
					 {
					 
						if(str1[j] == "\t" ||str1[j] == " " )
						{
						i=i+1
						 if(i==line_wide)break
						}
						
						j=j+1
						if(j==strlen(str1)-1)return 0
					 }

			
	find_start=j
	//msg(j)
	SetBufIns(hbuf,ln, find_start+1)
	ln=ln+1
	Insert_New_Line	
	hbuf = GetCurrentBuf() 
	str1= GetBufLine(hbuf,ln)
	//msg(strlen(str1))
	 }
}

//=号前空格处理
macro CY_testxxxxx()
{   
hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
    hbuf = GetCurrentBuf() 
    iTotalLn = GetBufLineCount (hbuf)
    ln=lnFirst
szLine = GetBufLine(hbuf,ln)
  find_start=strstr(szLine,"=")
 // if(gx_start!=0xffffffff) return 0
 find_start_temp=find_start;
  while(szLine[find_start_temp-1]==" "&&find_start_temp>1)
  {
	find_start_temp=find_start_temp-1
  }
	  if(find_start_temp!=find_start-1)//超过1个空格
	  { 

	  szLine_new1=strmid(szLine,0,find_start_temp);
	  
   if(find_start_temp==find_start) //没空格
		szLine_new1=cat(szLine_new1," ");
		
	  szLine_new2=strmid(szLine,find_start,strlen(szLine))	  
	  szLine_new=cat(szLine_new1,szLine_new2)
	   PutBufLine(hbuf, ln,szLine_new)
	  }

}
macro CY_del_sel_proj()
{
	hwnd = GetCurrentWnd()  
    sel = GetWndSel( hwnd ) 
    hbuf = GetCurrentBuf() 
    sel_line= GetBufLine(hbuf,sel.lnFirst)
	Breakpoint_buf=strmid(sel_line,sel.ichFirst,sel.ichLim)
	Breakpoint_buf=TrimLeft(Breakpoint_buf)
	if(strlen(Breakpoint_buf)<5)
	{
	msg("句子太短，容易误删，强制退出")
return 0
	}
	ask("确定要删除所有以 @Breakpoint_buf@ 开头的句子")；
	DelInProj_cy(Breakpoint_buf," ")
}

macro CY_del_Debu_Breakpoint()
{
		
/*		szBreakpoint_ID = 2//getreg(Breakpoint_ID)
	//msg(szBreakpoint_ID)
 	//if(szBreakpoint_ID==1||szBreakpoint_ID==nil)szBreakpoint_ID=30;
	//msg(szBreakpoint_ID)
	
while (szBreakpoint_ID>0)
	{
	Breakpoint_buf="Auto_PRINTLOG"
	//Breakpoint_buf="PATCH_PRINTLOG"

	//Breakpoint_buf="Auto_PRINTLOG(@szBreakpoint_ID@);//break point>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
	DelInProj_cy(Breakpoint_buf," ")
	szBreakpoint_ID=szBreakpoint_ID-1
	}*/
	Breakpoint_buf="Auto_PRINTLOG"

	DelInProj_cy(Breakpoint_buf," ")

	SetReg (Breakpoint_ID,1 )	

}
macro CY_Add_Debug_Breakpoint()
{
	hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    hbuf = GetCurrentBuf() 
		//	SetReg (Breakpoint_ID, )		
			szBreakpoint_ID = getreg(Breakpoint_ID)
			if (szBreakpoint_ID==nil)
	{
	szBreakpoint_ID=1
	}
	else if (szBreakpoint_ID>255) 
	szBreakpoint_ID=1
	Breakpoint_buf="Auto_PRINTLOG(@szBreakpoint_ID@);//break point>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
	 InsBufLine(hbuf, lnFirst+1,Breakpoint_buf)
	SetReg (Breakpoint_ID,szBreakpoint_ID+1 )	
	savebuf(hbuf)
}
macro CY_add_macro_kh()
{

hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
    hbuf = GetCurrentBuf() 
    iTotalLn = GetBufLineCount (hbuf)
    ln=lnFirst
	symbol = GetSymbolLocationFromLn(hbuf, ln)
	//msg(symbol)
if( symbol.Type!="Constant" && symbol.Type!="Macro" )   
 return 0
    szLine = GetBufLine(hbuf,ln)

    Sel_lnFirst =symbol.lnFirst
    Sel_lnLast =symbol.lnLim-1
     name=GetAnystring(ln,3,1)
        
      if(name=="")return 0
       name_buf=name.buf
    Sel_ichFirst=name.start
    Sel_ichLim=name.end
    
    if(name_buf[0]=="(" )
    return 0
  if(Sel_lnLast ==Sel_lnFirst)
 {

     changeSign_buf1=strmid(szLine,0,Sel_ichFirst)

 changeSign_buf2=strmid(szLine,Sel_ichFirst,Sel_ichLim)
 changeSign_buf3=strmid(szLine,Sel_ichLim,strlen(szLine))

 changeSign_buf="@changeSign_buf1@(@changeSign_buf2@)@changeSign_buf3@"
 PutBufLine(hbuf, ln,changeSign_buf)
 }
 else
 {
// msg("last")

  name=GetAnystring(Sel_lnLast,1,1) 
    find_while=strstr(name.buf,"while")
  if(find_while!=0xffffffff)return 0;
 Sel_ichLim=name.end
 changeSign_buf=InserCharInString_cy(szLine,"(",Sel_ichFirst)
 PutBufLine(hbuf, Sel_lnFirst,changeSign_buf)
 szLine2 = GetBufLine(hbuf,Sel_lnLast )
 changeSign_buf2=InserCharInString_cy(szLine2,")",Sel_ichLim)
  PutBufLine(hbuf, Sel_lnLast,changeSign_buf2)	
 }
}
macro CY_test_file()
{
    hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    hbuf = GetCurrentBuf() 
   // iTotalLn = GetBufLineCount (hbuf)
    ln=lnFirst
	symbol = GetSymbolLocationFromLn(hbuf, ln)
	msg(symbol.Type)
if( symbol.Type!="#-Directive" )   
 return 0	 
szLine=GetBufLine(hbuf,ln)
word_def=GetAnyWord(szLine,1,0)
if(word_def!="#ifndef")return 0
word=GetAnyWord(szLine,2,0)
Select_Match
lnLast = GetWndSelLnLast( hwnd ) 
szLine_last=GetBufLine(hbuf,lnLast)
szLine_last=TrimRight(szLine_last)
      gx_start=strstr(szLine_last,"/*")
       if(gx_start!=0xffffffff) return 0
       gx_start=strstr(szLine_last,"//")
       if(gx_start!=0xffffffff) return 0
end_title="@szLine_last@//end of @word@"
if(lnLast-lnFirst>9)
PutBufLine ( hbuf, lnLast, end_title ) 
}
macro Ctest_deal()
{		
		filename_text="result.txt"
		hbuf_txt =  OpenBuf (filename_text)	
		iTotalLn_txt =GetBufLineCount (hbuf_txt)
		ln_txt=0
		file_last=""
 while(ln_txt+8<iTotalLn_txt)
	 {
			szLine_Rule_ID = GetBufLine(hbuf_txt,ln_txt+4)
				gx_start=strstr(szLine_Rule_ID,"FW-")  
		      	if(gx_start==0xffffffff)
		      	{
				msg("error")
		      	return 0
				}
				Rule_ID=strmid(szLine_Rule_ID,gx_start,strlen(szLine_Rule_ID))
					if(
					(
					//Rule_ID=="FW-FORMAT-MST.M200419_10")
					//||(Rule_ID=="FW-SAFTY-MST.75")||(Rule_ID=="FW-FORMAT-MST.G96")
					(Rule_ID=="FW-FORMAT-MST.07")  // =前 ASCII 空格
				//	||Rule_ID=="FW-FORMAT-MST.04"   //超过120
					)
					{
				szLine_msg = GetBufLine(hbuf_txt,ln_txt)
						//路径提取，打开文件
				szLine_txt = GetBufLine(hbuf_txt,ln_txt+1)
				buf_char=CharFromAscii (92)
				filename_head="@buf_char@src@buf_char@"
				gx_start=strstr(szLine_txt,filename_head)  
		      	if(gx_start==0xffffffff)return 0
		      	filename_this=strmid(szLine_txt,gx_start,strlen(szLine_txt))
		      	if(file_last!=filename_this)
		      	{
		      	if(file_last!="")
		      	{
		      //	savebuf(hbuf_cfile)
				//closebuf(hbuf_cfile)
		      	}
		      	file_last=filename_this
		      	}
		      	temp=OpenMiscFile (filename_this)
				hbuf_cfile   =  OpenBuf (filename_this)
				//行号提取，跳转到行
				szLine_line_num = GetBufLine(hbuf_txt,ln_txt+3)
				ln_cfile= strmid(szLine_line_num,6,strlen(szLine_line_num))-1
				SetBufIns(hbuf_cfile,ln_cfile, 0)
				Select_Line
				
		if(Rule_ID=="FW-FORMAT-MST.M200419_10")
		{
			symbol = GetSymbolLocationFromLn(hbuf_cfile, ln_cfile)
			if (symbol == "")
				{
				ln_txt=ln_txt+8
				continue
				}
			err_start=strstr(szLine_msg,"'")
			err_word  = GetNearWord_cy(szLine_msg,err_start,1)
			new_word="(@err_word@)"	
			if(symbol.lnLim-symbol.lnFirst>1  )
			 DoReplace_ADDkh(hbuf_cfile, err_word, new_word,symbol.lnFirst,symbol.lnLim)	
			//Replacefile_cy(err_word,new_word,hbuf_cfile,symbol.lnFirst+1,symbol.lnLim)
			else 
			{
			hwnd = 0
			ich=0
			sel = SearchInBuf(hbuf_cfile, err_word, ln_cfile, ich, TRUE, FALSE, TRUE)
			if (sel == "")
				{
				ln_txt=ln_txt+8
				continue
				}
			ich = sel.ichLim;
			sel = SearchInBuf(hbuf_cfile, err_word, ln_cfile, ich, TRUE, FALSE, TRUE)
			//SearchInBuf(hbuf, szOld, ln, ich, TRUE, FALSE, TRUE)

			if (sel == "")
				{
				ln_txt=ln_txt+8
				continue
				}
			if (hwnd == 0)
				{
				SetCurrentBuf(hbuf_cfile)
				hwnd = GetCurrentWnd()
				}
			SetWndSel(hwnd, sel)
		szLine = GetBufLine(hbuf_cfile, sel.lnFirst )
		if(sel.ichFirst>2)
		if((szLine[sel.ichFirst-1]=="("&&szLine[sel.ichLim]==")")||(szLine[sel.ichFirst-2]=="("&&szLine[sel.ichLim+1]==")"))
		//if((szLine[sel.ichFirst-1]=="("||szLine[sel.ichFirst-2]=="(")&&(szLine[sel.ichLim]==")"||szLine[sel.ichLim+1]==")"))
		{
		}
		else
		SetBufSelText(hbuf_cfile, new_word)
			}
		}
		 else if(Rule_ID=="FW-FORMAT-MST.04")
		{
		  // msg("del")
			CY_DelLineTitle() 
		}
		else if((Rule_ID=="FW-SAFTY-MST.75")||(Rule_ID=="FW-FORMAT-MST.G96"))
		{
hwnd = GetCurrentWnd()  
  //  selection = GetWndSel( hwnd )  
  //  lnFirst = GetWndSelLnFirst( hwnd )  
   // lnLast = GetWndSelLnLast( hwnd ) 
   
    hbuf = hbuf_cfile
  //  iTotalLn = GetBufLineCount (hbuf)
    ln=ln_cfile
	symbol = GetSymbolLocationFromLn(hbuf_cfile, ln_cfile)
	if (symbol == "")
				{
				ln_txt=ln_txt+8
				continue
				}
if( symbol.Type!="Constant" && symbol.Type!="Macro" )   
{
				ln_txt=ln_txt+8
				continue
				}
    szLine = GetBufLine(hbuf_cfile, ln_cfile)
 name=GetAnystring(ln,3,1) 
 if(name=="")
   {
				ln_txt=ln_txt+8
				continue
	}
     Sel_ichFirst=name.start
    Sel_ichLim=name.end
    Sel_lnFirst =symbol.lnFirst
    Sel_lnLast =symbol.lnLim-1
    name_buf=name.buf
      if(name_buf[0]=="(" )
  {
				ln_txt=ln_txt+8
				continue
	}
  if(Sel_lnLast ==Sel_lnFirst)
 {
     changeSign_buf1=strmid(szLine,0,Sel_ichFirst)

 changeSign_buf2=strmid(szLine,Sel_ichFirst,Sel_ichLim)
 changeSign_buf3=strmid(szLine,Sel_ichLim,strlen(szLine))

 changeSign_buf="@changeSign_buf1@(@changeSign_buf2@)@changeSign_buf3@"
 PutBufLine(hbuf, ln,changeSign_buf)
 }
 else
 {
  name=GetAnystring(Sel_lnLast,1,1) 
  find_while=strstr(name.buf,"while")
  if(find_while!=0xffffffff)
  {
				ln_txt=ln_txt+8
				continue
  }
 Sel_ichLim=name.end
 changeSign_buf=InserCharInString_cy(szLine,"(",Sel_ichFirst)
 PutBufLine(hbuf, Sel_lnFirst,changeSign_buf)
 szLine2 = GetBufLine(hbuf,Sel_lnLast )
 changeSign_buf2=InserCharInString_cy(szLine2,")",Sel_ichLim)
  PutBufLine(hbuf, Sel_lnLast,changeSign_buf2)	
 }

		}
	 else if(Rule_ID=="FW-FORMAT-MST.07")
	{  
	// msg("=")
	    hbuf = hbuf_cfile
	    ln=ln_cfile
	hwnd = GetCurrentWnd()  
	selection = GetWndSel( hwnd )  
	szLine = GetBufLine(hbuf,ln)
	  find_start=strstr(szLine,"=")
	  if(find_start==0xffffffff) 
	  {
      ln_txt=ln_txt+8
	  continue
	  }
	  	 // msg(szLine[find_start])

	 find_start_temp=find_start;
	  while(szLine[find_start_temp-1]==" "&&find_start_temp>1)
	  {
		find_start_temp=find_start_temp-1
	  }
	  if(find_start_temp!=find_start-1)//超过1个空格
	  { 

	  szLine_new1=strmid(szLine,0,find_start_temp);
	  
 //  if(find_start_temp==find_start) //没空格
		szLine_new1=cat(szLine_new1," ")
		
	  szLine_new2=strmid(szLine,find_start,strlen(szLine))	  
	  szLine_new=cat(szLine_new1,szLine_new2)
	   PutBufLine(hbuf, ln,szLine_new)
	  }

	}
		
 savebuf(hbuf_cfile)
 closebuf(hbuf_cfile)
					}

	ln_txt=ln_txt+8
	 }	
}
macro funcdef_test()
{
//////////////////////单行测试
     hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
    hbuf = GetCurrentBuf() 
    iTotalLn = GetBufLineCount (hbuf)
    ln=lnFirst
	symbol = GetSymbolLocationFromLn(hbuf, ln)
    szLine = GetBufLine(hbuf,ln)
if(symbol.Type!="Function Prototype")return 0
//////////////////////////
//从函数头分离出函数参数
iBegin = symbol.ichName
hTmpBuf = NewBuf("Tempbuf")
nMaxParamSize = GetWordFromString(hTmpBuf,szLine,iBegin,strlen(szLine),"(",",",")")
    xdate_start=strstr(this_line,";")  
	if(xdate_start!=0xffffffff ) SetBufIns (hbuf, ln,xdate_start )
	Jump_To_Definition
	hbuf_def = GetCurrentBuf() 
 	hwnd_def= GetCurrentWnd()  
    selection = GetWndSel( hwnd_def )  
    ln_def = GetWndSelLnFirst( hwnd_def)  
    symbol_def = GetSymbolLocationFromLn(hbuf_def, ln_def)
    iTotalLn_def=symbol_def.lnLim
        lnMax = GetBufLineCount(hTmpBuf)
        i = 0
	        while ( i < lnMax) 
        {
 myVar=return_var_type(hTmpBuf,ln,ProjctOrFunc)
if(new_var=="")return 0
new_var=myVar.new
this_var=myVar.old 
  Replacefile_cy(this_var,new_var,hbuf_def,ln_def,iTotalLn)
            i=i+1
        }
      //  CloseBuf (hTmpBuf)       


Go_Back
 CloseBuf (hbuf_def)  


}
macro project_test()
{
//工程文件遍历模块
 hprj=GetCurrentProj ()
ifileMax = GetProjFileCount (hprj)
ifile=0
while (ifile <2)
    {
filename = GetProjFileName (hprj, ifile)
//hbuf   =  OpenBuf (filename)
hbuf   = GetBufHandle (filename)
//temp=OpenMiscFile (filename)
    buf =TrimRight(filename)
    len = strlen( buf)  
    if(buf[len-1]=="h")
    
    break
    ifile = ifile + 1
    }
/**/
msg(ifileMax)
 msg(filename)
//当前文件 符号(函数名和endif,include等)遍历
    	//isymMax = GetBufSymCount (hbuf)
       isym = 0
       symname = GetBufSymName (hbuf, isym)
        lnLast=GetSymbolLine (symname)
    msg(symname)
}
macro CY_test413()
{
	/* This does a progressive search as the user types characters
	   Pressing Enter or Escape will cancel the search 
	*/

    hbuf = GetCurrentBuf()
    hwnd = GetCurrentWnd()

    key = 0
    char = 1 // needs to start with any non-zero value
    SearchFor = ""
    sel = GetWndSel(hwnd)
    
	while (char != 0)
	{
		key = GetKey()
		char = CharFromKey(key)
		if (char != 0)
		{
		    
			if (key == 13) //Enter searches current string again
				sel.ichFirst = sel.ichFirst + 1
			else if (key == 8) // backspace
			{
				if (strlen(SearchFor) > 0)
					SearchFor = strtrunc (SearchFor, strlen(SearchFor) - 1)
			}
			else
				SearchFor = cat(SearchFor, char)
			sel = SearchInBuf(hbuf, SearchFor, sel.lnFirst, sel.ichFirst, 0, 0, 0)
			if (sel == "")
			{
				sel = GetWndSel(hwnd)
				if (key == 13)
				{
					sel.fExtended = 0
					sel.ichLim = sel.ichFirst
					SetWndSel(hwnd, sel)
					char = 0
					Beep()
				}
				else  
					if (strlen(SearchFor) > 0)
						SearchFor = strtrunc (SearchFor, strlen(SearchFor) - 1)
			}
			else
			{
        		ScrollWndToLine(hwnd, sel.lnFirst)
        		SetWndSel(hwnd, sel)
                LoadSearchPattern(SearchFor, 0, 0, 0)
        	}
        }
	}
}
	

macro AddSignStart2End()   
{   //用杠杠注释,不选中多行的话,注释当前行  
    hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
    hbuf = GetCurrentBuf()  
 	buf= GetBufSelText (hbuf)
 	msg(buf)
    ln = lnFirst  
    buf0 = GetBufLine( hbuf, ln ) 
    buf =TrimRight(buf0)
    len = strlen( buf ) 
    firststart = len   
////////////////////////////
//获取所选行的长度均值
   	ln = lnFirst 
 	line_num=0
	total_len=0
    avg_len=0
    if( ln == lnLast )line_num=1 
      while( ln <= lnLast )  
    {  
        buf0 = GetBufLine( hbuf, ln ) 
    	buf =TrimRight(buf0) 
        len = strlen( buf )  
        start = 0
        buf2 = TrimLeft(buf)  //去前面的空格，得到真实句子buf2,别把buf替换了，后面还要用其真实格式
		real_len=strlen(buf2)
        if(  real_len >1 &&len <50  )  
        {  
           line_num=line_num+1								
           total_len=total_len+len          
        }  
        ln = ln + 1  
    }
   SetBufIns(hbuf,ln-1, new_len+1)
}
/*
a b c d e f g h i j 
k l m n o p q r s t
u v w x y z
*/
//修改模式时，个人ID，可通过输入cg 加按键ctrl+enter 修改个人信息
macro CY_InsertID() 
{
	// get mode ID
	IDbuf=""
	szModeID = getreg(ModeID)   		 // change ID
	if (szModeID!=1)
	{
		return IDbuf
	}
    szTime = GetSysTime(True)
	Day = szTime.Day
	Month = szTime.Month
	Year = szTime.Year
	Compress_Mode=0   //1压缩模式
	if(Compress_Mode==1)
{
szDay = get_36jinz(Day)
szMonth = get_36jinz(Month)
Year=Year-2000

szYear = get_36jinz(Year)
 }
else 

{
	if (Day < 10)
	{
		szDay = "0@Day@"
	}
	else
	{
		szDay = Day
	}
	if (Month < 10)
	{
		szMonth = "0@Month@"
	}
	else
	{
		szMonth = Month
	}
	szYear=Year
}
	// get change ID
	szProbmID = getreg(ProbmID)   		 // change ID
    IDlen=strlen(szProbmID)
	if(IDlen>2)
	//szProbmID=strmid( szProbmID, IDlen-2, IDlen ) 
	 szProbmID = szProbmID-szProbmID/100*100
        if(szProbmID == "#")
    {
      szProbmID="1"
    }
    /*
    else if (szProbmID < 10)
	{
		szProbmID = "0@szProbmID@"
	}
    else  if (szProbmID >100)
    {
    szProbmID = szProbmID-szProbmID/100*100
     if (szProbmID < 10)
     szProbmID = "0@szProbmID@"
    } */
	//get aurthor name
	szMyName = getreg(MYNAME)    
	if (strlen(szMyName) <= 0)
	{
		szMyName = ""
	}
		// get aurthor ID
		szMyID = getreg(MYID)   		 //MyID
	//	Msg(szMyID)
	if (strlen(szMyID) <= 0)
	{
		szMyID = "0000"
	}
    BlankString=CreateBlankString(6)
	IDbuf="G@szYear@@szMonth@@szDay@@szMyID@@szProbmID@ @szMyName@ "
    
//	IDbuf="G@szYear@@szMonth@@szDay@@szMyID@@szProbmID@@BlankString@@szMyName@" //
	return IDbuf

}
macro CY_InsertID2() 
{
	// get mode ID
	IDbuf=""
	szModeID = getreg(ModeID)   		 // change ID
	if (szModeID!=1)
	{
		return IDbuf
	}
    szTime = GetSysTime(True)
	Day = szTime.Day
	Month = szTime.Month
	Year = szTime.Year
	if (Day < 10)
	{
		szDay = "0@Day@"
	}
	else
	{
		szDay = Day
	}
	if (Month < 10)
	{
		szMonth = "0@Month@"
	}
	else
	{
		szMonth = Month
	}

	// get change ID
	szProbmID = getreg(ProbmID)   		 // change ID
    IDlen=strlen(szProbmID)
	if(IDlen>2)
	//szProbmID=strmid( szProbmID, IDlen-2, IDlen ) 
	 szProbmID = szProbmID-szProbmID/100*100
        if(szProbmID == "#")
    {
      szProbmID="01"
    }
    else if (szProbmID < 10)
	{
		szProbmID = "0@szProbmID@"
	}
    else  if (szProbmID >100)
    {
    szProbmID = szProbmID-szProbmID/100*100
     if (szProbmID < 10)
     szProbmID = "0@szProbmID@"
    } 
	//get aurthor name
	szMyName = getreg(MYNAME)    
	if (strlen(szMyName) <= 0)
	{
		szMyName = ""
	}
		// get aurthor ID
		szMyID = getreg(MYID)   		 //MyID
	//	Msg(szMyID)
	if (strlen(szMyID) <= 0)
	{
		szMyID = "0000"
	}
	
	IDbuf="G16@szMonth@@szDay@@szMyID@@szProbmID@ @szMyName@ "
	return IDbuf

}
macro FindGG( buf) 
{
len = strlen( buf )

if( len >= 2 ) 
{  
            start = 0  
  
            while( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9) )  
            {  
                start = start + 1  
                if( start >= len )  
                    break  
            }  
            while( start <= len - 2 )  
            {  

                if( strmid( buf, start, start+1  ) == "/" && strmid( buf, start+1, start + 2 ) == "/" )  
                {  
					Title_num_temp=Title_num*2
					
					ln_temp=ln
					//低地址 存低位		
					Title_ln[Title_num_temp+1]=CharFromAscii (ln_temp/100)
					//ln_temp=ln%1000
					Title_ln[Title_num_temp]=CharFromAscii (ln_temp-(ln_temp/100)*100)			
					Title_start[Title_num]=CharFromAscii(start)
                    
					//标准长度收集
					buf1 = strmid( buf,0,start)
					
  					buf11 =TrimRight(buf1) 	
		 			real_len= strlen(buf11)
		 			Title_len[Title_num]=CharFromAscii(real_len)
		 			if(real_len<50&&real_len>4)
		 			{
					norm_num=norm_num+1
					len_sum=len_sum+real_len
					}
					Title_num=Title_num+1
                 break
                }  
			 start = start + 1 
            }  
        }
}
macro CY_LineNoteADDorAjust()
{
    hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
    hbuf = GetCurrentBuf()  
CY_InsertAnyLineNote( hbuf, lnFirst,lnLast,1)  
}
macro CY_InsertAnyLineNote2( hbuf, lnFirst,lnLast,add_title_mode)  
{   //对齐杠杠注释,不选中多行的话,默认只处理当前行  
    long_flag=0
    ln = lnFirst
    Title_num=0
    norm_num=0
    len_sum=0
    ln_temp=0
    buf_ID=CY_InsertID()  //
    buf_ID=cat("//",buf_ID)
    new_len =0
    pitch_len=15
    //整型数组 比较麻烦
    Title_ln= "" 
    Title_start= "" 
	Title_len=  ""
    while( ln <= lnLast )  
    {  
        buf = GetBufLine( hbuf, ln )  
    	buf =TrimRight(buf)   	
        len = strlen( buf )  
        if( len >= 2 )  
        {  
            start = 0  
  
            while( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9) )  
            {  
                start = start + 1  
                if( start >= len )  
                    break  
            }  
            while( start <= len - 2 )  
            {  

                if( strmid( buf, start, start+1  ) == "/" && strmid( buf, start+1, start + 2 ) == "/" )  
                {  
					Title_num_temp=Title_num*2
					
					ln_temp=ln
					Title_ln=WriteNumString(Title_ln,Title_num,ln_temp,2)		
					Title_start=WriteNumString(Title_start,Title_num,start,1)
					//Title_start[Title_num]=CharFromAscii(start)
                    
					//标准长度收集
					buf1 = strmid( buf,0,start)
					
  					buf11 =TrimRight(buf1) 	
		 			real_len= strlen(buf11)
		 			Title_len=WriteNumString(Title_len,Title_num,real_len,1)
		 			//Title_len[Title_num]=CharFromAscii(real_len)
		 			if(real_len<50&&real_len>4)
		 			{
					norm_num=norm_num+1
					len_sum=len_sum+real_len
					}
					Title_num=Title_num+1
                 break
                }  
			 start = start + 1 
            }  
        }  
        ln = ln + 1  
    }
    /////////////////////////////////
   	//上面只是采集信息，下面开始处理对齐
   	/////////////////////////////
   	avg_len=0
	  if( norm_num > 0 &&norm_num<20) avg_len=(( len_sum/norm_num)/pitch_len+1)*pitch_len

		   	 while( Title_num > 0 )  
		    {  
		    //上面先计算加1，这里先减再计算
		    Title_num=Title_num-1
		  //参数重置	
		buf_tempp=ReadNumString(Title_ln,Title_num ,2)
	  ln=buf_tempp
	  	len=ReadNumString(Title_len,Title_num,1)
	  	start=ReadNumString(Title_start,Title_num,1)
         buf = GetBufLine( hbuf, ln ) 
    	 buf =TrimRight(buf) 
         len_total = strlen( buf ) 
		 buf1 = strmid( buf,0,len)
		 if(len_total>len)
		 buf_CN = strmid( buf,start+2,len_total )  //注释字符串
		else buf_CN=""
		buf_CN=cat(buf_ID,buf_CN)
    	//标准的对齐模块,ajust 不需要 len>0
        if(  len<75&&len_total<115) 
        {           
	 norm_len=avg_len
	//超出平均长度 的处理
	 if(len>norm_len)
	 norm_len=(len/pitch_len+1)*pitch_len
	 
     //  for(i=0;i<60-len;i++)
       buf_space=""
       i=len
    //   norm_len=(len/10+1)*10
       while(norm_len-i>1)
       	{
		buf_space=cat(buf_space, " ")	
        i = i +1; 
		}
		//msg(buf_space)
      	 // buf2=cat(buf, "//")
          buf2 = cat( buf1, cat(buf_space , buf_CN ) )
              new_len = strlen( buf2 ) 
         //buf2 = cat( buf, cat(buf_space , buf_CN ) )    
            PutBufLine ( hbuf, ln, buf2 )  
        }
        else if( len>=75||len_total>115)
        {
			start=0
         while( start < len )
         {
			if( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9))  
            {  
                start = start + 1  
                if( start > len )  
                    break  
            }
            else break
          }  
			num_space=start
			 buf_space=""
		  	while(num_space>0)
       		{
			buf_space=cat(buf_space, " ")	
        	num_space =num_space -1; 
			}
			 buf2 = cat(buf_space , buf_CN ) 
             new_len = strlen( buf2 )  
            //先去注释，再插入 
          	PutBufLine ( hbuf, ln, buf1 )  
          	InsBufLine(hbuf, ln, buf2)
			//添加了一行，计数加1，方便后面处理
			ln = ln + 1 
			long_flag=1
        }
        ln = ln + 1  
		
	}
	
   if(long_flag==1)ln = ln - 1 
   SetBufIns(hbuf,ln-1, new_len+1)
} 

macro CY_InsertAnyLineNote( hbuf, lnFirst,lnLast,add_title_mode)  
 {   //对齐杠杠注释,不选中多行的话,默认只处理当前行  

    long_flag=0
    ln = lnFirst
    Title_num=0
    norm_num=0
    len_sum=0
    ln_temp=0
    buf_ID=CY_InsertID2()  
    buf_ID=cat("//",buf_ID)
    buf2=""
    ///
    avg_len=0
	pitch_len=15
    new_len =0
    //整型数组 比较麻烦
    Title_ln= "" 
    Title_start= "" 
	Title_len=  ""
	real_line_num=0
	real_unline_num=0
	real_unline_ln=""
	real_unline_len_sum=0

    while( ln <= lnLast )  
    {  
        buf = GetBufLine( hbuf, ln )  
    	buf =TrimRight(buf)   	
        len = strlen( buf )  
        if( len >= 2 )  
        {  
            start = 0  
  			 IsLineGG_flag=0
            while( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9) )  
            {  
                start = start + 1  
                if( start >= len )  
                    break  
            }  
            while( start <= len - 2 )   //do 
            {  
            real_line_num=real_line_num+1
                if( strmid( buf, start, start+1  ) == "/" && strmid( buf, start+1, start + 2 ) == "/" )  
                {  
					Title_num_temp=Title_num*2
					
					ln_temp=ln
					Title_ln=WriteNumString(Title_ln,Title_num,ln_temp,2)		
					Title_start=WriteNumString(Title_start,Title_num,start,1)
					//Title_start[Title_num]=CharFromAscii(start)
                    
					//标准长度收集
					buf1 = strmid( buf,0,start)
					
  					buf11 =TrimRight(buf1) 	
		 			real_len= strlen(buf11)
		 			Title_len=WriteNumString(Title_len,Title_num,real_len,1)
		 			//Title_len[Title_num]=CharFromAscii(real_len)
		 			if(real_len<50&&real_len>4)
		 			{
					norm_num=norm_num+1
					len_sum=len_sum+real_len
					}
					Title_num=Title_num+1
					IsLineGG_flag=1
                 break
                }  
                
			 start = start + 1 
            }  
            //遍历完成
                if(IsLineGG_flag == 0)
                {  
               real_unline_len_sum=real_unline_len_sum+real_len
				real_unline_ln=WriteNumString(real_unline_ln,real_unline_num,ln,2)
				real_unline_num=real_unline_num+1
                }
        }  
        ln = ln + 1  
    }
    /////////////////////////////////
   	//上面只是采集信息，下面开始处理对齐
   	/////////////////////////////

	  if( norm_num > 0 ) avg_len=(( len_sum/norm_num)/pitch_len+1)*pitch_len

		   	 while( Title_num > 0 )  
		    {  
		    //上面先计算加1，这里先减再计算
		    Title_num=Title_num-1
		  //参数重置	
		buf_tempp=ReadNumString(Title_ln,Title_num ,2)
	  ln=buf_tempp
	  	len=ReadNumString(Title_len,Title_num,1)
	  	start=ReadNumString(Title_start,Title_num,1)
         buf = GetBufLine( hbuf, ln ) 
    	 buf =TrimRight(buf) 
         len_total = strlen( buf ) 
		 buf1 = strmid( buf,0,len)
		 if(len_total>len)
		 buf_CN = strmid( buf,start+2,len_total )  //注释字符串
		else buf_CN=""
		buf_CN=cat(buf_ID,buf_CN)
    	//标准的对齐模块,ajust 不需要 len>0
        if(  len<75&&len_total<115) 
        {           
	 norm_len=avg_len
	//超出平均长度 的处理
	 if(len>norm_len)
	 norm_len=(len/pitch_len+1)*pitch_len
	 
     //  for(i=0;i<60-len;i++)
       buf_space=""
       i=len
    //   norm_len=(len/10+1)*10
       while(norm_len-i>1)
       	{
		buf_space=cat(buf_space, " ")	
        i = i +1; 
		}
		//msg(buf_space)
      	 // buf2=cat(buf, "//")
          buf2 = cat( buf1, cat(buf_space , buf_CN ) )
              new_len = strlen( buf2 ) 
         //buf2 = cat( buf, cat(buf_space , buf_CN ) )    
            PutBufLine ( hbuf, ln, buf2 )  
        }
        else if( len>=75||len_total>115)
        {
			start=0
         while( start < len )
         {
			if( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9))  
            {  
                start = start + 1  
                if( start > len )  
                    break  
            }
            else break
          }  
			num_space=start
			 buf_space=""
		  	while(num_space>0)
       		{
			buf_space=cat(buf_space, " ")	
        	num_space =num_space -1; 
			}
			 buf2 = cat(buf_space , buf_CN ) 
             new_len = strlen( buf2 )  
            //先去注释，再插入 
          	PutBufLine ( hbuf, ln, buf1 )  
          	InsBufLine(hbuf, ln, buf2)
			//添加了一行，计数加1，方便后面处理
			ln = ln + 1 
			//long_flag=1
        }
        ln = ln + 1  
		
	}
	/////////////////////////////////
	/////////////无注释行处理///////////////////
	if(real_line_num>Title_num&&add_title_mode==1)
	{
	if(real_unline_num)
	 avg_len=(( real_unline_len_sum/real_unline_num)/pitch_len+1)*pitch_len 
		  while( real_unline_num > 0 )  
		   {  
		    //上面先计算加1，这里先减再计算
		real_unline_num=real_unline_num-1
		buf_tempp=ReadNumString(real_unline_ln,real_unline_num ,2)
		ln=buf_tempp
		
         buf0 = GetBufLine( hbuf, ln ) 
    	buf =TrimRight(buf0) 
        len = strlen( buf ) 
        buf2 = TrimLeft(buf)  //去前面的空格，得到真实句子
		  real_len=strlen(buf2)
        
        if( real_len>1&&len<75) 
        {           
	 norm_len=(avg_len/pitch_len+1)*pitch_len
	//超出平均长度 的处理
	 if(len>norm_len)
	 norm_len=(len/pitch_len+1)*pitch_len	 
     //  for(i=0;i<60-len;i++)
       buf_space=""
       i=len
    //   norm_len=(len/10+1)*10
       while(norm_len-i>1)
       	{
		buf_space=cat(buf_space, " ")	
        i = i +1; 
		}
		//msg(buf_space)
      	 // buf2=cat(buf, "//")
          buf2 = cat( buf, cat(buf_space , "@buf_ID@ $" ) )
              new_len = strlen( buf2 )  
            PutBufLine ( hbuf, ln, buf2 )  
        }
        else if( len>=75)
        {
			start=0
         while( start < len )
         {
			if( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9))  
            {  
                start = start + 1  
                if( start > len )  
                    break  
            }
            else break
          }  
			num_space=start
			 buf_space=""
		  	while(num_space>0)
       		{
			buf_space=cat(buf_space, " ")	
        	num_space =num_space -1; 
			}
			 buf2 = cat(buf_space , "@buf_ID@ $" ) 
             new_len = strlen( buf2 )  
          //  PutBufLine ( hbuf, ln, buf2 )  
          	InsBufLine(hbuf, ln, buf2)
          	//添加了一行，计数加1，方便后面处理
			ln = ln + 1 
			long_flag=1
        }
        ln = ln + 1  
    }
			
	}

   if(long_flag==1)ln = ln - 1 
   SetBufIns(hbuf,ln-1, new_len+1)
}
//数组名 数组指针  赋值()  mode(1/2位字符>>  2位或4位十进制)
macro WriteNumString(match_lnFirst,match_num,ln_temp,mode)
{
if(mode==2)
{
					if(strlen(match_lnFirst)<(match_num+1)*2)
					{
					match_lnFirst=cat(match_lnFirst,CharFromAscii (32+ln_temp-(ln_temp/100)*100))	//字符串最小字符为32
					match_lnFirst=cat(match_lnFirst,CharFromAscii (32+ln_temp/100))
					}
					else 
					{
					match_lnFirst[match_num*2]=CharFromAscii (32+ln_temp-(ln_temp/100)*100)	//字符串最小字符为32
					match_lnFirst[match_num*2+1]=CharFromAscii (32+ln_temp/100)
					}
}
else if(mode==1)					
{
if(strlen(match_lnFirst)<(match_num+1))
					{				
					match_lnFirst=cat(match_lnFirst,CharFromAscii (32+ln_temp))
					}
					else 
					{				
					match_lnFirst[match_num]=CharFromAscii (32+ln_temp)
					}
}
 return match_lnFirst
}
macro ReadNumString(match_lnFirst,match_num, mode)
{
if(mode==1)	
buf_tempp=AsciiFromChar(match_lnFirst[match_num])-32
else if(mode==2)	
buf_tempp=AsciiFromChar(match_lnFirst[match_num*2])-32+(AsciiFromChar(match_lnFirst[match_num*2+1])-32)*100
return buf_tempp
}
macro CY_LineNoteAjust() 
{   //对齐杠杠注释,不选中多行的话,默认只处理当前行  
    hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
    long_flag=0
    hbuf = GetCurrentBuf()  
    ln = lnFirst
    Title_num=0
    norm_num=0
    len_sum=0
    ln_temp=0
    buf_ID=CY_InsertID()  //
    buf_ID=cat("//",buf_ID)
    new_len =0
    pitch_len=15
    //整型数组 比较麻烦
    Title_ln= "" 
    Title_start= "" 
	Title_len=  ""
    while( ln <= lnLast )  
    {  
        buf = GetBufLine( hbuf, ln )  
    	buf =TrimRight(buf)   	
        len = strlen( buf )  
        if( len >= 2 )  
        {  
            start = 0  
  
            while( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9) )  
            {  
                start = start + 1  
                if( start >= len )  
                    break  
            }  
            while( start <= len - 2 )  
            {  

                if( strmid( buf, start, start+1  ) == "/" && strmid( buf, start+1, start + 2 ) == "/" )  
                {  
					Title_num_temp=Title_num*2
					
					ln_temp=ln
					Title_ln=WriteNumString(Title_ln,Title_num,ln_temp,2)		
					Title_start=WriteNumString(Title_start,Title_num,start,1)
					//Title_start[Title_num]=CharFromAscii(start)
                    
					//标准长度收集
					buf1 = strmid( buf,0,start)
					
  					buf11 =TrimRight(buf1) 	
		 			real_len= strlen(buf11)
		 			Title_len=WriteNumString(Title_len,Title_num,real_len,1)
		 			//Title_len[Title_num]=CharFromAscii(real_len)
		 			if(real_len<50&&real_len>4)
		 			{
					norm_num=norm_num+1
					len_sum=len_sum+real_len
					}
					Title_num=Title_num+1
                 break
                }  
			 start = start + 1 
            }  
        }  
        ln = ln + 1  
    }
    /////////////////////////////////
   	//上面只是采集信息，下面开始处理对齐
   	/////////////////////////////
   	avg_len=0
	  if( norm_num > 0 &&norm_num<20) avg_len=(( len_sum/norm_num)/pitch_len+1)*pitch_len

		   	 while( Title_num > 0 )  
		    {  
		    //上面先计算加1，这里先减再计算
		    Title_num=Title_num-1
		  //参数重置	
		buf_tempp=ReadNumString(Title_ln,Title_num ,2)
	  ln=buf_tempp
	  	len=ReadNumString(Title_len,Title_num,1)
	  	start=ReadNumString(Title_start,Title_num,1)
         buf = GetBufLine( hbuf, ln ) 
    	 buf =TrimRight(buf) 
         len_total = strlen( buf ) 
		 buf1 = strmid( buf,0,len)
		 if(len_total>len)
		 buf_CN = strmid( buf,start+2,len_total )  //注释字符串
		else buf_CN=""
		buf_CN=cat(buf_ID,buf_CN)
    	//标准的对齐模块,ajust 不需要 len>0
        if(  len<75&&len_total<115) 
        {           
	 norm_len=avg_len
	//超出平均长度 的处理
	 if(len>norm_len)
	 norm_len=(len/pitch_len+1)*pitch_len
	 
     //  for(i=0;i<60-len;i++)
       buf_space=""
       i=len
    //   norm_len=(len/10+1)*10
       while(norm_len-i>1)
       	{
		buf_space=cat(buf_space, " ")	
        i = i +1; 
		}
		//msg(buf_space)
      	 // buf2=cat(buf, "//")
          buf2 = cat( buf1, cat(buf_space , buf_CN ) )
              new_len = strlen( buf2 ) 
         //buf2 = cat( buf, cat(buf_space , buf_CN ) )    
            PutBufLine ( hbuf, ln, buf2 )  
        }
        else if( len>=75||len_total>115)
        {
			start=0
         while( start < len )
         {
			if( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9))  
            {  
                start = start + 1  
                if( start > len )  
                    break  
            }
            else break
          }  
			num_space=start
			 buf_space=""
		  	while(num_space>0)
       		{
			buf_space=cat(buf_space, " ")	
        	num_space =num_space -1; 
			}
			 buf2 = cat(buf_space , buf_CN ) 
             new_len = strlen( buf2 )  
            //先去注释，再插入 
          	PutBufLine ( hbuf, ln, buf1 )  
          	InsBufLine(hbuf, ln, buf2)
			//添加了一行，计数加1，方便后面处理
			ln = ln + 1 
			long_flag=1
        }
        ln = ln + 1  
		
	}
	
   if(long_flag==1)ln = ln - 1 
   SetBufIns(hbuf,ln-1, new_len+1)
} 
macro CY_DelLineTitle()  
{   //取消杠杠注释,不选中多行的话,默认只处理当前行  
    hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
  
    hbuf = GetCurrentBuf()  
    ln = lnFirst
    
    while( ln <= lnLast )  
    {  
        buf = GetBufLine( hbuf, ln )  
    	buf =TrimRight(buf)   	
        len = strlen( buf )  
        if( len >= 2 )  
        {  
            start = 0  
  
            while( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9) )  
            {  
                start = start + 1  
                if( start >= len )  
                    break  
            }  
            while( start <= len - 2 )  
            {  

                if( strmid( buf, start, start+1  ) == "/" && strmid( buf, start+1, start + 2 ) == "/" )  
                {  
                    buf2 = strmid( buf, 0, start )
                    PutBufLine( hbuf, ln, buf2 )  
                    break
                }  
			 start = start + 1 
            }  
        }  
        ln = ln + 1  
    }  
    SetWndSel( hwnd, selection )  
    }

macro CY_unFileHead()
{   
// get function name
	hbuf = GetCurrentBuf()
	lnFirst=0
	lnLast=GetBufLineCount (hbuf)
/*
    	isymMax = GetBufSymCount (hbuf)
        isym = 0
       symname = GetBufSymName (hbuf, isym)
        lnLast=GetSymbolLine (symname)
*/
	if(lnLast>20)lnLast=20
	get_flag=0	
	ln=0
		//找注释头 /*
	    while( ln < lnLast )  
	    {  
		//去左边空格
	        buf0 = GetBufLine( hbuf, ln ) 
			buf =TrimLeft(buf0) 
	        len = strlen(buf)  
	        if(len>=2)
	        if(strmid( buf,0, 2) == "/*")  
	        {  
             lnFirst=ln
             get_flag=get_flag+1     
             break
	        }  
	        ln = ln + 1  
	    }
	    				//找注释尾 */
			    while( ln < lnLast ) 
			    {  
				//去右边空格
			        buf0 = GetBufLine( hbuf, ln ) 
			    	buf0 =TrimRight(buf0)
			    	buf =TrimLeft(buf0) 
			        len = strlen( buf )  
			       //得考虑被//注释的 */ 
			       if(len>=2)
			        if(  strmid( buf, len-2, len) == "*/" && strmid( buf,0, 2) != "//")  
			        {  
                     lnLast=ln
                     get_flag=get_flag+1
                   //  msg("L=@lnLast@")
                     break
			        }  
			        ln = ln + 1  
			    } 
	    // 头尾都存在 即get_flag==2删除注释
	    if(get_flag==2)
	    {
		ln=lnLast
			while( ln >=lnFirst )  
		    {
		    buf = GetBufLine( hbuf, ln ) 
			DelBufLine (hbuf, ln)
		    ln = ln - 1  
		    }		
	    }	
	  //  SaveBuf (hbuf)
	//symbol = GetSymbolLocationFromLn(hbuf, ln+2)
	//if(symbol=="")CY_unFileHead()
	
}

macro CY_unFuncHead2(hbuf,ln)
{   
// get function name
	//hbuf = GetCurrentBuf()
	//szFunc = GetCurSymbol()
	//ln = GetSymbolLine(szFunc)
	lnLast=ln
	get_flag=0	
	buf_Description="none"
	buf_Input="void"
	buf_Output="void"
	buf_Return="void"
	buf_others="none"
//大部分函数头 行数小于10	
	if(lnLast>20)
	lnFirst=ln-20
	else lnFirst=1

	ln =ln -1
				//找注释尾 */
			    while( ln > lnFirst )  
			    {  
				//去右边空格
			        buf0 = GetBufLine( hbuf, ln ) 
			    	buf0 =TrimRight(buf0)
			    	buf =TrimLeft(buf0) 
			        len = strlen( buf )  
			       //得考虑被//注释的 */ 
			       if(len>=2)
			        if(  strmid( buf, len-2, len) == "*/" && strmid( buf,0, 2) != "//")  
			        {  
                     lnLast=ln
                     get_flag=get_flag+1
                   //  msg("L=@lnLast@")
                     break
			        }  
			        ln = ln - 1  
			    } 
		//找注释头 /*
	    while( ln > lnFirst )  
	    {  
		//去左边空格
	        buf0 = GetBufLine( hbuf, ln ) 
			buf =TrimLeft(buf0) 
	        len = strlen(buf)  
	        if(len>=2)
	        if(strmid( buf,0, 2) == "/*")  
	        {  
             lnFirst=ln
             get_flag=get_flag+1     
             break
	        }  
	        ln = ln - 1  
	    }
	    // 头尾都存在 即get_flag==2删除注释
	    if(get_flag==2)
	    {
		ln=lnLast
		while( ln >=lnFirst )  
	    {
	    buf = GetBufLine( hbuf, ln ) 
		DelBufLine (hbuf, ln)
	    ln = ln - 1  
	    }		
	    }
	    
}

macro CY_unFuncHead()
{   
// get function name
	hbuf = GetCurrentBuf()
	szFunc = GetCurSymbol()
	ln = GetSymbolLine(szFunc)
	lnLast=ln
	get_flag=0	
	buf_Description="none"
	buf_Input="void"
	buf_Output="void"
	buf_Return="void"
	buf_others="none"
//大部分函数头 行数小于10	
	if(lnLast>20)
	lnFirst=ln-20
	else lnFirst=1

	ln =ln -1
				//找注释尾 */
			    while( ln > lnFirst )  
			    {  
				//去右边空格
			        buf0 = GetBufLine( hbuf, ln ) 
			    	buf0 =TrimRight(buf0)
			    	buf =TrimLeft(buf0) 
			        len = strlen( buf )  
			       //得考虑被//注释的 */ 
			       if(len>=2)
			        if(  strmid( buf, len-2, len) == "*/" && strmid( buf,0, 2) != "//")  
			        {  
                     lnLast=ln
                     get_flag=get_flag+1
                   //  msg("L=@lnLast@")
                     break
			        }  
			        ln = ln - 1  
			    } 
		//找注释头 /*
	    while( ln > lnFirst )  
	    {  
		//去左边空格
	        buf0 = GetBufLine( hbuf, ln ) 
			buf =TrimLeft(buf0) 
	        len = strlen(buf)  
	        if(len>=2)
	        if(strmid( buf,0, 2) == "/*")  
	        {  
             lnFirst=ln
             get_flag=get_flag+1     
             break
	        }  
	        ln = ln - 1  
	    }
	    // 头尾都存在 即get_flag==2删除注释
	    if(get_flag==2)
	    {
		ln=lnLast
		while( ln >=lnFirst )  
	    {
	    buf = GetBufLine( hbuf, ln ) 
		DelBufLine (hbuf, ln)
	    ln = ln - 1  
	    }		
	    }
	    
}
macro CY_InsertLineNote()  
{   //用杠杠注释,不选中多行的话,注释当前行  
    hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
    norm_len=60  
    hbuf = GetCurrentBuf()  
    IDbuf=CY_InsertID()
    change_mode=1	  //修改模式
    if(strlen(IDbuf)<=0)
    {
    change_mode=0     //正常添加注释模式
    IDbuf="$"
    }
    if( change_mode==1&&lnLast-lnFirst>0)
    {
 InsBufLine(hbuf, lnLast+1,"//End @IDbuf@")  //先添加最后一行，InsBufLine 插入当前行
 InsBufLine(hbuf, lnFirst,"//Start @IDbuf@ $")
 SetBufIns(hbuf, lnFirst, 20)
 return 0
    }
    ln = lnFirst  
        pitch_len=15
    buf0 = GetBufLine( hbuf, ln ) 
    buf =TrimRight(buf0)
    len = strlen( buf ) 
    //msg(len)
    firststart = len   
    long_flag=0
////////////////////////////

//获取所选行的长度均值
   	ln = lnFirst 
 	line_num=0
	total_len=0
    avg_len=0
    if( ln == lnLast )line_num=1 
      while( ln <= lnLast )  
    {  
        buf0 = GetBufLine( hbuf, ln ) 
    	buf =TrimRight(buf0) 
        len = strlen( buf )  
        start = 0
		/*
        while( start < len )  
        {  
			
            if(  strmid( buf, start, start + 2 ) == "//"  )  
            {  
                start = start + 1  
                if( start > len )  
                    break  
            }  
            else  ( start > len )
                break  
        }  
        */
        buf2 = TrimLeft(buf)  //去前面的空格，得到真实句子buf2,别把buf替换了，后面还要用其真实格式
		real_len=strlen(buf2)
        if(  real_len >1 &&len <50  )  
        {  
           line_num=line_num+1
           total_len=total_len+len
        }  
        ln = ln + 1  
    }
    if(line_num>0)
    avg_len=total_len/line_num
    norm_len=avg_len
    ln = lnFirst 
    while( ln <= lnLast )  
    {  
         buf0 = GetBufLine( hbuf, ln ) 
    	buf =TrimRight(buf0) 
        len = strlen( buf ) 
        buf2 = TrimLeft(buf)  //去前面的空格，得到真实句子
		real_len=strlen(buf2)
        
        if( real_len>1&&len<75) 
        {           
	 norm_len=(avg_len/pitch_len+1)*pitch_len
	//超出平均长度 的处理
	 if(len>norm_len)
	 norm_len=(len/pitch_len+1)*pitch_len
	 
     //  for(i=0;i<60-len;i++)
       buf_space=""
       i=len
    //   norm_len=(len/10+1)*10
       while(norm_len-i>1)
       	{
		buf_space=cat(buf_space, " ")	
        i = i +1; 
		}
		//msg(buf_space)
      	 // buf2=cat(buf, "//")
          buf2 = cat( buf, cat(buf_space , "//@IDbuf@" ) )
              new_len = strlen( buf2 )  
            PutBufLine ( hbuf, ln, buf2 )  
        }
        else if( len>=75)
        {
			start=0
         while( start < len )
         {
			if( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9)			)  
            {  
                start = start + 1  
                if( start > len )  
                    break  
            }
            else break
          } 
          /* 
			num_space=start
			
			 buf_space=""
		  	while(num_space>0)
       		{
			buf_space=cat(buf_space, " ")	
        	num_space =num_space -1; 
			}
			*/
			buf_space=strmid(buf,0,start)
			 buf2 = cat(buf_space , "//@IDbuf@" ) 
             new_len = strlen( buf2 )  
          //  PutBufLine ( hbuf, ln, buf2 )  
          	InsBufLine(hbuf, ln, buf2)
          	//添加了一行，计数加1，方便后面处理
			ln = ln + 1 
			long_flag=1
        }
        ln = ln + 1  
    }  
   // SetWndSel( hwnd, selection ) 
   if(long_flag==1)ln = ln - 1 
   SetBufIns(hbuf,ln-1, new_len+1)
}

macro CY_ChangeFunHeader()
{
CY_unFuncHead() 
CY_InsertFunHeader()
}
macro CY_ChangeFunHeader2(hbuf,isym,ln_input,symname)
{
CY_unFuncHead2(hbuf,ln_input)
//msg("input=@ln_input@")
//SetCurrentBuf  (hbuf)
//SaveBuf (hbuf)
//	hbuf = GetCurrentBuf()
	szFunc = GetBufSymLocation(hbuf, isym) //更新行数据
	//ln = GetSymbolLine(szFunc)
ln_input2=szFunc.lnFirst
//msg("inNew=@ln_input2@")
CY_InsertFunHeader2(hbuf,szFunc,ln_input2,symname)
}
macro CY_ChangFileHeader()
{
CY_unFileHead()

CY_InsertCFileHeader() 
} 
 ************************************************************  
Copyright (C), 1988-1999, Nantian Co., Ltd.
Description:     // 模块描述
Function List:   // 主要函数及其功能
1.	-------
2.	-------
3.	-------
History:         // 历史修改记录
date - author - created
date - author - modify 
description
***********************************************************/
/*****************           GOODIX CONFIDENTIAL            ****************/
/*****************                                          ****************/
/***************** Description : xxxxxxxxxxxx               ****************/
/*****************                                          ****************/
/*****************     Company : Huiding Technology Co.,Ltd.****************/
/*****************  Programmer : Name                       ****************/
/*****************             :                            ****************/
/****************************************************************************/
macro CY_InsertCFileHeader()
{
	//get aurthor name
	//szMyName = getenv(MYNAME)       					 //MYNAME
	//     SetReg (MYID, szID)
	szMyName = getreg(MYNAME)    
	if (strlen(szMyName) <= 0)
	{
		szMyName = "###"
	}

	// get company name
	szCompanyName = getreg(MYCOMPANY) 				 //MYCOMPANY
	if (strlen(szCompanyName) <= 0)
	{
		szCompanyName = szMyName
	}

	// get time
	szTime = GetSysTime(True)
	Day = szTime.Day
	Month = szTime.Month
	Year = szTime.Year
	if (Day < 10)
	{
		szDay = "0@Day@"
	}
	else
	{
		szDay = Day
	}
	if (Month < 10)
	{
		szMonth = "0@Month@"
	}
	else
	{
		szMonth = Month
	}

	// get file name
	hbuf = GetCurrentBuf()
	szpathName = GetBufName(hbuf)
	szfileName = GetFileName(szpathName)
	nlength = StrLen(szfileName)

	// assemble the string
	hbuf = GetCurrentBuf()
//InsBufLine(hbuf, 0, "")
	InsBufLine(hbuf, 0, "/******************************************************************************")
	//InsBufLine(hbuf, 2, " FILE:                 @szfileName@ ")
	InsBufLine(hbuf, 1, " Copyright (c) 2002-@Year@ Huiding Technology Co., Ltd.")
	InsBufLine(hbuf, 2, " FILE:                   @szfileName@ ")
	InsBufLine(hbuf, 3, " Description:            none")
	InsBufLine(hbuf, 4, " Function List:  ")
	
	//InsBufLine(hbuf, 6, "* Copyright (c) @Year@ by @szCompanyName@. All Rights Reserved.")
	//InsBufLine(hbuf, 6, " ")
	InsBufLine(hbuf, 5, " History:")
	InsBufLine(hbuf, 6, " Version     Date        Description          Name")
	InsBufLine(hbuf, 7, "  0.1        @Year@/@szMonth@/@szDay@  Initial Version      @szMyName@ ")
	InsBufLine(hbuf, 8, "******************************************************************************/")
	//InsBufLine(hbuf, 11, "   ")
	//InsBufLine(hbuf, 12, "****************************************************************************************")
	//InsBufLine(hbuf, 13, "****************************************************************************************/")
	//InsBufLine(hbuf, 14, "")
	//InsBufLine(hbuf, 15, "")
	// put the insertion point
	SetBufIns(hbuf,3, 28)
	 hnewbuf = newbuf(hNil)
	 GetFunctionList(hbuf,hnewbuf)
	InsertFileList( hbuf,hnewbuf,5)
	//UpdateFunctionList2(hbuf+4)                   //CY  函数自动列表功能
}

 macro CY_InsertFunHeader()
{  
// get function name
	
	hbuf = GetCurrentBuf()
	szFunc = GetCurSymbol()
	ln = GetSymbolLine(szFunc)
// get time
	szTime = GetSysTime(True)
	Day = szTime.Day
	Month = szTime.Month
	Year = szTime.Year
	if (Day < 10)
	{
		szDay = "0@Day@"
	}
	else
	{
		szDay = Day
	}
	if (Month < 10)
	{
		szMonth = "0@Month@"
	}
	else
	{
		szMonth = Month
	}

	// get aurthor ID
		szMyID = getreg(MYID)   		 //MyID
	if (strlen(szMyID) <= 0)
	{
		szMyID = "0000"
	}

	// get version ID
		szProbmID = getreg(ProbmID)   		 //MyID
	//	Msg(szProbmID)
	if (strlen(szProbmID) <= 0)
	{
		szProbmID = "01"
	}
		 iIns = 0
        symbol = GetSymbolLocationFromLn(hbuf, ln)
        if(strlen(symbol) > 0)
        {
            hTmpBuf = NewBuf("Tempbuf")
                
            //将文件参数头整理成一行并去掉了注释
            szLine = GetFunctionDef(hbuf,symbol)            
             iBegin = symbol.ichName
           // msg()
            //取出返回值定义
            szTemp = strmid(szLine,0,iBegin)
            szTemp = TrimString(szTemp)
         //	msg(szLine)
            szRet =  GetFirstWord(szLine)
         // msg(szRet)
            if(symbol.Type == "Method")
            {
                szTemp = strmid(szTemp,strlen(szRet),strlen(szTemp))
                szTemp = TrimString(szTemp)
                if(szTemp == "::")
                {
                    szRet = ""
                }
            }
            if(toupper (szRet) == "MACRO")
            {
                //对于宏返回值特殊处理
                szRet = ""
            }
            if(szRet!="void")szRet="@szRet@    //$"
            //从函数头分离出函数参数
            nMaxParamSize = GetWordFromString(hTmpBuf,szLine,iBegin,strlen(szLine),"(",",",")")
            lnMax = GetBufLineCount(hTmpBuf)
            ln = symbol.lnFirst
            SetBufIns (hbuf, ln, 0)
        }
	buf_others="none"
	buf_Output="none"
	// assemble the string
	szContent="$"
	//szContent = Ask("输入函数描述")	
	//InsBufLine(hbuf, ln, "")
	ln=ln-1
	InsBufLine(hbuf, ln+1, "/***************************************************************************")
	InsBufLine(hbuf, ln+2, "  Function:          @szFunc@")
	InsBufLine(hbuf, ln+3, "  Description:       @szContent@")
	//InsBufLine(hbuf, ln+4, "  Input :                      none")
    
    //前面进入循环默认先加了一行
  //  else ln=ln-1;
	InsBufLine(hbuf, ln+4, "  Output:            void")
	InsBufLine(hbuf, ln+5, "  Return:            @szRet@")
//	InsBufLine(hbuf, ln+6, "  Return:            @szRet@")
//	InsBufLine(hbuf, ln+7, "  Others:            G16@szMonth@@szDay@@szMyID@")
	InsBufLine(hbuf, ln+6, "  Others:            @buf_others@")
	InsBufLine(hbuf, ln+7, "****************************************************************************/")

	        //输出     输入参数表
    
        i = 0
        szIns=			   "  Input:             "
		ln_temp = ln
 		        while ( i < lnMax) 
		        {
		            szTmp = GetBufLine(hTmpBuf, i)
		            nLen = strlen(szTmp)
		            
		            //对齐参数后面的空格，实际是对齐后面的参数的说明
		            szBlank = CreateBlankString(nMaxParamSize - nLen + 2)
		            szTmp = cat(szTmp,szBlank)
		            ln_temp = ln_temp + 1
		            szTmp2= szTmp
                    szTmp2=TrimRight(szTmp2)
                    szTmp2=Trimleft(szTmp2)	
		            nLen2 = strlen(szTmp2)
		            
		            if(nLen2==0)szTmp="void" 	            
		            szTmp = cat(szIns,szTmp)
		            if(nLen2>3)
		            {
		            if( szTmp2[3]=="d"&&szTmp2[1]=="o")  //void
		            InsBufLine(hbuf, ln_temp+3, "@szTmp@")
                    else
		            InsBufLine(hbuf, ln_temp+3, "@szTmp@    //$")
                    }
		            else if(nLen2==0)  //void
		            InsBufLine(hbuf, ln_temp+3, "@szTmp@")
		            else
		            InsBufLine(hbuf, ln_temp+3, "@szTmp@    //$")
		            iIns = 1
		            szIns =    "                     "
		            i = i + 1
		        }    
		        closebuf(hTmpBuf)
		      
    
    if(iIns== 0)
    {               
            InsBufLine(hbuf, ln+4, "  Input:             void")
            
    }


	// put the insertion point
	SetBufIns(hbuf, ln+3, 33)

}

 macro CY_InsertFunHeader2(hbuf,symbol,ln,szFunc)
{  
// get function name
	//hbuf = GetCurrentBuf()
	//szFunc = GetCurSymbol()
	//ln = GetSymbolLine(szFunc)
// get time
	szTime = GetSysTime(True)
	Day = szTime.Day
	Month = szTime.Month
	Year = szTime.Year
	if (Day < 10)
	{
		szDay = "0@Day@"
	}
	else
	{
		szDay = Day
	}
	if (Month < 10)
	{
		szMonth = "0@Month@"
	}
	else
	{
		szMonth = Month
	}

	// get aurthor ID
		szMyID = getreg(MYID)   		 //MyID
	if (strlen(szMyID) <= 0)
	{
		szMyID = "0000"
	}

	// get version ID
		szProbmID = getreg(ProbmID)   		 //MyID
	//	Msg(szProbmID)
	if (strlen(szProbmID) <= 0)
	{
		szProbmID = "01"
	}
		 iIns = 0
      //  symbol = GetSymbolLocationFromLn(hbuf, ln)
        if(strlen(symbol) > 0)
        {
            hTmpBuf = NewBuf("Tempbuf")
                
            //将文件参数头整理成一行并去掉了注释
            szLine = GetFunctionDef(hbuf,symbol)            
            iBegin = symbol.ichName
           // msg()
            //取出返回值定义
            szTemp = strmid(szLine,0,iBegin)
            szTemp = TrimString(szTemp)
         //	msg(szLine)
            szRet =  GetFirstWord(szLine)
         // msg(szRet)
            if(symbol.Type == "Method")
            {
                szTemp = strmid(szTemp,strlen(szRet),strlen(szTemp))
                szTemp = TrimString(szTemp)
                if(szTemp == "::")
                {
                    szRet = ""
                }
            }
            if(toupper (szRet) == "MACRO")
            {
                //对于宏返回值特殊处理
                szRet = ""
            }
            if(szRet!="void")szRet="@szRet@    //$"
            //从函数头分离出函数参数
            nMaxParamSize = GetWordFromString(hTmpBuf,szLine,iBegin,strlen(szLine),"(",",",")")
            lnMax = GetBufLineCount(hTmpBuf)
            ln = symbol.lnFirst
            SetBufIns (hbuf, ln, 0)
        }
	buf_others="none"
	buf_Output="none"
	// assemble the string
	szContent="$"
	//szContent = Ask("输入函数描述")	
	//InsBufLine(hbuf, ln, "")
	ln=ln-1
	InsBufLine(hbuf, ln+1, "/***************************************************************************")
	InsBufLine(hbuf, ln+2, "  Function:          @szFunc@")
	InsBufLine(hbuf, ln+3, "  Description:       @szContent@")
	//InsBufLine(hbuf, ln+4, "  Input :                      none")
    
    //前面进入循环默认先加了一行
  //  else ln=ln-1;
	InsBufLine(hbuf, ln+4, "  Output:            void")
	InsBufLine(hbuf, ln+5, "  Return:            @szRet@")
//	InsBufLine(hbuf, ln+6, "  Return:            @szRet@")
//	InsBufLine(hbuf, ln+7, "  Others:            G16@szMonth@@szDay@@szMyID@")
	InsBufLine(hbuf, ln+6, "  Others:            @buf_others@")
	InsBufLine(hbuf, ln+7, "****************************************************************************/")

	        //输出     输入参数表
    
        i = 0
        szIns=			   "  Input:             "
		ln_temp = ln
 		        while ( i < lnMax) 
		        {
		            szTmp = GetBufLine(hTmpBuf, i)
		            nLen = strlen(szTmp)
		            
		            //对齐参数后面的空格，实际是对齐后面的参数的说明
		            szBlank = CreateBlankString(nMaxParamSize - nLen + 2)
		            szTmp = cat(szTmp,szBlank)
		            ln_temp = ln_temp + 1
		            szTmp2= szTmp
                    szTmp2=TrimRight(szTmp2)
                    szTmp2=Trimleft(szTmp2)	
		              nLen2 = strlen(szTmp2)
		            
		            if(nLen2==0)szTmp="void" 	            
		            szTmp = cat(szIns,szTmp)
		            if(nLen2>3)
		            {
		            if( szTmp2[3]=="d"&&szTmp2[1]=="o")  //void
		            InsBufLine(hbuf, ln_temp+3, "@szTmp@")
                    else
		            InsBufLine(hbuf, ln_temp+3, "@szTmp@    //$")
                    }
		            else if(nLen2==0)  //void
		            InsBufLine(hbuf, ln_temp+3, "@szTmp@")
		            else
		            InsBufLine(hbuf, ln_temp+3, "@szTmp@    //$")

		            iIns = 1
		            szIns =    "                     "
		            i = i + 1
		        }    
		        closebuf(hTmpBuf)
		      
    
    if(iIns== 0)
    {               
            InsBufLine(hbuf, ln+4, "  Input:             void")
            
    }


	// put the insertion point
	SetBufIns(hbuf, ln+3, 33)

}

macro GetSecondWord(szLine)
{
    szLine = TrimLeft(szLine)  //去前面的空格，得到真实句子
//	szLine = TrimRight(szLine) //去后面的空格，得到真实句子
    nIdx = 0
    iLen = strlen(szLine)
	 while(nIdx < iLen || nIdx ==iLen)
    {
        if( (szLine[nIdx] == " ")  
      //  || (szLine[nIdx] == "=")
           )
         { 
					nIdx_temp = nIdx
					szLine=strmid(szLine,nIdx,iLen)
					//msg(szLine)
					 szLine = TrimLeft(szLine)
					 iLen = strlen(szLine)
					 nIdx= 0
				    while(nIdx < iLen || nIdx ==iLen)
				    {
				     //   return strmid(szLine,0,nIdx)
					  if( (szLine[nIdx] == " ") || (szLine[nIdx] == "\t") 
			          || (szLine[nIdx] == ";") || (szLine[nIdx] == "(")
			          || (szLine[nIdx] == ".") || (szLine[nIdx] == "{")
			          || (szLine[nIdx] == ",") || (szLine[nIdx] == ":")
			          || (szLine[nIdx] == "=")
			          )	
						 {
					     return strmid(szLine,0,nIdx)
					     }
					  if(nIdx ==iLen)   strmid(szLine,0,nIdx)
					nIdx = nIdx + 1
				    }
		}
		else  if(  (szLine[nIdx] == "\t") 
          || (szLine[nIdx] == ";") || (szLine[nIdx] == "(")
          || (szLine[nIdx] == ".") || (szLine[nIdx] == "{")
          || (szLine[nIdx] == ",") || (szLine[nIdx] == ":") )
          {
			 return ""
          }
		 if(nIdx ==iLen)   strmid(szLine,0,nIdx)
        nIdx = nIdx + 1
    }
    return ""
    
}
//查找语义段，即相邻括号算一个段
//word_num 选择第1 到第N个字符串
macro GetAnystring(ln,word_num,mode) 
{
hwnd = GetCurrentWnd()
hbuf = GetCurrentBuf()  
szLine=GetBufLine(hbuf, ln) 
real_len=strlen(szLine)
    szLine = TrimLeft(szLine)  //去前面的空格，得到真实句子
      iLen = strlen(szLine)
      if(iLen==0)   return ""   
    blank_num=real_len-iLen
    nIdx = 0
    nIdx_start = 0
   //nIdx_end_last = 0
  // if( (szLine[0] == "/") && ((szLine[1] == "/") ||(szLine[1] == "*") )) 
  // return ""   
    nIdx_end = 0
        	change_flag=0
    while(nIdx <= iLen)
    {
        if( (szLine[nIdx] == " ") || (szLine[nIdx] == "\t") || (szLine[nIdx] == "/") 
          || (szLine[nIdx] == ";")||nIdx == iLen )
         {  
         //  对于 / 的误判断 处理
         if((nIdx < iLen)&&(szLine[nIdx] == "/") )
		 if((szLine[nIdx+1] != "/") && (szLine[nIdx] != "*") )	
		 {
		change_flag=1
		 nIdx = nIdx + 1
		 continue
		 }
		 if((nIdx < iLen)&&(szLine[nIdx] == " ")&&change_flag==1 )  //空格后的运算符
		 if((szLine[nIdx+1] == "<") || (szLine[nIdx+1] == ">")|| (szLine[nIdx+1] == "=")|| (szLine[nIdx+1] == "|")|| (szLine[nIdx+1] == "&")
		|| (szLine[nIdx+1] == "*")|| (szLine[nIdx+1] == "+")|| (szLine[nIdx+1] == "-")
		 )	
		 {
		 while(szLine[nIdx+2]==" "||szLine[nIdx+2]==">"||szLine[nIdx+2]=="<")
		 {nIdx = nIdx + 1}
		change_flag=1
		 nIdx = nIdx + 3
		 continue
		 }
/**/		 	kh_start=nIdx+1
		if(kh_start<iLen-1)
		  while(szLine[kh_start] != "("  )
		  {
			kh_start=kh_start+1
			if(kh_start==iLen-1)
			{
			kh_start=0
			break
			}
		  }

		 if((nIdx > 2)&&(szLine[nIdx] == " ")&&change_flag==1&&kh_start!=0)//空格前的条件命令符
		// if( ((szLine[nIdx-3] == "f") &&(szLine[nIdx-2] == "o")&& (szLine[nIdx-1] == "r")))
		 {
		  nIdx_temp = nIdx 
		  get_cmd_falg=0
		 find_start=strstr(szline,"for")
		 if(find_start!=0xffffffff) 
		  {
	     	if(find_start==nIdx-3)
	        get_cmd_falg = 1
		  }
		  find_start=strstr(szline,"while")
		 if(find_start!=0xffffffff) 
		  {
	     	if(find_start==nIdx-5)
	        get_cmd_falg = 1
		  }
		  find_start=strstr(szline,"if")
		 if(find_start!=0xffffffff) 
		  {
	     	if(find_start==nIdx-2)
	        get_cmd_falg = 1
		  }
		  find_start=strstr(szline,"for")
		 if(find_start!=0xffffffff) 
		  {
	     	if(find_start==nIdx-3)
	        get_cmd_falg = 1
		  }
		  find_start=strstr(szline,"switch")
		 if(find_start!=0xffffffff) 
		   {
	     	if(find_start==nIdx-3)
	        get_cmd_falg = 1
		  }
		   find_start=strstr(szline,"case")
		 if(find_start!=0xffffffff) 
		   {
	     	if(find_start==nIdx-3)
	        get_cmd_falg = 1
		  }
	    if( get_cmd_falg == 1)
	    {
	    SetBufIns(hbuf,ln, kh_start+blank_num)
		Select_Match
		nIdx_kh_last=GetWndSelIchLim (hwnd)
		nIdx=nIdx_kh_last-blank_num
		change_flag =1
		 continue
	    }

		 }
					 	if(change_flag==0)
						{
						nIdx_start=nIdx+1
						}
						else if(change_flag==1)   //前面已经有非符号字符
						{
						 nIdx_end = nIdx
						change_flag =2
						}
					if(word_num>1&&change_flag==2)
					{
					change_flag=0
					nIdx_start=nIdx_end+1
					//msg("word_num=@word_num@")
					word_num=word_num-1
					
					}			
				else if(word_num==1&&change_flag==2)
				{
				if(nIdx_start> nIdx_end)return "" //匹配到下一行，出现此情况
				buf=strmid(szLine,nIdx_start,nIdx_end)		
				line = nil
				if(mode==1)
				{
				line.buf=buf
				line.start=nIdx_start+blank_num
				line.end =nIdx_end+blank_num
				return  line
				}
				else 
				return  buf
			//	return strmid(szLine,nIdx_start,nIdx_end)
				}
		 }
		 else 
		 {
		 //找到相邻括号，匹配完括号，跳到最后
		 if((szLine[nIdx] == "(") || (szLine[nIdx] == "[") )
		 {
		 SetBufIns(hbuf,ln, nIdx+blank_num)
		Select_Match
		nIdx_kh_last=GetWndSelIchLim (hwnd)
		
		nIdx=nIdx_kh_last-blank_num-1
		 }
		 change_flag=1
		 }	
        nIdx = nIdx + 1
    }
    return ""   
}
//word_num 选择第1 到第N个字符串
macro GetAnyWord(szLine,word_num,mode) 
{
real_len=strlen(szLine)
    szLine = TrimLeft(szLine)  //去前面的空格，得到真实句子
      iLen = strlen(szLine)
      if(iLen==0)   return ""   
      blank_num=real_len-iLen
    nIdx = 0
    nIdx_start = 0
   //nIdx_end_last = 0
   if( (szLine[0] == "/") && ((szLine[1] == "/") ||(szLine[1] == "*") )) 
   return ""   
    nIdx_end = 0
        	change_flag=0
    while(nIdx <= iLen)
    {
        if( (szLine[nIdx] == " ") || (szLine[nIdx] == "\t") || (szLine[nIdx] == "\n")
          || (szLine[nIdx] == ";") || (szLine[nIdx] == "(")
         // || (szLine[nIdx] == ".") 
          || (szLine[nIdx] == "{")|| (szLine[nIdx] == "}") ||(nIdx==iLen)
          || (szLine[nIdx] == ",") || (szLine[nIdx] == ":") )
         { 
					
					 	if(change_flag==0)
						{
						nIdx_start=nIdx+1
						}
						else if(change_flag==1)   //前面已经有非符号字符
						{
						 nIdx_end = nIdx
						change_flag =2
						}
					if(word_num>1&&change_flag==2)
					{
					change_flag=0
					nIdx_start=nIdx_end+1
					word_num=word_num-1
					}			
				else if(word_num==1&&change_flag==2)
				{
				buf=strmid(szLine,nIdx_start,nIdx_end)		
				line = nil
				if(mode==1)
				{
				line.buf=buf
				line.start=nIdx_start+blank_num
				line.end =nIdx_end+blank_num
				return  line
				}
				else 
				return  buf
			//	return strmid(szLine,nIdx_start,nIdx_end)
				}
		 }
		 else change_flag=1
        nIdx = nIdx + 1
    }
    return ""   
}
macro Chang2Macro(szLine)
{
nIdx = 0
iLen = strlen(szLine)
    while(nIdx < iLen)
    {
	isupper(ch) //判断大写 
	//(AsciiFromChar (szLine[nIdx]) > 64) &&(AsciiFromChar (szLine[nIdx]) < 91) //大写
		 if( (AsciiFromChar (szLine[nIdx]) > 96) &&(AsciiFromChar (szLine[nIdx]) < 123)
		 )
		 {
PutBufLine (szLine, ln, s)
		 }
         //-32
    }

}
macro CY_test_Chang2Macro() 
{  

	// get function name
    hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
  
    hbuf = GetCurrentBuf() 
	ln=lnFirst
/*
        buf = GetBufLine( hbuf, ln )  
 		buf = GetSecondWord(buf)
 // num=AsciiFromChar (buf[0])
	msg(buf)
	*/
theSymbol = GetSymbolLocationFromLn(hbuf, ln)
	 //theSymbol= GetCurSymbol()
	 
	 msg(theSymbol.Type)
} 
macro BufFind( buf_find ) 
{  
   hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
  
    hbuf = GetCurrentBuf()  
    ln = lnFirst 
            buf = GetBufLine( hbuf, ln )  
        len = strlen( buf )
        if( len >= 2 )  
        {  
            start = 0  
  
            while( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9) )  
            {  
                start = start + 1  
                if( start >= len )  
                    break  
            }  
            if( start < len - 2 ) 
            {  
                if( strmid( buf, start, start + 2 ) == buf_find )  
                {  
                    buf2 = cat( strmid( buf, 0, start ), strmid( buf, start + 2, len ) )  
                    PutBufLine( hbuf, ln, buf2 )  
                }  
            }  
        }
} 
//36进制
 macro get_36jinz( input_num)  
{ 
	if (input_num > 9)
	{
		input_num = CharFromAscii(input_num-10+97)//+'a'
	}
  return input_num
}
 macro CY_test2()  
{   //用杠杠注释,不选中多行的话,注释当前行  
    hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
  
    hbuf = GetCurrentBuf()  
  
    ln = lnFirst  
    buf = GetBufLine( hbuf, ln )  
    len = strlen( buf )  
    firststart = len  
    while( ln <= lnLast )  
    {  
        buf = GetBufLine( hbuf, ln )  
        len = strlen( buf )  
        start = 0  
        while( start < len )  
        {  
            if( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9) )  
            {  
                start = start + 1  
                if( start > len )  
                    break  
            }  
            else  
                break  
        }  
        if( start < len && start < firststart )  
        {  
            firststart = start  
        }  
        ln = ln + 1  
    }  
  
    ln = lnFirst  
    while( ln <= lnLast )  
    {  
        buf = GetBufLine( hbuf, ln )  
        len = strlen( buf )  
        if( len > 0 )  
        {  
        norm_len=80     
       //  for(i=0;i<60-len;i++)
       buf_space=" "
       i=len
       while(norm_len-i>0)
       	{
	buf_space=cat(buf_space, " ")	
              i = i +1; 
	}
	//msg(buf_space)
       // buf2=cat(buf, "//")
          buf2 = cat( buf, cat(buf_space , "//" ) )  
            PutBufLine ( hbuf, ln, buf2 )  
        }  
        ln = ln + 1  
    }  
    SetWndSel( hwnd, selection )  
}  
macro CY_test12()
{
     //配置信息
    // get window, sel, and buffer handles
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    if (sel.ichFirst == 0)
        stop
    hbuf = GetWndBuf(hwnd)
     // get line the selection (insertion point) is on
    szLine = GetBufLine(hbuf, sel.lnFirst);

    //get strlen of buf
      len = strlen( szLine )  
    firststart = len  
    // parse word just to the left of the insertion point
    wordinfo = GetWordLeftOfIch(sel.ichFirst, szLine)
        msg(sel.ichFirst)
    ln = sel.lnFirst;
 //msg(wordinfo.szWord)
szLeft= wordinfo.szWord
// InsBufLine(hbuf,ln,"@szLeft@      //")
// DelBufLine (hbuf,ln+1)
/*
SetBufIns(hbuf,10, 0)
*/

}

macro CY_test2()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = sel.lnFirst
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        szLeft = CreateBlankString(sel.ichFirst)
        InsBufLine(hbuf, ln,szLeft)
        SetWndSel(hwnd,sel)
    }
    val = ExpandBraceLarge()
    szLeft = val.szLeft
    InsBufLine(hbuf, ln, "@szLeft@while ( # )")    
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        PutBufLine(hbuf,ln+2, "@szLeft@    $")
    }
    SetBufIns (hbuf, ln, strlen(szLeft)+7)
    SearchForward()
}


macro Comment_gx()    
{  //用杠星注释,不换行,至少注释一行,不推荐使用  
    hbuf = GetCurrentBuf();    
    hwnd = GetCurrentWnd();    
    
    sel = GetWndSel(hwnd);    
    
    iLine = sel.lnFirst;    
        
    // indicate the comment char according to the file type    
    // for example, using "#" for perl file(.pl) and "/* */" for C/C++.    
    filename = tolower(GetBufName(hbuf));    
    suffix = "";    
    len = strlen(filename);    
    i = len - 1;    
    while (i >= 0)    
    {    
        if (filename[i-1] == ".")    
        {    
            suffix = strmid(filename, i, len)    
            break;    
        }    
        i = i -1;    
    }    
    if  ( suffix == "pl" )    
    {    
        filetype = 2; // PERL    
    }    
    else    
    {    
        filetype = 1; // C    
    }    
    
    szLine = GetBufLine(hbuf, iLine);    
    if (filetype == 1)  // C    
    {    
        szLine = cat("/*", szLine);    
    }    
    else                // PERL    
    {    
        szLine = cat("# ", szLine);    
    }    
    PutBufLine(hbuf, iLine, szLine);    
    iLine = sel.lnLast;    
    szLine = GetBufLine(hbuf, iLine);    
    if (filetype == 1)  // C    
    {    
        szLine = cat(szLine, "*/");    
    }    
    else                // PERL    
    {    
        szLine = cat("# ", szLine);    
    }    
    PutBufLine(hbuf, iLine, szLine);    
    
    
    
    if (sel.lnFirst == sel.lnLast)    
    {    
        tabSize = _tsGetTabSize() - 1;    
        sel.ichFirst = sel.ichFirst + tabSize;    
        sel.ichLim = sel.ichLim + tabSize;    
    }    
    SetWndSel(hwnd, sel);    
}    
macro CY_add_del_gg()  
{   //用杠杠注释,不选中多行的话,注释当前行  
    hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
    hbuf = GetCurrentBuf()   
    ln = lnFirst  
    buf = GetBufLine( hbuf, ln )  
    len = strlen( buf )  
    firststart = len 
    gg_line_num=0
    total_line_num=lnLast-ln+1
    while( ln <= lnLast )  
    {  
        buf = GetBufLine( hbuf, ln )  
        len = strlen( buf )  
        start = 0  
                    while( buf[start] == CharFromAscii(32) || buf[start] == CharFromAscii(9) )  
            {  
                start = start + 1  
                if( start >= len )  
                    break  
            } 
                        if( start < len - 2 )  
            {  
                if( strmid( buf, start, start + 2 ) == "//" )  
                { 
                        gg_line_num=gg_line_num+1;

                }
            }

        ln = ln + 1  
    }
    add_del_mode=1
    if(gg_line_num>total_line_num*2/3)
  	add_del_mode=0
    ln = lnFirst  
    if(add_del_mode==1)
    while( ln <= lnLast )  
    {  
        buf = GetBufLine( hbuf, ln )  
        len = strlen( buf )  
        if( len > 0 )  
        {  
           // buf2 = cat(cat( "//",strmid( buf, 0, firststart )  ), strmid( buf, firststart, len ) )  
           buf2 = cat( "//", buf  )
            PutBufLine ( hbuf, ln, buf2 )  
        }  
        ln = ln + 1  
    }
else if(add_del_mode==0)
    while( ln <= lnLast )  
    {  
        buf = GetBufLine( hbuf, ln )  
        len = strlen( buf )  
        if( len >= 2 )  
        {  
            start = 0  
  
            while( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9) )  
            {  
                start = start + 1  
                if( start >= len )  
                    break  
            }  
            if( start < len - 2 )  
            {  
                if( strmid( buf, start, start + 2 ) == "//" )  
                {  
                    buf2 = cat( strmid( buf, 0, start ), strmid( buf, start + 2, len ) )  
                    PutBufLine( hbuf, ln, buf2 )  
                }  
            }  
        }  
        ln = ln + 1  
    }
    SetWndSel( hwnd, selection )  
}
    
macro Comment_gg()  
{   //用杠杠注释,不选中多行的话,注释当前行  
    hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
  
    hbuf = GetCurrentBuf()  
  
    ln = lnFirst  
    buf = GetBufLine( hbuf, ln )  
    len = strlen( buf )  
    firststart = len  
    while( ln <= lnLast )  
    {  
        buf = GetBufLine( hbuf, ln )  
        len = strlen( buf )  
        start = 0  
        while( start < len )  
        {  
            if( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9) )  
            {  
                start = start + 1  
                if( start > len )  
                    break  
            }  
            else  
                break  
        }  
        if( start < len && start < firststart )  
        {  
            firststart = start  
        }  
        ln = ln + 1  
    }  
  
    ln = lnFirst  
    while( ln <= lnLast )  
    {  
        buf = GetBufLine( hbuf, ln )  
        len = strlen( buf )  
        if( len > 0 )  
        {  
            buf2 = cat( cat( strmid( buf, 0, firststart ), "//" ), strmid( buf, firststart, len ) )  
            PutBufLine ( hbuf, ln, buf2 )  
        }  
        ln = ln + 1  
    }  
    SetWndSel( hwnd, selection )  
}  
  
macro unComment_gg()  
{   //取消杠杠注释,不选中多行的话,默认只处理当前行  
    hwnd = GetCurrentWnd()  
    selection = GetWndSel( hwnd )  
    lnFirst = GetWndSelLnFirst( hwnd )  
    lnLast = GetWndSelLnLast( hwnd )  
  
    hbuf = GetCurrentBuf()  
    ln = lnFirst
    
    while( ln <= lnLast )  
    {  
        buf = GetBufLine( hbuf, ln )  
        len = strlen( buf )  
        if( len >= 2 )  
        {  
            start = 0  
  
            while( strmid( buf, start, start + 1 ) == CharFromAscii(32) || strmid( buf, start, start + 1 ) == CharFromAscii(9) )  
            {  
                start = start + 1  
                if( start >= len )  
                    break  
            }  
            if( start < len - 2 )  
            {  
                if( strmid( buf, start, start + 2 ) == "//" )  
                {  
                    buf2 = cat( strmid( buf, 0, start ), strmid( buf, start + 2, len ) )  
                    PutBufLine( hbuf, ln, buf2 )  
                }  
            }  
        }  
        ln = ln + 1  
    }  
    SetWndSel( hwnd, selection )  
    }






//Ok _2

macro UpdateFunctionList2(ln2)
{
    hnewbuf = newbuf("")
    if(hnewbuf == hNil)
    {
        stop
    }
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    //msg(hbuf)
    GetFunctionList(hbuf,hnewbuf)
    ln = sel.lnFirst
    iHistoryCount = 1
    isLastLine = ln
    iTotalLn = GetBufLineCount (hbuf) 
    while(ln < iTotalLn)
    {
        szCurLine = GetBufLine(hbuf, ln);
        iLen = strlen(szCurLine)
        j = 0;
        while(j < iLen)
        {
            if(szCurLine[j] != " ")
                break
            j = j + 1
        }
        
        //以文件头说明中前有大于10个空格的为函数列表记录
        if(j > 10)
        {
            DelBufLine(hbuf, ln)   
        }
        else
        {
            break
        }
        iTotalLn = GetBufLineCount (hbuf) 
    }

    //插入函数列表
    InsertFileList( hbuf,hnewbuf,ln2 )
    closebuf(hnewbuf)
 }  
macro AutoExpand()
{
    //配置信息
    // get window, sel, and buffer handles
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    if(sel.lnFirst != sel.lnLast) 
    {
        /*块命令处理*/
        BlockCommandProc()
    }
    if (sel.ichFirst == 0)
        stop
    hbuf = GetWndBuf(hwnd)
    language = getreg(LANGUAGE)
    if(language != 1)
    {
        language = 0
    }
    nVer = 0
    nVer = GetVersion()
    /*取得用户名*/
    szMyName = getreg(MYNAME)
    if(strlen( szMyName ) == 0)
    {
        szMyName = Ask("Enter your name:")
        setreg(MYNAME, szMyName)
    }
    // get line the selection (insertion point) is on
    szLine = GetBufLine(hbuf, sel.lnFirst);
    // parse word just to the left of the insertion point
    wordinfo = GetWordLeftOfIch(sel.ichFirst, szLine)
    ln = sel.lnFirst;
    chTab = CharFromAscii(9)
        
    // prepare a new indented blank line to be inserted.
    // keep white space on left and add a tab to indent.
    // this preserves the indentation level.
    chSpace = CharFromAscii(32);
    ich = 0
    while (szLine[ich] == chSpace || szLine[ich] == chTab)
    {
        ich = ich + 1
    }
    szLine1 = strmid(szLine,0,ich)
    szLine = strmid(szLine, 0, ich) # "    "
    
    sel.lnFirst = sel.lnLast
    sel.ichFirst = wordinfo.ich
    sel.ichLim = wordinfo.ich

    /*自动完成简化命令的匹配显示*/
    wordinfo.szWord = RestoreCommand(hbuf,wordinfo.szWord)
    sel = GetWndSel(hwnd)
    if (wordinfo.szWord == "pn") /*问题单号的处理*/
    {
      //  DelBufLine(hbuf, ln)
        AddPromblemNo()
        return
    }
    /*配置命令执行*/
    else if (wordinfo.szWord == "config" || wordinfo.szWord == "co")
    {
        DelBufLine(hbuf, ln)
        ConfigureSystem()
        return
    }
     /*修改配置命令执行*/
    else if (wordinfo.szWord == "cg" || wordinfo.szWord == "change")
    {
        DelBufLine(hbuf, ln)
        ConfigureProblem()
        return
    } 
    /*调试配置命令执行*/
    else if (wordinfo.szWord == "de" || wordinfo.szWord == "debug")
    {
        DelBufLine(hbuf, ln)
		 ConfigureDebug()
        return
    }
    /*修改历史记录更新*/
    else if (wordinfo.szWord == "hi")
    {
        DelBufLine(hbuf, ln)
        InsertHistory(hbuf,ln,language)
        return
    }
    else if (wordinfo.szWord == "abg")
    {
        sel.ichFirst = sel.ichFirst - 3
        SetWndSel(hwnd,sel)
        InsertReviseAdd()
        PutBufLine(hbuf, ln+1 ,szLine1)
        SetBufIns(hwnd,ln+1,sel.ichFirst)
        return
    }
    else if (wordinfo.szWord == "dbg")
    {
        sel.ichFirst = sel.ichFirst - 3
        SetWndSel(hwnd,sel)
        InsertReviseDel()
        PutBufLine(hbuf, ln+1 ,szLine1)
        SetBufIns(hwnd,ln+1,sel.ichFirst)
        return
    }
    else if (wordinfo.szWord == "mbg")
    {
        sel.ichFirst = sel.ichFirst - 3
        SetWndSel(hwnd,sel)
        InsertReviseMod()
        PutBufLine(hbuf, ln+1 ,szLine1)
        SetBufIns(hwnd,ln+1,sel.ichFirst)
        return
    }
    if(language == 1)
    {
        ExpandProcEN(szMyName,wordinfo,szLine,szLine1,nVer,ln,sel)
    }
    else
    {
        ExpandProcCN(szMyName,wordinfo,szLine,szLine1,nVer,ln,sel)
    }
}			

macro ExpandProcEN(szMyName,wordinfo,szLine,szLine1,nVer,ln,sel)
{
  
    szCmd = wordinfo.szWord
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    hbuf = GetWndBuf(hwnd)
    /*英文注释*/
    if (szCmd == "/*")
    {   
        if(wordinfo.ichLim > 70)
        {
            Msg("The right margine is small, Please use a new line")
            stop 
        }
        szCurLine = GetBufLine(hbuf, sel.lnFirst);
        szLeft = strmid(szCurLine,0,wordinfo.ichLim)
        lineLen = strlen(szCurLine)
        kk = 0
        while(wordinfo.ichLim + kk < lineLen)
        {
            if((szCurLine[wordinfo.ichLim + kk] != " ")||(szCurLine[wordinfo.ichLim + kk] != "\t")
            {
                msg("you must insert /* at the end of a line");
                return
            }
            kk = kk + 1
        }
        szContent = Ask("Please input comment")
        DelBufLine(hbuf, ln)
        szLeft = cat( szLeft, " ")
        CommentContent(hbuf,ln,szLeft,szContent,1)            
        return
    }
    else if(szCmd == "{")
    {
        InsBufLine(hbuf, ln + 1, "@szLine@")
        InsBufLine(hbuf, ln + 2, "@szLine1@" # "}");
        SetBufIns (hbuf, ln + 1, strlen(szLine))
        return
    }
    else if (szCmd == "while" )
    {
        SetBufSelText(hbuf, " ( # )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#");
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}");
    }
    else if( szCmd == "else" )
    {
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 2, "@szLine@");
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}");
        SetBufIns (hbuf, ln + 2, strlen(szLine))
        return
    }
    else if (szCmd == "#ifd" || szCmd == "#ifdef") //#ifdef
    {
        DelBufLine(hbuf, ln)
        InsIfdef()
        return
    }
    else if (szCmd == "#ifn" || szCmd == "#ifndef") //#ifndef
    {
        DelBufLine(hbuf, ln)
        InsIfndef()
        return
    }
    else if (szCmd == "#if")
    {
        DelBufLine(hbuf, ln)
        InsertPredefIf()
        return
    }
    else if (szCmd == "cpp")
    {
        DelBufLine(hbuf, ln)
        InsertCPP(hbuf,ln)
        return
    }    
    else if (szCmd == "if")
    {
        SetBufSelText(hbuf, " ( # )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#");
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}");
/*            InsBufLine(hbuf, ln + 4, "@szLine1@" # "else");
        InsBufLine(hbuf, ln + 5, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 6, "@szLine@" # ";");
        InsBufLine(hbuf, ln + 7, "@szLine1@" # "}");*/
    }
    else if (szCmd == "ef")
    {
        PutBufLine(hbuf, ln, szLine1 # "else if ( # )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#");
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}");
    }
    else if (szCmd == "ife")
    {
        PutBufLine(hbuf, ln, szLine1 # "if ( # )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#");
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}");
        InsBufLine(hbuf, ln + 4, "@szLine1@" # "else");
        InsBufLine(hbuf, ln + 5, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 6, "@szLine@" # ";");
        InsBufLine(hbuf, ln + 7, "@szLine1@" # "}");
    }
    else if (szCmd == "ifs")
    {
        PutBufLine(hbuf, ln, szLine1 # "if ( # )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#");
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}");
        InsBufLine(hbuf, ln + 4, "@szLine1@" # "else if ( # )");
        InsBufLine(hbuf, ln + 5, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 6, "@szLine@" # ";");
        InsBufLine(hbuf, ln + 7, "@szLine1@" # "}");
        InsBufLine(hbuf, ln + 8, "@szLine1@" # "else");
        InsBufLine(hbuf, ln + 9, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 10, "@szLine@" # ";");
        InsBufLine(hbuf, ln + 11, "@szLine1@" # "}");
    }
    else if (szCmd == "for")
    {
        SetBufSelText(hbuf, " ( # ; # ; # )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{")
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#")
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}")
        SetWndSel(hwnd, sel)
        SearchForward()
        szVar = ask("Please input loop variable")
        newsel = sel
        newsel.ichLim = GetBufLineLength (hbuf, ln)
        SetWndSel(hwnd, newsel)
        SetBufSelText(hbuf, " ( @szVar@ = # ; @szVar@ # ; @szVar@++ )")
    }
    else if (szCmd == "fo")
    {
        SetBufSelText(hbuf, "r ( ulI = 0; ulI < # ; ulI++ )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{")
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#")
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}")
        symname =GetCurSymbol ()
        symbol = GetSymbolLocation(symname)
        if(strlen(symbol) > 0)
        {
            nIdx = symbol.lnName + 1;
            while( 1 )
            {
                szCurLine = GetBufLine(hbuf, nIdx);
                nRet = strstr(szCurLine,"{")
                if( nRet != 0xffffffff )
                {
                    break;
                }
                nIdx = nIdx + 1
                if(nIdx > symbol.lnLim)
                {
                    break
                }
             }
             InsBufLine(hbuf, nIdx + 1, "    UINT32_T ulI = 0;");        
         }
    }
    else if (szCmd == "switch" )
    {
        nSwitch = ask("Please input the number of case")
        SetBufSelText(hbuf, " ( # )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{")
        InsertMultiCaseProc(hbuf,szLine1,nSwitch)
    }
    else if (szCmd == "do")
    {
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{")
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#");
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "} while ( # );")
    }
    else if (szCmd == "case" )
    {
        SetBufSelText(hbuf, " # :")
        InsBufLine(hbuf, ln + 1, "@szLine@" # "#")
        InsBufLine(hbuf, ln + 2, "@szLine@" # "break;")
    }
    else if (szCmd == "struct" || szCmd == "st")
    {
        DelBufLine(hbuf, ln)
        szStructName = toupper(Ask("Please input struct name"))
        InsBufLine(hbuf, ln, "@szLine1@typedef struct @szStructName@");
        InsBufLine(hbuf, ln + 1, "@szLine1@{");
        InsBufLine(hbuf, ln + 2, "@szLine@             ");
        szStructName = cat(szStructName,"_STRU")
        InsBufLine(hbuf, ln + 3, "@szLine1@}@szStructName@;");
        SetBufIns (hbuf, ln + 2, strlen(szLine))
        return
    }
    else if (szCmd == "enum" || szCmd == "en")
    {
        DelBufLine(hbuf, ln)
        szStructName = toupper(Ask("Please input enum name"))
        InsBufLine(hbuf, ln, "@szLine1@typedef enum @szStructName@");
        InsBufLine(hbuf, ln + 1, "@szLine1@{");
        InsBufLine(hbuf, ln + 2, "@szLine@             ");
        szStructName = cat(szStructName,"_ENUM")
        InsBufLine(hbuf, ln + 3, "@szLine1@}@szStructName@;");
        SetBufIns (hbuf, ln + 2, strlen(szLine))
        return
    }
    else if (szCmd == "file" || szCmd == "fi")
    {
        DelBufLine(hbuf, ln)
        InsertFileHeaderEN( hbuf,0, szMyName,"" )
        return
    }
    else if (szCmd == "func" || szCmd == "fu")
    {
        DelBufLine(hbuf,ln)
        lnMax = GetBufLineCount(hbuf)
        if(ln != lnMax)
        {
            szNextLine = GetBufLine(hbuf,ln)
            if( (strstr(szNextLine,"(") != 0xffffffff) || (nVer != 2))
            {
                symbol = GetCurSymbol()
                if(strlen(symbol) != 0)
                {  
                    FuncHeadCommentEN(hbuf, ln, symbol, szMyName,0)
                    return
                }
            }
        }
        szFuncName = Ask("Please input function name")
        FuncHeadCommentEN(hbuf, ln, szFuncName, szMyName, 1)
    }
    else if (szCmd == "tab")
    {
        DelBufLine(hbuf, ln)
        ReplaceBufTab()
        return
    }
    else if (szCmd == "ap")
    {   
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day
        
        DelBufLine(hbuf, ln)
        szQuestion = AddPromblemNo()
        InsBufLine(hbuf, ln, "@szLine1@/* Promblem Number: @szQuestion@     Author:@szMyName@,   Date:@sz@/@sz1@/@sz3@ ");
        szContent = Ask("Description")
        szLeft = cat(szLine1,"   Description    : ");
        if(strlen(szLeft) > 70)
        {
            Msg("The right margine is small, Please use a new line")
            stop 
        }
        ln = CommentContent(hbuf,ln + 1,szLeft,szContent,1)
        return
    }
    else if (szCmd == "hd")
    {
        DelBufLine(hbuf, ln)
        CreateFunctionDef(hbuf,szMyName,1)
        return
    }
    else if (szCmd == "hdn")
    {
        DelBufLine(hbuf, ln)

        /*生成不要文件名的新头文件*/
        CreateNewHeaderFile()
        return
    }
    else if (szCmd == "ab")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day
        
        DelBufLine(hbuf, ln)
        szQuestion = GetReg ("PNO")
        if(strlen(szQuestion)>0)
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Added by @szMyName@, @sz@/@sz1@/@sz3@   PN:@szQuestion@ */");
        }
        else
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Added by @szMyName@, @sz@/@sz1@/@sz3@ */");        
        }
        return
    }
    else if (szCmd == "ae")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln)
        InsBufLine(hbuf, ln, "@szLine1@/* END:   Added by @szMyName@, @sz@/@sz1@/@sz3@ */");
        return
    }
    else if (szCmd == "db")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln)
        szQuestion = GetReg ("PNO")
            if(strlen(szQuestion) > 0)
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Deleted by @szMyName@, @sz@/@sz1@/@sz3@   PN:@szQuestion@ */");
        }
        else
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Deleted by @szMyName@, @sz@/@sz1@/@sz3@ */");
        }
        
        return
    }
    else if (szCmd == "de")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln + 0)
        InsBufLine(hbuf, ln, "@szLine1@/* END: Deleted by @szMyName@, @sz@/@sz1@/@sz3@ */");
        return
    }
    else if (szCmd == "mb")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln)
        szQuestion = GetReg ("PNO")
        if(strlen(szQuestion) > 0)
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Modified by @szMyName@, @sz@/@sz1@/@sz3@   PN:@szQuestion@ */");
        }
        else
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Modified by @szMyName@, @sz@/@sz1@/@sz3@ */");
        }
        return
    }
    else if (szCmd == "me")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln)
        InsBufLine(hbuf, ln, "@szLine1@/* END:   Modified by @szMyName@, @sz@/@sz1@/@sz3@ */");
        return
    }
    else
    {
        SearchForward()
//            ExpandBraceLarge()
        stop
    }
    SetWndSel(hwnd, sel)
    SearchForward()
}


macro ExpandProcCN(szMyName,wordinfo,szLine,szLine1,nVer,ln,sel)
{
    szCmd = wordinfo.szWord
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    hbuf = GetWndBuf(hwnd)

    //中文注释
    if (szCmd == "/*")
    {   
        if(wordinfo.ichLim > 70)
        {
            Msg("右边空间太小,请用新的行")
            stop 
        }        szCurLine = GetBufLine(hbuf, sel.lnFirst);
        szLeft = strmid(szCurLine,0,wordinfo.ichLim)
        lineLen = strlen(szCurLine)
        kk = 0
        /*注释只能在行尾，避免注释掉有用代码*/
        while(wordinfo.ichLim + kk < lineLen)
        {
            if(szCurLine[wordinfo.ichLim + kk] != " ")
            {
                msg("只能在行尾插入");
                return
            }
            kk = kk + 1
        }
        szContent = Ask("请输入注释的内容")
        DelBufLine(hbuf, ln)
        szLeft = cat( szLeft, " ")
        CommentContent(hbuf,ln,szLeft,szContent,1)            
        return
    }
    else if(szCmd == "{")
    {
        InsBufLine(hbuf, ln + 1, "@szLine@")
        InsBufLine(hbuf, ln + 2, "@szLine1@" # "}");
        SetBufIns (hbuf, ln + 1, strlen(szLine))
        return
    }
    else if (szCmd == "while" || szCmd == "wh")
    {
        SetBufSelText(hbuf, " ( # )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#");
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}");
    }
    else if( szCmd == "else" || szCmd == "el")
    {
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 2, "@szLine@");
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}");
        SetBufIns (hbuf, ln + 2, strlen(szLine))
        return
    }
    else if (szCmd == "#ifd" || szCmd == "#ifdef") //#ifdef
    {
        DelBufLine(hbuf, ln)
        InsIfdef()
        return
    }
    else if (szCmd == "#ifn" || szCmd == "#ifndef") //#ifdef
    {
        DelBufLine(hbuf, ln)
        InsIfndef()
        return
    }
    else if (szCmd == "#if")
    {
        DelBufLine(hbuf, ln)
        InsertPredefIf()
        return
    }
    else if (szCmd == "cpp")
    {
        DelBufLine(hbuf, ln)
        InsertCPP(hbuf,ln)
        return
    }    
    else if (szCmd == "if")
    {
        SetBufSelText(hbuf, " ( # )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#");
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}");
/*            InsBufLine(hbuf, ln + 4, "@szLine1@" # "else");
        InsBufLine(hbuf, ln + 5, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 6, "@szLine@" # ";");
        InsBufLine(hbuf, ln + 7, "@szLine1@" # "}");*/
    }
    else if (szCmd == "ef")
    {
        PutBufLine(hbuf, ln, szLine1 # "else if ( # )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#");
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}");
    }
    else if (szCmd == "ife")
    {
        PutBufLine(hbuf, ln, szLine1 # "if ( # )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#");
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}");
        InsBufLine(hbuf, ln + 4, "@szLine1@" # "else");
        InsBufLine(hbuf, ln + 5, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 6, "@szLine@" # ";");
        InsBufLine(hbuf, ln + 7, "@szLine1@" # "}");
    }
    else if (szCmd == "ifs")
    {
        PutBufLine(hbuf, ln, szLine1 # "if ( # )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#");
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}");
        InsBufLine(hbuf, ln + 4, "@szLine1@" # "else if ( # )");
        InsBufLine(hbuf, ln + 5, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 6, "@szLine@" # ";");
        InsBufLine(hbuf, ln + 7, "@szLine1@" # "}");
        InsBufLine(hbuf, ln + 8, "@szLine1@" # "else");
        InsBufLine(hbuf, ln + 9, "@szLine1@" # "{");
        InsBufLine(hbuf, ln + 10, "@szLine@" # ";");
        InsBufLine(hbuf, ln + 11, "@szLine1@" # "}");
    }
    else if (szCmd == "for")
    {
        SetBufSelText(hbuf, " ( # ; # ; # )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{")
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#")
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}")
        SetWndSel(hwnd, sel)
        SearchForward()
        szVar = ask("请输入循环变量")
        newsel = sel
        newsel.ichLim = GetBufLineLength (hbuf, ln)
        SetWndSel(hwnd, newsel)
        SetBufSelText(hbuf, " ( @szVar@ = # ; @szVar@ # ; @szVar@++ )")
    }
    else if (szCmd == "fo")
    {
        SetBufSelText(hbuf, "r ( ulI = 0; ulI < # ; ulI++ )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{")
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#")
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "}")
        symname =GetCurSymbol ()
        symbol = GetSymbolLocation(symname)
        if(strlen(symbol) > 0)
        {
            nIdx = symbol.lnName + 1;
            while( 1 )
            {
                szCurLine = GetBufLine(hbuf, nIdx);
                nRet = strstr(szCurLine,"{")
                if( nRet != 0xffffffff )
                {
                    break;
                }
                nIdx = nIdx + 1
                if(nIdx > symbol.lnLim)
                {
                    break
                }
            }
            InsBufLine(hbuf, nIdx + 1, "    UINT32_T ulI = 0;");        
        }
    }
    else if (szCmd == "switch" || szCmd == "sw")
    {
        nSwitch = ask("请输入case的个数")
        SetBufSelText(hbuf, " ( # )")
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{")
        InsertMultiCaseProc(hbuf,szLine1,nSwitch)
    }
    else if (szCmd == "do")
    {
        InsBufLine(hbuf, ln + 1, "@szLine1@" # "{")
        InsBufLine(hbuf, ln + 2, "@szLine@" # "#");
        InsBufLine(hbuf, ln + 3, "@szLine1@" # "} while ( # );")
    }
    else if (szCmd == "case" || szCmd == "ca" )
    {
        SetBufSelText(hbuf, " # :")
        InsBufLine(hbuf, ln + 1, "@szLine@" # "#")
        InsBufLine(hbuf, ln + 2, "@szLine@" # "break;")
    }
    else if (szCmd == "struct" || szCmd == "st" )
    {
        DelBufLine(hbuf, ln)
        szStructName = toupper(Ask("请输入结构名:"))
        InsBufLine(hbuf, ln, "@szLine1@typedef struct @szStructName@");
        InsBufLine(hbuf, ln + 1, "@szLine1@{");
        InsBufLine(hbuf, ln + 2, "@szLine@      ");
        szStructName = cat(szStructName,"_STRU")
        InsBufLine(hbuf, ln + 3, "@szLine1@}@szStructName@;");
        SetBufIns (hbuf, ln + 2, strlen(szLine))
        return
    }
    else if (szCmd == "enum" || szCmd == "en")
    {
        DelBufLine(hbuf, ln)
        //提示输入枚举名并转换为大写
        szStructName = toupper(Ask("请输入枚举名:"))
        InsBufLine(hbuf, ln, "@szLine1@typedef enum @szStructName@");
        InsBufLine(hbuf, ln + 1, "@szLine1@{");
        InsBufLine(hbuf, ln + 2, "@szLine@       ");
        szStructName = cat(szStructName,"_ENUM")
        InsBufLine(hbuf, ln + 3, "@szLine1@}@szStructName@;");
        SetBufIns (hbuf, ln + 2, strlen(szLine))
        return
    }
    else if (szCmd == "file" || szCmd == "fi" )
    {
        DelBufLine(hbuf, ln)
        /*生成文件头说明*/
        InsertFileHeaderCN( hbuf,0, szMyName,"" )
        return
    }
    else if (szCmd == "hd")
    {
        DelBufLine(hbuf, ln)
        /*生成C语言的头文件*/
        CreateFunctionDef(hbuf,szMyName,0)
        return
    }
    else if (szCmd == "hdn")
    {
        DelBufLine(hbuf, ln)
        /*生成不要文件名的新头文件*/
        CreateNewHeaderFile()
        return
    }
    else if (szCmd == "func" || szCmd == "fu")
    {
        DelBufLine(hbuf,ln)
        lnMax = GetBufLineCount(hbuf)
        if(ln != lnMax)
        {
            szNextLine = GetBufLine(hbuf,ln)
            /*对于2.1版的si如果是非法symbol就会中断执行，故该为以后一行
              是否有‘（’来判断是否是新函数*/
            if( (strstr(szNextLine,"(") != 0xffffffff) || (nVer != 2))
            {
                /*是已经存在的函数*/
                symbol = GetCurSymbol()
                if(strlen(symbol) != 0)
                {  
                    FuncHeadCommentCN(hbuf, ln, symbol, szMyName,0)
                    return
                }
            }
        }
        szFuncName = Ask("请输入函数名称:")
        /*是新函数*/
        FuncHeadCommentCN(hbuf, ln, szFuncName, szMyName, 1)
    }
    else if (szCmd == "tab") /*将tab扩展为空格*/
    {
        DelBufLine(hbuf, ln)
        ReplaceBufTab()
    }
    else if (szCmd == "ap")
    {   
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day
        
        DelBufLine(hbuf, ln)
        szQuestion = AddPromblemNo()
        InsBufLine(hbuf, ln, "@szLine1@/* 问 题 单: @szQuestion@     修改人:@szMyName@,   时间:@sz@/@sz1@/@sz3@ ");
        szContent = Ask("修改原因")
        szLeft = cat(szLine1,"   修改原因: ");
        if(strlen(szLeft) > 70)
        {
            Msg("右边空间太小,请用新的行")
            stop 
        }
        ln = CommentContent(hbuf,ln + 1,szLeft,szContent,1)
        return
    }
    else if (szCmd == "ab")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day
        
        DelBufLine(hbuf, ln)
        szQuestion = GetReg ("PNO")
        if(strlen(szQuestion)>0)
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Added by @szMyName@, @sz@/@sz1@/@sz3@   问题单号:@szQuestion@ */");
        }
        else
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Added by @szMyName@, @sz@/@sz1@/@sz3@ */");        
        }
        return
    }
    else if (szCmd == "ae")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln)
        InsBufLine(hbuf, ln, "@szLine1@/* END:   Added by @szMyName@, @sz@/@sz1@/@sz3@ */");
        return
    }
    else if (szCmd == "db")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln)
        szQuestion = GetReg ("PNO")
        if(strlen(szQuestion) > 0)
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Deleted by @szMyName@, @sz@/@sz1@/@sz3@   问题单号:@szQuestion@ */");
        }
        else
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Deleted by @szMyName@, @sz@/@sz1@/@sz3@ */");
        }
        
        return
    }
    else if (szCmd == "de")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln + 0)
        InsBufLine(hbuf, ln, "@szLine1@/* END: Deleted by @szMyName@, @sz@/@sz1@/@sz3@ */");
        return
    }
    else if (szCmd == "mb")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln)
        szQuestion = GetReg ("PNO")
        if(strlen(szQuestion) > 0)
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Modified by @szMyName@, @sz@/@sz1@/@sz3@   问题单号:@szQuestion@ */");
        }
        else
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Modified by @szMyName@, @sz@/@sz1@/@sz3@ */");
        }
        return
    }
    else if (szCmd == "me")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln)
        InsBufLine(hbuf, ln, "@szLine1@/* END:   Modified by @szMyName@, @sz@/@sz1@/@sz3@ */");
        return
    }
    else
    {
        SearchForward()
        stop
    }
    SetWndSel(hwnd, sel)
    SearchForward()
}

macro BlockCommandProc()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    if(sel.lnFirst > 0)
    {
        ln = sel.lnFirst - 1
    }
    else
    {
        stop
    }
    szLine = GetBufLine(hbuf,ln)
    szLine = TrimString(szLine)
    if(szLine == "while" || szLine == "wh")
    {
        InsertWhile()   /*插入while*/
    }
    else if(szLine == "do")
    {
        InsertDo()   //插入do while语句
    }
    else if(szLine == "for")
    {
        InsertFor()  //插入for语句
    }
    else if(szLine == "if")
    {
        InsertIf()   //插入if语句
    }
    else if(szLine == "el" || szLine == "else")
    {
        InsertElse()  //插入else语句
        DelBufLine(hbuf,ln)
        stop
    }
    else if((szLine == "#ifd") || (szLine == "#ifdef"))
    {
        InsIfdef()        //插入#ifdef
        DelBufLine(hbuf,ln)
        stop
    }
    else if((szLine == "#ifn") || (szLine == "#ifndef"))
    {
        InsIfndef()        //插入#ifdef
        DelBufLine(hbuf,ln)
        stop
    }    
    else if (szLine == "abg")
    {
        InsertReviseAdd()
        DelBufLine(hbuf, ln)
        stop
    }
    else if (szLine == "dbg")
    {
        InsertReviseDel()
        DelBufLine(hbuf, ln)
        stop
    }
    else if (szLine == "mbg")
    {
        InsertReviseMod()
        DelBufLine(hbuf, ln)
        stop
    }
    else if(szLine == "#if")
    {
        InsertPredefIf()
        DelBufLine(hbuf,ln)
        stop
    }
    DelBufLine(hbuf,ln)
    SearchForward()
    stop
}

macro RestoreCommand(hbuf,szCmd)
{
    if(szCmd == "ca")
    {
        SetBufSelText(hbuf, "se")
        szCmd = "case"
    }
    else if(szCmd == "sw") 
    {
        SetBufSelText(hbuf, "itch")
        szCmd = "switch"
    }
    else if(szCmd == "el")
    {
        SetBufSelText(hbuf, "se")
        szCmd = "else"
    }
    else if(szCmd == "wh")
    {
        SetBufSelText(hbuf, "ile")
        szCmd = "while"
    }
    return szCmd
}

macro SearchForward()
{
    LoadSearchPattern("#", 1, 0, 1);
    Search_Forward
}

macro SearchBackward()
{
    LoadSearchPattern("#", 1, 0, 1);
    Search_Backward
}

macro InsertFuncName()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    symbolname = GetCurSymbol()
    SetBufSelText (hbuf, symbolname)
}
//ChenYang在 str1 中间匹配str2得到的字符开始位置
macro strstr(str1,str2)
{
    i = 0
    j = 0
    len1 = strlen(str1)
    len2 = strlen(str2)
    if((len1 == 0) || (len2 == 0))
    {
        return 0xffffffff
    }
    while( i < len1)
    {
        if(str1[i] == str2[j])
        {
            while(j < len2)
            {
                j = j + 1
                if(str1[i+j] != str2[j]) 
                {
                    break
                }
            }     
            if(j == len2)
            {
                return i
            }
            j = 0
        }
        i = i + 1      
    }  
    return 0xffffffff
}
macro InsertTraceInfo()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    hbuf = GetWndBuf(hwnd)
    sel = GetWndSel(hwnd)
    symbol = GetSymbolLocationFromLn(hbuf, sel.lnFirst)
    InsertTraceInCurFunction(hbuf,symbol)
}

macro InsertTraceInCurFunction(hbuf,symbol)
{
    ln = GetBufLnCur (hbuf)
    symbolname = symbol.Symbol
    nLineEnd = symbol.lnLim
    nExitCount = 1;
    InsBufLine(hbuf, ln, "    DebugTrace(\"\\r\\n |@symbolname@() entry--- \");")
    ln = ln + 1
    fIsEnd = 1
    fIsNeedPrt = 1
    fIsSatementEnd = 1
    szLeftOld = ""
    while(ln < nLineEnd)
    {
        szLine = GetBufLine(hbuf, ln)
        iCurLineLen = strlen(szLine)
        
        /*剔除其中的注释语句*/
        RetVal = SkipCommentFromString(szLine,fIsEnd)
        szLine = RetVal.szContent
        fIsEnd = RetVal.fIsEnd
        //查找是否有return语句
/*        ret =strstr(szLine,"return")
        if(ret != 0xffffffff)
        {
            if( (szLine[ret+6] == " " ) || (szLine[ret+6] == "\t" )
                || (szLine[ret+6] == ";" ) || (szLine[ret+6] == "(" ))
            {
                szPre = strmid(szLine,0,ret)
            }
            SetBufIns(hbuf,ln,ret)
            Paren_Right
            sel = GetWndSel(hwnd)
            if( sel.lnLast != ln )
            {
                GetbufLine(hbuf,sel.lnLast)
                RetVal = SkipCommentFromString(szLine,1)
                szLine = RetVal.szContent
                fIsEnd = RetVal.fIsEnd
            }
        }*/
        //获得左边空白大小
        nLeft = GetLeftBlank(szLine)
        if(nLeft == 0)
        {
            szLeft = "    "
        }
        else
        {
            szLeft = strmid(szLine,0,nLeft)
        }
        szLine = TrimString(szLine)
        iLen = strlen(szLine)
        if(iLen == 0)
        {
            ln = ln + 1
            continue
        }
        szRet = GetFirstWord(szLine)
//        if( (szRet == "if") || (szRet == "else")
        //查找是否有return语句
//        ret =strstr(szLine,"return")
        
        if( szRet == "return")
        {
            if( fIsSatementEnd == 0)
            {
                fIsNeedPrt = 1
                InsBufLine(hbuf,ln+1,"@szLeftOld@}")
                szEnd = cat(szLeft,"DebugTrace(\"\\r\\n |@symbolname@() exit---: @nExitCount@ \");")
                InsBufLine(hbuf, ln, szEnd )
                InsBufLine(hbuf,ln,"@szLeftOld@{")
                nExitCount = nExitCount + 1
                nLineEnd = nLineEnd + 3
                ln = ln + 3
            }
            else
            {
                fIsNeedPrt = 0
                szEnd = cat(szLeft,"DebugTrace(\"\\r\\n |@symbolname@() exit---: @nExitCount@ \");")
                InsBufLine(hbuf, ln, szEnd )
                nExitCount = nExitCount + 1
                nLineEnd = nLineEnd + 1
                ln = ln + 1
            }
        }
        else
        {
	        ret =strstr(szLine,"}")
	        if( ret != 0xffffffff )
	        {
	            fIsNeedPrt = 1
	        }
        }
        
        szLeftOld = szLeft
        ch = szLine[iLen-1] 
        if( ( ch  == ";" ) || ( ch  == "{" ) 
             || ( ch  == ":" )|| ( ch  == "}" ) || ( szLine[0] == "#" ))
        {
            fIsSatementEnd = 1
        }
        else
        {
            fIsSatementEnd = 0
        }
        ln = ln + 1
    }
    
    //只要前面的return后有一个}了说明函数的结尾没有返回，需要再加一个出口打印
    if(fIsNeedPrt == 1)
    {
        InsBufLine(hbuf, ln,  "    DebugTrace(\"\\r\\n |@symbolname@() exit---: @nExitCount@ \");")        
        InsBufLine(hbuf, ln,  "")        
    }
}

macro GetFirstWord(szLine)
{
    szLine = TrimLeft(szLine)
    nIdx = 0
    iLen = strlen(szLine)
    while(nIdx < iLen)
    {
        if( (szLine[nIdx] == " ") || (szLine[nIdx] == "\t") //|| (szLine[nIdx] == "\n")
          || (szLine[nIdx] == ";") || (szLine[nIdx] == "(")
          || (szLine[nIdx] == "=") 
          //|| (szLine[nIdx] == ".") 
          || (szLine[nIdx] == "{")
          || (szLine[nIdx] == ",") || (szLine[nIdx] == ":") )
        {
            return strmid(szLine,0,nIdx)
        }
        nIdx = nIdx + 1
    }
    return ""
    
}
//mode 0向左，1向右
macro GetNearWord_cy(szLine,start,search_mode) 
{
    szLine = TrimLeft(szLine)
    nIdx = start
    nIdx_start=0
    nIdx_end=start
    end_falg=0
    finded_flag=0
    iLen = strlen(szLine)
	if(search_mode==0)
    check_nIdx=0
    else     
    check_nIdx=iLen
    while(nIdx >= 0 && nIdx<=iLen)
    {
        if( (szLine[nIdx] == " ") || (szLine[nIdx] == "\t") 
          || (szLine[nIdx] == ";") || (szLine[nIdx] == "(")
          || (szLine[nIdx] == "=") || (szLine[nIdx] == ")") || (szLine[nIdx] == "{")
          || (szLine[nIdx] == ".") || (szLine[nIdx] == "{")
          || (szLine[nIdx] == ",") || (szLine[nIdx] == ":")|| (szLine[nIdx] == "'") 
		  || (nIdx==check_nIdx)
          )
        {
		if(    end_falg==0)
		{
   		 end_falg=1
    	nIdx_end=nIdx
		}
		else if( end_falg==1&&finded_flag==1)
		{
		 nIdx_start=nIdx
		 if(search_mode==0)
         return strmid(szLine,nIdx_start+1,nIdx_end)
         else 
         return strmid(szLine,nIdx_end+1,nIdx_start)

		}
        }
        else finded_flag=1
        if( (szLine[nIdx] == ";")|| (szLine[nIdx] == "}")|| (szLine[nIdx] == "\t")|| (szLine[nIdx] == "'") )finded_flag=0
        if(search_mode==0)
        nIdx = nIdx - 1
        else 
        nIdx = nIdx + 1

    }
    return ""
    
}
macro AutoInsertTraceInfoInBuf()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)

    isymMax = GetBufSymCount(hbuf)
    isym = 0
    while (isym < isymMax) 
    {
        symbol = GetBufSymLocation(hbuf, isym)
        isCodeBegin = 0
        fIsEnd = 1
        isBlandLine = 0
        if(strlen(symbol) > 0)
        {
            if(symbol.Type == "Class Placeholder")
	        {
		        hsyml = SymbolChildren(symbol)
				cchild = SymListCount(hsyml)
				ichild = 0
		    	while (ichild < cchild)
				{
                    symbol = GetBufSymLocation(hbuf, isym)
    		        hsyml = SymbolChildren(symbol)
					childsym = SymListItem(hsyml, ichild)
                    ln = childsym.lnName 
                    isCodeBegin = 0
                    fIsEnd = 1
                    isBlandLine = 0
                    while( ln < childsym.lnLim )
                    {   
                        szLine = GetBufLine (hbuf, ln)
                        
                        //去掉注释的干扰
                        RetVal = SkipCommentFromString(szLine,fIsEnd)
        		        szNew = RetVal.szContent
        		        fIsEnd = RetVal.fIsEnd
                        if(isCodeBegin == 1)
                        {
                            szNew = TrimLeft(szNew)
                            //检测是否是可执行代码开始
                            iRet = CheckIsCodeBegin(szNew)
                            if(iRet == 1)
                            {
                                if( isBlandLine != 0 )
                                {
                                    ln = isBlandLine
                                }
                                InsBufLine(hbuf,ln,"")
                                childsym.lnLim = childsym.lnLim + 1
                                SetBufIns(hbuf, ln+1 , 0)
                                InsertTraceInCurFunction(hbuf,childsym)
                                break
                            }
                            if(strlen(szNew) == 0) 
                            {
                                if( isBlandLine == 0 ) 
                                {
                                    isBlandLine = ln;
                                }
                            }
                            else
                            {
                                isBlandLine = 0
                            }
                        }
        		        //查找到函数的开始
        		        if(isCodeBegin == 0)
        		        {
            		        iRet = strstr(szNew,"{")
                            if(iRet != 0xffffffff)
                            {
                                isCodeBegin = 1
                            }
                        }
                        ln = ln + 1
                    }
                    ichild = ichild + 1
				}
		        SymListFree(hsyml)
	        }
            else if( ( symbol.Type == "Function") ||  (symbol.Type == "Method") )
            {
                ln = symbol.lnName     
                while( ln < symbol.lnLim )
                {   
                    szLine = GetBufLine (hbuf, ln)
                    
                    //去掉注释的干扰
                    RetVal = SkipCommentFromString(szLine,fIsEnd)
    		        szNew = RetVal.szContent
    		        fIsEnd = RetVal.fIsEnd
                    if(isCodeBegin == 1)
                    {
                        szNew = TrimLeft(szNew)
                        //检测是否是可执行代码开始
                        iRet = CheckIsCodeBegin(szNew)
                        if(iRet == 1)
                        {
                            if( isBlandLine != 0 )
                            {
                                ln = isBlandLine
                            }
                            SetBufIns(hbuf, ln , 0)
                            InsertTraceInCurFunction(hbuf,symbol)
                            InsBufLine(hbuf,ln,"")
                            break
                        }
                        if(strlen(szNew) == 0) 
                        {
                            if( isBlandLine == 0 ) 
                            {
                                isBlandLine = ln;
                            }
                        }
                        else
                        {
                            isBlandLine = 0
                        }
                    }
    		        //查找到函数的开始
    		        if(isCodeBegin == 0)
    		        {
        		        iRet = strstr(szNew,"{")
                        if(iRet != 0xffffffff)
                        {
                            isCodeBegin = 1
                        }
                    }
                    ln = ln + 1
                }
            }
        }
        isym = isym + 1
    }
    
}

macro CheckIsCodeBegin(szLine)
{
    iLen = strlen(szLine)
    if(iLen == 0)
    {
        return 0
    }
    nIdx = 0
    nWord = 0
    if( (szLine[nIdx] == "(") || (szLine[nIdx] == "-") 
           || (szLine[nIdx] == "*") || (szLine[nIdx] == "+"))
    {
        return 1
    }
    if( szLine[nIdx] == "#" )
    {
        return 0
    }
    while(nIdx < iLen)
    {
        if( (szLine[nIdx] == " ")||(szLine[nIdx] == "\t") 
             || (szLine[nIdx] == "(")||(szLine[nIdx] == "{")
             || (szLine[nIdx] == ";") )
        {
            if(nWord == 0)
            {
                if( (szLine[nIdx] == "(")||(szLine[nIdx] == "{")
                         || (szLine[nIdx] == ";")  )
                {
                    return 1
                }
                szFirstWord = StrMid(szLine,0,nIdx)
                if(szFirstWord == "return")
                {
                    return 1
                }
            }
            while(nIdx < iLen)
            {
                if( (szLine[nIdx] == " ")||(szLine[nIdx] == "\t") )
                {
                    nIdx = nIdx + 1
                }
                else
                {
                    break
                }
            }
            nWord = nWord + 1
            if(nIdx == iLen)
            {
                return 1
            }
        }
        if(nWord == 1)
        {
            asciiA = AsciiFromChar("A")
            asciiZ = AsciiFromChar("Z")
            ch = toupper(szLine[nIdx])
            asciiCh = AsciiFromChar(ch)
            if( ( szLine[nIdx] == "_" ) || ( szLine[nIdx] == "*" )
                 || ( ( asciiCh >= asciiA ) && ( asciiCh <= asciiZ ) ) )
            {
                return 0
            }
            else
            {
                return 1
            }
        }
        nIdx = nIdx + 1
    }
    return 1
}
macro AutoInsertTraceInfoInPrj()
{
    hprj = GetCurrentProj()
    ifileMax = GetProjFileCount (hprj)
    ifile = 0
    while (ifile < ifileMax)
    {
        filename = GetProjFileName (hprj, ifile)
        szExt = toupper(GetFileNameExt(filename))
        if( (szExt == "C") || (szExt == "CPP") )
        {
            hbuf = OpenBuf (filename)
            if(hbuf != 0)
            {
                SetCurrentBuf(hbuf)
                AutoInsertTraceInfoInBuf()
            }
        }
        //自动保存打开文件，可根据需要打开
/*        if( IsBufDirty (hbuf) )
        {
            SaveBuf (hbuf)
        }
        CloseBuf(hbuf)*/
        ifile = ifile + 1
    }
}

macro RemoveTraceInfo()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    if(hbuf == hNil)
       stop
    symbolname = GetCurSymbol()
    symbol = GetSymbolLocationFromLn(hbuf, sel.lnFirst)
//    symbol = GetSymbolLocation (symbolname)
    nLineEnd = symbol.lnLim
    szEntry = "DebugTrace(\"\\r\\n |@symbolname@() entry--- \");"
    szExit = "DebugTrace(\"\\r\\n |@symbolname@() exit---:" 
    ln = symbol.lnName
    fIsEntry = 0
    while(ln < nLineEnd)
    {
        szLine = GetBufLine(hbuf, ln)
        
        /*剔除其中的注释语句*/
        RetVal = TrimString(szLine)
        if(fIsEntry == 0)
        {
            ret = strstr(szLine,szEntry)
            if(ret != 0xffffffff)
            {
                DelBufLine(hbuf,ln)
                nLineEnd = nLineEnd - 1
                fIsEntry = 1
                ln = ln + 1
                continue
            }
        }
        ret = strstr(szLine,szExit)
        if(ret != 0xffffffff)
        {
            DelBufLine(hbuf,ln)
            nLineEnd = nLineEnd - 1
        }
        ln = ln + 1
    }
}

macro RemoveCurBufTraceInfo()
{
    hbuf = GetCurrentBuf()
    isymMax = GetBufSymCount(hbuf)
    isym = 0
    while (isym < isymMax) 
    {
        isLastLine = 0
        symbol = GetBufSymLocation(hbuf, isym)
        fIsEnd = 1
        if(strlen(symbol) > 0)
        {
            if(symbol.Type == "Class Placeholder")
	        {
		        hsyml = SymbolChildren(symbol)
				cchild = SymListCount(hsyml)
				ichild = 0
		    	while (ichild < cchild)
				{
    		        hsyml = SymbolChildren(symbol)
					childsym = SymListItem(hsyml, ichild)
                    SetBufIns(hbuf,childsym.lnName,0)
                    RemoveTraceInfo()
					ichild = ichild + 1
				}
		        SymListFree(hsyml)
	        }
            else if( ( symbol.Type == "Function") ||  (symbol.Type == "Method") )
            {
                SetBufIns(hbuf,symbol.lnName,0)
                RemoveTraceInfo()
            }
        }
        isym = isym + 1
    }
}

macro RemovePrjTraceInfo()
{
    hprj = GetCurrentProj()
    ifileMax = GetProjFileCount (hprj)
    ifile = 0
    while (ifile < ifileMax)
    {
        filename = GetProjFileName (hprj, ifile)
        hbuf = OpenBuf (filename)
        if(hbuf != 0)
        {
            SetCurrentBuf(hbuf)
            RemoveCurBufTraceInfo()
        }
        //自动保存打开文件，可根据需要打开
/*        if( IsBufDirty (hbuf) )
        {
            SaveBuf (hbuf)
        }
        CloseBuf(hbuf)*/
        ifile = ifile + 1
    }
}

macro InsertFileHeaderEN(hbuf, ln,szName,szContent)
{
    
    hnewbuf = newbuf("")
    if(hnewbuf == hNil)
    {
        stop
    }
    /*取得公司名*/
    szCompany = getreg(MYCOMPANY)
    if(strlen( MYCOMPANY ) == 0)
    {
        szCompany = Ask("Enter your name:")
        setreg(MYCOMPANY, szCompany)
    }
     /*取得版权*/
    szCopyright = getreg(MYCOPYRIGHT)
    if(strlen( MYCOPYRIGHT ) == 0)
    {
        szCopyright = Ask("Enter your name:")
        setreg(MYCOPYRIGHT, szCopyright)
    }   
    GetFunctionList(hbuf,hnewbuf)
    InsBufLine(hbuf, ln + 0,  "/******************************************************************************")
    InsBufLine(hbuf, ln + 1,  "")
    InsBufLine(hbuf, ln + 2,  "  Copyright (C), @szCopyright@, @szCompany@.")
    InsBufLine(hbuf, ln + 3,  "")
    InsBufLine(hbuf, ln + 4,  " ******************************************************************************")
    sz = GetFileName(GetBufName (hbuf))
    InsBufLine(hbuf, ln + 5,  "  File Name     : @sz@")
    InsBufLine(hbuf, ln + 6,  "  Version       : Initial Draft")
    InsBufLine(hbuf, ln + 7,  "  Author        : @szName@")
    SysTime = GetSysTime(1)
    sz=SysTime.Year
    sz1=SysTime.month
    sz3=SysTime.day
    InsBufLine(hbuf, ln + 8,  "  Created       : @sz@/@sz1@/@sz3@")
    InsBufLine(hbuf, ln + 9,  "  Last Modified :")
    szTmp = "  Description   : "
    nlnDesc = ln
    iLen = strlen (szContent)
    InsBufLine(hbuf, ln + 10, "  Description   : @szContent@")
    InsBufLine(hbuf, ln + 11, "  Function List :")
    
    //插入函数列表
    ln = InsertFileList(hbuf,hnewbuf,ln + 12) - 12
    closebuf(hnewbuf)
    InsBufLine(hbuf, ln + 12, "  History       :")
    InsBufLine(hbuf, ln + 13, "  1.Date        : @sz@/@sz1@/@sz3@")
    InsBufLine(hbuf, ln + 14, "    Author      : @szName@")
    InsBufLine(hbuf, ln + 15, "    Modification: Created file")
    InsBufLine(hbuf, ln + 16, "")
    InsBufLine(hbuf, ln + 17, "******************************************************************************/")
    InsBufLine(hbuf, ln + 18, "")
    InsBufLine(hbuf, ln + 19, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 20, " * external variables                           *")
    InsBufLine(hbuf, ln + 21, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 22, "")
    InsBufLine(hbuf, ln + 23, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 24, " * external routine prototypes                  *")
    InsBufLine(hbuf, ln + 25, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 26, "")
    InsBufLine(hbuf, ln + 27, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 28, " * internal routine prototypes                  *")
    InsBufLine(hbuf, ln + 29, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 30, "")
    InsBufLine(hbuf, ln + 31, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 32, " * project-wide global variables                *")
    InsBufLine(hbuf, ln + 33, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 34, "")
    InsBufLine(hbuf, ln + 35, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 36, " * module-wide global variables                 *")
    InsBufLine(hbuf, ln + 37, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 38, "")
    InsBufLine(hbuf, ln + 39, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 40, " * constants                                    *")
    InsBufLine(hbuf, ln + 41, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 42, "")
    InsBufLine(hbuf, ln + 43, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 44, " * macros                                       *")
    InsBufLine(hbuf, ln + 45, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 46, "")
    InsBufLine(hbuf, ln + 47, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 48, " * routines' implementations                    *")
    InsBufLine(hbuf, ln + 49, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 50, "")
    if(iLen != 0)
    {
        return
    }
    
    //如果没有功能描述内容则提示输入
    szContent = Ask("Description")
    SetBufIns(hbuf,nlnDesc + 14,0)
    DelBufLine(hbuf,nlnDesc +10)
    
    //注释输出处理,自动换行
    CommentContent(hbuf,nlnDesc + 10,"  Description   : ",szContent,0)
}


macro InsertFileHeaderCN(hbuf, ln,szName,szContent)
{
    hnewbuf = newbuf("")
    if(hnewbuf == hNil)
    {
        stop
    }
    /*取得公司名*/
    szCompany = getreg(MYCOMPANY)
    if(strlen( MYCOMPANY ) == 0)
    {
        szCompany = Ask("Enter your name:")
        setreg(MYCOMPANY, szCompany)
    }
     /*取得版权*/
    szCopyright = getreg(MYCOPYRIGHT)
    if(strlen( MYCOPYRIGHT ) == 0)
    {
        szCopyright = Ask("Enter your name:")
        setreg(MYCOPYRIGHT, szCopyright)
    }     
    GetFunctionList(hbuf,hnewbuf)
    InsBufLine(hbuf, ln + 0,  "/******************************************************************************")
    InsBufLine(hbuf, ln + 1,  "")
    InsBufLine(hbuf, ln + 2,  "                  版权所有 (C), @szCopyright@, @szCompany@")
    InsBufLine(hbuf, ln + 3,  "")
    InsBufLine(hbuf, ln + 4,  " ******************************************************************************")
    sz = GetFileName(GetBufName (hbuf))
    InsBufLine(hbuf, ln + 5,  "  文 件 名   : @sz@")
    InsBufLine(hbuf, ln + 6,  "  版 本 号   : 初稿")
    InsBufLine(hbuf, ln + 7,  "  作    者   : @szName@")
    SysTime = GetSysTime(1)
    szTime = SysTime.Date
    InsBufLine(hbuf, ln + 8,  "  生成日期   : @szTime@")
    InsBufLine(hbuf, ln + 9,  "  最近修改   :")
    iLen = strlen (szContent)
    nlnDesc = ln
    szTmp = "  功能描述   : "
    InsBufLine(hbuf, ln + 10, "  功能描述   : @szContent@")
    InsBufLine(hbuf, ln + 11, "  函数列表   :")
    
    //插入函数列表
    ln = InsertFileList(hbuf,hnewbuf,ln + 12) - 12
    closebuf(hnewbuf)
    InsBufLine(hbuf, ln + 12, "  修改历史   :")
    InsBufLine(hbuf, ln + 13, "  1.日    期   : @szTime@")

    if( strlen(szMyName)>0 )
    {
       InsBufLine(hbuf, ln + 14, "    作    者   : @szName@")
    }
    else
    {
       InsBufLine(hbuf, ln + 14, "    作    者   : #")
    }
    InsBufLine(hbuf, ln + 15, "    修改内容   : 创建文件")    
    InsBufLine(hbuf, ln + 16, "")
    InsBufLine(hbuf, ln + 17, "******************************************************************************/")
    InsBufLine(hbuf, ln + 18, "")
    InsBufLine(hbuf, ln + 19, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 20, " * 包含头文件                                   *")
    InsBufLine(hbuf, ln + 21, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 22, "")
    InsBufLine(hbuf, ln + 23, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 24, " * 外部变量说明                                 *")
    InsBufLine(hbuf, ln + 25, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 26, "")
    InsBufLine(hbuf, ln + 27, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 28, " * 外部函数原型说明                             *")
    InsBufLine(hbuf, ln + 29, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 30, "")
    InsBufLine(hbuf, ln + 31, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 32, " * 内部函数原型说明                             *")
    InsBufLine(hbuf, ln + 33, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 34, "")
    InsBufLine(hbuf, ln + 35, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 36, " * 全局变量                                     *")
    InsBufLine(hbuf, ln + 37, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 38, "")
    InsBufLine(hbuf, ln + 39, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 40, " * 模块级变量                                   *")
    InsBufLine(hbuf, ln + 41, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 42, "")
    InsBufLine(hbuf, ln + 43, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 44, " * 常量定义                                     *")
    InsBufLine(hbuf, ln + 45, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 46, "")
    InsBufLine(hbuf, ln + 47, "/*----------------------------------------------*")
    InsBufLine(hbuf, ln + 48, " * 宏定义                                       *")
    InsBufLine(hbuf, ln + 49, " *----------------------------------------------*/")
    InsBufLine(hbuf, ln + 50, "")
    if(strlen(szContent) != 0)
    {
        return
    }
    
    //如果没有输入功能描述的话提示输入
    szContent = Ask("请输入文件功能描述的内容")
    SetBufIns(hbuf,nlnDesc + 14,0)
    DelBufLine(hbuf,nlnDesc +10)
    
    //自动排列显示功能描述
    CommentContent(hbuf,nlnDesc+10,"  功能描述   : ",szContent,0)
}

macro GetFunctionList(hbuf,hnewbuf)
{
    isymMax = GetBufSymCount (hbuf)
    isym = 0
    //依次取出全部的但前buf符号表中的全部符号
    while (isym < isymMax) 
    {
        symbol = GetBufSymLocation(hbuf, isym)
        if(symbol.Type == "Class Placeholder")
        {
	        hsyml = SymbolChildren(symbol)
			cchild = SymListCount(hsyml)
			ichild = 0
	    	while (ichild < cchild)
			{
				childsym = SymListItem(hsyml, ichild)
                AppendBufLine(hnewbuf,childsym.symbol)
				ichild = ichild + 1
			}
	        SymListFree(hsyml)
        }
        if(strlen(symbol) > 0)
        {
            if( (symbol.Type == "Method") || 
                (symbol.Type == "Function") || ("Editor Macro" == symbol.Type) )
            {
                //取出类型是函数和宏的符号
                symname = symbol.Symbol
                //将符号插入到新buf中这样做是为了兼容V2.1
                AppendBufLine(hnewbuf,symname)
               }
           }
        isym = isym + 1
    }
}
macro InsertFileList(hbuf,hnewbuf,ln)
{
    if(hnewbuf == hNil)
    {
        return ln
    }
    isymMax = GetBufLineCount (hnewbuf)
    isym = 0
    while (isym < isymMax) 
    {
        szLine = GetBufLine(hnewbuf, isym)
        InsBufLine(hbuf,ln,"          @szLine@")
        ln = ln + 1
        isym = isym + 1
    }
    return ln 
}


macro CommentContent1 (hbuf,ln,szPreStr,szContent,isEnd)
{
    //将剪贴板中的多段文本合并
    szClip = MergeString()
    //去掉多余的空格
    szTmp = TrimString(szContent)
    //如果输入窗口中的内容是剪贴板中的内容说明是剪贴过来的
    ret = strstr(szClip,szTmp)
    if(ret == 0)
    {
        szContent = szClip
    }
    szLeftBlank = szPreStr
    iLen = strlen(szPreStr)
    k = 0
    while(k < iLen)
    {
        szLeftBlank[k] = " ";
        k = k + 1;
    }
    iLen = strlen (szContent)
    szTmp = cat(szPreStr,"#");
    if( iLen == 0)
    {
        InsBufLine(hbuf, ln, "@szTmp@")
    }
    else
    {
        i = 0
        while  (iLen - i > 75 - k )
        {
            j = 0
            while(j < 75 - k)
            {
                iNum = szContent[i + j]
                //如果是中文必须成对处理
                if( AsciiFromChar (iNum)  > 160 )
                {
                   j = j + 2
                }
                else
                {
                   j = j + 1
                }
                if( (j > 70 - k) && (szContent[i + j] == " ") )
                {
                    break
                }
            }
            if( (szContent[i + j] != " " ) )
            {
                n = 0;
                iNum = szContent[i + j + n]
                while( (iNum != " " ) && (AsciiFromChar (iNum)  < 160))
                {
                    n = n + 1
                    if((n >= 3) ||(i + j + n >= iLen))
                         break;
                    iNum = szContent[i + j + n]
                   }
                if(n < 3)
                {
                    j = j + n 
                    sz1 = strmid(szContent,i,i+j)
                    sz1 = cat(szPreStr,sz1)                
                }
                else
                {
                    sz1 = strmid(szContent,i,i+j)
                    sz1 = cat(szPreStr,sz1)
                    if(sz1[strlen(sz1)-1] != "-")
                    {
                        sz1 = cat(sz1,"-")                
                    }
                }
            }
            else
            {
                sz1 = strmid(szContent,i,i+j)
                sz1 = cat(szPreStr,sz1)
            }
            InsBufLine(hbuf, ln, "@sz1@")
            ln = ln + 1
            szPreStr = szLeftBlank
            i = i + j
            while(szContent[i] == " ")
            {
                i = i + 1
            }
        }
        sz1 = strmid(szContent,i,iLen)
        sz1 = cat(szPreStr,sz1)
        if(isEnd)
        {
            sz1 = cat(sz1,"*/")
        }
        InsBufLine(hbuf, ln, "@sz1@")
    }
    return ln
}



macro CommentContent (hbuf,ln,szPreStr,szContent,isEnd)
{
    szLeftBlank = szPreStr
    iLen = strlen(szPreStr)
    k = 0
    while(k < iLen)
    {
        szLeftBlank[k] = " ";
        k = k + 1;
    }

    hNewBuf = newbuf("clip")
    if(hNewBuf == hNil)
        return       
    SetCurrentBuf(hNewBuf)
    PasteBufLine (hNewBuf, 0)
    lnMax = GetBufLineCount( hNewBuf )
    szTmp = TrimString(szContent)

    //判断如果剪贴板是0行时对于有些版本会有问题，要排除掉
    if(lnMax != 0)
    {
        szLine = GetBufLine(hNewBuf , 0)
	    ret = strstr(szLine,szTmp)
	    if(ret == 0)
	    {
	        /*如果输入窗输入的内容是剪贴板的一部分说明是剪贴过来的取剪贴板中的内
	          容*/
	        szContent = TrimString(szLine)
	    }
	    else
	    {
	        lnMax = 1
	    }	    
    }
    else
    {
        lnMax = 1
    }    
    szRet = ""
    nIdx = 0
    while ( nIdx < lnMax) 
    {
        if(nIdx != 0)
        {
            szLine = GetBufLine(hNewBuf , nIdx)
            szContent = TrimLeft(szLine)
               szPreStr = szLeftBlank
        }
        iLen = strlen (szContent)
        szTmp = cat(szPreStr,"#");
        if( (iLen == 0) && (nIdx == (lnMax - 1))
        {
            InsBufLine(hbuf, ln, "@szTmp@")
        }
        else
        {
            i = 0
            //以每行75个字符处理
            while  (iLen - i > 75 - k )
            {
                j = 0
                while(j < 75 - k)
                {
                    iNum = szContent[i + j]
                    if( AsciiFromChar (iNum)  > 160 )
                    {
                       j = j + 2
                    }
                    else
                    {
                       j = j + 1
                    }
                    if( (j > 70 - k) && (szContent[i + j] == " ") )
                    {
                        break
                    }
                }
                if( (szContent[i + j] != " " ) )
                {
                    n = 0;
                    iNum = szContent[i + j + n]
                    //如果是中文字符只能成对处理
                    while( (iNum != " " ) && (AsciiFromChar (iNum)  < 160))
                    {
                        n = n + 1
                        if((n >= 3) ||(i + j + n >= iLen))
                             break;
                        iNum = szContent[i + j + n]
                    }
                    if(n < 3)
                    {
                        //分段后只有小于3个的字符留在下段则将其以上去
                        j = j + n 
                        sz1 = strmid(szContent,i,i+j)
                        sz1 = cat(szPreStr,sz1)                
                    }
                    else
                    {
                        //大于3个字符的加连字符分段
                        sz1 = strmid(szContent,i,i+j)
                        sz1 = cat(szPreStr,sz1)
                        if(sz1[strlen(sz1)-1] != "-")
                        {
                            sz1 = cat(sz1,"-")                
                        }
                    }
                }
                else
                {
                    sz1 = strmid(szContent,i,i+j)
                    sz1 = cat(szPreStr,sz1)
                }
                InsBufLine(hbuf, ln, "@sz1@")
                ln = ln + 1
                szPreStr = szLeftBlank
                i = i + j
                while(szContent[i] == " ")
                {
                    i = i + 1
                }
            }
            sz1 = strmid(szContent,i,iLen)
            sz1 = cat(szPreStr,sz1)
            if((isEnd == 1) && (nIdx == (lnMax - 1))
            {
                sz1 = cat(sz1," */")
            }
            InsBufLine(hbuf, ln, "@sz1@")
        }
        ln = ln + 1
        nIdx = nIdx + 1
    }
    closebuf(hNewBuf)
    return ln - 1
}

macro FormatLine()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    if(sel.ichFirst > 70)
    {
        Msg("选择太靠右了")
        stop 
    }
    hbuf = GetWndBuf(hwnd)
    // get line the selection (insertion point) is on
    szCurLine = GetBufLine(hbuf, sel.lnFirst);
    lineLen = strlen(szCurLine)
    szLeft = strmid(szCurLine,0,sel.ichFirst)
    szContent = strmid(szCurLine,sel.ichFirst,lineLen)
    DelBufLine(hbuf, sel.lnFirst)
    CommentContent(hbuf,sel.lnFirst,szLeft,szContent,0)            

}
//生成指定长度 空格 字符串
macro CreateBlankString(nBlankCount)
{
    szBlank=""
    nIdx = 0
    while(nIdx < nBlankCount)
    {
        szBlank = cat(szBlank," ")
        nIdx = nIdx + 1
    }
    return szBlank
}
//去除前面的空格
macro TrimLeft(szLine)
{
    nLen = strlen(szLine)
    if(nLen == 0)
    {
        return szLine
    }
    nIdx = 0
    while( nIdx < nLen )
    {
        if( ( szLine[nIdx] != " ") && (szLine[nIdx] != "\t") )
        {
            break
        }
        nIdx = nIdx + 1
    }
    return strmid(szLine,nIdx,nLen)
}
//去除后面的空格
macro TrimLeft_End2Start(szLine)
{
    nLen = strlen(szLine)
    if(nLen == 0)
    {
        return szLine
    }
    nIdx = nLen
    while( nIdx < nLen )
    {
        if( ( szLine[nIdx] != " ") && (szLine[nIdx] != "\t"))
        {
            break
        }
        nIdx = nIdx - 1
    }
    return strmid(szLine,0,nIdx)
}
macro TrimRight(szLine)
{
    nLen = strlen(szLine)
    if(nLen == 0)
    {
        return szLine
    }
    nIdx = nLen
    while( nIdx > 0 )
    {
        nIdx = nIdx - 1
        if( ( szLine[nIdx] != " ") && (szLine[nIdx] != "\t") )
        {
            break
        }
    }
    return strmid(szLine,0,nIdx+1)
}
macro TrimString(szLine)
{
    szLine = TrimLeft(szLine)
    szLIne = TrimRight(szLine)
    return szLine
}
 
macro GetFunctionDef(hbuf,symbol)
{
    ln = symbol.lnName
    szFunc = ""
    if(strlen(symbol) == 0)
    {
       return szFunc
    }
    fIsEnd = 1
//    msg(symbol)
    while(ln < symbol.lnLim)
    {
        szLine = GetBufLine (hbuf, ln)
        //去掉被注释掉的内容
        RetVal = SkipCommentFromString(szLine,fIsEnd)
		szLine = RetVal.szContent
		szLine = TrimString(szLine)
		fIsEnd = RetVal.fIsEnd
        //如果是'{'表示函数参数头结束了
        ret = strstr(szLine,"{")        
        if(ret != 0xffffffff)
        {
            szLine = strmid(szLine,0,ret)
            szFunc = cat(szFunc,szLine)
            break
        }
        szFunc = cat(szFunc,szLine)        
        ln = ln + 1
    }
    return szFunc
}

macro GetWordFromString(hbuf,szLine,nBeg,nEnd,chBeg,chSeparator,chEnd)
{
    if((nEnd > strlen(szLine) || (nBeg > nEnd))
    {
        return 0
    }
    nMaxLen = 0
    nIdx = nBeg
    //先定位到开始字符标记处
    while(nIdx < nEnd)
    {
        if(szLine[nIdx] == chBeg)
        {
            break
        }
        nIdx = nIdx + 1
    }
    nBegWord = nIdx + 1
    
    //用于检测chBeg和chEnd的配对情况
    iCount = 0
    
    nEndWord = 0
    //以分隔符为标记进行搜索
    while(nIdx < nEnd)
    {
        if(szLine[nIdx] == chSeparator)
        {
           szWord = strmid(szLine,nBegWord,nIdx)
           szWord = TrimString(szWord)
           nLen = strlen(szWord)
           if(nMaxLen < nLen)
           {
               nMaxLen = nLen
           }
           AppendBufLine(hbuf,szWord)
           nBegWord = nIdx + 1
        }
        if(szLine[nIdx] == chBeg)
        {
            iCount = iCount + 1
        }
        if(szLine[nIdx] == chEnd)
        {
            iCount = iCount - 1
            nEndWord = nIdx
            if( iCount == 0 )
            {
                break
            }
        }
        nIdx = nIdx + 1
    }
    if(nEndWord > nBegWord)
    {
        szWord = strmid(szLine,nBegWord,nEndWord)
        szWord = TrimString(szWord)
        nLen = strlen(szWord)
        if(nMaxLen < nLen)
        {
            nMaxLen = nLen
        }
        AppendBufLine(hbuf,szWord)
    }
    return nMaxLen
}

macro FuncHeadCommentCN(hbuf, ln, szFunc, szMyName,newFunc)
{
    iIns = 0
    if(newFunc != 1)
    {
        symbol = GetSymbolLocationFromLn(hbuf, ln)
        if(strlen(symbol) > 0)
        {
            hTmpBuf = NewBuf("Tempbuf")
            if(hTmpBuf == hNil)
            {
                stop
            }
            //将文件参数头整理成一行并去掉了注释
            szLine = GetFunctionDef(hbuf,symbol)            
            iBegin = symbol.ichName 
            //取出返回值定义
            szTemp = strmid(szLine,0,iBegin)
            szTemp = TrimString(szTemp)
            szRet =  GetFirstWord(szTemp)
            if(symbol.Type == "Method")
            {
                szTemp = strmid(szTemp,strlen(szRet),strlen(szTemp))
                szTemp = TrimString(szTemp)
                if(szTemp == "::")
                {
                    szRet = ""
                }
            }
            if(toupper (szRet) == "MACRO")
            {
                //对于宏返回值特殊处理
                szRet = ""
            }
            //从函数头分离出函数参数
            nMaxParamSize = GetWordFromString(hTmpBuf,szLine,iBegin,strlen(szLine),"(",",",")")
            lnMax = GetBufLineCount(hTmpBuf)
            ln = symbol.lnFirst
            SetBufIns (hbuf, ln, 0)
        }
    }
    else
    {
        lnMax = 0
        szLine = ""
        szRet = ""
    }
    InsBufLine(hbuf, ln, "/*****************************************************************************")
    if( strlen(szFunc)>0 )
    {
        InsBufLine(hbuf, ln+1, " 函 数 名  : @szFunc@")
    }
    else
    {
        InsBufLine(hbuf, ln+1, " 函 数 名  : #")
    }
    oldln = ln
    InsBufLine(hbuf, ln+2, " 功能描述  : ")
    szIns = " 输入参数  : "
    if(newFunc != 1)
    {
        //对于已经存在的函数插入函数参数
        i = 0
        while ( i < lnMax) 
        {
            szTmp = GetBufLine(hTmpBuf, i)
            nLen = strlen(szTmp);
            szBlank = CreateBlankString(nMaxParamSize - nLen + 2)
            szTmp = cat(szTmp,szBlank)
            ln = ln + 1
            szTmp = cat(szIns,szTmp)
            InsBufLine(hbuf, ln+2, "@szTmp@")
            iIns = 1
            szIns = "             "
            i = i + 1
        }    
        closebuf(hTmpBuf)
    }
    if(iIns == 0)
    {       
            ln = ln + 1
            InsBufLine(hbuf, ln+2, " 输入参数  : 无")
    }
    InsBufLine(hbuf, ln+3, " 输出参数  : 无")
    InsBufLine(hbuf, ln+4, " 返 回 值  : @szRet@")
    InsBufLine(hbuf, ln+5, " 调用函数  : ")
    InsBufLine(hbuf, ln+6, " 被调函数  : ")
    InsbufLIne(hbuf, ln+7, " ");
    InsBufLine(hbuf, ln+8, " 修改历史      :")
    SysTime = GetSysTime(1);
    szTime = SysTime.Date

    InsBufLine(hbuf, ln+9, "  1.日    期   : @szTime@")

    if( strlen(szMyName)>0 )
    {
       InsBufLine(hbuf, ln+10, "    作    者   : @szMyName@")
    }
    else
    {
       InsBufLine(hbuf, ln+10, "    作    者   : #")
    }
    InsBufLine(hbuf, ln+11, "    修改内容   : 新生成函数")    
    InsBufLine(hbuf, ln+12, "")    
    InsBufLine(hbuf, ln+13, "*****************************************************************************/")
    if ((newFunc == 1) && (strlen(szFunc)>0))
    {
        InsBufLine(hbuf, ln+14, "UINT32_T  @szFunc@( # )")
        InsBufLine(hbuf, ln+15, "{");
        InsBufLine(hbuf, ln+16, "    #");
        InsBufLine(hbuf, ln+17, "}");
        SearchForward()
    }        
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    sel.ichFirst = 0
    sel.ichLim = sel.ichFirst
    sel.lnFirst = ln + 14
    sel.lnLast = ln + 14        
    szContent = Ask("请输入函数功能描述的内容")
    setWndSel(hwnd,sel)
    DelBufLine(hbuf,oldln + 2)

    //显示输入的功能描述内容
    newln = CommentContent(hbuf,oldln+2," 功能描述  : ",szContent,0) - 2
    ln = ln + newln - oldln
    if ((newFunc == 1) && (strlen(szFunc)>0))
    {
        isFirstParam = 1
            
        //提示输入新函数的返回值
        szRet = Ask("请输入返回值类型")
        if(strlen(szRet) > 0)
        {
            PutBufLine(hbuf, ln+4, " 返 回 值  : @szRet@")            
            PutBufLine(hbuf, ln+14, "@szRet@ @szFunc@(   )")
            SetbufIns(hbuf,ln+14,strlen(szRet)+strlen(szFunc) + 3
        }
        szFuncDef = ""
        sel.ichFirst = strlen(szFunc)+strlen(szRet) + 3
        sel.ichLim = sel.ichFirst + 1
        //循环输入参数
        while (1)
        {
            szParam = ask("请输入函数参数名")
            szParam = TrimString(szParam)
            szTmp = cat(szIns,szParam)
            szParam = cat(szFuncDef,szParam)
            sel.lnFirst = ln + 14
            sel.lnLast = ln + 14
            setWndSel(hwnd,sel)
            sel.ichFirst = sel.ichFirst + strlen(szParam)
            sel.ichLim = sel.ichFirst
            oldsel = sel
            if(isFirstParam == 1)
            {
                PutBufLine(hbuf, ln+2, "@szTmp@")
                isFirstParam  = 0
            }
            else
            {
                ln = ln + 1
                InsBufLine(hbuf, ln+2, "@szTmp@")
                oldsel.lnFirst = ln + 14
                oldsel.lnLast = ln + 14        
            }
            SetBufSelText(hbuf,szParam)
            szIns = "             "
            szFuncDef = ", "
            oldsel.lnFirst = ln + 16
            oldsel.lnLast = ln + 16
            oldsel.ichFirst = 4
            oldsel.ichLim = 5
            setWndSel(hwnd,oldsel)
        }
    }
    return ln + 17
}

macro FuncHeadCommentEN(hbuf, ln, szFunc, szMyName,newFunc)
{
    iIns = 0
    if(newFunc != 1)
    {
        symbol = GetSymbolLocationFromLn(hbuf, ln)
        if(strlen(symbol) > 0)
        {
            hTmpBuf = NewBuf("Tempbuf")
                
            //将文件参数头整理成一行并去掉了注释
            szLine = GetFunctionDef(hbuf,symbol)            
            iBegin = symbol.ichName
            
            //取出返回值定义
            szTemp = strmid(szLine,0,iBegin)
            szTemp = TrimString(szTemp)
            szRet =  GetFirstWord(szTemp)
            if(symbol.Type == "Method")
            {
                szTemp = strmid(szTemp,strlen(szRet),strlen(szTemp))
                szTemp = TrimString(szTemp)
                if(szTemp == "::")
                {
                    szRet = ""
                }
            }
            if(toupper (szRet) == "MACRO")
            {
                //对于宏返回值特殊处理
                szRet = ""
            }
            
            //从函数头分离出函数参数
            nMaxParamSize = GetWordFromString(hTmpBuf,szLine,iBegin,strlen(szLine),"(",",",")")
            lnMax = GetBufLineCount(hTmpBuf)
            ln = symbol.lnFirst
            SetBufIns (hbuf, ln, 0)
        }
    }
    else
    {
        lnMax = 0
        szRet = ""
        szLine = ""
    }
    InsBufLine(hbuf, ln, "/*****************************************************************************")
    InsBufLine(hbuf, ln+1, " Prototype    : @szFunc@")
    InsBufLine(hbuf, ln+2, " Description  : ")
    oldln  = ln 
    szIns = " Input        : "
    if(newFunc != 1)
    {
        //对于已经存在的函数输出输入参数表
        i = 0
        while ( i < lnMax) 
        {
            szTmp = GetBufLine(hTmpBuf, i)
            nLen = strlen(szTmp);
            
            //对齐参数后面的空格，实际是对齐后面的参数的说明
            szBlank = CreateBlankString(nMaxParamSize - nLen + 2)
            szTmp = cat(szTmp,szBlank)
            ln = ln + 1
            szTmp = cat(szIns,szTmp)
            InsBufLine(hbuf, ln+2, "@szTmp@")
            iIns = 1
            szIns = "                "
            i = i + 1
        }    
        closebuf(hTmpBuf)
    }
    if(iIns == 0)
    {       
            ln = ln + 1
            InsBufLine(hbuf, ln+2, " Input        : None")
    }
    InsBufLine(hbuf, ln+3, " Output       : None")
    InsBufLine(hbuf, ln+4, " Return Value : @szRet@")
    InsBufLine(hbuf, ln+5, " Calls        : ")
    InsBufLine(hbuf, ln+6, " Called By    : ")
    InsbufLIne(hbuf, ln+7, " ");
    
    SysTime = GetSysTime(1);
    sz1=SysTime.Year
    sz2=SysTime.month
    sz3=SysTime.day

    InsBufLine(hbuf, ln + 8, "  History        :")
    InsBufLine(hbuf, ln + 9, "  1.Date         : @sz1@/@sz2@/@sz3@")
    InsBufLine(hbuf, ln + 10, "    Author       : @szMyName@")
    InsBufLine(hbuf, ln + 11, "    Modification : Created function")
    InsBufLine(hbuf, ln + 12, "")    
    InsBufLine(hbuf, ln + 13, "*****************************************************************************/")
    if ((newFunc == 1) && (strlen(szFunc)>0))
    {
        InsBufLine(hbuf, ln+14, "UINT32_T  @szFunc@( # )")
        InsBufLine(hbuf, ln+15, "{");
        InsBufLine(hbuf, ln+16, "    #");
        InsBufLine(hbuf, ln+17, "}");
        SearchForward()
    }        
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    sel.ichFirst = 0
    sel.ichLim = sel.ichFirst
    sel.lnFirst = ln + 14
    sel.lnLast = ln + 14        
    szContent = Ask("Description")
    DelBufLine(hbuf,oldln + 2)
    setWndSel(hwnd,sel)
    newln = CommentContent(hbuf,oldln + 2," Description  : ",szContent,0) - 2
    ln = ln + newln - oldln
    if ((newFunc == 1) && (strlen(szFunc)>0))
    {
        //提示输入函数返回值名
        szRet = Ask("Please input return value type")
        if(strlen(szRet) > 0)
        {
            PutBufLine(hbuf, ln+4, " Return Value : @szRet@")            
            PutBufLine(hbuf, ln+14, "@szRet@ @szFunc@( # )")
            SetbufIns(hbuf,ln+14,strlen(szRet)+strlen(szFunc) + 3
        }
        szFuncDef = ""
        isFirstParam = 1
        sel.ichFirst = strlen(szFunc)+strlen(szRet) + 3
        sel.ichLim = sel.ichFirst + 1

        //循环输入新函数的参数
        while (1)
        {
            szParam = ask("Please input parameter")
            szParam = TrimString(szParam)
            szTmp = cat(szIns,szParam)
            szParam = cat(szFuncDef,szParam)
            sel.lnFirst = ln + 14
            sel.lnLast = ln + 14
            setWndSel(hwnd,sel)
            sel.ichFirst = sel.ichFirst + strlen(szParam)
            sel.ichLim = sel.ichFirst
            oldsel = sel
            if(isFirstParam == 1)
            {
                PutBufLine(hbuf, ln+2, "@szTmp@")
                isFirstParam  = 0
            }
            else
            {
                ln = ln + 1
                InsBufLine(hbuf, ln+2, "@szTmp@")
                oldsel.lnFirst = ln + 14
                oldsel.lnLast = ln + 14        
            }
            SetBufSelText(hbuf,szParam)
            szIns = "                "
            szFuncDef = ", "
            oldsel.lnFirst = ln + 16
            oldsel.lnLast = ln + 16
            oldsel.ichFirst = 4
            oldsel.ichLim = 5
            setWndSel(hwnd,oldsel)
        }
    }
    return ln + 17
}
macro InsertHistory(hbuf,ln,language)
{
    iHistoryCount = 1
    isLastLine = ln
    i = 0
    while(ln-i>0)
    {
        szCurLine = GetBufLine(hbuf, ln-i);
        iBeg1 = strstr(szCurLine,"日期  ")
        iBeg2 = strstr(szCurLine,"Date      ")
        if((iBeg1 != 0xffffffff) || (iBeg2 != 0xffffffff))
        {
            iHistoryCount = iHistoryCount + 1
            i = i + 1
            continue
        }
  //      iBeg1 = strstr(szCurLine,"修改历史")
 //      iBeg2 = strstr(szCurLine,"History      ")
        if((iBeg1 != 0xffffffff) || (iBeg2 != 0xffffffff))
        {
            break
        }
        iBeg = strstr(szCurLine,"/**********************")
        if( iBeg != 0xffffffff )
        {
            break
        }
        i = i + 1
    }
    if(language == 0)
    {
        InsertHistoryContentCN(hbuf,ln,iHistoryCount)
    }
    else
    {
        InsertHistoryContentEN(hbuf,ln,iHistoryCount)
    }
}
macro UpdateFunctionList()
{
    hnewbuf = newbuf("")
    if(hnewbuf == hNil)
    {
        stop
    }
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    //msg(hbuf)
    GetFunctionList(hbuf,hnewbuf)
    ln = sel.lnFirst
    iHistoryCount = 1
    isLastLine = ln
    iTotalLn = GetBufLineCount (hbuf) 
    while(ln < iTotalLn)
    {
        szCurLine = GetBufLine(hbuf, ln);
        iLen = strlen(szCurLine)
        j = 0;
        while(j < iLen)
        {
            if(szCurLine[j] != " ")
                break
            j = j + 1
        }
        
        //以文件头说明中前有大于10个空格的为函数列表记录
        if(j > 10)
        {
            DelBufLine(hbuf, ln)   
        }
        else
        {
            break
        }
        iTotalLn = GetBufLineCount (hbuf) 
    }

    //插入函数列表
    InsertFileList( hbuf,hnewbuf,ln )
    closebuf(hnewbuf)
 }

macro  InsertHistoryContentCN(hbuf,ln,iHostoryCount)
{
    SysTime = GetSysTime(1);
    szTime = SysTime.Date
    szMyName = getreg(MYNAME)

    InsBufLine(hbuf, ln, "")
    InsBufLine(hbuf, ln + 1, "  @iHostoryCount@.日期   :  @szTime@")

    if( strlen(szMyName) > 0 )
    {
       InsBufLine(hbuf, ln + 2, "    作者   : @szMyName@")
    }
    else
    {
       InsBufLine(hbuf, ln + 2, "    作者   : #")
    }
       szContent = Ask("请输入修改的内容")
       CommentContent(hbuf,ln + 3,"    修改内容   : ",szContent,0)
}


macro  InsertHistoryContentEN(hbuf,ln,iHostoryCount)
{
    SysTime = GetSysTime(1);
    szTime = SysTime.Date
    sz1=SysTime.Year
    sz2=SysTime.month
    sz3=SysTime.day
    szMyName = getreg(MYNAME)
    InsBufLine(hbuf, ln, "")
    InsBufLine(hbuf, ln + 1, "  @iHostoryCount@.Date         : @sz1@/@sz2@/@sz3@")

    InsBufLine(hbuf, ln + 2, "    Author       : @szMyName@")
       szContent = Ask("Please input modification")
       CommentContent(hbuf,ln + 3,"    Modification : ",szContent,0)
}

macro CreateFunctionDef(hbuf, szName, language)
{
    ln = 0

    //获得当前没有后缀的文件名
    szFileName = GetFileNameNoExt(GetBufName (hbuf))
    if(strlen(szFileName) == 0)
    {    
        sz = ask("请输入头文件名")
        szFileName = GetFileNameNoExt(sz)
        szExt = GetFileNameExt(szFileName)        
        szPreH = toupper (szFileName)
        szPreH = cat("__",szPreH)
        szExt = toupper(szExt)
        szPreH = cat(szPreH,"_@szExt@__")
    }
    szPreH = toupper (szFileName)
    sz = cat(szFileName,".h")
    szPreH = cat("__",szPreH)
    szPreH = cat(szPreH,"_H__")
    hOutbuf = NewBuf(sz) // create output buffer
    if (hOutbuf == 0)
        stop
    //搜索符号表取得函数名
    SetCurrentBuf(hOutbuf)
    isymMax = GetBufSymCount(hbuf)
    isym = 0
    while (isym < isymMax) 
    {
        isLastLine = 0
        symbol = GetBufSymLocation(hbuf, isym)
        fIsEnd = 1
        if(strlen(symbol) > 0)
        {
            if(symbol.Type == "Class Placeholder")
	        {
		        hsyml = SymbolChildren(symbol)
				cchild = SymListCount(hsyml)
				ichild = 0
				szClassName = symbol.Symbol
                InsBufLine(hOutbuf, ln, "}")
			    InsBufLine(hOutbuf, ln, "{")
			    InsBufLine(hOutbuf, ln, "class @szClassName@")
			    ln = ln + 2
		    	while (ichild < cchild)
				{
					childsym = SymListItem(hsyml, ichild)
					childsym.Symbol = szClassName
                    ln = CreateClassPrototype(hbuf,ln,childsym)
					ichild = ichild + 1
				}
		        SymListFree(hsyml)
                InsBufLine(hOutbuf, ln + 1, "")
		        ln = ln + 2
	        }
            else if( symbol.Type == "Function" )
            {
                ln = CreateFuncPrototype(hbuf,ln,"extern",symbol)
            }
            else if( symbol.Type == "Method" ) 
            {
                szLine = GetBufline(hbuf,symbol.lnName)
                szClassName = GetLeftWord(szLine,symbol.ichName)
                symbol.Symbol = szClassName
                ln = CreateClassPrototype(hbuf,ln,symbol)            
            }
            
        }
        isym = isym + 1
    }
    InsertCPP(hOutbuf,0)
    HeadIfdefStr(szPreH)
    szContent = GetFileName(GetBufName (hbuf))
    if(language == 0)
    {
        szContent = cat(szContent," 的头文件")
        //插入文件头说明
        InsertFileHeaderCN(hOutbuf,0,szName,szContent)
    }
    else
    {
        szContent = cat(szContent," header file")
        //插入文件头说明
        InsertFileHeaderEN(hOutbuf,0,szName,szContent)        
    }
}


macro GetLeftWord(szLine,ichRight)
{
    if(ich == 0)
    {
        return ""
    }
    ich = ichRight
    while(ich > 0)
    {
        if( (szLine[ich] == " ") || (szLine[ich] == "\t")
            || ( szLine[ich] == ":") || (szLine[ich] == "."))

        {
            ich = ich - 1
            ichRight = ich
        }
        else
        {
            break
        }
    }    
    while(ich > 0)
    {
        if(szLine[ich] == " ")
        {
            ich = ich + 1
            break
        }
        ich = ich - 1
    }
    return strmid(szLine,ich,ichRight)
}
macro CreateClassPrototype(hbuf,ln,symbol)
{
    isLastLine = 0
    fIsEnd = 1
    hOutbuf = GetCurrentBuf()
    szLine = GetBufLine (hbuf, symbol.lnName)
    sline = symbol.lnFirst     
    szClassName = symbol.Symbol
    ret = strstr(szLine,szClassName)
    if(ret == 0xffffffff)
    {
        return ln
    }
    szPre = strmid(szLine,0,ret)
    szLine = strmid(szLine,symbol.ichName,strlen(szLine))
    szLine = cat(szPre,szLine)
    //去掉注释的干扰
    RetVal = SkipCommentFromString(szLine,fIsEnd)
    fIsEnd = RetVal.fIsEnd
    szNew = RetVal.szContent
    szLine = cat("    ",szLine)
    szNew = cat("    ",szNew)
    while((isLastLine == 0) && (sline < symbol.lnLim))
    {   
        i = 0
        j = 0
        iLen = strlen(szNew)
        while(i < iLen)
        {
            if(szNew[i]=="(")
            {
               j = j + 1;
            }
            else if(szNew[i]==")")
            {
                j = j - 1;
                if(j <= 0)
                {
                    //函数参数头结束
                    isLastLine = 1  
                    //去掉最后多余的字符
        	        szLine = strmid(szLine,0,i+1);
                    szLine = cat(szLine,";")
                    break
                }
            }
            i = i + 1
        }
        InsBufLine(hOutbuf, ln, "@szLine@")
        ln = ln + 1
        sline = sline + 1
        if(isLastLine != 1)
        {              
            //函数参数头还没有结束再取一行
            szLine = GetBufLine (hbuf, sline)
            //去掉注释的干扰
            RetVal = SkipCommentFromString(szLine,fIsEnd)
	        szNew = RetVal.szContent
	        fIsEnd = RetVal.fIsEnd
        }                    
    }
    return ln
}

macro CreateFuncPrototype(hbuf,ln,szType,symbol)
{
    isLastLine = 0
    hOutbuf = GetCurrentBuf()
    szLine = GetBufLine (hbuf,symbol.lnName)
    //去掉注释的干扰
    RetVal = SkipCommentFromString(szLine,fIsEnd)
    szNew = RetVal.szContent
    fIsEnd = RetVal.fIsEnd
    szLine = cat("@szType@ ",szLine)
    szNew = cat("@szType@ ",szNew)
    sline = symbol.lnFirst     
    while((isLastLine == 0) && (sline < symbol.lnLim))
    {   
        i = 0
        j = 0
        iLen = strlen(szNew)
        while(i < iLen)
        {
            if(szNew[i]=="(")
            {
               j = j + 1;
            }
            else if(szNew[i]==")")
            {
                j = j - 1;
                if(j <= 0)
                {
                    //函数参数头结束
                    isLastLine = 1  
                    //去掉最后多余的字符
        	        szLine = strmid(szLine,0,i+1);
                    szLine = cat(szLine,";")
                    break
                }
            }
            i = i + 1
        }
        InsBufLine(hOutbuf, ln, "@szLine@")
        ln = ln + 1
        sline = sline + 1
        if(isLastLine != 1)
        {              
            //函数参数头还没有结束再取一行
            szLine = GetBufLine (hbuf, sline)
            szLine = cat("         ",szLine)
            //去掉注释的干扰
            RetVal = SkipCommentFromString(szLine,fIsEnd)
	        szNew = RetVal.szContent
	        fIsEnd = RetVal.fIsEnd
        }                    
    }
    return ln
}


macro CreateNewHeaderFile()
{
    hbuf = GetCurrentBuf()
    language = getreg(LANGUAGE)
    if(language != 1)
    {
        language = 0
    }
    szName = getreg(MYNAME)
    if(strlen( szName ) == 0)
    {
        szMyName = Ask("Enter your name:")
        setreg(MYNAME, szMyName)
    }
    isymMax = GetBufSymCount(hbuf)
    isym = 0
    ln = 0
    //获得当前没有后缀的文件名
    sz = ask("Please input header file name")
    szFileName = GetFileNameNoExt(sz)
    szExt = GetFileNameExt(sz)        
    szPreH = toupper (szFileName)
    szPreH = cat("__",szPreH)
    szExt = toupper(szExt)
    szPreH = cat(szPreH,"_@szExt@__")
    hOutbuf = NewBuf(sz) // create output buffer
    if (hOutbuf == 0)
        stop

    SetCurrentBuf(hOutbuf)
    InsertCPP(hOutbuf,0)
    HeadIfdefStr(szPreH)
    szContent = GetFileName(GetBufName (hbuf))
    if(language == 0)
    {
        szContent = cat(szContent," 的头文件")

        //插入文件头说明
        InsertFileHeaderCN(hOutbuf,0,szName,szContent)
    }
    else
    {
        szContent = cat(szContent," header file")

        //插入文件头说明
        InsertFileHeaderEN(hOutbuf,0,szName,szContent)        
    }

    lnMax = GetBufLineCount(hOutbuf)
    if(lnMax > 9)
    {
        ln = lnMax - 9
    }
    else
    {
        return
    }
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    sel.lnFirst = ln
    sel.ichFirst = 0
    sel.ichLim = 0
    SetBufIns(hOutbuf,ln,0)
    szType = Ask ("Please prototype type : extern or static")
    //搜索符号表取得函数名
    while (isym < isymMax) 
    {
        isLastLine = 0
        symbol = GetBufSymLocation(hbuf, isym)
        fIsEnd = 1
        if(strlen(symbol) > 0)
        {
            if(symbol.Type == "Class Placeholder")
	        {
		        hsyml = SymbolChildren(symbol)
				cchild = SymListCount(hsyml)
				ichild = 0
				szClassName = symbol.Symbol
                InsBufLine(hOutbuf, ln, "}")
			    InsBufLine(hOutbuf, ln, "{")
			    InsBufLine(hOutbuf, ln, "class @szClassName@")
			    ln = ln + 2
		    	while (ichild < cchild)
				{
					childsym = SymListItem(hsyml, ichild)
					childsym.Symbol = szClassName
                    ln = CreateClassPrototype(hbuf,ln,childsym)
					ichild = ichild + 1
				}
		        SymListFree(hsyml)
                InsBufLine(hOutbuf, ln + 1, "")
		        ln = ln + 2
	        }
            else if( symbol.Type == "Function" )
            {
                ln = CreateFuncPrototype(hbuf,ln,szType,symbol)
            }
            else if( symbol.Type == "Method" ) 
            {
                szLine = GetBufline(hbuf,symbol.lnName)
                szClassName = GetLeftWord(szLine,symbol.ichName)
                symbol.Symbol = szClassName
                ln = CreateClassPrototype(hbuf,ln,symbol)            
            }
        }
        isym = isym + 1
    }
    sel.lnLast = ln 
    SetWndSel(hwnd,sel)
}

//chenyang,获得字符串指定位置的左边字符信息,只提取字符和#  / *
macro GetWordLeftOfIch(ich, sz)
{
    wordinfo = "" // create a "wordinfo" structure
    
    chTab = CharFromAscii(9)
    
    // scan backwords over white space, if any
    ich = ich - 1;
    if (ich >= 0)
        while (sz[ich] == " " || sz[ich] == chTab)
        {
            ich = ich - 1;
            if (ich < 0)
                break;
        }
    
    // scan backwords to start of word    
    ichLim = ich + 1;
    asciiA = AsciiFromChar("A")
    asciiZ = AsciiFromChar("Z")
    while (ich >= 0)
    {
        ch = toupper(sz[ich])
        asciiCh = AsciiFromChar(ch)
        
/*        if ((asciiCh < asciiA || asciiCh > asciiZ)
             && !IsNumber(ch)
             &&  (ch != "#") )
            break // stop at first non-identifier character
*/
        //只提取字符和/#   *作为命令
        if ((asciiCh < asciiA || asciiCh > asciiZ) 
           && !IsNumber(ch)
           && ( ch != "#" && ch != "{" && ch != "/" && ch != "*"))
            break;

        ich = ich - 1;
    }
    
    ich = ich + 1
    wordinfo.szWord = strmid(sz, ich, ichLim)
    wordinfo.ich = ich
    wordinfo.ichLim = ichLim;
    
    return wordinfo
}


macro ReplaceBufTab()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    hbuf = GetWndBuf(hwnd)
    iTotalLn = GetBufLineCount (hbuf)
    nBlank = Ask("一个Tab替换几个空格")
    if(nBlank == 0)
    {
        nBlank = 4
    }
    szBlank = CreateBlankString(nBlank)
    ReplaceInBuf(hbuf,"\t",szBlank,0, iTotalLn, 1, 0, 0, 1)
}
/*


macro ReplaceInBuf(hbuf,chOld,chNew,nBeg,nEnd,fMatchCase, fRegExp, fWholeWordsOnly, fConfirm)
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    hbuf = GetWndBuf(hwnd)
    sel = GetWndSel(hwnd)
    sel.ichLim = 0
    sel.lnLast = 0
    sel.ichFirst = sel.ichLim
    sel.lnFirst = sel.lnLast
    SetWndSel(hwnd, sel)
    LoadSearchPattern(chOld, 0, 0, 0);
    while(1)
    {
        Search_Forward
        selNew = GetWndSel(hwnd)
        if(sel == selNew)
        {
            break
        }
        SetBufSelText(hbuf, chNew)
           selNew.ichLim = selNew.ichFirst 
        SetWndSel(hwnd, selNew)
        sel = selNew
    }
}*/
macro ConfigureDebug()

{
     szModeID = ASK("请输入Debug序号")
    if(szModeID == "#")
    {
       SetReg (Breakpoint_ID,1 )	
    }
    else
    {
       SetReg (Breakpoint_ID, szModeID)
    }


}

macro ConfigureProblem()
{
     szModeID = ASK("请输入0或1，关闭开启修改模式")
    if(szModeID == "#")
    {
       SetReg ("ModeID", "0")
    }
    else
    {
       SetReg (ModeID, szModeID)
    }
        if(szModeID == "0")
        return 0 
    szProbmID = ASK("请输入1位修改编号");
    if(szProbmID == "#")
    {
       SetReg ("ProbmID", "01")
    }
    if (szProbmID > 10)
 {
  tem=szProbmID/10
    szProbmID=szProbmID-10*tem
 }
    SetReg (ProbmID, szProbmID)
    /*
    else if (szProbmID < 10)
	{
		szProbmID = "0@szProbmID@"
		SetReg (ProbmID, szProbmID)
	}
    else  if (szProbmID >100)
    {
    szProbmID = szProbmID-szProbmID/100*100
     if (szProbmID < 10)
     szProbmID = "0@szProbmID@"
       SetReg (ProbmID, szProbmID)
    }  
    */

}

macro ConfigureSystem()
{
  
    szName = ASK("请输入您的姓名拼写");
    if(szName == "#")
    {
       SetReg ("MYNAME", "xxxx")
    }
    else
    {
       SetReg ("MYNAME", szName)
    }
 //       szID = ASK("Please input your ID");
    szID = ASK("请输入您的4位工号");
    if(szID == "#")
    {
       SetReg ("MYID", "0000")
    }
    else
    {
       SetReg (MYID, szID)
    }
 /*     szVersID = ASK("请输入修改版本号");
    if(szVersID == "#")
    {
       SetReg ("VersID", "01")
    }
    else
    {
       SetReg (VersID, szVersID)
    }
     szCompany = ASK("Please input your company");
    if(szCompany == "#")
    {
        SetReg("MYCOMPANY","Goodix")
    }
    else
    {
        SetReg("MYCOMPANY",szCompany)
    }    
  szCopyright = ASK("Please input your Copyright ");
    if(szCopyright == "#")
    {
        SetReg("MYCOPYRIGHT","2002-2016")
    }
    else
    {
        SetReg("MYCOPYRIGHT",szCopyright)
    }
    */


    
}
//返回左边空格数量
macro GetLeftBlank(szLine)
{
    nIdx = 0
    nEndIdx = strlen(szLine)
    while( nIdx < nEndIdx )
    {
        if( (szLine[nIdx] !=" ") && (szLine[nIdx] !="\t") )
        {
            break;
        }
        nIdx = nIdx + 1
    }
    return nIdx
}

macro ExpandBraceLittle()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    if( (sel.lnFirst == sel.lnLast) 
        && (sel.ichFirst == sel.ichLim) )
    {
        SetBufSelText (hbuf, "(  )")
        SetBufIns (hbuf, sel.lnFirst, sel.ichFirst + 2)    
    }
    else
    {
        SetBufIns (hbuf, sel.lnFirst, sel.ichFirst)    
        SetBufSelText (hbuf, "( ")
        SetBufIns (hbuf, sel.lnLast, sel.ichLim + 2)    
        SetBufSelText (hbuf, " )")
    }
    
}

macro ExpandBraceMid()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    if( (sel.lnFirst == sel.lnLast) 
        && (sel.ichFirst == sel.ichLim) )
    {
        SetBufSelText (hbuf, "[]")
        SetBufIns (hbuf, sel.lnFirst, sel.ichFirst + 1)    
    }
    else
    {
        SetBufIns (hbuf, sel.lnFirst, sel.ichFirst)    
        SetBufSelText (hbuf, "[")
        SetBufIns (hbuf, sel.lnLast, sel.ichLim + 1)    
        SetBufSelText (hbuf, "]")
    }
    
}

macro ExpandBraceLarge()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = sel.lnFirst
    nlineCount = 0
    retVal = ""
    szLine = GetBufLine( hbuf, ln )    
    nLeft = GetLeftBlank(szLine)
    szLeft = strmid(szLine,0,nLeft);
    szRight = ""
    szMid = ""
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        //对于没有块选择的情况，直接插入{}即可
        if( nLeft == strlen(szLine) )
        {
            SetBufSelText (hbuf, "{")
        }
        else
        {    
            ln = ln + 1        
            InsBufLine(hbuf, ln, "@szLeft@{")     
            nlineCount = nlineCount + 1

        }
        InsBufLine(hbuf, ln + 1, "@szLeft@    ")
        InsBufLine(hbuf, ln + 2, "@szLeft@}")
        nlineCount = nlineCount + 2
        SetBufIns (hbuf, ln + 1, strlen(szLeft)+4)
    }
    else
    {
        //对于有块选择的情况还得考虑将块选择区分开了
        
        //检查选择区内是否大括号配对，如果嫌太慢则注释掉下面的判断
        RetVal= CheckBlockBrace(hbuf)
        if(RetVal.iCount != 0)
        {
            msg("Invalidated brace number")
            stop
        }
        
        //取出选中区前的内容
        szOld = strmid(szLine,0,sel.ichFirst)
        if(sel.lnFirst != sel.lnLast)
        {
            //对于多行的情况
            
            //第一行的选中部分
            szMid = strmid(szLine,sel.ichFirst,strlen(szLine))
            szMid = TrimString(szMid)
            szLast = GetBufLine(hbuf,sel.lnLast)
            if( sel.ichLim > strlen(szLast) )
            {
                //如果选择区长度大于改行的长度，最大取该行的长度
                szLineselichLim = strlen(szLast)
            }
            else
            {
                szLineselichLim = sel.ichLim
            }
            
            //得到最后一行选择区为的字符
            szRight = strmid(szLast,szLineselichLim,strlen(szLast))
            szRight = TrimString(szRight)
        }
        else
        {
            //对于选择只有一行的情况
             if(sel.ichLim >= strlen(szLine))
             {
                 sel.ichLim = strlen(szLine)
             }
             
             //获得选中区的内容
             szMid = strmid(szLine,sel.ichFirst,sel.ichLim)
             szMid = TrimString(szMid)            
             if( sel.ichLim > strlen(szLine) )
             {
                 szLineselichLim = strlen(szLine)
             }
             else
             {
                 szLineselichLim = sel.ichLim
             }
             
             //同样得到选中区后的内容
             szRight = strmid(szLine,szLineselichLim,strlen(szLine))
             szRight = TrimString(szRight)
        }
        nIdx = sel.lnFirst
        while( nIdx < sel.lnLast)
        {
            szCurLine = GetBufLine(hbuf,nIdx+1)
            if( sel.ichLim > strlen(szCurLine) )
            {
                szLineselichLim = strlen(szCurLine)
            }
            else
            {
                szLineselichLim = sel.ichLim
            }
            szCurLine = cat("    ",szCurLine)
            if(nIdx == sel.lnLast - 1)
            {
                //对于最后一行应该是选中区内的内容后移四位
                szCurLine = strmid(szCurLine,0,szLineselichLim + 4)
                PutBufLine(hbuf,nIdx+1,szCurLine)                    
            }
            else
            {
                //其它情况是整行的内容后移四位
                PutBufLine(hbuf,nIdx+1,szCurLine)
            }
            nIdx = nIdx + 1
        }
        if(strlen(szRight) != 0)
        {
            //最后插入最后一行没有被选择的内容
            InsBufLine(hbuf, sel.lnLast + 1, "@szLeft@@szRight@")        
        }
        InsBufLine(hbuf, sel.lnLast + 1, "@szLeft@}")        
        nlineCount = nlineCount + 1
        if(nLeft < sel.ichFirst)
        {
            //如果选中区前的内容不是空格，则要保留该部分内容
            PutBufLine(hbuf,ln,szOld)
            InsBufLine(hbuf, ln+1, "@szLeft@{")
            nlineCount = nlineCount + 1
            ln = ln + 1
        }
        else
        {
            //如果选中区前没有内容直接删除该行
            DelBufLine(hbuf,ln)
            InsBufLine(hbuf, ln, "@szLeft@{")
        }
        if(strlen(szMid) > 0)
        {
            //插入第一行选择区的内容
            InsBufLine(hbuf, ln+1, "@szLeft@    @szMid@")
            nlineCount = nlineCount + 1
            ln = ln + 1
        }        
    }
    retVal.szLeft = szLeft
    retVal.nLineCount = nlineCount
    //返回行数和左边的空白
    return retVal
}

/*
macro ScanStatement(szLine,iBeg)
{
    nIdx = 0
    iLen = strlen(szLine)
    while(nIdx < iLen -1)
    {
        if(szLine[nIdx] == "/" && szLine[nIdx + 1] == "/")
        {
            return 0xffffffff
        }
        if(szLine[nIdx] == "/" && szLine[nIdx + 1] == "*")
        {
           while(nIdx < iLen)
           {
               if(szLine[nIdx] == "*" && szLine[nIdx + 1] == "/")
               {
                   break
               }
               nIdx = nIdx + 1
               
           }
        }
        if( (szLine[nIdx] != " ") && (szLine[nIdx] != "\t" ))
        {
            return nIdx
        }
        nIdx = nIdx + 1
    }
    if( (szLine[iLen -1] == " ") || (szLine[iLen -1] == "\t" ))
    {
        return 0xffffffff
    }
    return nIdx
}
*/
/*
macro MoveCommentLeftBlank(szLine)
{
    nIdx  = 0
    iLen = strlen(szLine)
    while(nIdx < iLen - 1)
    { 
        if(szLine[nIdx] == "/" && szLine[nIdx+1] == "*")
        {
            szLine[nIdx] = " "
            szLine[nIdx + 1] = " "
            nIdx = nIdx + 2
            while(nIdx < iLen - 1)
            {
                if(szLine[nIdx] != " " && szLine[nIdx] != "\t")
                {
                    szLine[nIdx - 2] = "/"
                    szLine[nIdx - 1] = "*"
                    return szLine
                }
                nIdx = nIdx + 1
            }
        
        }
        if(szLine[nIdx] == "/" && szLine[nIdx+1] == "/")
        {
            szLine[nIdx] = " "
            szLine[nIdx + 1] = " "
            nIdx = nIdx + 2
            while(nIdx < iLen - 1)
            {
                if(szLine[nIdx] != " " && szLine[nIdx] != "\t")
                {
                    szLine[nIdx - 2] = "/"
                    szLine[nIdx - 1] = "/"
                    return szLine
                }
                nIdx = nIdx + 1
            }
        
        }
        nIdx = nIdx + 1
    }
    return szLine
}
*/
macro DelCompoundStatement()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = sel.lnFirst
    szLine = GetBufLine(hbuf,ln )
    nLeft = GetLeftBlank(szLine)
    szLeft = strmid(szLine,0,nLeft);
    Msg("@szLine@  will be deleted !")
    fIsEnd = 1
    while(1)
    {
        RetVal = SkipCommentFromString(szLine,fIsEnd)
        szTmp = RetVal.szContent
        fIsEnd = RetVal.fIsEnd
        //查找复合语句的开始
        ret = strstr(szTmp,"{")
        if(ret != 0xffffffff)
        {
            szNewLine = strmid(szLine,ret+1,strlen(szLine))
            szNew = strmid(szTmp,ret+1,strlen(szTmp))
            szNew = TrimString(szNew)
            if(szNew != "")
            {
                InsBufLine(hbuf,ln + 1,"@szLeft@    @szNewLine@");
            }
            sel.lnFirst = ln
            sel.lnLast = ln
            sel.ichFirst = ret
            sel.ichLim = ret
            //查找对应的大括号
            
            //使用自己编写的代码速度太慢
            retTmp = SearchCompoundEnd(hbuf,ln,ret)
            if(retTmp.iCount == 0)
            {
                
                DelBufLine(hbuf,retTmp.ln)
                sel.ichFirst = 0
                sel.ichLim = 0
                DelBufLine(hbuf,ln)
                sel.lnLast = retTmp.ln - 1
                SetWndSel(hwnd,sel)
                Indent_Left
            }
            
            //使用Si的大括号配对方法，但V2.1时在注释嵌套时可能有误
/*            SetWndSel(hwnd,sel)
            Block_Down
            selNew = GetWndSel(hwnd)
            if(selNew != sel)
            {
                
                DelBufLine(hbuf,selNew.lnFirst)
                sel.ichFirst = 0
                sel.ichLim = 0
                DelBufLine(hbuf,ln)
                sel.lnLast = selNew.lnFirst - 1
                SetWndSel(hwnd,sel)
                Indent_Left
            }*/
            break
        }
        szTmp = TrimString(szTmp)
        iLen = strlen(szTmp)
        if(iLen != 0)
        {
            if(szTmp[iLen-1] == ";")
            {
                break
            }
        }
        DelBufLine(hbuf,ln)   
        if( ln == GetBufLineCount(hbuf ))
        {
             break
        }
        szLine = GetBufLine(hbuf,ln)
    }
}

macro CheckBlockBrace(hbuf)
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    ln = sel.lnFirst
    nCount = 0
    RetVal = ""
    szLine = GetBufLine( hbuf, ln )    
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        RetVal.iCount = 0
        RetVal.ich = sel.ichFirst
        return RetVal
    }
    if(sel.lnFirst == sel.lnLast && sel.ichFirst != sel.ichLim)
    {
        RetTmp = SkipCommentFromString(szLine,fIsEnd)
        szTmp = RetTmp.szContent
        RetVal = CheckBrace(szTmp,sel.ichFirst,sel.ichLim,"{","}",0,1)
        return RetVal
    }
    if(sel.lnFirst != sel.lnLast)
    {
	    fIsEnd = 1
	    while(ln <= sel.lnLast)
	    {
	        if(ln == sel.lnFirst)
	        {
	            RetVal = CheckBrace(szLine,sel.ichFirst,strlen(szLine)-1,"{","}",nCount,fIsEnd)
	        }
	        else if(ln == sel.lnLast)
	        {
	            RetVal = CheckBrace(szLine,0,sel.ichLim,"{","}",nCount,fIsEnd)
	        }
	        else
	        {
	            RetVal = CheckBrace(szLine,0,strlen(szLine)-1,"{","}",nCount,fIsEnd)
	        }
	        fIsEnd = RetVal.fIsEnd
	        ln = ln + 1
	        nCount = RetVal.iCount
	        szLine = GetBufLine( hbuf, ln )    
	    }
    }
    return RetVal
}

macro SearchCompoundEnd(hbuf,ln,ichBeg)
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    ln = sel.lnFirst
    nCount = 0
    SearchVal = ""
//    szLine = GetBufLine( hbuf, ln )
    lnMax = GetBufLineCount(hbuf)
    fIsEnd = 1
    while(ln < lnMax)
    {
        szLine = GetBufLine( hbuf, ln )
        RetVal = CheckBrace(szLine,ichBeg,strlen(szLine)-1,"{","}",nCount,fIsEnd)
        fIsEnd = RetVal.fIsEnd
        ichBeg = 0
        nCount = RetVal.iCount
        
        //如果nCount=0则说明{}是配对的
        if(nCount == 0)
        {
            break
        }
        ln = ln + 1
//        szLine = GetBufLine( hbuf, ln )    
    }
    SearchVal.iCount = RetVal.iCount
    SearchVal.ich = RetVal.ich
    SearchVal.ln = ln
    return SearchVal
}

macro CheckBrace(szLine,ichBeg,ichEnd,chBeg,chEnd,nCheckCount,isCommentEnd)
{
    retVal = ""
    retVal.ich = 0
    nIdx = ichBeg
    nLen = strlen(szLine)
    if(ichEnd >= nLen)
    {
        ichEnd = nLen - 1
    }
    fIsEnd = 1
    while(nIdx <= ichEnd)
    {
        //如果是/*注释区，跳过该段
        if( (isCommentEnd == 0) || (szLine[nIdx] == "/" && szLine[nIdx+1] == "*"))
        {
            fIsEnd = 0
            while(nIdx <= ichEnd )
            {
                if(szLine[nIdx] == "*" && szLine[nIdx+1] == "/")
                {
                    nIdx = nIdx + 1 
                    fIsEnd  = 1
                    isCommentEnd = 1
                    break
                }
                nIdx = nIdx + 1 
            }
            if(nIdx > ichEnd)
            {
                break
            }
        }
        //如果是//注释则停止查找
        if(szLine[nIdx] == "/" && szLine[nIdx+1] == "/")
        {
            break
        }
        if(szLine[nIdx] == chBeg)
        {
            nCheckCount = nCheckCount + 1
        }
        if(szLine[nIdx] == chEnd)
        {
            nCheckCount = nCheckCount - 1
            if(nCheckCount == 0)
            {
                retVal.ich = nIdx
            }
        }
        nIdx = nIdx + 1
    }
    retVal.iCount = nCheckCount
    retVal.fIsEnd = fIsEnd
    return retVal
}

macro InsertElse()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = sel.lnFirst
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        szLeft = CreateBlankString(sel.ichFirst)
        InsBufLine(hbuf, ln,szLeft)
        SetWndSel(hwnd,sel)
    }
    val = ExpandBraceLarge()
    szLeft = val.szLeft
    InsBufLine(hbuf, ln, "@szLeft@else")    
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        PutBufLine(hbuf,ln+2, "@szLeft@    ")
        SetBufIns (hbuf, ln+2, strlen(szLeft)+4)
        return
    }
    SetBufIns (hbuf, ln, strlen(szLeft)+7)
}

macro InsertCase()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = sel.lnFirst
    szLine = GetBufLine( hbuf, ln )    
    nLeft = GetLeftBlank(szLine)
    szLeft = strmid(szLine,0,nLeft);
    InsBufLine(hbuf, ln, "@szLeft@" # "case # :")
    InsBufLine(hbuf, ln + 1, "@szLeft@" # "    " # "#")
    InsBufLine(hbuf, ln + 2, "@szLeft@" # "    " # "break;")
    SearchForward()    
}

macro InsertSwitch()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = sel.lnFirst
    szLine = GetBufLine( hbuf, ln )    
    nLeft = GetLeftBlank(szLine)
    szLeft = strmid(szLine,0,nLeft);
    InsBufLine(hbuf, ln, "@szLeft@switch ( # )")    
    InsBufLine(hbuf, ln + 1, "@szLeft@" # "{")
    nSwitch = ask("请输入case的个数")
    InsertMultiCaseProc(hbuf,szLeft,nSwitch)
    SearchForward()    
}

macro InsertMultiCaseProc(hbuf,szLeft,nSwitch)
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    ln = sel.lnFirst

    nIdx = 0
    if(nSwitch == 0)
    {
        hNewBuf = newbuf("clip")
        if(hNewBuf == hNil)
            return       
        SetCurrentBuf(hNewBuf)
        PasteBufLine (hNewBuf, 0)
        nLeftMax = 0
        lnMax = GetBufLineCount(hNewBuf )
        i = 0
        fIsEnd = 1
        while ( i < lnMax) 
        {
            szLine = GetBufLine(hNewBuf , i)
            //先去掉代码中注释的内容
            RetVal = SkipCommentFromString(szLine,fIsEnd)
            szLine = RetVal.szContent
            fIsEnd = RetVal.fIsEnd
//            nLeft = GetLeftBlank(szLine)
            //从剪贴板中取得case值
            szLine = GetSwitchVar(szLine)
            if(strlen(szLine) != 0 )
            {
                ln = ln + 3
                InsBufLine(hbuf, ln - 1, "@szLeft@    " # "case @szLine@:")
                InsBufLine(hbuf, ln    , "@szLeft@    " # "    " # "#")
                InsBufLine(hbuf, ln + 1, "@szLeft@    " # "    " # "break;")
              }
              i = i + 1
        }
        closebuf(hNewBuf)
       }
       else
       {
        while(nIdx < nSwitch)
        {
            ln = ln + 3
            InsBufLine(hbuf, ln - 1, "@szLeft@    " # "case # :")
            InsBufLine(hbuf, ln    , "@szLeft@    " # "    " # "#")
            InsBufLine(hbuf, ln + 1, "@szLeft@    " # "    " # "break;")
            nIdx = nIdx + 1
        }
      }
    InsBufLine(hbuf, ln + 2, "@szLeft@    " # "default:")
    InsBufLine(hbuf, ln + 3, "@szLeft@    " # "    " # "#")
    InsBufLine(hbuf, ln + 4, "@szLeft@" # "}")
    SetWndSel(hwnd, sel)
    SearchForward()
}
//chenyang,返回变量名
macro GetSwitchVar(szLine)
{
    if( (szLine == "{") || (szLine == "}") )
    {
        return ""
    }
    //CY 返回匹配完成的字符开始位置，两个相同字符串 则返回0
    ret = strstr(szLine,"#define" )
    if(ret != 0xffffffff)
    {
        szLine = strmid(szLine,ret + 8,strlen(szLine))
    }
    szLine = TrimLeft(szLine)
    nIdx = 0
    nLen = strlen(szLine)
    while( nIdx < nLen)
    {
        if((szLine[nIdx] == " ") || (szLine[nIdx] == ",") || (szLine[nIdx] == "="))
        {
            szLine = strmid(szLine,0,nIdx)
            return szLine
        }
        nIdx = nIdx + 1
    }
    return szLine
}

/*
macro SkipControlCharFromString(szLine)
{
   nLen = strlen(szLine)
   nIdx = 0
   newStr = ""
   while(nIdx < nLen - 1)
   {
       if(szLine[nIdx] == "\t")
       {
           newStr = cat(newStr,"    ")
       }
       else if(szLine[nIdx] < " ")
       {
           newStr = cat(newStr," ")           
       }
       else
       {
           newStr = cat(newStr," ")                      
       }
   }
}
*/
macro SkipCommentFromString(szLine,isCommentEnd)
{
    RetVal = ""
    fIsEnd = 1
    nLen = strlen(szLine)
    nIdx = 0
    while(nIdx < nLen )
    {
        //如果当前行开始还是被注释，或遇到了注释开始的变标记，注释内容改为空格?        
        if( (isCommentEnd == 0) || (szLine[nIdx] == "/" && szLine[nIdx+1] == "*"))
        {
            fIsEnd = 0
            while(nIdx < nLen )
            {
                if(szLine[nIdx] == "*" && szLine[nIdx+1] == "/")
                {
                    szLine[nIdx+1] = " "
                    szLine[nIdx] = " " 
                    nIdx = nIdx + 1 
                    fIsEnd  = 1
                    isCommentEnd = 1
                    break
                }
                szLine[nIdx] = " "
                
                //如果是倒数第二个则最后一个也肯定是在注释内
//                if(nIdx == nLen -2 )
//                {
//                    szLine[nIdx + 1] = " "
//                }
                nIdx = nIdx + 1 
            }    
            
            //如果已经到了行尾终止搜索
            if(nIdx == nLen)
            {
                break
            }
        }
        
        //如果遇到的是//来注释的说明后面都为注释
        if(szLine[nIdx] == "/" && szLine[nIdx+1] == "/")
        {
            szLine = strmid(szLine,0,nIdx)
            break
        }
        nIdx = nIdx + 1                
    }
    RetVal.szContent = szLine;
    RetVal.fIsEnd = fIsEnd
    return RetVal
}

macro InsertDo()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = sel.lnFirst
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        szLeft = CreateBlankString(sel.ichFirst)
        InsBufLine(hbuf, ln,szLeft)
        SetWndSel(hwnd,sel)
    }
    val = ExpandBraceLarge()
    szLeft = val.szLeft
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        PutBufLine(hbuf,ln+1, "@szLeft@    #")
    }
    PutBufLine(hbuf, sel.lnLast + val.nLineCount, "@szLeft@}while ( # );")    
//       SetBufIns (hbuf, sel.lnLast + val.nLineCount, strlen(szLeft)+8)
    InsBufLine(hbuf, ln, "@szLeft@do")    
    SearchForward()
}

macro InsertWhile()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = sel.lnFirst
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        szLeft = CreateBlankString(sel.ichFirst)
        InsBufLine(hbuf, ln,szLeft)
        SetWndSel(hwnd,sel)
    }
    val = ExpandBraceLarge()
    szLeft = val.szLeft
    InsBufLine(hbuf, ln, "@szLeft@while ( # )")    
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        PutBufLine(hbuf,ln+2, "@szLeft@    #")
    }
    SetBufIns (hbuf, ln, strlen(szLeft)+7)
    SearchForward()
}

macro InsertFor()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = sel.lnFirst
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        szLeft = CreateBlankString(sel.ichFirst)
        InsBufLine(hbuf, ln,szLeft)
        SetWndSel(hwnd,sel)
    }
    val = ExpandBraceLarge()
    szLeft = val.szLeft
    InsBufLine(hbuf, ln,"@szLeft@for ( # ; # ; # )")
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        PutBufLine(hbuf,ln+2, "@szLeft@    #")
    }
    sel.lnFirst = ln
    sel.lnLast = ln 
    sel.ichFirst = 0
    sel.ichLim = 0
    SetWndSel(hwnd, sel)
    SearchForward()
    szVar = ask("请输入循环变量")
    PutBufLine(hbuf,ln, "@szLeft@for ( @szVar@ = # ; @szVar@ # ; @szVar@++ )")
    SearchForward()
}

macro InsertIf()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    ln = sel.lnFirst
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        szLeft = CreateBlankString(sel.ichFirst)
        InsBufLine(hbuf, ln,szLeft)
        SetWndSel(hwnd,sel)
    }
    val = ExpandBraceLarge()
    szLeft = val.szLeft
    InsBufLine(hbuf, ln, "@szLeft@if ( # )")    
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        PutBufLine(hbuf,ln+2, "@szLeft@    #")
    }
//       SetBufIns (hbuf, ln, strlen(szLeft)+4)
    SearchForward()
}
macro CY_test321()
{
temp=MergeString()
msg(temp)
}



macro MergeString()
{
    hbuf = newbuf("clip")
    if(hbuf == hNil)
        return       
    SetCurrentBuf(hbuf)
    PasteBufLine (hbuf, 0)
    
    //如果剪贴板中没有内容，则返回
    lnMax = GetBufLineCount(hbuf )
    if( lnMax == 0 )
    {
        closebuf(hbuf)
        return ""
    }
    lnLast =  0
    if(lnMax > 1)
    {
        lnLast = lnMax - 1
         i = lnMax - 1
    }
    while ( i > 0) 
    {
        szLine = GetBufLine(hbuf , i-1)
        szLine = TrimLeft(szLine)
        nLen = strlen(szLine)
        if(szLine[nLen - 1] == "-")
        {
              szLine = strmid(szLine,0,nLen - 1)
        }
        nLen = strlen(szLine)
        if( (szLine[nLen - 1] != " ") && (AsciiFromChar (szLine[nLen - 1])  <= 160))
        {
              szLine = cat(szLine," ") 
        }
        SetBufIns (hbuf, lnLast, 0)
        SetBufSelText(hbuf,szLine)
        i = i - 1
    }
    szLine = GetBufLine(hbuf,lnLast)
    closebuf(hbuf)
    return szLine
}

macro ClearPrombleNo()
{
   SetReg ("PNO", "")
}

macro AddPromblemNo()
{
    szQuestion = ASK("Please Input problem number ");
    if(szQuestion == "#")
    {
       szQuestion = " "
       SetReg ("PNO", "")
    }
    else
    {
       SetReg (PNO, szQuestion)
    }

    return szQuestion
}

/*
this macro convet selected  C++ coment block to C comment block 
for example:
  line "  // aaaaa "
  convert to  /* aaaaa */
*/
/*  ComentCPPtoC()
{
    hwnd = GetCurrentWnd()
    lnFirst = GetWndSelLnFirst( hwnd )
    lnLast = GetWndSelLnLast( hwnd )

    lnCurrent = lnFirst
    fIsEnd = 1
    while ( lnCurrent <= lnLast )
    {
        fIsEnd = CmtCvtLine( lnCurrent,fIsEnd )
        lnCurrent = lnCurrent + 1;
    }
}*/

macro ComentCPPtoC()
{
    hwnd = GetCurrentWnd()
    hbuf = GetCurrentBuf()
    lnFirst = GetWndSelLnFirst( hwnd )
    lnCurrent = lnFirst
    lnLast = GetWndSelLnLast( hwnd )
    ch_comment = CharFromAscii(47)   
    isCommentEnd = 1
    isCommentContinue = 0
    while ( lnCurrent <= lnLast )
    {

        ich = 0
        szLine = GetBufLine(hbuf,lnCurrent)
        ilen = strlen(szLine)
        while ( ich < ilen )
        {
            if( (szLine[ich] != " ") && (szLine[ich] != "\t") )
            {
                break
            }
            ich = ich + 1
        }
        /*如果是空行，跳过该行*/
        if(ich == ilen)
        {         
            lnCurrent = lnCurrent + 1
            szOldLine = szLine
            continue 
        }
        
        /*如果该行只有一个字符*/
        if(ich > ilen - 2)
        {
            if( isCommentContinue == 1 )
            {
                szOldLine = cat(szOldLine,"  */")
                PutBufLine(hbuf,lnCurrent-1,szOldLine)
                isCommentContinue = 0
            }
            lnCurrent = lnCurrent + 1
            szOldLine = szLine
            continue 
        }       
        if( isCommentEnd == 1 )
        {
            /*如果不是在注释区内*/
            if(( szLine[ich]==ch_comment ) && (szLine[ich+1]==ch_comment))
            {
                
                /* 去掉中间嵌套的注释 */
                nIdx = ich + 2
                while ( nIdx < ilen -1 )
                {
                    if( (( szLine[nIdx] == "/" ) && (szLine[nIdx+1] == "*")||
                         ( szLine[nIdx] == "*" ) && (szLine[nIdx+1] == "/") )
                    {
                        szLine[nIdx] = " "
                        szLine[nIdx+1] = " "
                    }
                    nIdx = nIdx + 1
                }
                
                if( isCommentContinue == 1 )
                {
                    /* 如果是连续的注释*/
                    szLine[ich] = " "
                    szLine[ich+1] = " "
                }
                else
                {
                    /*如果不是连续的注释则是新注释的开始*/
                    szLine[ich] = "/"
                    szLine[ich+1] = "*"
                }
                if ( lnCurrent == lnLast )
                {
                    /*如果是最后一行则在行尾添加结束注释符*/
                    szLine = cat(szLine,"  */")
                    isCommentContinue = 0
                }
                /*更新该行*/
                PutBufLine(hbuf,lnCurrent,szLine)
                isCommentContinue = 1
                szOldLine = szLine
                lnCurrent = lnCurrent + 1
                continue 
            }
            else
            {   
                /*如果该行的起始不是//注释*/
                if( isCommentContinue == 1 )
                {
                    szOldLine = cat(szOldLine,"  */")
                    PutBufLine(hbuf,lnCurrent-1,szOldLine)
                    isCommentContinue = 0
                }
            }        
        }
        while ( ich < ilen - 1 )
        {
            //如果是/*注释区，跳过该段
            if( (isCommentEnd == 0) || (szLine[ich] == "/" && szLine[ich+1] == "*"))
            {
                isCommentEnd = 0
                while(ich < ilen - 1 )
                {
                    if(szLine[ich] == "*" && szLine[ich+1] == "/")
                    {
                        ich = ich + 1 
                        isCommentEnd = 1
                        break
                    }
                    ich = ich + 1 
                }
                if(ich >= ilen - 1)
                {
                    break
                }
            }
            
            if(( szLine[ich]==ch_comment ) && (szLine[ich+1]==ch_comment))
            {
                /* 如果是//注释*/
                isCommentContinue = 1
                nIdx = ich
                //去掉期间的/* 和 */注释符以免出现注释嵌套错误
                while ( nIdx < ilen -1 )
                {
                    if( (( szLine[nIdx] == "/" ) && (szLine[nIdx+1] == "*")||
                         ( szLine[nIdx] == "*" ) && (szLine[nIdx+1] == "/") )
                    {
                        szLine[nIdx] = " "
                        szLine[nIdx+1] = " "
                    }
                    nIdx = nIdx + 1
                }
                szLine[ich+1] = "*"
                if( lnCurrent == lnLast )
                {
                    szLine = cat(szLine,"  */")
                }
                PutBufLine(hbuf,lnCurrent,szLine)
                break
            }
            ich = ich + 1
        }
        szOldLine = szLine
        lnCurrent = lnCurrent + 1
    }
}


macro ComentLine()
{
    hwnd = GetCurrentWnd()
    hbuf = GetCurrentBuf()
    lnFirst = GetWndSelLnFirst( hwnd )
    lnCurrent = lnFirst
    lnLast = GetWndSelLnLast( hwnd )
    lnOld = 0
    while ( lnCurrent <= lnLast )
    {
        szLine = GetBufLine(hbuf,lnCurrent)
        DelBufLine(hbuf,lnCurrent)
        nLeft = GetLeftBlank(szLine)
        szLeft = strmid(szLine,0,nLeft);
        szLine = TrimString(szLine)
        ilen = strlen(szLine)
        if(iLen == 0)
        {
            continue
        }
        nIdx = 0
        //去掉期间的/* 和 */注释符以免出现注释嵌套错误
        while ( nIdx < ilen -1 )
        {
            if( (( szLine[nIdx] == "/" ) && (szLine[nIdx+1] == "*")||
                 ( szLine[nIdx] == "*" ) && (szLine[nIdx+1] == "/") )
            {
                szLine[nIdx] = " "
                szLine[nIdx+1] = " "
            }
            nIdx = nIdx + 1
        }
        szLine = cat("/* ",szLine)
        lnOld = lnCurrent
        lnCurrent = CommentContent(hbuf,lnCurrent,szLeft,szLine,1)
        lnLast = lnCurrent - lnOld + lnLast
        lnCurrent = lnCurrent + 1
    }
}

macro CmtCvtLine(lnCurrent, isCommentEnd)
{
    hbuf = GetCurrentBuf()
    szLine = GetBufLine(hbuf,lnCurrent)
    ch_comment = CharFromAscii(47)   
    ich = 0
    ilen = strlen(szLine)
    
    fIsEnd = 1
    iIsComment = 0;
    
    while ( ich < ilen - 1 )
    {
        //如果是/*注释区，跳过该段
        if( (isCommentEnd == 0) || (szLine[ich] == "/" && szLine[ich+1] == "*"))
        {
            fIsEnd = 0
            while(ich < ilen - 1 )
            {
                if(szLine[ich] == "*" && szLine[ich+1] == "/")
                {
                    ich = ich + 1 
                    fIsEnd  = 1
                    isCommentEnd = 1
                    break
                }
                ich = ich + 1 
            }
            if(ich >= ilen - 1)
            {
                break
            }
        }
        if(( szLine[ich]==ch_comment ) && (szLine[ich+1]==ch_comment))
        {
            nIdx = ich
            while ( nIdx < ilen -1 )
            {
                if( (( szLine[nIdx] == "/" ) && (szLine[nIdx+1] == "*")||
                     ( szLine[nIdx] == "*" ) && (szLine[nIdx+1] == "/") )
                {
                    szLine[nIdx] = " "
                    szLine[nIdx+1] = " "
                }
                nIdx = nIdx + 1
            }
            szLine[ich+1] = "*"
            szLine = cat(szLine,"  */")
            DelBufLine(hbuf,lnCurrent)
            InsBufLine(hbuf,lnCurrent,szLine)
            return fIsEnd
        }
        ich = ich + 1
    }
    return fIsEnd
}

macro GetFileNameExt(sz)
{
    i = 1
    j = 0
    szName = sz
    iLen = strlen(sz)
    if(iLen == 0)
      return ""
    while( i <= iLen)
    {
      if(sz[iLen-i] == ".")
      {
         j = iLen-i 
         szExt = strmid(sz,j + 1,iLen)
         return szExt
      }
      i = i + 1
    }
    return ""
}

macro GetFileNameNoExt(sz)
{
    i = 1
    szName = sz
    iLen = strlen(sz)
    j = iLen 
    if(iLen == 0)
      return ""
    while( i <= iLen)
    {
      if(sz[iLen-i] == ".")
      {
         j = iLen-i 
      }
      if( sz[iLen-i] == "\\" )
      {
         szName = strmid(sz,iLen-i+1,j)
         return szName
      }
      i = i + 1
    }
    szName = strmid(sz,0,j)
    return szName
}

macro GetFileName(sz)
{
    i = 1
    szName = sz
    iLen = strlen(sz)
    if(iLen == 0)
      return ""
    while( i <= iLen)
    {
      if(sz[iLen-i] == "\\")
      {
        szName = strmid(sz,iLen-i+1,iLen)
        break
      }
      i = i + 1
    }
    return szName
}

macro InsIfdef()
{
    sz = Ask("Enter #ifdef condition:")
    if (sz != "")
        IfdefStr(sz);
}

macro InsIfndef()
{
    sz = Ask("Enter #ifndef condition:")
    if (sz != "")
        IfndefStr(sz);
}

macro InsertCPP(hbuf,ln)
{
    InsBufLine(hbuf, ln, "")
    InsBufLine(hbuf, ln, "#endif /* __cplusplus */")
    InsBufLine(hbuf, ln, "#endif")
    InsBufLine(hbuf, ln, "extern \"C\"{")
    InsBufLine(hbuf, ln, "#if __cplusplus")
    InsBufLine(hbuf, ln, "#ifdef __cplusplus")
    InsBufLine(hbuf, ln, "")
    
    iTotalLn = GetBufLineCount (hbuf)            
    InsBufLine(hbuf, iTotalLn, "")
    InsBufLine(hbuf, iTotalLn, "#endif /* __cplusplus */")
    InsBufLine(hbuf, iTotalLn, "#endif")
    InsBufLine(hbuf, iTotalLn, "}")
    InsBufLine(hbuf, iTotalLn, "#if __cplusplus")
    InsBufLine(hbuf, iTotalLn, "#ifdef __cplusplus")
    InsBufLine(hbuf, iTotalLn, "")
}

macro ReviseCommentProc(hbuf,ln,szCmd,szMyName,szLine1)
{
    if (szCmd == "ap")
    {   
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day
        
        DelBufLine(hbuf, ln)
        szQuestion = AddPromblemNo()
        InsBufLine(hbuf, ln, "@szLine1@/* 问 题 单: @szQuestion@     修改人:@szMyName@,   时间:@sz@/@sz1@/@sz3@ ");
        szContent = Ask("修改原因")
        szLeft = cat(szLine1,"   修改原因: ");
        if(strlen(szLeft) > 70)
        {
            Msg("The right margine is small, Please use a new line")
            stop 
        }
        ln = CommentContent(hbuf,ln + 1,szLeft,szContent,1)
        return
    }
    else if (szCmd == "ab")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day
        
        DelBufLine(hbuf, ln)
        szQuestion = GetReg ("PNO")
        if(strlen(szQuestion)>0)
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Added by @szMyName@, @sz@/@sz1@/@sz3@   问题单号:@szQuestion@*/");
        }
        else
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Added by @szMyName@, @sz@/@sz1@/@sz3@ */");        
        }
        return
    }
    else if (szCmd == "ae")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln)
        InsBufLine(hbuf, ln, "@szLine1@/* END:   Added by @szMyName@, @sz@/@sz1@/@sz3@ */");
        return
    }
    else if (szCmd == "db")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln)
        szQuestion = GetReg ("PNO")
        if(strlen(szQuestion) > 0)
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Deleted by @szMyName@, @sz@/@sz1@/@sz3@   问题单号:@szQuestion@*/");
        }
        else
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Deleted by @szMyName@, @sz@/@sz1@/@sz3@ */");
        }
        
        return
    }
    else if (szCmd == "de")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln + 0)
        InsBufLine(hbuf, ln, "@szLine1@/* END: Deleted by @szMyName@, @sz@/@sz1@/@sz3@ */");
        return
    }
    else if (szCmd == "mb")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln)
        szQuestion = GetReg ("PNO")
            if(strlen(szQuestion) > 0)
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Modified by @szMyName@, @sz@/@sz1@/@sz3@   问题单号:@szQuestion@*/");
        }
        else
        {
            InsBufLine(hbuf, ln, "@szLine1@/* BEGIN: Modified by @szMyName@, @sz@/@sz1@/@sz3@ */");
        }
        return
    }
    else if (szCmd == "me")
    {
        SysTime = GetSysTime(1)
        sz=SysTime.Year
        sz1=SysTime.month
        sz3=SysTime.day

        DelBufLine(hbuf, ln)
        InsBufLine(hbuf, ln, "@szLine1@/* END:   Modified by @szMyName@, @sz@/@sz1@/@sz3@ */");
        return
    }
}
macro InsertReviseAdd()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    lnMax = GetBufLineCount(hbuf)
    language = getreg(LANGUAGE)
    if(language != 1)
    {
        language = 0
    }
    szMyName = getreg(MYNAME)
    if(strlen( szMyName ) == 0)
    {
        szMyName = Ask("Enter your name:")
        setreg(MYNAME, szMyName)
    }
    SysTime = GetSysTime(1)
    sz=SysTime.Year
    sz1=SysTime.month
    sz3=SysTime.day
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        szLeft = CreateBlankString(sel.ichFirst)
    }
    else
    {
        szLine = GetBufLine( hbuf, sel.lnFirst )    
        nLeft = GetLeftBlank(szLine)
        szLeft = strmid(szLine,0,nLeft);
    }
    szQuestion = GetReg ("PNO")
    if(strlen(szQuestion)>0)
    {
        InsBufLine(hbuf, sel.lnFirst, "@szLeft@/* BEGIN: Added by @szMyName@, @sz@/@sz1@/@sz3@   PN:@szQuestion@ */");
    }
    else
    {
        InsBufLine(hbuf, sel.lnFirst, "@szLeft@/* BEGIN: Added by @szMyName@, @sz@/@sz1@/@sz3@ */");        
    }

    if(sel.lnLast < lnMax - 1)
    {
        InsBufLine(hbuf, sel.lnLast + 2, "@szLeft@/* END:   Added by @szMyName@, @sz@/@sz1@/@sz3@   PN:@szQuestion@ */");            
    }
    else
    {
        AppendBufLine(hbuf, "@szLeft@/* END:   Added by @szMyName@, @sz@/@sz1@/@sz3@ */");                        
    }
    SetBufIns(hbuf,sel.lnFirst + 1,strlen(szLeft))
}

macro InsertReviseDel()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    lnMax = GetBufLineCount(hbuf)
    language = getreg(LANGUAGE)
    if(language != 1)
    {
        language = 0
    }
    szMyName = getreg(MYNAME)
    if(strlen( szMyName ) == 0)
    {
        szMyName = Ask("Enter your name:")
        setreg(MYNAME, szMyName)
    }
    SysTime = GetSysTime(1)
    sz=SysTime.Year
    sz1=SysTime.month
    sz3=SysTime.day
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        szLeft = CreateBlankString(sel.ichFirst)
    }
    else
    {
        szLine = GetBufLine( hbuf, sel.lnFirst )    
        nLeft = GetLeftBlank(szLine)
        szLeft = strmid(szLine,0,nLeft);
    }
    szQuestion = GetReg ("PNO")
    if(strlen(szQuestion)>0)
    {
        InsBufLine(hbuf, sel.lnFirst, "@szLeft@/* BEGIN: Deleted by @szMyName@, @sz@/@sz1@/@sz3@   PN:@szQuestion@ */");
    }
    else
    {
        InsBufLine(hbuf, sel.lnFirst, "@szLeft@/* BEGIN: Deleted by @szMyName@, @sz@/@sz1@/@sz3@ */");        
    }

    if(sel.lnLast < lnMax - 1)
    {
        InsBufLine(hbuf, sel.lnLast + 2, "@szLeft@/* END:   Deleted by @szMyName@, @sz@/@sz1@/@sz3@   PN:@szQuestion@ */");            
    }
    else
    {
        AppendBufLine(hbuf, "@szLeft@/* END:   Deleted by @szMyName@, @sz@/@sz1@/@sz3@ */");                        
    }
    SetBufIns(hbuf,sel.lnFirst + 1,strlen(szLeft))
}

macro InsertReviseMod()
{
    hwnd = GetCurrentWnd()
    sel = GetWndSel(hwnd)
    hbuf = GetCurrentBuf()
    lnMax = GetBufLineCount(hbuf)
    language = getreg(LANGUAGE)
    if(language != 1)
    {
        language = 0
    }
    szMyName = getreg(MYNAME)
    if(strlen( szMyName ) == 0)
    {
        szMyName = Ask("Enter your name:")
        setreg(MYNAME, szMyName)
    }
    SysTime = GetSysTime(1)
    sz=SysTime.Year
    sz1=SysTime.month
    sz3=SysTime.day
    if(sel.lnFirst == sel.lnLast && sel.ichFirst == sel.ichLim)
    {
        szLeft = CreateBlankString(sel.ichFirst)
    }
    else
    {
        szLine = GetBufLine( hbuf, sel.lnFirst )    
        nLeft = GetLeftBlank(szLine)
        szLeft = strmid(szLine,0,nLeft);
    }
    szQuestion = GetReg ("PNO")
    if(strlen(szQuestion)>0)
    {
        InsBufLine(hbuf, sel.lnFirst, "@szLeft@/* BEGIN: Modified by @szMyName@, @sz@/@sz1@/@sz3@   PN:@szQuestion@ */");
    }
    else
    {
        InsBufLine(hbuf, sel.lnFirst, "@szLeft@/* BEGIN: Modified by @szMyName@, @sz@/@sz1@/@sz3@ */");        
    }

    if(sel.lnLast < lnMax - 1)
    {
        InsBufLine(hbuf, sel.lnLast + 2, "@szLeft@/* END:   Modified by @szMyName@, @sz@/@sz1@/@sz3@   PN:@szQuestion@ */");            
    }
    else
    {
        AppendBufLine(hbuf, "@szLeft@/* END:   Modified by @szMyName@, @sz@/@sz1@/@sz3@ */");                        
    }
    SetBufIns(hbuf,sel.lnFirst + 1,strlen(szLeft))
}

// Wrap ifdef <sz> .. endif around the current selection
macro IfdefStr(sz)
{
    hwnd = GetCurrentWnd()
    lnFirst = GetWndSelLnFirst(hwnd)
    lnLast = GetWndSelLnLast(hwnd)
    hbuf = GetCurrentBuf()
    lnMax = GetBufLineCount(hbuf)
    if(lnMax != 0)
    {
        szLine = GetBufLine( hbuf, lnFirst )    
    }
    nLeft = GetLeftBlank(szLine)
    szLeft = strmid(szLine,0,nLeft);
     
    hbuf = GetCurrentBuf()
    if(lnLast + 1 < lnMax)
    {
        InsBufLine(hbuf, lnLast+1, "@szLeft@#endif /* @sz@ */")
    }
    else if(lnLast + 1 == lnMax)
    {
        AppendBufLine(hbuf, "@szLeft@#endif /* @sz@ */")
    }
    else 
    {
        AppendBufLine(hbuf, "")
        AppendBufLine(hbuf, "@szLeft@#endif /* @sz@ */")
    }    
    InsBufLine(hbuf, lnFirst, "@szLeft@#ifdef @sz@")
    SetBufIns(hbuf,lnFirst + 1,strlen(szLeft))
}
macro IfndefStr(sz)
{
    hwnd = GetCurrentWnd()
    lnFirst = GetWndSelLnFirst(hwnd)
    lnLast = GetWndSelLnLast(hwnd)
    hbuf = GetCurrentBuf()
    lnMax = GetBufLineCount(hbuf)
    if(lnMax != 0)
    {
        szLine = GetBufLine( hbuf, lnFirst )    
    }
    nLeft = GetLeftBlank(szLine)
    szLeft = strmid(szLine,0,nLeft);
     
    hbuf = GetCurrentBuf()
    if(lnLast + 1 < lnMax)
    {
        InsBufLine(hbuf, lnLast+1, "@szLeft@#endif /* @sz@ */")
    }
    else if(lnLast + 1 == lnMax)
    {
        AppendBufLine(hbuf, "@szLeft@#endif /* @sz@ */")
    }
    else 
    {
        AppendBufLine(hbuf, "")
        AppendBufLine(hbuf, "@szLeft@#endif /* @sz@ */")
    }    
    InsBufLine(hbuf, lnFirst, "@szLeft@#ifndef @sz@")
    SetBufIns(hbuf,lnFirst + 1,strlen(szLeft))
}


macro InsertPredefIf()
{
    sz = Ask("Enter #if condition:")
    PredefIfStr(sz)
}

macro PredefIfStr(sz)
{
    hwnd = GetCurrentWnd()
    lnFirst = GetWndSelLnFirst(hwnd)
    lnLast = GetWndSelLnLast(hwnd)
    hbuf = GetCurrentBuf()
    lnMax = GetBufLineCount(hbuf)
    if(lnMax != 0)
    {
        szLine = GetBufLine( hbuf, lnFirst )    
    }
    nLeft = GetLeftBlank(szLine)
    szLeft = strmid(szLine,0,nLeft);
     
    hbuf = GetCurrentBuf()
    if(lnLast + 1 < lnMax)
    {
        InsBufLine(hbuf, lnLast+1, "@szLeft@#endif /* #if @sz@ */")
    }
    else if(lnLast + 1 == lnMax)
    {
        AppendBufLine(hbuf, "@szLeft@#endif /* #if @sz@ */")
    }
    else 
    {
        AppendBufLine(hbuf, "")
        AppendBufLine(hbuf, "@szLeft@#endif /* #if @sz@ */")
    }    
    InsBufLine(hbuf, lnFirst, "@szLeft@#if  @sz@")
    SetBufIns(hbuf,lnFirst + 1,strlen(szLeft))
}

macro HeadIfdefStr(sz)
{
    hwnd = GetCurrentWnd()
    lnFirst = GetWndSelLnFirst(hwnd)
    hbuf = GetCurrentBuf()
    InsBufLine(hbuf, lnFirst, "")
    InsBufLine(hbuf, lnFirst, "#define @sz@")
    InsBufLine(hbuf, lnFirst, "#ifndef @sz@")
    iTotalLn = GetBufLineCount (hbuf)                
    InsBufLine(hbuf, iTotalLn, "#endif /* @sz@ */")
    InsBufLine(hbuf, iTotalLn, "")
}

macro GetSysTime(a)
{
    //从sidate取得时间
    RunCmd ("sidate")
    SysTime=""
    SysTime.Year=getreg(Year)
    if(strlen(SysTime.Year)==0)
    {
        setreg(Year,"2002")
        setreg(Month,"05")
        setreg(Day,"02")
        SysTime.Year="2002"
        SysTime.month="05"
        SysTime.day="20"
        SysTime.Date="2002年05月20日"
    }
    else
    {
        SysTime.Month=getreg(Month)
        SysTime.Day=getreg(Day)
        SysTime.Date=getreg(Date)
   /*         SysTime.Date=cat(SysTime.Year,"年")
        SysTime.Date=cat(SysTime.Date,SysTime.Month)
        SysTime.Date=cat(SysTime.Date,"月")
        SysTime.Date=cat(SysTime.Date,SysTime.Day)
        SysTime.Date=cat(SysTime.Date,"日")*/
    }
    return SysTime
}

macro HeaderFileCreate()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    hbuf = GetWndBuf(hwnd)
    language = getreg(LANGUAGE)
    if(language != 1)
    {
        language = 0
    }
    szMyName = getreg(MYNAME)
    if(strlen( szMyName ) == 0)
    {
        szMyName = Ask("Enter your name:")
        setreg(MYNAME, szMyName)
    }

   CreateFunctionDef(hbuf,szMyName,language)
}

macro FunctionHeaderCreate()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    sel = GetWndSel(hwnd)
    ln = sel.lnFirst
    hbuf = GetWndBuf(hwnd)
    language = getreg(LANGUAGE)
    if(language != 1)
    {
        language = 0
    }
    szMyName = getreg(MYNAME)
    if(strlen( szMyName ) == 0)
    {
        szMyName = Ask("Enter your name:")
        setreg(MYNAME, szMyName)
    }
    nVer = GetVersion()
    lnMax = GetBufLineCount(hbuf)
    if(ln != lnMax)
    {
        szNextLine = GetBufLine(hbuf,ln)
        if( (strstr(szNextLine,"(") != 0xffffffff) || (nVer != 2 ))
        {
            symbol = GetCurSymbol()
            if(strlen(symbol) != 0)
            {  
                if(language == 0)
                {
                    FuncHeadCommentCN(hbuf, ln, symbol, szMyName,0)
                }
                else
                {                
                    FuncHeadCommentEN(hbuf, ln, symbol, szMyName,0)
                }
                return
            }
        }
    }
    if(language == 0 )
    {
        szFuncName = Ask("请输入函数名称:")
            FuncHeadCommentCN(hbuf, ln, szFuncName, szMyName, 1)
    }
    else
    {
        szFuncName = Ask("Please input function name")
           FuncHeadCommentEN(hbuf, ln, szFuncName, szMyName, 1)
    
    }
}

macro GetVersion()
{
   Record = GetProgramInfo ()
   return Record.versionMajor
}

macro GetProgramInfo ()
{   
    Record = ""
    Record.versionMajor     = 2
    Record.versionMinor    = 1
    return Record
}

macro FileHeaderCreate()
{
    hwnd = GetCurrentWnd()
    if (hwnd == 0)
        stop
    ln = 0
    hbuf = GetWndBuf(hwnd)
    language = getreg(LANGUAGE)
    if(language != 1)
    {
        language = 0
    }
    szMyName = getreg(MYNAME)
    if(strlen( szMyName ) == 0)
    {
        szMyName = Ask("Enter your name:")
        setreg(MYNAME, szMyName)
    }
       SetBufIns (hbuf, 0, 0)
    if(language == 0)
    {
        InsertFileHeaderCN( hbuf,ln, szMyName,"" )
    }
    else
    {
        InsertFileHeaderEN( hbuf,ln, szMyName,"" )
    }
}


////////字符补全模块///////

macro CompleteWord()
{
	CW_guts(1)
}

macro CompleteWordBack()
{
	CW_guts(0)
}



/* Completion "word" was found in file "fname" at line "lno".
 * Search hBuf for an exact previous match to "word".  If
 * none found, append a match record to hBuf, and return
 * the match record.  If found and bReplace is false, leave
 * hBuf alone and return "".  Else replace the file & line
 * fields of the matching record, move it to end of the
 * buffer, & return it.
 */
macro CW_addword(word, fname, lno, hBuf, bReplace)
{
    /* SearchInBuf (hbuf, pattern, lnStart, ichStart,
                    fMatchCase, fRegExpr, fWholeWordsOnly)
    */
	foundit = SearchInBuf(hBuf, ";match=\"@word@\"", 1, 0, 1, 0, 0)
	record = ""
	if (foundit == "") {
		record = "file=\"@fname@\";line=\"@lno@\";match=\"@word@\""
	}
	else if (bReplace) {
		record = GetBufLine(hBuf, foundit.lnFirst)
		record.file = fname
		record.line = lno
		DelBufLine(hBuf, foundit.lnFirst)
	}
	if (record != "") {
		AppendBufLine(hBuf, record)
	}
	return record
}

/* Search in hSourceBuf for unique full-word matches to regexp,
 * up through line lastlno, adding match records to hResultBuf.
 * In the end, the match recrods look "as if" we had really
 * searched backward from lastlno, which the closest preceding
 * matches earliest in the list.
 */
macro CW_addallbackwards(regexp, hSourceBuf, hResultBuf, lastlno)
{
	lno = 0
	ich = 0	
	fname = GetBufName(hSourceBuf)
	while (1) {
	    /* SearchInBuf(hbuf, pattern, lnStart, ichStart,
	                   fMatchCase, fRegExpr, fWholeWordsOnly)
	    */
		foundit = SearchInBuf(hSourceBuf, regexp, lno, ich, 1, 1, 1)
		if (foundit == "") {
			break
		}
		lno = foundit.lnFirst
		if (lno > lastlno) {
			break
		}
		ich = foundit.ichLim
		matchline = GetBufLine(hSourceBuf, lno)
		match = strmid(matchline, foundit.ichFirst, ich)
		/* We're forced to search forward, but want the last match
		 * (closest preceding the target), so tell CW_addword to
		 * replace any previous match.
		 */
		CW_addword(match, fname, lno, hResultBuf, 1)
	}
	/* reverse the match order */
	n = GetBufLineCount(hResultBuf) - 1
	i = 1
	while (i < n) {
		r1 = GetBufLine(hResultBuf, i)
		r2 = GetBufLine(hResultBuf, n)
		PutBufLine(hResultBuf, i, r2)
		PutBufLine(hResultBuf, n, r1)
		i = i + 1
		n = n - 1
	}
}

/* The major complication here is that this is essentially an asynch
 * event-driven process:  we don't know what the user has done
 * between invocations, so have to squirrel away and check a lot
 * of state in order to guess whether they're invoking the
 * CompleteWord macros repeatedly.
 */
macro CW_guts(bForward)
{
	hwnd = GetCurrentWnd()
	selection = GetWndSel(hwnd)
	if (selection.fExtended) {
		Msg("Cannot word-complete with active selection")
		stop
	}
	hbuf = GetCurrentBuf()
	hResultBuf = GetOrCreateBuf("*Completion*")

	/* Guess whether we're continuing an old one. */
	newone = 0
	if (GetBufLineCount(hResultBuf) == 0) {
		newone = 1
	}
	else {
		stat = GetBufLine(hResultBuf, 0)
		newone = stat.orighbuf != hbuf ||
				 stat.orighwnd != hwnd ||
				 stat.origlno != selection.lnFirst ||
		         stat.newj != selection.ichFirst
	}

	/* suck up stem word */
	if (newone) {
		j = selection.ichFirst	/* index of char to right of cursor */
	}
	else {
		j = stat.origj
	}
	line = GetBufLine(hbuf, selection.lnFirst)
	i = j - 1				/* index of char to left of cursor */
	while (i >= 0) {
		ch = line[i]
		if (isupper(ch) || islower(ch) || IsNumber(ch) || ch == "_") {
			i = i - 1
		}
		else {
			break
		}
	}
	i = i + 1
	if (i >= j) {
		Msg("Cursor must follow [a-zA-Z0-9_]")
		stop
	}
	/* BUG contra docs, line[j] is not included in the following */
	word = strmid(line, i, j)
	regexp = "@word@[a-zA-Z0-9_]+"


	/* BUG "||" apparently doesn't short-circuit, so
        	if (newone || word != stat.stem)
       doesn't work (if newone, stat isn't defined)
    */
    if (!newone) {
    	/* despite that everything looks the same, they
    	   may have changed the stem! */
    	newone = word != stat.stem
    }
    if (newone) {
		stat = ""
		stat.orighbuf = hbuf
		stat.orighwnd = hwnd
		stat.origlno  = selection.lnFirst
		stat.origi    = i
		stat.origj    = j
		stat.stem     = word
		stat.newj     = j
		stat.index    = 0
		stat.searchwnd = hwnd
		stat.searchlno = selection.lnFirst
		stat.searchich = j
		ClearBuf(hResultBuf)
		AppendBufLine(hResultBuf, stat)
		CW_addallbackwards(regexp, hbuf, hResultBuf, stat.origlno)
		if (GetBufLineCount(hResultBuf) >= 2) {
			/* found at least one completion in this buffer,
			   so display the first */
			CW_completeindex(hResultBuf, 1)
			return
		}
	}

	/* continuing an old one, or a new one w/o backward match */
	n = GetBufLineCount(hResultBuf)
	i = stat.index
	if (!bForward) {
		if (i > 1) {
			CW_completeindex(hResultBuf, i - 1)
		}
		else {
			CW_completeword(hResultBuf, word, 0)
			Msg("move forward for completions")
		}
		return
	}

	/* moving forward */
	if (i < n-1) {
		CW_completeindex(hResultBuf, i + 1)
		return
	}

	if (i == n) {
		Msg("move back for completions")
		return
	}

	/* i == n-1: we're at the last one; look for another completion */
	while (1) {
		stat = GetBufLine(hResultBuf, 0)
		hwnd = stat.searchwnd
		lno	= stat.searchlno
		ich = stat.searchich
		hbuf = GetWndBuf(hwnd)
	    /* SearchInBuf(hbuf, pattern, lnStart, ichStart,
	                   fMatchCase, fRegExpr, fWholeWordsOnly)
	    */
	    if (hBuf == hResultBuf) {
	    	/* no point searching our own result list! */
	    	foundit = ""
	    }
	    else {
			foundit = SearchInBuf(hbuf, regexp, lno, ich, 1, 1, 1)
		}
		if (foundit == "") {
			hwnd = GetNextWnd(hwnd)
			if (hwnd == 0 || hwnd == stat.orighwnd) {
				n = GetBufLineCount(hResultBuf)
				if (n == 1) {
					Msg("No completions for @word@")
				}
				else {
					CW_completeword(hResultBuf, word, n)
					Msg("No more completions for @word@")
				}
				break
			}
			stat.searchwnd = hwnd
			stat.searchlno = 0
			stat.searchich = 0
			PutBufLine(hResultBuf, 0, stat)
			continue
		}
		lno = foundit.lnFirst
		ich = foundit.ichLim
		stat.searchlno = lno
		stat.searchich = ich
		PutBufLine(hResultBuf, 0, stat)
		matchline = GetBufLine(hbuf, lno)
		match = strmid(matchline, foundit.ichFirst, ich)
		result = CW_addword(match, GetBufName(hbuf), lno, hResultBuf, 0)
		if (result != "") {
			CW_completeindex(hResultBuf, GetBufLineCount(hResultBuf) - 1)
			break
		}
	}
}

/* Replace the stem with the completion at index i */
macro CW_completeindex(hBuf, i)
{
	record = GetBufLine(hBuf, i)
	CW_completeword(hBuf, record.match, i)
}

/* Replace the stem with the given completion */
macro CW_completeword(hBuf, completion, i)
{
	stat = GetBufLine(hBuf, 0)
	targetBuf = stat.orighbuf
	oldline = GetBufLine(targetBuf, stat.origlno)
	newline = cat(strmid(oldline, 0, stat.origi), completion)
	newj = strlen(newline)
	newline = cat(newline, strmid(oldline, stat.newj, strlen(oldline)))
	PutBufLine(targetBuf, stat.origlno, newline)
	SetBufIns(targetBuf, stat.origlno, newj)
	stat.newj = newj
	stat.index = i
	PutBufLine(hBuf, 0, stat)
}

/* Get handle of buffer with name "name", or create a new one
 * if no such buffer exists.
 */
macro GetOrCreateBuf(name)
{
	hBuf = GetBufHandle(name)
	if (hBuf == 0) {
		hBuf = NewBuf(name)
	}
	return hBuf
}














    

