import com.impinj.octane.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

public class ReaderSettings {
    public static void main(String[] args) {
        // Input the hostname or IP address of the reader in command line.
        //String hostname = "speedwayr-15-00-60";
        String hostname="impinj-14-04-05";
        ImpinjReader reader = new ImpinjReader();
        try {
            reader.connect(hostname+".local");
        } catch (OctaneSdkException e) {
            e.printStackTrace();
        }
        Settings settings = reader.queryDefaultSettings();
        settings.setReaderMode(ReaderMode.MaxThroughput);
        // Thermotag uses the persistence time of session 1 as the metric to do temperature sensing.
        // The corresponding settings are given below.
        settings.setSession(1); // Session 1
        settings.setSearchMode(SearchMode.SingleTarget); // Query A
        settings.setTagPopulationEstimate(1);
        ArrayList<AntennaConfig> arrayList = settings.getAntennas().getAntennaConfigs();
        for (AntennaConfig ac : arrayList) {
            ac.setEnabled(false);
            ac.setIsMaxTxPower(false);
            ac.setTxPowerinDbm(30);
            ac.setIsMaxRxSensitivity(true);
        }
        AntennaConfig ac = arrayList.get(0);
        ac.setEnabled(true);
        ReportConfig r = settings.getReport();
        r.setIncludeAntennaPortNumber(true);
        r.setIncludeFirstSeenTime(true);
        r.setIncludeLastSeenTime(true);
        r.setIncludeFastId(true);
        r.setIncludePeakRssi(true);
        r.setIncludePcBits(true);
        r.setIncludeChannel(true);
        r.setIncludeDopplerFrequency(true);
        r.setIncludePhaseAngle(true);
        r.setMode(ReportMode.Individual);
        settings.setReport(r);
        // Select a subset of tags in the environment.
        TagFilter t1 = settings.getFilters().getTagFilter1();
        t1.setBitCount(32);
        t1.setBitPointer(32);
        t1.setMemoryBank(MemoryBank.Epc);
        t1.setFilterOp(TagFilterOp.Match);
        // If the first 32 bits of a tag's ID matches "20210414", it will reply to the reader.
        t1.setTagMask("20220805");
        settings.getFilters().setMode(TagFilterMode.OnlyFilter1);
        try {
            settings.save("./src/settings.json");
        } catch (IOException e) {
            e.printStackTrace();
        }
        reader.disconnect();
    }
}