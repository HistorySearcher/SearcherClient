package com.project.lucene.main;


import java.io.FileOutputStream;
import java.io.IOException;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

import com.project.lucene.bean.LogBean;

public class MakeXML {
	 /**
	  * @param args
	  */
	public static void main(String[] args) {
		  // TODO Auto-generated method stub
			LogBean bean=new LogBean();
		
		  Document doc = new Document();  
		  
		  Element root = new Element("generator");
		  
		  Element pack = new Element("package");
		  
		  Element pack_name = new Element("package-name");
		  
		  root.addContent(pack);//root element 의 하위 element 를 만들기
		  pack.addContent(pack_name); //package element 의 하위로 package-name 만들기
		  pack_name.setText("권학");
		  
		  doc.setRootElement(root);
		  
		  try{
			  FileOutputStream out=new FileOutputStream("d:\\LuceneTest\\"+bean.getDate()+"\\"+bean.getDate()+".xml");
			  XMLOutputter serializer=new XMLOutputter();
			  
			  Format f=serializer.getFormat();
			  f.setEncoding("UTF-8");
			  f.setIndent(" ");
			  f.setLineSeparator("\r\n");
			  f.setTextMode(Format.TextMode.TRIM);
			  serializer.setFormat(f);
			  
			  serializer.output(doc, out);
			  out.flush();
			  out.close();
			    //String 으로 xml 출력
			     // XMLOutputter outputter = new XMLOutputter(Format.getPrettyFormat().setEncoding("UTF-8")) ;
			     // System.out.println(outputter.outputString(doc));
		  }catch (IOException e) {                                         
		      System.err.println(e);                                        
		  } 
		  
		  
	}
	
	
}
