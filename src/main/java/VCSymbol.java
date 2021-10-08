public class VCSymbol extends java_cup.runtime.Symbol {
    private int line;
    private int column;
    private String character; // string which form token

    public VCSymbol(int type, int line, int column, String character) {
        this(type, line, column, -1, -1, null, character);
    }

    public VCSymbol(int type, int line, int column, Object value, String character) {
        this(type, line, column, -1, -1, value, character);
    }

    public VCSymbol(int type, int line, int column, int left, int right, Object value, String character) {
        super(type, left, right, value);
        this.line = line;
        this.column = column;
        this.character = character;
    }

    public int getLine() {
        return line;
    }

    public int getColumn() {
        return column;
    }

    public  String getCharacter() {
        return character;
    }
    public String toString() {
        return "line "
                + line
                + ", column "
                + column
                + ", sym: "
                + sym
                + (value == null ? "" : (", value: '" + value + "'"));
    }

}