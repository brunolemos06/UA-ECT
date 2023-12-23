package commInfra;

/**
 *    Parametric FIFO derived from a parametric memory.
 *    Errors are reported.
 *
 *    @param <R> data type of stored objects
 */

public class MemFIFO<R> extends MemObject<R>
{
  /**
   *   Pointer to the first empty location.
   */

   private int inPnt;

  /**
   *   Pointer to the first occupied location.
   */

   private int outPnt;

  /**
   *   Signaling FIFO empty state.
   */

   private boolean empty;

  /**
   *   FIFO instantiation.
   *   The instantiation only takes place if the memory exists.
   *   Otherwise, an error is reported.
   *
   *     @param storage memory to be used
   *     @throws MemException when the memory does not exist
   */

   public MemFIFO (R [] storage) throws MemException
   {
     super (storage);
     inPnt = outPnt = 0;
     empty = true;
   }

  /**
   *   FIFO insertion.
   *   A parametric object is written into it.
   *   If the FIFO is full, an error is reported.
   *
   *    @param val parametric object to be written
   *    @throws MemException when the FIFO is full
   */

   @Override
   public void write (R val) throws MemException
   {
     if ((inPnt != outPnt) || empty)
        { mem[inPnt] = val;
          inPnt = (inPnt + 1) % mem.length;
          empty = false;
        }
        else throw new MemException ("Fifo full!");
   }

  /**
   *   FIFO retrieval.
   *   A parametric object is read from it.
   *   If the FIFO is empty, an error is reported.
   *
   *    @return first parametric object that was written
   *    @throws MemException when the FIFO is empty
   */

   @Override
   public R read () throws MemException
   {
     R val;

     if (!empty)
        { val = mem[outPnt];
          mem[outPnt] = null;
          outPnt = (outPnt + 1) % mem.length;
          empty = (inPnt == outPnt);
        }
        else throw new MemException ("Fifo empty!");
     return val;
   }
  
  /**
   *   Test FIFO current full status.
   *
   *    @return true, if FIFO is full -
   *            false, otherwise
   */
   public boolean full ()
   {
     return !((inPnt != outPnt) || empty);
   }

  /**
  * Test FIFO current empty status.
  * @return true, if FIFO is empty - false, otherwise
  */
  public boolean isEmpty() {
    return empty;
  }

  /**
  *  Check if the value is in the FIFO
  * @param value
  * @return true if the value is in the FIFO, false otherwise
  */ 
  public boolean isIn(R value) {
    for (int i = 0; i < mem.length; i++) {
      if (mem[i] == value) {
        return true;
      }
    }
    return false;
  }

  /**
  * Check if the value is the next to be read
  * @param value
  * @return true if the value is the next to be read, false otherwise
  */
  public boolean nextOut(R value) {
    if (mem[outPnt] == value) {
      return true;
    }
    return false;
  }

  /**
  * Check if the FIFO has at least num elements
  * @param num
  * @return true if the FIFO has at least num elements, false otherwise
  */
  public boolean enough(int num) {
    int count = 0;
    for (int i = 0; i < mem.length; i++) {
      if (mem[i] != null) {
        count++;
      }
    }
    return count >= num;
  }
}