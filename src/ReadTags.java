import com.impinj.octane.ImpinjReader;
import com.impinj.octane.OctaneSdkException;
import com.impinj.octane.Settings;

import java.io.File;
import java.io.FileWriter;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Scanner;

public class ReadTags {
    public static String TEXTNAME = "Monza5-2"; // Filename
    // This field refers to the sensor id.
    // If multiple sensors are used in the experiment, this field is helped to determine which sensor is used when measuring the persistence time.
    public static String SENSORID = "01";
    public static ImpinjReader reader;
    static String dateMsg ="";
    static ArrayList<String> arr = new ArrayList<>();
    static {
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("YYMMdd");
        dateMsg+=sdf.format(date);
        File file = new File(".\\data"+dateMsg+"\\ftimes\\");
        if (!file.exists() && !file.isDirectory()) {
            file.mkdirs();
        }
        file = new File(".\\data"+dateMsg+"\\ptimes\\");
        if (!file.exists() && !file.isDirectory()) {
            file.mkdirs();
        }
    }
    public static void measureFisrtSeenTime()throws Exception{
        // Write start time to file.
        Writer ftimes_writer = new FileWriter(".\\data"+dateMsg+"\\ftimes\\"+TEXTNAME+".txt",true);
        String msg="";
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("YYYY/MM/dd HH:mm:ss");
        msg+=sdf.format(date);
        ftimes_writer.write(msg+"\n");
        ftimes_writer.flush();
        ftimes_writer.close();
    }
    public static void measurePersistenceTime()throws Exception{
        // Write RFID data to file.
        Writer ptimes_writer = new FileWriter(".\\data"+dateMsg+"\\ptimes\\"+TEXTNAME+".txt",true);
        long begin = System.currentTimeMillis();
        while(System.currentTimeMillis()-begin<60000) {
            reader.start();
            Thread.sleep(10000);
            reader.stop();
            Thread.sleep(10000);
            for (String s:arr)
                ptimes_writer.write(s);
            ptimes_writer.flush();
            arr.clear();
        }
        ptimes_writer.close();
    }
    public static void main(String[] args) {
        try {
            reader = new ImpinjReader();
            // Input the hostname or IP address of the reader in command line
            System.out.println("Input hostname of the reader");
            Scanner scanner = new Scanner(System.in);
            String hostname = scanner.nextLine();
            // Connect reader through hostname or IP address
            reader.connect(hostname+".local");
            // Load settings
            reader.applySettings(Settings.load("ReadTags/settings.json"));
            // Set data format
            reader.setTagReportListener(new TagReportListenerImplementation());
            // Measure start time
            measureFisrtSeenTime();
            // Measure RFID data for 1 min
            measurePersistenceTime();
            // Turn off the reader
            reader.disconnect();
        } catch (OctaneSdkException ex) {
            System.out.println(ex.getMessage());
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
            ex.printStackTrace(System.out);
        }
    }
}
