public class GenericList{
    // class constant for default size
    private static final int DEFAULT_CAP = 10;
    private Object[] iValues;
    private int iSize;
    public void add(Object x){
        insert(iSize, x);
    }
    public Object get(int pos){
        return iValues[pos];
    }
    public void insert(int pos, Object obj){
        ensureCapcity();
        for(int i = iSize; i > pos; i--){
            iValues[i] = iValues[i - 1];
        }
        iValues[pos] = obj;
        iSize++;
    }

    public Object remove(int pos){
        Object removedValue = iValues[pos];
        for(int i = pos; i < iSize - 1; i++)
            iValues[i] = iValues[i + 1];
        iValues[iSize - 1] = null;
        iSize--;
        return removedValue;
    }
    private void ensureCapcity(){
        if(iSize == iValues.length)
            resize();
    }
}
