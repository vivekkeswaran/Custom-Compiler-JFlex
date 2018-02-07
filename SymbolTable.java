
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class SymbolTable {

    private int currentScopeCount;
    private HashMap<Integer, LinkedList<String>> symbolTable;
    private HashMap<Integer, Boolean> scopeStatus;
    private LinkedList scopeLst[];

    public SymbolTable() {
        Initialize();
    }

    private void Initialize() {
        currentScopeCount = 0;
        symbolTable = new HashMap<Integer, LinkedList<String>>();
        scopeStatus = new HashMap<Integer, Boolean>();
        scopeLst = new LinkedList[5];

        for (int pos = 0; pos < 5; pos++) {
            scopeLst[pos] = new LinkedList();
            symbolTable.put(pos, scopeLst[pos]);
        }
    }

    public void insert(String strSymbol, int scope, int symbolTableIndex) {
        if (scopeLst[symbolTableIndex] == null) {
            scopeLst[symbolTableIndex] = new LinkedList();
        }
        scopeLst[symbolTableIndex].add(0, strSymbol + ":" + scope);
        symbolTable.put(symbolTableIndex, scopeLst[symbolTableIndex]);
    }

    public List<String> find_in_All_Scope(String sVal, int scope, int symbolTableIndex) {
        Boolean isFirst = true;
        List<String> otherScopeEntries = new ArrayList<String>();
        LinkedList<String> lis = (LinkedList) symbolTable.get(symbolTableIndex);
        if (lis == null) {
            return otherScopeEntries;
        }

        for (int j = 0; j < lis.size(); j++) {
            String temp = lis.get(j).toString();
            String info[] = temp.split(":");
            if (sVal.equals(info[0])) {
                if (!isFirst) {
                    otherScopeEntries.add(temp);
                }
                isFirst = false;
            }
        }

        return otherScopeEntries;
    }

    public boolean find_in_Current_Scope(String sVal, int scope, int symbolTableIndex) {
        LinkedList<String> lis = (LinkedList) symbolTable.get(symbolTableIndex);
        if (lis == null || lis.size() == 0) {
            if (sVal.trim().equals("")) {
                return false;
            }
            return true;
        }
        sVal = sVal.replaceAll("[{}()]", "");
        for (int j = 0; j < lis.size(); j++) {
            String temp = lis.get(j).toString();
            if (sVal.trim().equals("")) {
                return false;
            }
            if (temp.equals(sVal + ":" + scope)) {
                return false;
            }
        }
        return true;
    }

    public void displaySymbolTable() {
        Iterator it = symbolTable.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry pair = (Map.Entry) it.next();
            LinkedList scopeObj = (LinkedList) pair.getValue();
            if (scopeObj.size() < 1) {
                printLine(pair.getKey() + ": " + " null");
            } else {
                print(pair.getKey() + ": ");
                for (Object symbol : scopeObj) {
                    print(" => " + symbol.toString());
                }
                System.out.println();
            }
        }
    }

    public Boolean createSymbolTableFromFile(String fileName) throws Exception {
        String strLine;
        Boolean status = true;
        try {
            FileReader fileReader = new FileReader(fileName);
            BufferedReader buffer = new BufferedReader(fileReader);

            while ((strLine = buffer.readLine()) != null) {
                String splitString[] = removeUnwantedCharacters(strLine).trim().split(" ");
                for (String strVal : splitString) {
                    ProcessInputSymbol(strVal);
                }
            }
        } catch (Exception ex) {
            printLine("Error Occured: " + ex.getMessage());
            status = false;
        } finally {
            return status;
        }
    }

    public Boolean createSymbolTable(String symbol) throws Exception {
        Boolean status = true;
        try {
            ProcessInputSymbol(symbol);
        } catch (Exception ex) {
            printLine("Error Occured: " + ex.getMessage());
            status = false;
        } finally {
            return status;
        }
    }

    private void ProcessInputSymbol(String strValue) {
        int scope = getCurrentScope(strValue);
        switch (strValue) {
            case "{":
            case "}":
            case "OPEN":
            case "CLOSE":
                break;
            default: {
                int modVal = getModValue(strValue);
                if (find_in_Current_Scope(strValue, scope, modVal)) {
                    insert(strValue, scope, modVal);
                }
                find_in_All_Scope(strValue, scope, modVal);
            }
        }
    }

    private static String removeUnwantedCharacters(String strVal) {
        strVal = strVal.replaceAll("\\{", " { ");
        strVal = strVal.replaceAll("\\}", " } ");
        strVal = strVal.replaceAll("(/\\*(?:.|[\\n\\r])*?\\*/)|(?://.*)", "");

        return strVal;
    }

    private static int getModValue(String sVal) {
        int asciiSum = 0;

        for (char character : sVal.toCharArray()) {
            asciiSum = asciiSum + (int) character;
        }

        return (asciiSum % 5);
    }

    public int getCurrentScope(String sVal) {
        int scope = 0;
        switch (sVal) {
            case "{":
            case "OPEN": {
                currentScopeCount++;
                scopeStatus.put(currentScopeCount, Boolean.TRUE);
            }
            break;
            case "}":
            case "CLOSE": {
                for (int i = scopeStatus.size(); i >= 0; i--) {
                    if (scopeStatus.get(i) == Boolean.TRUE) {
                        scopeStatus.put(i, Boolean.FALSE);
                        break;
                    }
                }
            }
            break;
        }

        for (int i = scopeStatus.size(); i >= 0; i--) {
            if (scopeStatus.get(i) == Boolean.TRUE) {
                scope = i;
                break;
            }
        }

        return scope;
    }

    private static void printLine(String s) {
        System.out.println(s);
    }

    private static void print(String s) {
        System.out.print(s);
    }
}
