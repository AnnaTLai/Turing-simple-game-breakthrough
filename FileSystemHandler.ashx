<h1 align="center">How to Use this Game Folder Structure</h1>
<p>The <strong><font face="Arial, Helvetica, sans-serif"><a href="Main.t">Main.t</a></font></strong> 
  file is to contain your major steps and blocks, game loop and major decision 
  structures (case or ifs) ONLY.</p>
<p><font color="#FF0000"><strong>[</strong></font> For <strong>example</strong>, 
  the procedure call (program statement) <font face="Arial, Helvetica, sans-serif"><strong>displayIntroWindow</strong></font> 
  would represent a major step or block and therefore would be called from the 
  main file (main program). The code (procedures and functions) that would handle 
  everything to do with the introduction screen would be stored in a file named 
  say, <strong><font face="Arial, Helvetica, sans-serif">IntroScreen.t</font></strong> 
  and stored in folder <a href="Files/Code/" target="_blank"><font face="Arial, Helvetica, sans-serif">Files\Code\</font></a>. 
  An <font face="Arial, Helvetica, sans-serif"><strong>include</strong></font> 
  statement for <strong><font face="Arial, Helvetica, sans-serif">IntroScreen.t</font></strong> 
  must be coded in file <a href="Files/Code/includes.t" target="_blank"><font face="Arial, Helvetica, sans-serif">Files\Code\</font>Includes.t</a> 
  (in chronological order of program use)<strong>. Note: The button routines are 
  coded in <a href="Files/Code/ButtonHandlers.t"><font face="Arial, Helvetica, sans-serif">buttonHandlers.t</font></a><font color="#FF0000"> 
  and may be used by all code files that follow it in the include.t file list.]</font></strong></p>
<p>All global variables with <em><strong>file scope</strong></em><strong> </strong>should 
  be declared in file <a href="Files/Code/MyGlobalVars.t" target="_blank"><font face="Arial, Helvetica, sans-serif">Files\Code\</font>MyGlobalVars.t</a>. 
  <font face="Arial, Helvetica, sans-serif">MyGlobalVars.t</font> should contain 
  a procedure that resets the values of each file scope variable to its initial 
  value.</p>
<p>Note that <strong><font face="Arial, Helvetica, sans-serif"><a href="Files/Code/MyImportList.t">Files\Code\MyImportList.t</a></font> 
  </strong>is the first <font face="Arial, Helvetica, sans-serif">include</font> 
  statement this is coded in <font face="Arial, Helvetica, sans-serif"><strong>includes.t</strong></font>. 
  It only contains the <strong>GUI</strong> unit in its import list. To use Dice 
  class or any class you may code replace the existing import statement with <font face="Arial, Helvetica, sans-serif"><strong><br>
  import GUI, Dice in &quot;Code/Classes/Dice.cla&quot;</strong></font>. The <font face="Arial, Helvetica, sans-serif"><strong>Dice</strong></font> 
  class files must now be stored in the classes folder. </p>
<p><strong>Exercise</strong>: For practice <em><strong>trace</strong></em> how 
  <strong><font face="Arial, Helvetica, sans-serif">displayFontWindow</font></strong> 
  and <font face="Arial, Helvetica, sans-serif"><strong>setInitialGameValues</strong></font> 
  work.</p>
<p>The advantage is that the <font face="Arial, Helvetica, sans-serif"><strong>main</strong></font> 
  program may be coded (use your major program steps from the Software Design 
  Document) with subprogram calls. Just create the appropriately named file, include 
  it in the correct order in includes.t. This file needs to contain empty subprograms(stubs) 
  so that the calls from the main will execute.</p>
<p><strong><font color="#FF0000">Music/sound, text, record (data) and graphic 
  files should be stored in the appropriate folder. Organizations of files and 
  the partitioning of code will help you focus at the coding task at hand, help 
  you debug your code with ease and have an initial main program that runs.</font></strong></p>
<p>&nbsp;</p>
