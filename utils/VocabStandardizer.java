import java.io.*;

public class VocabStandardizer {
	
	// the file to be standardized has to be a list of vocabols. 
	// each voice has to be on a single line. 
	// call the list "1.txt" and put it in C:/
	// the result standardized list will be called "2.txt" and can be found in C:/ 

	public static void main (String[] args) {
		String line;
		BufferedReader in = null;
		BufferedWriter writer = null;
		String text = "";
		int counter = 1000;					// set the number of voices to scan
		
		try {
			in = new BufferedReader(new FileReader("C:/1.txt"));	
			line = in.readLine();
			text += "ValueTY(" + (++counter) + ",'" + line + "'";
			
			while ((line = in.readLine()) != null)
				text += "), ValueTY(" + (++counter) + ", '" + line + "'";
			
			text += ")";
			System.out.println(text);			

			writer = new BufferedWriter (new FileWriter ("C:/2.txt"));
		    writer.write(text);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (writer != null)
					writer.close();
			}
			catch (IOException e) {
				e.printStackTrace();
			}
		}	
	}
}