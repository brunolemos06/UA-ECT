package clientSide.entities;

/**
 * Master Thief Clone
 * It specifies the master thief methods for the clone
 */
public interface MasterThiefClone {
    /**
     * Set the state of the master thief
     * @param state of the thief
     */ 
    public void setMasterThiefState(int state);

    /**
     * Get the state of the master thief
     * @return master thief state
     */
    public int getMasterThiefState();
}