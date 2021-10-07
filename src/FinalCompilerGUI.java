import java.io.*;
import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.nio.file.Files;
import java.nio.file.Paths;

public class FinalCompilerGUI {
    private JPanel mainPannel;
    private JButton openFileBtn;
    private JTextField inputDir;
    private JTextField outputDir;
    private JTextArea outputText;
    private JButton analysisBtn;
    private JFileChooser fileOpener;
    private File file ;

    public FinalCompilerGUI() {

        openFileBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                fileOpener = new JFileChooser();
                fileOpener.setCurrentDirectory(new File("."));
                fileOpener.setFileFilter(new FileNameExtensionFilter("VC code files","vc"));
                int returnValue = fileOpener.showOpenDialog(null);
                if(returnValue == JFileChooser.APPROVE_OPTION){
                    try{
                        file = fileOpener.getSelectedFile();
                        inputDir.setText(file.getPath());
                        outputDir.setText(file.getPath());
                    }catch (Exception ioe){
                        ioe.printStackTrace();
                    }
                }
            }
        });

        analysisBtn.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String output;
                try {
                    output = Scanner.vcScanFile(file);
                    outputText.setText(output);
                    Files.write(Paths.get("./output/output.txt"), output.getBytes());

                } catch (Exception exception) {
                    exception.printStackTrace();
                }

            }
        });
    }

    public static void main(String[] args) {
        JFrame frame = new JFrame("Lexical Analysis for VC Language");
        frame.setContentPane(new FinalCompilerGUI().mainPannel);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.pack();
        frame.setVisible(true);
    }

}
