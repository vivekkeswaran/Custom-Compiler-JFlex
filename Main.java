import java.io.*;
import java_cup.runtime.SymbolFactory;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ScannerBuffer;
import java_cup.runtime.XMLElement;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamWriter;
import javax.xml.transform.*;
import javax.xml.transform.stream.*;

public class Main {
   
   public static  void main(String argv[]) {    
    try 
	{
		ComplexSymbolFactory symFactory = new ComplexSymbolFactory();
		FileReader reader = new FileReader(argv[0]);
		BufferedReader bufReader = new BufferedReader(reader);
		Lexer lex = new Lexer(bufReader, symFactory);
	    ScannerBuffer scanBuffer = new ScannerBuffer(lex);
	    
		parser p = new parser(scanBuffer);
		p.parse();		
		
		lex.displaySymbolTable();
    } catch (Exception e) {
		e.printStackTrace();
    }	
  }
}
