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
    public static String TEXTNAME = ""; // Filename
    // This field refers to the sensor id.
    // If multiple sensors are used in the experiment, this field is helped to determine which sensor is used when measuring the persistence time.
    public static String SENSORID = "0";
    public static ImpinjReader reader;
    static String dateMsg ="";
    static ArrayList<String> arr = new ArrayList<>();
    static {
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("YYMMdd");
        dateMsg+=sdf.format(date);
        File file = new File(".\\data"+dateMsg);
        if (!file.exists() && !file.isDirectory()) {
            file.mkdirs();
        }
    }
    public static void measurePersistenceTime()throws Exception{
        // Write RFID data to file.
        Writer ptimes_writer = new FileWriter(".\\data"+dateMsg+"\\"+TEXTNAME+".txt",true);
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
            Scanner scanner = new Scanner(System.in);
            //String hostname = "speedwayr-15-00-60";
            String hostname="impinj-14-04-05";
            System.out.println("Input temperature");
            TEXTNAME=scanner.nextLine();
            //String hostname="speedwayr-15-00-60";
            // Connect reader through hostname or IP address
            reader.connect(hostname+".local");
            // Load settings
            reader.applySettings(Settings.load("./src/settings.json"));
            // Set data format
            reader.setTagReportListener(new TagReportListenerImplementation());
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
